      subroutine main_fortran(argc, argv)
#define _OUTLIB_ 
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   This is the pseudo main routine. The true main routine is written
c   in C and passes the command line arguments to this routine.
c
c   The program is called by the command (may be changed in the future)
c
c      mcfast   [-f file_cmd] [-l file_lpt] [-hb file_hbook]
c
c   For help on the switches, type
c
c      mcfast -h
c
c   If file_cmd is specified, commands are read from the file file_cmd.
c   Otherwise, commands are read from the user's terminal until a ^D
c   (EOF) is typed.
c 
c   If file_lpt is specified, it is taken as the name of the Ascii output
c   file containing status information, histograms, run summaries, etc.
c   If not specified, output is written to the file "mcparam.lpt".
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Modified 11/21/94 ASB added initialization and summary for MCFIO output
c    9/11/95  TWenaus geomview graphics
      implicit none

#include "dataset.inc"
#include "mcp_luns.inc"
#include "mcp_files.inc"
#include "mcp_hbook.inc"
#include "mcp_ranseeds.inc"
#include "mcp_summary.inc"	/*! for mcp_filetype    Linux cpp confused by !     */
#include "mcp_ioparam.inc"	/*! for filetype parameters */
#include "stdlun.inc"		/*! for qqufile             */

c     Externals
      integer  cmd_lenstr
      external cmd_lenstr
      integer lenocc
      external lenocc
c     Calling arguments
      integer argc                !Number of arguments
      character*(*) argv(0:argc)  !List of arguments

c     Local variables
      integer i, leng, status, lmcfast, error
      character*120 hbkdir,mcfastdir
      record /dataset/ datfile
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(argc .eq. 1) then
        if(argv(1) .ne. '-h') goto 9992
        call mcp_help
        stop
      endif

      call fp_exception                 !Handle floating point errors

      if(mod(argc,2) .ne. 0) goto 9991  !Arguments must occur in pairs

      mcp_filecmd = ' '
      hbk_file = 'mcfast.rz'
      mcp_filelpt = 'mcfast.lpt'
      qqufile = ' '

      do i=1,argc,2
        if(     argv(i) .eq. '-f') then
          mcp_filecmd = argv(i+1)
        else if(argv(i) .eq. '-l') then
          mcp_filelpt = argv(i+1)
        else if(argv(i) .eq. '-hb') then
          hbk_file = argv(i+1)
        else if(argv(i) .eq. '-qu') then
          qqufile = argv(i+1)
        endif
      enddo

      call mcp_init                     !Initialize variables, etc.

      open(unit=mcp_llpt, file=mcp_filelpt, status='unknown',
     *     err=9993)

      call mcp_time_init           !Init time routines

      call mcp_version_write(6)    !Print version number
      call mcp_version_write(mcp_llpt)

      call usr_hbinit              !HBOOK initialization
      call usr_init
      call trig_init
      call gam_init

      call trk_init
      call fctl_init

      call mcp_read_cmd              !Read commands to process the job

      call mcp_qq_init

      if (index(mcp_filegeo,'.geo').ne.0) then
        print *,'Reading geometry from old style database ',mcp_filegeo
        write(mcp_llpt,*) 
     +    'Reading geometry from old style database ',mcp_filegeo
        call geo_get_data(mcp_filegeo,0) !Read in geometry from ASCII file
      else if (index(mcp_filegeo,'.db').ne.0) then
        print *,'Reading geometry from dbin database ',
     +    mcp_filegeo(:lenocc(mcp_filegeo))
        write(mcp_llpt,*) 'Reading geometry from dbin database ',
     +    mcp_filegeo(:lenocc(mcp_filegeo))
        call geo_load(mcp_filegeo)       !Load geometry from dbin database
      else
c       don't complain if reading back in a mcfast output file
        if(mcp_filetype(1).ne.MCF_IO_MCFAST) then
          leng = max(1, cmd_lenstr(mcp_filegeo))
          write(6,5000) mcp_filegeo(:leng)
          write(mcp_llpt,5000) mcp_filegeo(:leng)
 5000     format('Unrecognized geometry file type ',a,
     &         ' Neither .geo nor .db')
          stop
        endif
      endif
c
c     Initialize Calorimetry (hits), if necessary
c
      call calor_init

      call detectors   ! fill generic detector array

      call det_geom(0) ! detector geometry graphics output, if selected
                       ! via geomview_out card

      call usr_setup   ! post-geometry user init

c     Check if data or parameters for internal generation are present
      call mcp_set_readtype(status)
      if(status .ne. 0) goto 9997
      call mcp_output_init           !initialize  MCFIO output

c     Set random seeds in mcfast
      call set_ranseeds(mcp_ranseeds, 1) !Init. random number generator
c     Call qqrnst so that dummy qqrnst will be linked
      call qqrnst(mcp_ranseeds(1), mcp_ranseeds(2))

      write(6,5010) mcp_ranseeds
      write(mcp_llpt,5010) mcp_ranseeds
 5010 format(/'MCFAST initial random seeds = ',2i12/)

c     Do all the work (read data, do analysis, etc.)
      if(mcp_filetype(1).eq.MCF_IO_MCFAST) then
c       check that background is the same file type as the signal
        if(mcp_filetype(2).ne.MCF_IO_MCFAST)then
c         check filename to see if a background file exists
          call dtf_getnext(datfile, 2, error)
          leng = max(1, cmd_lenstr(datfile.file) )
          if(error .eq. 0 .and. leng .gt. 1 ) goto 9999
        endif
        call mcp_reanalyze
      else
c       check that background is the same file type as the signal
c       simpler check because filetype is MCF_IO_STDHEP by default
        if(mcp_filetype(2).eq.MCF_IO_MCFAST) goto 9999
        call mcp_analyze
      endif

      call mcp_summary             !Program summary
      call mcp_output_summary      !MCFIO output summary
      call trig_summary(mcp_llpt)  !Trigger summary
      call trk_summary             !Charged particle reconstruction summary
      call shw_summary             !Shower summary
      call gam_summary             !Gamma reconstruction summary
      call usr_summary             !User summary
      call usr_hbsummary           !HBOOK User summary

      close(unit=mcp_llpt)
      return

c     Error
 9991 write(6,5001) argc
 5001 format('Main: Total of ',i1,' arguments. Must be even.')
      stop

c     Error
 9992 leng = cmd_lenstr(argv(1))
      write(6,5001) argv(1)(:leng)
 5002 format('Main: Argument not understood: "',a,'"')
      stop

 9993 leng = max(1, cmd_lenstr(mcp_filelpt))
      write(6,5003) mcp_filelpt(:leng), mcp_llpt
 5003 format('Main: Error opening lpt file ', a,' on unit ',i2)
      stop

 9997 stop

 9999 write(6,5004)
      write(mcp_llpt,5004)
 5004 format('Main: Error: ',
     1       'background file type must match input file type')
      stop

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:19  eugenio
c Initial revision
c
c Revision 1.17  1999/07/29 16:38:40  garren
c make sure that the dummy qqrnst is called
c
c Revision 1.16  1999/07/28  21:34:06  garren
c dummy ranp for QQ that calls the mcfast rann
c
c Revision 1.15  1998/11/20  22:41:16  procario
c On Linux the ! comment after an include does not work use C style instead
c
c Revision 1.14  1998/06/23  23:47:40  bphyslib
c fix references to renamed routines
c
c Revision 1.13  1998/02/13  23:08:52  kutschke
c Add call to fit_init.
c
c Revision 1.12  1997/08/27  16:10:58  garren
c don't require geometry if reading back mcfast output file
c
c Revision 1.11  1997/08/21  15:08:49  garren
c check that background file type matches signal file type
c
c Revision 1.10  1997/08/15  17:02:23  garren
c read back in event files generated by MCFast
c
c Revision 1.9  1997/04/04  18:07:48  garren
c add hooks to initialize user trigger code
c

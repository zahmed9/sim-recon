      subroutine main_fortran(argc, argv)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   This is the pseudo main routine. The true main routine is written
c   in C and passes the command line arguments to this routine.
c
c   The program is started by the command:
c
c      name  [-f cmd_file] [-l lpt_file] [-o out_file] [-i input_file]
c            [-hb hbook_file] [-qq] [-qu qq_user_file]
c     
c   where "name" is the name of the event generator.
c
c   For help on the switches, type
c
c      name -h
c
c   If file_cmd is specified, commands are read from the file cmd_file.
c   Otherwise, commands are read from the user's terminal until a ^D
c   (EOF) is typed.
c 
c   If file_lpt is specified, it is taken as the name of the Ascii output
c   file containing status information, histograms, run summaries, etc.
c   If not specified, output is written to the file "mcparam.lpt".
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "file_names.inc"
#include "qq_flag.inc"
#include "stdlun.inc"

c     Externals

c     Calling arguments
      integer argc                !Number of arguments
      character*(*) argv(0:argc)  !List of arguments

c     Local variables
      integer i, leng, status
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      file_input = ' '
      file_lpt = ' '
      file_evt_rd = ' '
      file_evt_wrt = ' '
      file_hbk = ' '
      qqufile = ' '
      lqq = .false.

      i = 1
      do while (i.le.argc)
        if(     argv(i) .eq. '-f') then
          file_input = argv(i+1)
          i = i + 1
        else if(argv(i) .eq. '-l') then
          file_lpt = argv(i+1)
          i = i + 1
        else if(argv(i) .eq. '-i') then
          file_evt_rd = argv(i+1)
          i = i + 1
        else if(argv(i) .eq. '-o') then
          file_evt_wrt = argv(i+1)
          i = i + 1
        else if(argv(i) .eq. '-hb') then
          file_hbk = argv(i+1)
          i = i + 1
        else if(argv(i) .eq. '-qq') then
          lqq = .true.
        else if(argv(i) .eq. '-qu') then
          qqufile = argv(i+1)
          i = i + 1
        else if(argv(i) .eq. '-h') then
          call main_fortran_help
        endif
        i = i + 1
      enddo

      call evgen_start

      return

c     Error
 9991 write(6,5001) argc
 5001 format('Main: Total of ',i1,' arguments. Must be even.')
      stop

      end

      subroutine main_fortran_help
C
      write(6,1001)
1001  format(' Main: the following input line arguments are available:'
     1       /10X,'-f cmd_file'
     2       /10X,'-l lpt_file'
     3       /10X,'-o event_output_file'
     4       /10X,'-i event_input_file'
     5       /10X,'-hb hbook_file'
     6       /10X,'-qq (use QQ for decay)'
     7       /10X,'-qu QQ_user_decay_file'
     8       /10X,'-h  (this help display)')
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:35  eugenio
c Initial revision
c
c Revision 1.5  1998/06/25 15:49:01  bphyslib
c add all necessary changes from v3_3
c

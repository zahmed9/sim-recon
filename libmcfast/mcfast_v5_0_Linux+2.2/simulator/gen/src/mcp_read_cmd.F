      subroutine mcp_read_cmd
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Read a command file and set variables. Input is interpreted by the
c  routines in cmd_parse.f.
c
c  input file format:
c            keyword value
c        or  keyword value1 value2
c
c    where keyword is one of the variables that can be set
c
c  A whole series of reals, integers and strings can be read in. See the
c  routine cmd_getitems which is used below.
c
c  Documentation for commands is available.  See
c              http://www-pat.fnal.gov/mcfast/version_doc
c
c  Author: Paul Avery  3-20-94
c  Modified 11/08/94 ASB added MCFIO commands
c  Modified 5-30-96 (Julia Yarba) - added switch for shower trans.prof.
c  Modified 10-11-96 (Julia Yarba) - more contrl over showers is given to user
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_params.inc"
#include "mcp_files.inc"
#include "mcp_ranseeds.inc"
#include "mcp_beams.inc"
#include "mcp_debug.inc"
#include "mcp_mcfio.inc"
#include "mcp_summary.inc"
#include "trace_params.inc"
#include "fit_params.inc"
#include "usr_params.inc"
#include "det_draw.inc"
#include "stdlun.inc"		/*! for qqufile  Linux cpp confused by ! */

      integer mlen
      parameter (mlen = 120)

c     Externals
      integer  cmd_match, cmd_integer, cmd_lenstr, cmd_logical
      external cmd_match, cmd_integer, cmd_lenstr, cmd_logical

      real cmd_real
      external cmd_real

      character*(mlen) cmd_string
#ifndef Linux  /* ABSOFT compiler cannot handle external character functions */
      external cmd_string
#endif
      
c     Local variables
      integer mcommand, mdet
      parameter (mcommand = 41)
      character cmdlist(mcommand)*20, subsyslist(dbg_max)*10
      character command*20, chr*1, keyword*20

      character string*(mlen), remain*(mlen), cfile*(mlen)
      integer pos, error, list(10), nread, icmd, leng, status
      integer leng_remain, subsys, lsubsys
      logical linit
      real xlist(10)
      character clist(10)*10

      integer num_ranseed, list_ranseed(2)
      integer num_fcon, list_fcon(2)
      integer num_icon, list_icon(2)

      equivalence (list, xlist)

      save linit, cmdlist, subsyslist
      save num_ranseed, list_ranseed
      save num_fcon, list_fcon
      save num_icon, list_icon

      data cmdlist/
     *  'max_event', 'max_print', 'batch',
     *  'file_in', 'background_in', 'file_out',
     *  'file_type', 'background_type',
     *  'ranseed', 'int_crossing',
     *  'generate_internal', 'fcon', 'icon',
     *  'file_geometry', 'luminosity', 'runtime', 'trigger',
     *  'dbg_trace', 'dbg_hist','qq_user_file',
     *  'make_decays', 'make_pair_convert', 'make_hits',
     *  'make_sec_int', 'use_kalman',
     *  'use_mult_scat', 'use_energy_loss',
     *  'control_shower','user_trigger',
     *  'step_max_distance', 'step_max_angle', 'step_max_dedx',
     *  'step_max_mscat', 'trk_max_turns', 'trk_min_kinetic',
     *  'trk_min_brem', 
     *  'mcfio_out','geomview_out',
     *  'trace_integrated', 'ctk_diag', 'ftk_diag' /

      data num_ranseed, list_ranseed/2, 1, 1/
      data num_fcon, list_fcon/2, 1, 3/
      data num_icon, list_icon/2, 1, 1/
      data linit/.TRUE./
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      geomview_out = .false.

      if(linit) then
        linit = .FALSE.
        subsyslist(jdbg_general) = 'general'
        subsyslist(jdbg_track) = 'track'
        subsyslist(jdbg_shower) = 'shower'
        subsyslist(jdbg_gamma) = 'gamma'
        subsyslist(jdbg_hcal) = 'hcal'
        subsyslist(jdbg_emcal) = 'emcal'
        subsyslist(jdbg_muon) = 'muon'
        subsyslist(jdbg_trig) = 'trig'
        subsyslist(jdbg_geom) = 'geom'
        subsyslist(jdbg_hits) = 'hits'
        subsyslist(jdbg_trace) = 'trace'
        subsyslist(jdbg_fit) = 'fit'
      endif

c     Read commands to process the job. If no command file specified,
c     read from user's terminal
      call cmd_init
      call cmd_open(mcp_filecmd, error)
      if(error .gt. 0) goto 9992

c     Read loop. cmd_readcmd reads in a line of text, skipping comments
c     and stripping off inline comments. The commmands 'exit', 'stop',
c     and 'include' are recognized by the program and dealt with internally.
100   call cmd_readline(string, status)
      if(status .eq. 1) goto 1000              !End of input
      if(status .eq. 2) goto 9999              !Error

c     Get initial keyword and match it to our command list
      call cmd_keyword(string, keyword, pos)
      icmd = cmd_match(keyword, cmdlist, mcommand)
      if(icmd .le. 0) goto 9993

      remain = string(pos+1:)
      leng_remain = cmd_lenstr(remain)

      command = cmdlist(icmd)

c     "generate_internal"
      if(command .eq. 'generate_internal') then
        call gnr_readparam

c     "user_trigger"
      else if(command .eq. 'user_trigger') then
        call usr_trigger

c     "fcon" ... floating point constants defined by user
      else if(command .eq. 'fcon') then
        call cmd_getitems(remain, num_fcon, list_fcon, nread,
     *                    list, clist, error)
        if(error .ne. 0) goto 9994
        if(list(1).le.0 .or.list(1).gt.mcon) goto 9995
        fcon(list(1)) = xlist(2)

c     "file_in" ... signal data files
      else if(command .eq. 'file_in') then
        cfile = cmd_string(remain, error)
        call dtf_addfile(cfile, 1, error)
        if(error .gt. 0) stop

c     "file_type" ... signal data file type
      else if(command .eq. 'file_type') then
        mcp_filetype(1) = cmd_integer(remain, error)
        if(error .gt. 0) stop

c     "background_in" ... background data files
      else if(command .eq. 'background_in') then
        cfile = cmd_string(remain, error)
        call dtf_addfile(cfile, 2, error)
        if(error .gt. 0) stop

c     "background_type" ... signal data file type
      else if(command .eq. 'background_type') then
        mcp_filetype(2) = cmd_integer(remain, error)
        if(error .gt. 0) stop

c     "batch or interactive"
      else if(command .eq. 'batch') then
        list(1) = cmd_logical(remain, error)
        if(error .ne. 0) goto 9993
        mcp_batch = list(1) .eq. 1

c     "trace_integrated"
      else if(command .eq. 'trace_integrated') then
        list(1) = cmd_logical(remain, error)
        if(error .ne. 0) goto 9993
        trk_lintegrated = list(1) .eq. 1
        
c     "make_decays"
      else if(command .eq. 'make_decays') then
        list(1) = cmd_logical(remain, error)
        if(error .ne. 0) goto 9993
        trk_ldecays = list(1) .eq. 1

c     "make_pair_convert"
      else if(command .eq. 'make_pair_convert') then
        list(1) = cmd_logical(remain, error)
        if(error .ne. 0) goto 9993
        trk_lpair = list(1) .eq. 1

c     "make_hits"
      else if(command .eq. 'make_hits') then
        list(1) = cmd_logical(remain, error)
        if(error .ne. 0) goto 9993
        trk_lhits = list(1) .eq. 1

c     "make_sec_int"
      else if(command .eq. 'make_sec_int') then
        list(1) = cmd_logical(remain, error)
        if(error .ne. 0) goto 9993
        trk_lint = list(1) .eq. 1

c     "use_kalman"
      else if(command .eq. 'use_kalman') then
        list(1) = cmd_logical(remain, error)
        if(error .ne. 0) goto 9993
        fit_lkalman = list(1) .eq. 1

c     "use_mult_scat"
      else if(command .eq. 'use_mult_scat') then
        list(1) = cmd_logical(remain, error)
        if(error .ne. 0) goto 9993
        trk_lscat = list(1) .eq. 1


c     "use_energy_loss"
      else if(command .eq. 'use_energy_loss') then
        list(1) = cmd_logical(remain, error)
        if(error .ne. 0) goto 9993
        trk_ldedx = list(1) .eq. 1

c     "contrl_shower"
      else if(command .eq. 'control_shower') then
        call ctl_shw_readparam

c     "step_max_distance"
      else if(command .eq. 'step_max_distance') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9993
        step_max_distance = xlist(1)

c     "step_max_angle"
      else if(command .eq. 'step_max_angle') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9993
        step_max_angle = xlist(1)

c     "step_max_dedx"
      else if(command .eq. 'step_max_dedx') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9993
        step_max_dedx = xlist(1)

c     "step_max_mscat"
      else if(command .eq. 'step_max_mscat') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9993
        step_max_mscat = xlist(1)

c     "trk_max_turns"
      else if(command .eq. 'trk_max_turns') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9993
        trk_max_turns = xlist(1)

c     "trk_min_kinetic"
      else if(command .eq. 'trk_min_kinetic') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9993
        trk_min_kinetic = xlist(1)

c     "trk_min_brem"
      else if(command .eq. 'trk_min_brem') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9993
        trk_min_brem = xlist(1)

c     "qq_user_file" ... QQ user decay file
      else if (command .eq. 'qq_user_file') then
        qqufile = cmd_string(remain,error)

c     "file_out"
      else if(command .eq. 'file_out') then
        mcp_fileout = cmd_string(remain, error)

c     "file_geometry"
      else if(command .eq. 'file_geometry') then
        mcp_filegeo = cmd_string(remain, error)

c     "icon" ... integer constants defined by user
      else if(command .eq. 'icon') then
        call cmd_getitems(remain, num_icon, list_icon, nread,
     *                    list, clist, error)
        if(error .ne. 0) goto 9994
        if(list(1).le.0 .or.list(1).gt.mcon) goto 9995
        icon(list(1)) = list(2)

c     "int_crossing"
      else if(command .eq. 'int_crossing') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9993
        mcp_int_crossing = xlist(1)

c     "max_event"
      else if(command .eq. 'max_event') then
        list(1) = cmd_integer(remain, error)
        if(error .ne. 0) goto 9993
        mcp_maxevent = list(1)

c     "max_print"
      else if(command .eq. 'max_print') then
        list(1) = cmd_integer(remain, error)
        if(error .ne. 0) goto 9993
        mcp_maxprint = list(1)

c     "ranseed"
      else if(command .eq. 'ranseed') then
        call cmd_getitems(remain, num_ranseed, list_ranseed, nread,
     *                    list, clist, error)
        if(error .ne. 0) goto 9993
        mcp_ranseeds(1) = list(1)
        mcp_ranseeds(2) = list(2)

c     "trigger"
      else if(command .eq. 'trigger') then
        call trig_prog_init

c     "luminosity"
      else if(command .eq. 'luminosity') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9993
        mcp_luminst = xlist(1)
        mcp_lumtot = mcp_luminst * mcp_runtime

c     "runtime"
      else if(command .eq. 'runtime') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9993
        mcp_runtime = xlist(1)
        mcp_lumtot = mcp_luminst * mcp_runtime

c     "dbg_trace" ... turn on print statements to trace a subsystem
      else if(command .eq. 'dbg_trace') then
        call cmd_keyword(remain, keyword, pos)
        subsys = cmd_match(keyword, subsyslist, dbg_max)
        if(subsys .le. 0) goto 9993
        remain = remain(pos+1:)
        lsubsys = cmd_logical(remain, error)
        if(error .ne. 0) goto 9993
        dbg_trace(subsys) = lsubsys

c     "dbg_hist" ... turn on histograms to debug a subsystem
      else if(command .eq. 'dbg_hist') then
        call cmd_keyword(remain, keyword, pos)
        subsys = cmd_match(keyword, subsyslist, dbg_max)
        if(subsys .le. 0) goto 9993
        remain = remain(pos+1:)
        lsubsys = cmd_logical(remain, error)
        if(error .ne. 0) goto 9993
        dbg_hist(subsys) = lsubsys
        
c     "mcfio_out" ... output file in MCfio format
      else if(command .eq. 'mcfio_out') then
        mcfio_out = .true.
        mcf_file_out = cmd_string(remain,error)

      else if (command .eq. 'geomview_out') then
        geomview_out = .true.
        geomview_file_out = cmd_string(remain,error)

c     "ctk_diag"
      else if(command .eq. 'ctk_diag') then
        list(1) = cmd_logical(remain, error)
        if(error .ne. 0) goto 9993
        fit_ctk_diag = list(1) .eq. 1

c     "ftk_diag"
      else if(command .eq. 'ftk_diag') then
        list(1) = cmd_logical(remain, error)
        if(error .ne. 0) goto 9993
        fit_ftk_diag = list(1) .eq. 1

c     Unknown
      else
        leng = cmd_lenstr(string)
        write(6,5080) string(:leng)
5080    format(' Error in input: ', a)
        stop 'Quitting ...'

      endif

      goto 100

c     Come here when done reading
1000  continue
      return

c     Come here if open error
9992  leng = max(1, cmd_lenstr(mcp_filecmd))
      write(6,5002) mcp_filecmd(:leng)
5002  format(' Error opening command file "', a,'"')
      stop

c     Come here if error
 9993 leng = cmd_lenstr(string)
      write(6,5009) string(:leng)
 5009 format('Error in expression: "',a,'"')
      stop

c     Come here if error reading user constants
 9994 continue
      stop

c     Come here if index for user constant out of range
 9995 write(6,5041) remain(:leng_remain)
 5041 format('Error in index for user constant: "',a,'"')
      stop

c     Error reading input file
9999  stop
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:20  eugenio
c Initial revision
c
c Revision 1.16  1999/05/12 20:21:34  kutschke
c 21 files changed/added to implement ctk Kalman filter.
c
c Revision 1.15  1998/11/24  19:43:27  procario
c Remove external on character functions on LInux only
c
c Revision 1.14  1998/11/20  22:41:17  procario
c On Linux the ! comment after an include does not work use C style instead
c
c Revision 1.13  1998/06/29  21:22:56  yarba_j
c added user switch for integrated (C++) tracing algorithm
c
c Revision 1.12  1998/04/24  21:00:05  mcbride
c  add debug flag for trace and fit steps
c
c Revision 1.11  1998/02/13  23:08:51  kutschke
c Read fit_lkalman.
c
c Revision 1.10  1998/02/13  19:22:43  mcbride
c add switch for secondary interactions
c
c Revision 1.9  1997/04/04  18:07:55  garren
c add hooks to initialize user trigger code
c

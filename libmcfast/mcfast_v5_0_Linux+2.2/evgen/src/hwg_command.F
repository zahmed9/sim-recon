      subroutine hwg_command
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Read Herwig commands from file.
c
c  Input is interpreted by a simple parsing package.
c
c  input file format:
c            keyword value
c        or  keyword value1 value2
c
c    where keyword is one of the variables that can be set
c

c  Author: Paul Avery  3-7-94
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#include "herwig61.inc"
#include "file_names.inc"
#include "herwig_cmd.inc"
#include "qq_flag.inc"
#include "stdlun.inc"

c     Externals
      integer  cmd_match, cmd_integer, cmd_lenstr
      real cmd_real
      character*200 cmd_string
      external cmd_match, cmd_integer, cmd_lenstr
      external cmd_real
      external cmd_string

c     Local variables
      integer mlen
      parameter (mlen = 200)

      character command*15, chr*1, keyword*15
      character string*(mlen), remain*(mlen)
      integer pos, error, list(10), nread, icmd, leng, status
      real xlist(10)
      character clist(10)*10

      integer num_ranseed, list_ranseed(2)
      integer num_rmass, list_rmass(2)

      equivalence (list, xlist)

      data cmdlist/
     *  'maxev', 'iprint','maxpr',  'maxer',
     *  'iproc', 'part1', 'part2',
     *  'pbeam1', 'pbeam2', 'ranseed',
     *  'ptmin', 'ptmax', 'yjmin',  'yjmax',
     *  'q2min', 'q2max', 'emmin', 'emmax', 'qcdlam',
     *  'rmass','qq','qq_user_file',
     *  'file_hbk', 'file_lpt', 'file_evt_rd', 'file_evt_wrt',
     *  'exit',  'stop'/

      data num_ranseed, list_ranseed/2, 1, 1/
      data num_rmass,   list_rmass  /2, 1, 2/
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Read commands to process the job. If no command file specified,
c     read from user's terminal
      call cmd_init
      call cmd_open(file_input, error)
      if(error .gt. 0) goto 9992

      nstring_list = 0

c     Read loop. cmd_readcmd reads in a line of text, skipping comments
c     and stripping off inline comments. The commmands 'exit', 'stop',
c     and 'include' are recognized by the program and dealt with internally.
100   call cmd_readline(string, status)
      if(status .eq. 1) goto 1000              !End of input
      if(status .eq. 2) goto 9998              !Error

c     Get initial keyword and match it to our command list
      call cmd_keyword(string, keyword, pos)
      icmd = cmd_match(keyword, cmdlist, mcommand)
      if(icmd .le. 0) goto 9997

      remain = string(pos+1:)

      command = cmdlist(icmd)

c     "exit" or "stop" encountered: quit reading the file
      if(command.eq.'exit' .or. command.eq.'stop') then
        goto 1000

c     "maxev"
      else if(command .eq. 'maxev') then
        list(1) = cmd_integer(remain, error)
        if(error .ne. 0) goto 9997
        maxev = list(1)

c     "file_hbk"
      else if(command .eq. 'file_hbk') then
        file_hbk = cmd_string(remain, error)

c     "file_lpt"
      else if(command .eq. 'file_lpt') then
        file_lpt = cmd_string(remain, error)

c     "file_evt_rd"
      else if(command .eq. 'file_evt_rd') then
        file_evt_rd = cmd_string(remain, error)

c     "file_evt_wrt"
      else if(command .eq. 'file_evt_wrt') then
        file_evt_wrt = cmd_string(remain, error)

c     "maxpr"
      else if(command .eq. 'maxpr') then
        list(1) = cmd_integer(remain, error)
        if(error .ne. 0) goto 9997
        maxpr = list(1)
        nstring_list = nstring_list + 1
        string_list(nstring_list) = command
        ival_string(1,nstring_list) = list(1)

c     "maxer"
      else if(command .eq. 'maxer') then
        list(1) = cmd_integer(remain, error)
        if(error .ne. 0) goto 9997
        maxer = list(1)

c     "iprint"
      else if(command .eq. 'iprint') then
        list(1) = cmd_integer(remain, error)
        if(error .ne. 0) goto 9997
        iprint = list(1)

c     "iproc"
      else if(command .eq. 'iproc') then
        list(1) = cmd_integer(remain, error)
        if(error .ne. 0) goto 9997
        iproc = list(1)

c     "part1"
      else if(command .eq. 'part1') then
        clist(1) = cmd_string(remain, error)
        if(clist(1) .eq. ' ') goto 9997
        part1 = clist(1)

c     "part2"
      else if(command .eq. 'part2') then
        clist(1) = cmd_string(remain, error)
        if(clist(1) .eq. ' ') goto 9997
        part2 = clist(1)

c     "pbeam1"
      else if(command .eq. 'pbeam1') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9997
        pbeam1 = xlist(1)

c     "pbeam2"
      else if(command .eq. 'pbeam2') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9997
        pbeam2 = xlist(1)

c     "ranseed"
      else if(command .eq. 'ranseed') then
        call cmd_getitems(remain, num_ranseed, list_ranseed, nread,
     *                    list, clist, error)
        if(error .ne. 0) goto 9997
        nrn(1) = list(1)
        nrn(2) = list(2)
        nstring_list = nstring_list + 1
        string_list(nstring_list) = command
        ival_string(1,nstring_list) = nrn(1)
        ival_string(2,nstring_list) = nrn(2)

c     "ptmin"
      else if(command .eq. 'ptmin') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9997
        ptmin = xlist(1)
        nstring_list = nstring_list + 1
        string_list(nstring_list) = command
        val_string(1,nstring_list) = ptmin

c     "ptmax"
      else if(command .eq. 'ptmax') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9997
        ptmax = xlist(1)
        nstring_list = nstring_list + 1
        string_list(nstring_list) = command
        val_string(1,nstring_list) = ptmax

c     "yjmin"
      else if(command .eq. 'yjmin') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9997
        yjmin = xlist(1)
        nstring_list = nstring_list + 1
        string_list(nstring_list) = command
        val_string(1,nstring_list) = yjmin

c     "yjmax"
      else if(command .eq. 'yjmax') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9997
        yjmax = xlist(1)
        nstring_list = nstring_list + 1
        string_list(nstring_list) = command
        val_string(1,nstring_list) = yjmax

c     "qcdlam"
      else if(command .eq. 'qcdlam') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9997
        qcdlam = xlist(1)
        nstring_list = nstring_list + 1
        string_list(nstring_list) = command
        val_string(1,nstring_list) = qcdlam

c     "rmass"
      else if(command .eq. 'rmass') then
        call cmd_getitems(remain, num_rmass, list_rmass, nread,
     *                    list, clist, error)
        if(error .ne. 0) goto 9997
        if(list(1).le.0 .or. list(1).gt.264) goto 9997
        rmass(list(1)) = xlist(2)
        nstring_list = nstring_list + 1
        string_list(nstring_list) = command
        ival_string(1,nstring_list) = list(1)
        val_string(1,nstring_list) = rmass(list(1))

c     "qq"
      else if(command .eq. 'qq') then
        lqq = .true.

c     "qq_user_file"
      else if(command .eq. 'qq_user_file') then
        clist(1) = cmd_string(remain, error)
        if(error .ne. 0) goto 9997
        qqufile = clist(1)

c     Unknown
      else
        leng = cmd_lenstr(string)
        write(6,5080) string(:leng)
5080    format(' Error in input: ', a)

      endif

      goto 100

c     Come here when done reading
1000  continue
      return

c     Come here if could not open file
9992  leng = cmd_lenstr(file_input)
      write(6,5011) file_input(:leng)
5011  format('Could not open file "',a,'"')
      stop

c     Come here if error reading line
9997  leng = cmd_lenstr(string)
      write(6,5012) string(:leng)
5012  format('Problem reading line: "',a,'"')
      stop

9998  leng = cmd_lenstr(file_input)
      write(6,5013) file_input(:leng)
5013  format('Error reading file: "',a,'"')
      stop

      end
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:35  eugenio
c Initial revision
c
c Revision 1.7  2000/01/26 02:51:44  bphyslib
c use herwig61.inc
c
c Revision 1.6  1998/07/09  21:00:21  garren
c for lund v6_115, herwig v5_9a, and isajet v7_37
c
c Revision 1.5  1998/06/25  15:48:59  bphyslib
c add all necessary changes from v3_3
c


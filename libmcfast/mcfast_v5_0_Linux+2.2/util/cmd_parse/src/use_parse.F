      subroutine test_parse(luin)
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  This is an example program showing how to read a command file and set
c  variables. Input is interpreted by the routines in cmd_parse.f.
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

c  Author: Paul Avery  3-7-94
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#include "herwig57.inc"

c---  User input, output files
      character*80 file_input, file_lpt, file_evt
      common/herwig_r1/file_input, file_lpt, file_evt

      integer mcommand
      parameter (mcommand = 24)
      character cmdlist*10
      common/herwig_r4/cmdlist(mcommand)

c     Externals
      integer  cmd_match, cmd_integer, cmd_lenstr
      real cmd_real
      character*80 cmd_string, cmd_strip
      external cmd_match, cmd_integer, cmd_lenstr
      external cmd_real
#ifndef Linux  /* ABSOFT compiler cannot handle external character functions */
      external cmd_string
      external cmd_strip
#endif
      
c     Arguments
      integer luin	!Fortran unit number for reading

c     Local variables
      integer mlen
      parameter (mlen = 120)

      character command*10, chr*1, keyword*10
      character string*(mlen), remain*(mlen)
      integer pos, error, list(10), nread, icmd, leng
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
     *  'rmass', 'file_lpt', 'file_evt',
     *  'exit',  'stop'/

      data num_ranseed, list_ranseed/2, 1, 1/
      data num_rmass,   list_rmass  /2, 1, 2/
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

100   read(luin, 5000, end=1000, err=9998) string
5000  format(a)

C     Skip comments( blank line or "!" in first column)
c     Get rid of ! comments
      if(string .eq. ' ') goto 100
      chr = string(1:1)
      if(chr .eq. '!') goto 100

      string = cmd_strip(string)     !Strip trailing ! comments

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

c     "file_lpt"
      else if(command .eq. 'file_lpt') then
        file_lpt = cmd_string(remain, error)

c     "file_evt"
      else if(command .eq. 'file_evt') then
        file_evt = cmd_string(remain, error)

c     "maxpr"
      else if(command .eq. 'maxpr') then
        list(1) = cmd_integer(remain, error)
        if(error .ne. 0) goto 9997
        maxpr = list(1)

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

c     "ptmin"
      else if(command .eq. 'ptmin') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9997
        ptmin = xlist(1)

c     "ptmax"
      else if(command .eq. 'ptmax') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9997
        ptmax = xlist(1)

c     "yjmin"
      else if(command .eq. 'yjmin') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9997
        yjmin = xlist(1)

c     "yjmax"
      else if(command .eq. 'yjmax') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9997
        yjmax = xlist(1)

c     "qcdlam"
      else if(command .eq. 'qcdlam') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9997
        qcdlam = xlist(1)

c     "rmass"
      else if(command .eq. 'rmass') then
        call cmd_getitems(remain, num_rmass, list_rmass, nread,
     *                    list, clist, error)
        if(error .ne. 0) goto 9997
        if(list(1).le.0 .or. list(1).gt.264) goto 9997
        rmass(list(1)) = xlist(2)

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

c     Come here if error
9997  continue
      return

9998  continue
      return

      end

      subroutine pyt_command
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Read Pythia commands from file.
c
c  Input is interpreted by a simple parsing package.
c
c  input file format:
c            keyword value
c        or  keyword value1 value2
c        or  pygive  string
c
c    where string is passed to routine pygive. It has the form
c
C            'PYVAR0=X; PYVAR1(I,J)=Y; PYVAR2(K)=Z'
C            'PYVAR3(L,M)=T; PYVAR4=U'
C            'PYVAR5(L)=V; ...etc.'
C            'etc.....'
C            'etc.....'
C
C      Where:
C          PYVARi refers to some Pythia variable in the Pythia common blocks.
C          I,J,K,L,M are indices for array variables.
C      For example, MSTU(32) = ...

c  Author: Paul Avery  3-7-94
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#include "stdhep.inc"
#include "stdlun.inc"
#include "pydat1.inc"
#include "pydatr.inc"
#include "file_names.inc"
#include "pythia_user.inc"
#include "qq_flag.inc"

c     Externals
      integer  cmd_match, cmd_integer, cmd_lenstr
      real cmd_real
      character cmd_string*200
      external cmd_match, cmd_integer, cmd_lenstr
      external cmd_real
      external cmd_string

c     Local variables
      integer mlen, mcommand
      parameter (mlen = 120)
      parameter (mcommand = 17)

      character chr*1, keyword*20, command*20
      character string*(mlen), remain*(mlen), cmdlist(mcommand)*(mlen)
      integer pos, error, list(10), nread, icmd, leng, status
      real xlist(10)
      character clist(10)*(mlen)

      equivalence (list, xlist)

      data cmdlist/
     *  'maxev', 'maxpr', 'ranseed','qq','qq_user_file',
     *  'pygive', 'frame', 'beam', 'target', 'cms_energy',
     *  'file_lpt', 'file_hbk', 'file_evt_wrt', 'file_evt_rd',
     *  'jetset_decay_file','exit',  'stop'/
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Read commands to process the job. If no command file specified,
c     read from user's terminal
      call cmd_init
      call cmd_open(file_input, error)
      if(error .gt. 0) goto 9992

      nstring_list = 0
      npygv = 0
      qqufile = ' '

c     set default jetset_decay_file
      call getenv('EVGEN_DIR',string)
      leng = index(string,' ') - 1
      jetset_decay_file = string(:leng) // '/input/jetset.dcy'
      

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

c     "pygive" ... pass string to pygive for further processing
c      just store the remainder of the string here and call pygive later
      else if(command .eq. 'pygive') then
        npygv = npygv + 1
        pygvlst(npygv) = remain

c     "maxev"
      else if(command .eq. 'maxev') then
        list(1) = cmd_integer(remain, error)
        if(error .ne. 0) goto 9997
        maxev = list(1)

c     "maxpr"
      else if(command .eq. 'maxpr') then
        list(1) = cmd_integer(remain, error)
        if(error .ne. 0) goto 9997
        maxpr = list(1)

c     "ranseed"
      else if(command .eq. 'ranseed') then
        list(1) = cmd_integer(remain, error)
        if(error .ne. 0) goto 9997
        mrpy(1) = list(1)

c     "qq"
      else if(command .eq. 'qq') then
        lqq = .true.

c     "qq_user_file"
      else if(command .eq. 'qq_user_file') then
        clist(1) = cmd_string(remain, error)
        if(error .ne. 0) goto 9997
        qqufile = clist(1)

c     "frame"
      else if(command .eq. 'frame') then
        clist(1) = cmd_string(remain, error)
        if(error .ne. 0) goto 9997
        frame = clist(1)

c     "beam"
      else if(command .eq. 'beam') then
        clist(1) = cmd_string(remain, error)
        if(error .ne. 0) goto 9997
        beam = clist(1)

c     "target"
      else if(command .eq. 'target') then
        clist(1) = cmd_string(remain, error)
        if(error .ne. 0) goto 9997
        target = clist(1)

c     "cms_energy"
      else if(command .eq. 'cms_energy') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9997
        cms_energy = xlist(1)

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

c     "jetset_decay_file"
      else if(command .eq. 'jetset_decay_file') then
        jetset_decay_file = cmd_string(remain, error)

      endif

      goto 100

c     Come here when done
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
c Revision 1.7  1999/09/13 20:04:14  garren
c need to be able to recognize a longer keyword
c
c Revision 1.6  1998/07/09  21:00:23  garren
c for lund v6_115, herwig v5_9a, and isajet v7_37
c
c Revision 1.5  1998/06/25  15:49:01  bphyslib
c add all necessary changes from v3_3
c

      subroutine cmd_readline(string, status)

c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c 
c  Reads a line of text and returns it to the user
c 
c  Inputs
c
c  None
c
c  Outputs
c
c   string      character variable
c               Input string we are trying to parse
c
c   status      integer variable
c                 0 if string filled normally
c                 1 if no more commands
c                 2 if error encountered
c 
c  author:    Paul Avery  Mar. 26, 1994
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "cmd_datatype.inc"
#include "cmd_parse.inc"

c     Externals
      integer  cmd_match
      external cmd_match

      character cmd_strip*120, cmd_string*80
#ifndef Linux  /* ABSOFT compiler cannot handle external character functions */
      external  cmd_strip, cmd_string
#endif

c     Calling arguments
      character*(*) string
      integer status

c     Local variables
      character cmdlist(3)*10, command*10, keyword*20, remain*80
      character cfile*80
      integer pos, error, icmd
      data cmdlist/
     *  'include', 'exit',  'stop'/
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

100   if(cmd_lun .eq. 0) goto 1000
      read(cmd_lun, 5000, end=500, err=9999) string
5000  format(a)

C     Skip comments( blank line or "!" in first column)
      string = cmd_strip(string)     !Strip trailing ! comments
      if(string .eq. ' ') goto 100

c     Get initial keyword and match it to our command list
      call cmd_keyword(string, keyword, pos)
      icmd = cmd_match(keyword, cmdlist, 3)
      if(icmd .le. 0) goto 400

      remain = string(pos+1:)

      command = cmdlist(icmd)

c     "exit" or "stop" encountered: quit reading the file
      if(command.eq.'exit' .or. command.eq.'stop') then
        goto 500

c     "include" encountered: open new file for reading
      else if(command .eq. 'include') then
        cfile = cmd_string(remain, error)
        call cmd_open(cfile, error)
        if(error .gt. 0) then
          status = 2
          return
        endif
        goto 100

      endif

c     Line read in. Return string to user.
400   status = 0
      return

c     Encountered "exit", "stop" or end of file ==> Quit file
500   call cmd_close
      goto 100

c     End of all input
1000  status = 1
      string = ' '
      return

c     Error reading
9999  status = 2
      string = ' '
      return
      end

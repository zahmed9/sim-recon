      subroutine mcp_checktypein

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Check to see if user typed anything at the terminal (async. read)
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_params.inc"

c     Externals
      integer  cmd_readterm, cmd_match, cmd_lenstr, cmd_integer
      external cmd_readterm, cmd_match, cmd_lenstr, cmd_integer

c     Local variables
      integer mcmdlist
      parameter (mcmdlist = 13)
      integer i, status, pos, icmd, leng, leng2, hist, error, skip
      character keyword*10, cmdlist(mcmdlist)*10, command*10
      character string*80, remain*80, chdir*80

      save cmdlist
      data cmdlist/
     *  'exit', 'quit', 'stop', 'status', 'help',
     *  'user', 'hcdir', 'hldir', 'htype', 'pause',
     *  'continue', 'next', 'skip'/
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

 500  if(mcp_pause) then
        call cmd_prompt('mcfast> ')
        read(5,5005) string
 5005   format(a)
      else
        status = cmd_readterm(string)
        if(status .eq. 0) goto 1000
      endif

      call cmd_keyword(string, keyword, pos)
      icmd = cmd_match(keyword, cmdlist, mcmdlist)
      leng = cmd_lenstr(string)

c     Don't type out status by default if we are paused
      if(leng.eq.0 .and. mcp_pause) then
        goto 500
      else if(leng .eq. 0) then
        command = 'status'
      else if(icmd .le. 0) then
        goto 9991
      else if(icmd .gt. 0) then
        command = cmdlist(icmd)
        remain = string(pos+1:)
        leng2 = cmd_lenstr(remain)
      endif

      if(command.eq.'exit' .or. command.eq.'quit' .or.
     *  command.eq.'stop') then
        mcp_exit = .TRUE.
        goto 1000

      else if(command .eq. 'status') then
        call mcp_status(6)

      else if(command .eq. 'hcdir') then
        chdir = remain
        if(chdir .ne. ' ') call hcdir(chdir, ' ')

      else if(command .eq. 'hldir') then
        call hcdir(chdir, 'R')
        call hldir(chdir, ' ')

      else if(command .eq. 'htype') then
        hist = cmd_integer(remain, error)
        if(error .ne. 0) goto 9992
        call houtpu(6)
        call hprint(hist)

      else if(command .eq. 'help') then
        write(6,5001)
5001    format(/' List of commands (can be abbreviated):',/
     *    ' continue         Continue after a pause',/
     *    ' exit/quit/stop   Stop reading data and finish',/
     *    ' help             Print this message'/
     *    ' hcdir <dir>      Change Hbook directory'/
     *    ' hldir            List contents of current Hbook directory'/
     *    ' htype <#>        Type Hbook histogram in current'
     *                       ' directory'/
     *    ' next             Analyze next event and pause'/
     *    ' pause            Pause and wait for further commands'/
     *    ' skip <n>         Read in but do not analyze the next n',
     *                       ' events'/
     *    ' status           Print a brief status message to terminal'/
     *    ' user             Call "usr_command" (supplied by user)'/
     *    ' <CR>             Same as "status"')

      else if(command .eq. 'next') then
        return

      else if(command .eq. 'pause') then
        mcp_pause = .TRUE.
        goto 500

      else if(command .eq. 'continue') then
        mcp_pause = .FALSE.

c     Skip events ... read and throw away the specified # of events
      else if(command .eq. 'skip') then
        skip = cmd_integer(remain, error)
        if(error .ne. 0) goto 9992
        do i=1,skip
          call mcp_nextevent(status)
          if(status .ne. 0) then
            mcp_exit = .TRUE.   !End of data
            goto 1000
          endif
        enddo

      else if(command .eq. 'user') then
        call usr_command

      endif

      if(mcp_pause) goto 500

c     Come here when done
1000  return

c     Illegal command
 9991 write(6,5011) string(:leng)
 5011 format(/' Illegal command: "',a,'"')
      if(mcp_pause) goto 500
      return

c     Illegal integer
 9992 write(6,5012) remain(:leng2)
 5012 format(/' Illegal integer: "',a,'"')
      if(mcp_pause) goto 500
      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:19  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 18:07:49  garren
c add hooks to initialize user trigger code
c

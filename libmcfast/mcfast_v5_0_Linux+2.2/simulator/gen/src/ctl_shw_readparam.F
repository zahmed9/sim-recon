      subroutine ctl_shw_readparam
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Read commands to define shower control parameters
c
c  input file format:
c            keyword value
c
c    where keyword is one of the variables that can be set
c
c  A whole series of reals, integers and strings can be read in. See the
c  routine cmd_getitems which is used below.
c

c  Author: Julia Yarba 10-11-96
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_luns.inc"
#include "control_shower.inc"

      integer mlen
      parameter (mlen = 120)

c     Externals
      integer  cmd_match, cmd_integer, cmd_logical, cmd_lenstr
      external cmd_match, cmd_integer, cmd_logical, cmd_lenstr

      real cmd_real
      external cmd_real

      character*(mlen) cmd_string
#ifndef Linux  /* ABSOFT compiler cannot handle external character functions */
      external cmd_string
#endif
      
c     Local variables
      integer mcommand
      parameter (mcommand = 6)
      character cmdlist(mcommand)*20
      character command*20, chr*1, keyword*20

      character string*(mlen), remain*(mlen), cfile*(mlen)
      integer pos, error, list(10), nread, icmd, leng, status
      integer leng_remain, leng_string
      real xlist(10)
      character*20 clist(20)

      equivalence (list, xlist)

      data cmdlist/
     * 'shw_trans', 'e_thresh', 'max_hit_step', 
     * 'e_vis_min', 'hit_generation', 'end'/

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Read loop. cmd_readcmd reads in a line of text, skipping comments
c     and stripping off inline comments. The commmands 'exit', 'stop',
c     and 'include' are recognized by the program and dealt with internally.
100   call cmd_readline(string, status)
      if(status .eq. 1) goto 1000              !End of input
      if(status .eq. 2) goto 9999              !Error

      leng_string = cmd_lenstr(string)

c     Get initial keyword and match it to our command list
      call cmd_keyword(string, keyword, pos)
      icmd = cmd_match(keyword, cmdlist, mcommand)
      if(icmd .le. 0) goto 9993

      remain = string(pos+1:)
      leng_remain = cmd_lenstr(remain)

      command = cmdlist(icmd)

c     "shw_trans"
      if(command .eq. 'shw_trans') then
        list(1) = cmd_logical(remain, error)
        if(error .ne. 0) goto 9993
        shw_trans = list(1) .eq. 1

c     "e_thresh"
      else if(command .eq. 'e_thresh') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9993
        thresh = xlist(1)

c     "e_vis_min"
      else if(command .eq. 'e_vis_min') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9993
        e_vis_min = xlist(1)

c     "max_hit_step"
      else if (command .eq. 'max_hit_step') then 
        max_ndep = cmd_integer(remain,error)
        if (error .gt. 0) stop

c     "hit_generation"
      else if (command .eq. 'hit_generation') then
        list(1) = cmd_logical(remain, error)
        if(error .ne. 0) goto 9993
        hit_generation = list(1) .eq. 1
c     Turn OFF shower transverse profile if hit_generation is OFF !
c     Otherwise it's just a waisting of time...
        if (.not.(hit_generation)) then
         shw_trans = .false.
        end if 

c     "end"
      else if(command .eq. 'end') then
        goto 1000

      endif

      goto 100

c     Come here when done reading
 1000 continue
      return

c     Error reading line
 9993 write(6,5033) string(:leng_string), remain(:leng_remain)
 5033 format(a,/,'Error reading command line: "',a,'"')
      stop

c     Error reading input file
 9999 stop
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:19  eugenio
c Initial revision
c
c Revision 1.5  1998/11/24 19:43:26  procario
c Remove external on character functions on LInux only
c
c Revision 1.4  1997/04/04  18:07:47  garren
c add hooks to initialize user trigger code
c

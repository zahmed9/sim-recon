      subroutine trig_prog_init
c----------------------------------------------------------------------
c-
c-   purpose and methods : initializes triggers and terms
c-
c-   inputs  : logical unit number for read
c-   outputs : 
c-   controls: 
c-
c-   created  21-feb-1994   amber s. boehnlein
c-
c----------------------------------------------------------------------

      implicit none

c     Externals
      integer  cmd_lenstr, cmd_match
      external cmd_lenstr, cmd_match

      integer mcom1, mcom2
      parameter (mcom1 = 3)
      parameter (mcom2 = 2)

      character*20 cmds1(mcom1), cmds2(mcom2), com1, com2, keyword
      character*127 line, remain

      integer icmd1, icmd2, status, ier, leng, pos
      logical parse, ok
      integer bitnumber, level

      data cmds1/'l1', 'l2', 'end'/
      data cmds2/'define', 'term'/
c----------------------------------------------------------------------

      parse = .true.
      do while (parse)
        ok = .true.

        call cmd_readline(line, status)
        if(status .eq. 1) goto 1000              !End of input
        if(status .eq. 2) goto 9995              !Error

c     Get initial keyword and match it to our command list
        call cmd_keyword(line, keyword, pos)
        icmd1 = cmd_match(keyword, cmds1, mcom1)
        if(icmd1 .le. 0) goto 9993
        com1 = cmds1(icmd1)

        remain = line(pos+1:)

        call cmd_keyword(remain, keyword, pos)
        if(com1 .ne. 'end') then
          icmd2 = cmd_match(keyword, cmds2, mcom2)
          if(icmd2 .le. 0) goto 9993
          com2 = cmds2(icmd2)
        endif

c     "end"
        if(com1 .eq. 'end') then
           parse = .false.

c     "l1" ==> level 1
        else if(com1 .eq. 'l1') then
          if(com2 .eq. 'define') then
            call trig_define_trigger(line,bitnumber,level,ier)
            if(ier.lt.0) ok=.false.
          else if(com2 .eq. 'term ') then
            call trig_define_term(line,bitnumber,level,ier)
            if(ier.lt.0) ok=.false.
          else
          endif

c     "l2" ==> level 2
        else if(com1 .eq. 'l2') then
          if(com2 .eq. 'define') then
            call trig_define_trigger(line,bitnumber,level,ier)
            if(ier.lt.0) ok=.false.
          else if(com2 .eq. 'term ') then
            call trig_define_term(line,bitnumber,level,ier)
            if(ier.lt.0) ok=.false.
          else
          endif
        endif
!        if (.not.ok) continue !print a warning
      enddo

c     Come here when end of input or "end" encountered
 1000 continue
      return

c     Come here if error encountered during read
 9995 write(6,5000)
 5000 format('Trig: Error encountered reading input')
      stop

c     Come here if bad keyword
 9993 leng = cmd_lenstr(line)
      write(6,5001) line(:leng)
 5001 format(' Trig: bad keyword: "',a,'"')
      stop

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:40  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:49  garren
c add rcs log line
c

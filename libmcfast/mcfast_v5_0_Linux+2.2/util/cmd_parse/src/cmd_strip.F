      character*(*) function cmd_strip(cstring)
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Strips inline "!" comment from a string and returns the part before
c   the comment.
c   Also: convert tabs to spaces
c
c  Input:
c
c   cstring   character variable
c             Character string to be stripped
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c     Externals
      integer  cmd_lenstr
      external cmd_lenstr

c     Arguments
      character*(*) cstring

c     Local variables
      integer pos, clen, i, ich
      character*1 atab, blank, ch
      data atab, blank /'	', ' '/
c  need this for Linux
      equivalence(ch,ich)
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      pos = index(cstring, '!')
      if(pos .gt. 1) then
        cmd_strip = cstring(:pos-1)
      else if(pos .eq. 1) then
        cmd_strip = ' '
      else
        cmd_strip = cstring
      endif
c
      clen = cmd_lenstr(cmd_strip)
      do i=1,clen
         ch = cmd_strip(i:i)
#ifdef Linux
         if(ich .eq. 9) cmd_strip(i:i) = blank
#else
         if(ch .eq. atab ) cmd_strip(i:i) = blank
#endif
      enddo

c     Normal exit
      return
      end

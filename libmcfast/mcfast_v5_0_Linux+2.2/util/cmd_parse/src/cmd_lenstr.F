      integer function cmd_lenstr(string)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Returns the position of the last non-blank character in "string"
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c     Arguments
      character string*(*)

c     Local variables
      integer i
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      do i=len(string),1,-1
        if(string(i:i) .ne. ' ') goto 100
      enddo
      i = 0

 100  cmd_lenstr = i

      return
      end

      character*(*) function cmd_string(cstring, error)
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Converts "cstring" to a string starting at a non-blank character
c
c  Input:
c
c   cstring   character variable
c             Character string to be converted to integer
c
c  Output:
c
c   error     integer variable
c             0 if no error during conversion
c             1 if error during conversion
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c     Externals
      integer  cmd_lenstr
      external cmd_lenstr

c     Arguments
      character*(*) cstring
      integer error

c     Local variables
      integer leng, i
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      leng = cmd_lenstr(cstring)
      error = 0

c     Remove all blanks in front of string
      do i=1,leng
        if(cstring(i:i) .ne. ' ') then
          cmd_string = cstring(i:)
          goto 1000
        endif
      enddo
      cmd_string = ' '

c     Normal exit
 1000 return
      end

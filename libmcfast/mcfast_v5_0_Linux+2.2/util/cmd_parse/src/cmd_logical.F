      integer function cmd_logical(cstring, error)
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Converts "cstring" to an logical integer (0 or 1)
c
c  Input:
c
c   cstring   character variable
c             Character string to be converted to logical integer (0 or 1)
c             Mixed case is acceptable since the string is converted to
c             uppercase before testing
c             1 ==> TRUE,  .TRUE.,  T, ON,  YES, Y
c             0 ==> FALSE, .FALSE., F, OFF, NO,  N
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
      character*80 string
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      leng = cmd_lenstr(cstring)

c     Remove all blanks in front of string
      string = ' '
      do i=1,leng
        if(cstring(i:i) .ne. ' ') then
          string = cstring(i:)
          goto 1000
        endif
      enddo

 1000 call cmd_upcase(string, string)

      if(string.eq.'TRUE' .or. string.eq.'.TRUE.' .or.
     *   string.eq.'ON'   .or. string.eq.'YES'    .or.
     *   string.eq.'T'    .or. string.eq.'Y') then
        cmd_logical = 1
        error = 0

      else if(string.eq.'FALSE' .or. string.eq.'.FALSE.' .or.
     *        string.eq.'OFF'   .or. string.eq.'NO'      .or.
     *        string.eq.'F'     .or. string.eq.'N') then
        cmd_logical = 0
        error = 0

      else
        cmd_logical = 0
        error = 1
      endif

      return
      end

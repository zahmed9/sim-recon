      integer function cmd_integer(cstring, error)
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Converts "cstring" to an integer
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
      integer a, leng
      character cformat*20
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Compute format statement because asshole IBM compiler does not
c     support descriptors without field widths.
      leng = cmd_lenstr(cstring)
      write(cformat,5001) leng
 5001 format('(i', i2.2, ')' )

      read(cstring, cformat, err=9999) a

c     Normal exit
      error = 0
      cmd_integer = a
      return

c     Error exit
 9999 error = 1
      cmd_integer = 0

      return
      end

      subroutine cmd_dump(string, lun)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    Writes "string" character by character to Fortran unit lun.
c    Each character's decimal value is printed out.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c     Externals
      integer  cmd_lenstr
      external cmd_lenstr

c     Arguments
      character string*(*)
      integer lun

c     Local variables
      integer i, leng
      character chr*1
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(lun .eq. 0) return

      leng = len(string)
      do i=1,leng
        chr = string(i:i)
        write(lun,5000) i, ichar(chr), chr
 5000   format(2i5, 1x, '"', a, '"')
      enddo

      return
      end

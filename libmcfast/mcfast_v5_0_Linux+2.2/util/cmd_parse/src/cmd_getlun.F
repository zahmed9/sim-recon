      subroutine cmd_getlun(lun)
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Finds next available fortran unit and returns the answer in "lun".
c   if none is available lun is set to 0.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
      implicit none

c     Calling argument
      integer lun
c
      logical lopen
      integer i
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c     Loop through units until we find one that's available
      do i=99,1,-1
        inquire(unit=i, opened=lopen)
        if(.not. lopen) then
          lun = i
          goto 1000
        endif
      enddo
      lun = 0
c
c     only exit point
1000  return
      end

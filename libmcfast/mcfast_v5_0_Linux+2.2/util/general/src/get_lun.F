      subroutine get_lun(lun)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     Finds next available Fortran unit and returns the answer in "lun".
C     If none is available lun is set to 0.
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
      implicit none
C     Calling argument
      integer lun
C
      logical lopen
      integer i
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
C     Loop through units until we find one that's available
      do i=99,1,-1
        inquire(unit=i, opened=lopen)
        if(.not. lopen) then
          lun = i
          goto 1000
        endif
      enddo
      lun = 0
C
C     Only exit point
1000  return
      end
c$Id$
c$Log$
cRevision 1.1  2000/06/19 19:59:49  eugenio
cInitial revision
c
cRevision 1.2  1997/03/10 22:07:33  garren
cadd c$Log$
cadd cRevision 1.1  2000/06/19 19:59:49  eugenio
cadd cInitial revision
cadd c
c

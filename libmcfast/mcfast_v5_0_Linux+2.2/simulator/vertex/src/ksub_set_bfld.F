      subroutine ksub_set_bfld(bfld, ltesla)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Sets the magnitude of magnetic field BFLDKN (always in Tesla).
C
C  BFLD    real variable (read)
C          B field
C
C  LTESLA  logical variable (read)
C          TRUE  = > BFLD is in Tesla
C          FALSE = > BFLD is in kGauss
C  10/31/94 A. Boehnlein from P. Avery CLEO KSBFLD
C  05/06/96 A. Boehnlein  moved call to kfil_bfield_rotation to here.
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none
#include "const.inc"
#include "kine_bfld.inc"
      integer kfil_bfield_rotation
      external kfil_bfield_rotation
      integer ok

C     External declarations

C     Calling arguments
      logical ltesla
      record /bfield_struct/ bfld

C     Local variables
!?
      DFLOAT cross, mag
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C     Be careful of units
      kine_bfld.bmag = bfld.bmag
      if(.not. ltesla) kine_bfld.bmag = kine_bfld.bmag / 10.

C     Calculate B field components
      kine_bfld.bdir(1) = bfld.bdir(1) 
      kine_bfld.bdir(2) = bfld.bdir(2) 
      kine_bfld.bdir(3) = bfld.bdir(3) 
      kine_bfld.type =    bfld.type       

C     Set up rotation matrix to rotate tracks such that "Z" is
C     along the direction of the field 
      ok = kfil_bfield_rotation()
      if(ok.ne.0) print *, "track rotation matrix not correct!"

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:47  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:32:09  garren
c add rcs log line
c

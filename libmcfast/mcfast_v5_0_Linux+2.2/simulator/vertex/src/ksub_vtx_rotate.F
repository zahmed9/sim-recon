      integer function ksub_vtx_rotate(z,vz,flag)
      
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>      
C     rotates vertex position to correspond with Z being in the direction
C     of the field.
C     Input: 3-d array of vertex position to rotate (z)
C            Flag 0, for rotating to new co-ordinate system
C            Flag 1, for rotating back --and rotating covariance matrix
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     Created 6/22/95   A. Boehnlein  -- version on the cheap
C                       for use with central dipole with field in the X or
C                       Y direction.  Should generalize to use direction
C                       cosines of magnetic field
C     modified 9/5/95 ASB  -- rotate the covarience matrix for flag = 0 to
C                          facilitate use with all routines
      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "track_kine.inc"
#include "kine_vtx_cnst.inc"
#include "kine_bfld.inc"
#include "track_dx.inc"
#include "bfield_rotation.inc"

c     Calling arguments
      DFLOAT z(3)
      DFLOAT vz(3,3)
      integer flag
      
C     Local variables      
      DFLOAT temp(7),temp2(7)     
      double precision work(99)
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      
c     Do nothing if no B field or aligned along Z direction      
      if(kine_bfld.type.eq.0.or.kine_bfld.type.eq.4) then
          goto 100
          
      else if(kine_bfld.type.eq.1.or.kine_bfld.type.eq.2) then
        temp(1) = z(1)
        temp(2) = z(2)
        temp(3) = z(3)
        temp(4) = 0
        temp(5) = z(1)
        temp(6) = z(2)
        temp(7) = z(3)
        
        if(flag.eq.0) then
          call dmmpy(7,7,
     &              bf_rot(1,1),bf_rot(1,2),bf_rot(2,1),
     &              temp(1),
     &              temp(2),
     &              temp2(1),temp2(2))
           call dmmlt(3,3,3,
     &           vz(1,1),vz(1,2),
     &           vz(2,1),
     &           bf_rot(1,1),bf_rot(1,2),bf_rot(2,1),     
     &           vz(1,1),vz(1,2),
     &           vz(2,1),
     &           work)
           call dmmlt(3,3,3,
     &           bf_rotinv(1,1),bf_rotinv(1,2),bf_rotinv(2,1),     
     &           vz(1,1),vz(1,2),
     &           vz(2,1),
     &           vz(1,1),vz(1,2),
     &           vz(2,1),
     &           work)
        else if(flag.eq.1) then
          call dmmpy(7,7,
     &              bf_rotinv(1,1),bf_rotinv(1,2),bf_rotinv(2,1),
     &              temp(1),
     &              temp(2),
     &              temp2(1),temp2(2))
        
           call dmmlt(3,3,3,
     &           vz(1,1),vz(1,2),
     &           vz(2,1),
     &           bf_rotinv(1,1),bf_rotinv(1,2),bf_rotinv(2,1),     
     &           vz(1,1),vz(1,2),
     &           vz(2,1),
     &           work)
           call dmmlt(3,3,3,
     &           bf_rot(1,1),bf_rot(1,2),bf_rot(2,1),     
     &           vz(1,1),vz(1,2),
     &           vz(2,1),
     &           vz(1,1),vz(1,2),
     &           vz(2,1),
     &           work)

        endif
        
        z(1) = temp2(1)
        z(2) = temp2(2)
        z(3) = temp2(3)
        
      else
         print *, "Bfield type not currently defined for vertexing"

      endif
      
c     Normal return      
100   ksub_vtx_rotate = 0
      return

c     Error return            
c9999  ksub_vtx_rotate = -1
c      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:47  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:32:10  garren
c add rcs log line
c

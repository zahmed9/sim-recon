      subroutine kvtx_fill_p1(itrk)
C     fills temporary arrays used for vertex fitting
C     In the vertex fitting routines the "Z" direction is
C     always considered to be in the direction of the field
C     regardless of the physical Z direction.
C     This routine rotates the tracks parameters and covariance matrices
C     such that this definition holds.
C     Input: track to rotate
C     results are stored in track_dx.inc
C***************************************************************
C     Created 5/19/95   A. Boehnlein  -- version on the cheap
C                       for use with central dipole with field in the X or
C                       Y direction.  Should generalize to use direction
C                       cosines of magnetic field

      implicit none
#include "const.inc"
#include "wtrack_struct.inc"
#include "track_kine.inc"
#include "kine_vtx_cnst.inc"
#include "kine_bfld.inc"
#include "track_dx.inc"
#include "bfield_rotation.inc"

      integer itrk

      double precision work(99)
      
      call ucopy(trk_kine(itrk).w, p1(itrk), WTRACK_WORD)
      call ucopy(trk_kine(itrk).w0, p0(itrk), WTRACK_WORD)
      call ucopy(trk_kine(itrk).cov, p1c(itrk).cov, 7*7*FLOAT_WORD)
      if(kine_bfld.type.eq.0.or.kine_bfld.type.eq.4) then
          return
      else if(kine_bfld.type.eq.1.or.kine_bfld.type.eq.2) then
          call dmmpy(7,7,
     &              bf_rot(1,1),bf_rot(1,2),bf_rot(2,1),
     &              trk_kine(itrk).w.px,
     &              trk_kine(itrk).w.py,
     &              p1(itrk).px,p1(itrk).py)
          p1(itrk).pt = sqrt(p1(itrk).px**2 + p1(itrk).py**2)
          call dmmpy(7,7,
     &              bf_rot(1,1),bf_rot(1,2),bf_rot(2,1),
     &              trk_kine(itrk).w0.px,
     &              trk_kine(itrk).w0.py,
     &              p0(itrk).px,p0(itrk).py)
          p0(itrk).pt = sqrt(p0(itrk).px**2 + p0(itrk).py**2)
          call dmmlt(7,7,7,
     &           p1c(itrk).cov(1,1),p1c(itrk).cov(1,2),
     &           p1c(itrk).cov(2,1),
     &           bf_rotinv(1,1),bf_rotinv(1,2),bf_rotinv(2,1),
     &           p1c(itrk).cov(1,1),p1c(itrk).cov(1,2),
     &           p1c(itrk).cov(2,1),
     &           work)
           call dmmlt(7,7,7,
     &           bf_rot(1,1),bf_rot(1,2),bf_rot(2,1),
     &           p1c(itrk).cov(1,1),p1c(itrk).cov(1,2),
     &           p1c(itrk).cov(2,1),
     &           p1c(itrk).cov(1,1),p1c(itrk).cov(1,2),
     &           p1c(itrk).cov(2,1),
     &           work)

      else
         print *, "Bfield type not currently defined for vertexing"

      endif
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:48  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:32:15  garren
c add rcs log line
c

      subroutine wtk_bend_plane_pars ( bf, p, rad_curve, sinth )

c Given a magnetic field and wtrack , compute the radius of
c curvature in the bend plane and the sin of the polar angle
c wrt to the bfield direction ( ie the factor which projects a
c 3d distance onto the bend plane.
c
c The caller needs to ensure that the magnitude of p is non-zero
c before calling this routine.

      implicit none

#include "const.inc"
#include "bfield_struct.inc"
#include "wtrack_struct.inc"

c Arguments:

      ! Input: B field description.  
      record /bfield_struct/ bf

      ! Input: Momentum vector
      DFLOAT p(3)

      ! Ouput: radius of curvature and sin of polar angle.
      DFLOAT rad_curve, sinth

c Local variables:

      ! Cosine of polar angle wrt the B field direction.
      DFLOAT costh

      ! Magnitude of the momentum.
      DFLOAT pmag

      ! Functions
      DFLOAT v3mag_d

      pmag = v3mag_d(p)
      if ( pmag .eq. 0. ) goto 9999

      costh = (bf.bdir(1)*p(1) + bf.bdir(2)*p(2) + bf.bdir(3)*p(3))/
     +        pmag
      sinth = dsqrt( dmax1(1.d0 - costh**2, 0.d0 ))

      rad_curve = sinth*pmag/abs(c_b)/bf.bmag

      ! Normal return.
      return

      ! Error return.
 9999 sinth     = 1
      rad_curve = 1.e36

      end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.2  1998/04/27 03:48:22  kutschke
c New file.
c
c

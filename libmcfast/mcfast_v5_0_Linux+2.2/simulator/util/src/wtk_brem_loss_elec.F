      subroutine wtk_brem_loss_elec(w1, radl, eta, Kmin, w2)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add bremmstrahlung energy loss to a w track, assuming electron identity.
c  .........................................................................
c
c  Inputs:
c
c  w1         w track structure
c             Track parameters before energy loss
c
c  radl       DFLOAT variable
c             Thickness in radiation lengths
c
c  eta(3)     DFLOAT array
c             Direction cosines of surface of scatterer. Need this to
c             calculate effective path length through material.
c
c  Kmin       DFLOAT variable
c             Minimum energy photon to radiate
c
c  Outputs:
c  w2         w track structure
c             Track parameters after energy loss
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"

c     Externals
      external brem_loss_elec
      DFLOAT   brem_loss_elec

c     Calling arguments
      record /wtrack_struct/ w1, w2
      DFLOAT radl, eta(3), Kmin

c     Local variables
      DFLOAT pnew, dot, ratio, mass
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     When doing energy loss, be sure to account for path length
      dot = abs(eta(1)*w1.px + eta(2)*w1.py + eta(3)*w1.pz) / w1.p
      if(dot .eq. 0.) dot = 1.E-6
      mass = sqrt(abs(w1.E**2 - w1.p**2))
      pnew = brem_loss_elec(w1.p, radl/dot, Kmin)
      if(pnew .le. 0.) goto 9999

c     Normalize the momentum
      ratio = pnew / w1.p

      w2.px = w1.px * ratio
      w2.py = w1.py * ratio
      w2.pz = w1.pz * ratio
      w2.E  = sqrt(pnew**2 + mass**2)
      w2.x  = w1.x
      w2.y  = w1.y
      w2.z  = w1.z
      w2.pt = sqrt(w2.px**2 + w2.py**2)
      w2.p  = pnew
      w2.q  = w1.q
      return

c     Error exit
 9999 w2.px = 0.
      w2.py = 0.
      w2.pz = 0.
      w2.E = mass
      w2.x = w1.x
      w2.y = w1.y
      w2.z = w1.z
      w2.pt = 0.
      w2.p = 0.
      w2.q = w1.q
      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.4  1999/07/27 21:59:07  kutschke
c Add abs() to definition of dot.
c
c Revision 1.3  1997/04/04  20:32:00  garren
c add rcs log line
c

      integer function dcalc_wtk_axial(w, xpos, bf, dcalc, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate the drift distance to an axial wire at xpos.
c
c    The equations to be solved (assuming drift is perp. to the wire
c    and track) are expressed in terms of the arc length s along the
c    track (in the xy plane)
c
c    [1+rho*dw]*sin(ps) =  -rho*dx'
c    [1+rho*dw]*cos(ps) = 1+rho*dy'
c
c    where the unknowns are dw and s
c
c    Define the auxliliary quantities
c       delw = dy' + 0.5*rho*(dx**2 + dy**2)
c       dx   = x0 - xw
c       dy   = y0 - yw
c       dx'  = dx*u0 + dy*v0
c       dy'  = dy*u0 - dx*v0
c       rho  = a / pt
c       a    = c_b * Bfield * q
c
c    The exact solution can be written
c    dw = 1/rho * {-1 + sqrt[1 + 2*rho*delw]}
c       = 2*delw / {1 + sqrt[]}
c
c    If we ignore the curvature (assuming that the track has been moved
c    to a point close to the wire) the solution can be written exactly
c    as:
c
c    dw = dy'
c    s  = -dx'
c  ..........................................................................
c
c  Inputs:
c  w          w track structure
c             Track parameters
c
c  xpos(3)    DFLOAT array
c             Position of axial wire (z not used)
c
c  bf         b field structure
c             B field info
c
c  Outputs:
c  dcalc      DFLOAT variable
c             Signed drift distance
c
c  s3d        DFLOAT variable
c             Distance track moved
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     Externals

c     Calling arguments
      record /wtrack_struct/ w
      record /bfield_struct/ bf
      DFLOAT xpos(3), dcalc, s3d

c     Local variables
      DFLOAT dx, dy, dxpr, dypr, a, s
      DFLOAT rho, ps, cosps, sinps, dcosps, x, y, px, py
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     We assume that the track is already close to the wire and use
c     the straight line approximation in this region to calculate
c     the drift distance.

      if(w.pt .eq. 0.) goto 9999

      dx = w.x - xpos(1)
      dy = w.y - xpos(2)
      dxpr = (dx*w.px + dy*w.py) / w.pt
      dypr = (dy*w.px - dx*w.py) / w.pt
      
      dcalc = -dypr

c     Arc length moved
      s = -dxpr
      s3d = s * w.p / w.pt

c     Normal exit
      dcalc_wtk_axial = 0
      return

c     Error exit
 9999 dcalc_wtk_axial = 1
      dcalc = 1.e10
      s3d = 0.
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:09  garren
c add rcs log line
c

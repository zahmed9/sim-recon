      integer function dcalc_wtk_stereo(w, xpos, eta, bf, dcalc, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Calculate the drift distance to stereo wire at location xpos(1-3) with
c   direction cosines eta(1-3).
c
c    The equations to be solved (assuming drift is perp. to the wire
c    and track) are expressed in terms of the arc length s along the
c    track (in the xy plane) and the point zp where the charge is
c    collected on the wire.
c
c    [1+rho*dw/u_d*etaz]*sin(ps) =  -rho*dx' + rho*(dw/u_d)lambda*etay'
c    [1+rho*dw/u_d*etaz]*cos(ps) = 1+rho*dy' + rho*(dw/u_d)lambda*etax'
c    zp = z0 + lambda*s + dw/u_d * [etay*cos(ps)-etax*sin(ps)]
c
c    where the unknowns are dw, s and zp
c
c    Define the auxliliary quantities
c       delw = dy' + 0.5*rho*(dx**2 + dy**2)
c       dx   = x0 - xw - (zp - zw)*etax/etaz
c       dy   = y0 - yw - (zp - zw)*etay/etaz
c       dx'  = dx*u0 + dy*v0
c       dy'  = dy*u0 - dx*v0
c       etax'= etax*u0 + etay*v0
c       etay'= etay*u0 - etax*v0
c       u_d  = sqrt{[etaz - lambda*(etax'*cos(ps) + etay'*sin(ps))]**2
c                        + [lambda*(etay'*cos(ps) - etax'*sin(ps))]**2}
c       rho  = a / pt
c       a    = c_b * Bfield * q
c       J    = etaz - lambda*[-rho*dx'*etay' + (1+rho*dy')*etax']
c       A    = etaz**2 - lambda**2*(etax**2 + etay**2)
c
c    The exact solution can be written
c    dw = u_d/rho*J/A * {-1 + sqrt[1 + 2*A*rho*delw/J**2]}
c       = u_d/J * 2*delw / {1 + sqrt[]}
c
c    which still depends on s and zp. New values of s and zp can be
c    recalculated from the first 3 equations using the solved value
c    of dw. Thus an iterative solution can be developed.
c
c    If we ignore the curvature (assuming that the track has been moved
c    to a point close to the wire) the solution can be written exactly
c    as:
c
c    dw = -u_d * dy' / J
c    s  = -dx' + dy'/J * lambda*etay'
c
c    where u_d  = sqrt{J**2 + [lambda*etay']**2}
c          J    = etaz - lambda*etax'
c
c    The no curvature case is better written in terms of cross products
c
c     dw =   (x0-xw) * (py*etaz - pz*etay) / |p x eta|
c          + (y0-yw) * (pz*etax - px*etaz) / |p x eta|
c          + (z0-zw) * (px*etay - py*etax) / |p x eta|
c  ..........................................................................
c
c  Inputs:
c  w          w track structure
c             Track parameters
c
c  xpos(3)    DFLOAT array
c             Wire location
c
c  eta(3)     DFLOAT array
c             Direction cosines of wire
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
      DFLOAT xpos(3), eta(3), dcalc, s3d

c     Local variables
      DFLOAT dx, dy, dz, ex, ey, ez
      DFLOAT pdoteta, pcrosseta, den
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     This routine assumes that the track is already near the correct
c     wire radius and z point.
c     We use the straight line approximation in this region to calculate
c     the drift distance.

      pdoteta = w.px*eta(1) + w.py*eta(2) + w.pz*eta(3)
      pcrosseta = sqrt(w.p**2 - pdoteta**2)
      if(pcrosseta .eq. 0) goto 9999

      den = 1. / pcrosseta

      dx = w.x - xpos(1)
      dy = w.y - xpos(2)
      dz = w.z - xpos(3)

      ex = (w.py*eta(3) - w.pz*eta(2)) * den
      ey = (w.pz*eta(1) - w.px*eta(3)) * den
      ez = (w.px*eta(2) - w.py*eta(1)) * den

c     dw =   (x0-xw) * (py*etaz - pz*etay) / |p x eta|
c          + (y0-yw) * (pz*etax - px*etaz) / |p x eta|
c          + (z0-zw) * (px*etay - py*etax) / |p x eta|
      dcalc = dx*ex + dy*ey + dz*ez

c     Arc length moved
      s3d = -(dx*w.px + dy*w.py + dz*w.pz) / w.p

c     Normal exit
      dcalc_wtk_stereo = 0
      return

c     Error exit
 9999 dcalc_wtk_stereo = 1
      dcalc = 1.e10
      s3d = 0.
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:10  garren
c add rcs log line
c

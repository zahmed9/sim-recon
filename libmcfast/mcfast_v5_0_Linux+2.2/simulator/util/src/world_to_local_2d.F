      subroutine world_to_local_2d ( xg, o, u, xl )
c
c Transform the 2D point x, in the world coordinate system to a
c local coordinate system.  This is a NOT a fully general tranformation.
c The most general allowed transformation is:
c
c 1) An offset in (x,y)
c 2) A rotation in the (x,y) plane.
c
c The inputs are all specified in the world coordinate system.
c  xg - the point to transform.
c  o  - the (x,y) location of the local origin.
c  u  - a unit vector along the u measurement direction ( see below ).
c
c The output, xl, is the point xg, specified in the local system. 
c
c Use ( u,v,w) to denote the local coordinate axes:
c     u = x_local
c     v = y_local = z_world x  u
c     w = z_local = z_world
c
c In vector notation the equations are:
c
c xl(1) = (xg-o) . u
c xl(2) = (xg-o) . ( z x u )
c
c where . is a dot product and x is a cross product.
c

#include "const.inc"

c     Arguments.
      DFLOAT xg(2), o(2), u(2), xl(2)

c     A temporary.
      DFLOAT t(2)

      t(1) = xg(1) - o(1)
      t(2) = xg(2) - o(2)

      xl(1) =  t(1)*u(1) + t(2)*u(2)
      xl(2) = -t(1)*u(2) + t(2)*u(1)

      end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.2  1999/03/16 23:36:43  kutschke
c New file.
c
c
c

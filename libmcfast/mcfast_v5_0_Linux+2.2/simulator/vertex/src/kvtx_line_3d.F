      integer function kvtx_line_3d(ntrk, itrk, x)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Returns intersection point in 3-d of several tracks, assuming that
C  the tracks are straight lines. This routine is used to obtain an initial
C  guess for the vertex in a full vertex fit. No errors are returned.
C
C  NTRK    integer variable (read)
C          Number of tracks
C
C  ITRK    integer array (read)
C          List of tracks in KN list to use
C
C *X       real array (write)
C          (x,y,z) intersection point. If it cannot be determined, it is
C          set to (0,0,0).
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  The lines are defined by the equation
C
C                  x = x0 + eta*r
C
C  where r is a free parameter (length) and eta is a set of direction
C  cosines. The track parametrization is the noncanonical one, i.e. x0, y0,
C  z0, nx, ny, nz, rho, p, Q, s. The curvature rho is ignored.
C
C  The intersection is defined as the point which minimizes the sum of
C  distances**2 to each of the lines:
C
C          d**2 = SUM(i) [ (x-x0(i)**2 - |(x-x0(i))*eta(i)|**2 ]
C
C  The sum is minimized when the x(j) components satisfy
C
C          0 = SUM(i) [ x(j)-x0(ij) - eta(ij)|(x-x0(i))*eta(i)| ]
C
C  These equations can be rewritten as a single matrix equation
C
C                 Ax = b
C
C                  x = A(inv) * b
C
C       | N-SUM[eta(i1)**2]    -SUM[eta(i1)eta(i2)]  -SUM[eta(i1)eta(i3)]|
C   A = |-SUM[eta(i1)eta(i2)]   N-SUM[eta(i2)**2)]   -SUM[eta(i2)eta(i3)]|
C       |-SUM[eta(i1)eta(i3)]  -SUM[eta(i2)eta(i3)]   N-SUM[eta(i3)**2]  |
C
C
C       |  SUM[x0(i1) - eta(i1)|x0(i)*(eta(i)| ]  |
C   b=  |  SUM[x0(i2) - eta(i2)|x0(i)*(eta(i)| ]  |
C       |  SUM[x0(i3) - eta(i3)|x0(i)*(eta(i)| ]  |
C
C
C   Dot product multiplication is indicated above by a *
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      IMPLICIT NONE
#include "const.inc"
#include "track_kine.inc"
C     Calling arguments
      integer ntrk, itrk(*)
      DFLOAT x(3)

C     Local variables
      DFLOAT a(3,3), b(3), dot, pinv
      integer i, it, ifail
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


      x(1) = 0.
      x(2) = 0.
      x(3) = 0.

c     construct matrices
      call vzero(a, 3*3*float_word)
      call vzero(b, 3*float_word)
      do 100 i=1,ntrk
        it = itrk(i)
        pinv = 1. / trk_kine(it).w.p
        a(1,1) = a(1,1) + 1. - (trk_kine(it).w.px * pinv)**2
        a(2,2) = a(2,2) + 1. - (trk_kine(it).w.py * pinv)**2
        a(3,3) = a(3,3) + 1. - (trk_kine(it).w.pz * pinv)**2
        a(1,2) = a(1,2) - trk_kine(it).w.px*trk_kine(it).w.py*pinv**2
        a(1,3) = a(1,3) - trk_kine(it).w.px*trk_kine(it).w.pz*pinv**2
        a(2,3) = a(2,3) - trk_kine(it).w.py*trk_kine(it).w.pz*pinv**2
        dot = (trk_kine(it).w.px*trk_kine(it).w.x
     *      +  trk_kine(it).w.py*trk_kine(it).w.y 
     *      +  trk_kine(it).w.pz*trk_kine(it).w.z) * pinv**2
        b(1) = b(1) + trk_kine(it).w.x - dot * trk_kine(it).w.px
        b(2) = b(2) + trk_kine(it).w.y - dot * trk_kine(it).w.py
        b(3) = b(3) + trk_kine(it).w.z - dot * trk_kine(it).w.pz
100   continue

c     fill in rest of symmetric matrix a
      a(2,1) = a(1,2)
      a(3,1) = a(1,3)
      a(3,2) = a(2,3)

c     invert a and compute x = a(inv) * b
      call dsynv2(a, 3, 3, ifail)
      if(ifail.ne.0) goto 1000

      x(1) = a(1,1)*b(1) + a(2,1)*b(2) + a(3,1)*b(3)
      x(2) = a(1,2)*b(1) + a(2,2)*b(2) + a(3,2)*b(3)
      x(3) = a(1,3)*b(1) + a(2,3)*b(2) + a(3,3)*b(3)

c     only exit point
1000  continue
      kvtx_line_3d = 0.
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:48  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:32:15  garren
c add rcs log line
c

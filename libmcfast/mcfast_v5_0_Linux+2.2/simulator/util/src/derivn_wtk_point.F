      integer function derivn_wtk_point(w1, w2, s3d, bf, R)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Calculate the derivatives of the track parameters at a new
c  point wrt parameters at an old point in an arbitrarily oriented,
c  fixed B field.
c
c  The derivative is computed numerically.

c  Inputs:
c  w1       w track structure
c           Old track parameters
c
c  w2       w track structure
c           New track parameters
c
c  s3d      DFLOAT variable
c           3-D arc length (redundant, can be computed from w1 and w2)
c
c  bf       B field structure
c           B field info
c
c Outputs:
c *R        DFLOAT array
c           7x7 derivative matrix of d(w2) / d(w1)
c
c Return:
c           0 ==> all OK
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "bfield_struct.inc"

c     Externals
      integer  move_wtk_arc
      external move_wtk_arc

c     calling arguments
      record /wtrack_struct/ w1, w2
      DFLOAT s3d
      record /bfield_struct/ bf
      DFLOAT R(7,7)

c     local variables
      record /wtrack_struct/ wi, wf
      DFLOAT dpx, dpy, dpz, de, dx, dy, dz
      DFLOAT psave, psave1, psave2
      integer status

      data dpx /0.01/
      data dpy /0.01/
      data dpz /0.01/
      data de /0.01/
      data dx /0.01/
      data dy /0.01/
      data dz /0.01/

      save dpx, dpy, dpz, de, dx, dy, dz
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Save initial helix
      call ucopy(w1, wi, WTRACK_WORD)

      call vzero(R, 7*7*FLOAT_WORD)

c     Change each parameter in turn to calculate numerical derivative

      psave = wi.px
      psave1 = wi.pt
      psave2 = wi.p
      wi.px = wi.px + dpx
      wi.pt = sqrt(wi.px**2 + wi.py**2)
      wi.p  = sqrt(wi.px**2 + wi.py**2 + wi.pz**2)
      status = move_wtk_arc(wi, s3d, bf, wf)
      if(status .ne. 0) goto 9999
      R(jwpx,jwpx)  = (wf.px - w2.px) / dpx
      R(jwpy,jwpx)  = (wf.py - w2.py) / dpx
      R(jwpz,jwpx)  = (wf.pz - w2.pz) / dpx
      R(jwe,jwpx)  = (wf.e - w2.e) / dpx
      R(jwx,jwpx)  = (wf.x - w2.x) / dpx
      R(jwy,jwpx)  = (wf.y - w2.y) / dpx
      R(jwz,jwpx)  = (wf.z - w2.z) / dpx
      wi.px = psave
      wi.pt = psave1
      wi.p  = psave2

      psave = wi.py
      psave1 = wi.pt
      psave2 = wi.p
      wi.py = wi.py + dpy
      wi.pt = sqrt(wi.px**2 + wi.py**2)
      wi.p  = sqrt(wi.px**2 + wi.py**2 + wi.pz**2)
      status = move_wtk_arc(wi, s3d, bf, wf)
      if(status .ne. 0) goto 9999
      R(jwpx,jwpy)  = (wf.px - w2.px) / dpy
      R(jwpy,jwpy)  = (wf.py - w2.py) / dpy
      R(jwpz,jwpy)  = (wf.pz - w2.pz) / dpy
      R(jwe,jwpy)  = (wf.e - w2.e) / dpy
      R(jwx,jwpy)  = (wf.x - w2.x) / dpy
      R(jwy,jwpy)  = (wf.y - w2.y) / dpy
      R(jwz,jwpy)  = (wf.z - w2.z) / dpy
      wi.py = psave
      wi.pt = psave1
      wi.p  = psave2

      psave = wi.pz
      psave2 = wi.p
      wi.pz = wi.pz + dpz
      wi.p  = sqrt(wi.px**2 + wi.py**2 + wi.pz**2)
      status = move_wtk_arc(wi, s3d, bf, wf)
      if(status .ne. 0) goto 9999
      R(jwpx,jwpz)  = (wf.px - w2.px) / dpz
      R(jwpy,jwpz)  = (wf.py - w2.py) / dpz
      R(jwpz,jwpz)  = (wf.pz - w2.pz) / dpz
      R(jwe,jwpz)  = (wf.e - w2.e) / dpz
      R(jwx,jwpz)  = (wf.x - w2.x) / dpz
      R(jwy,jwpz)  = (wf.y - w2.y) / dpz
      R(jwz,jwpz)  = (wf.z - w2.z) / dpz
      wi.pz = psave
      wi.p  = psave2

      psave = wi.x
      wi.x = wi.x + dx
      status = move_wtk_arc(wi, s3d, bf, wf)
      if(status .ne. 0) goto 9999
      R(jwpx,jwx)  = (wf.px - w2.px) / dx
      R(jwpy,jwx)  = (wf.py - w2.py) / dx
      R(jwpz,jwx)  = (wf.pz - w2.pz) / dx
      R(jwe,jwx)  = (wf.e - w2.e) / dx
      R(jwx,jwx)  = (wf.x - w2.x) / dx
      R(jwy,jwx)  = (wf.y - w2.y) / dx
      R(jwz,jwx)  = (wf.z - w2.z) / dx
      wi.x = psave

      psave = wi.y
      wi.y = wi.y + dy
      status = move_wtk_arc(wi, s3d, bf, wf)
      if(status .ne. 0) goto 9999
      R(jwpx,jwy)  = (wf.px - w2.px) / dy
      R(jwpy,jwy)  = (wf.py - w2.py) / dy
      R(jwpz,jwy)  = (wf.pz - w2.pz) / dy
      R(jwe,jwy)  = (wf.e - w2.e) / dy
      R(jwx,jwy)  = (wf.x - w2.x) / dy
      R(jwy,jwy)  = (wf.y - w2.y) / dy
      R(jwz,jwy)  = (wf.z - w2.z) / dy
      wi.y = psave

      psave = wi.z
      wi.z = wi.z + dz
      status = move_wtk_arc(wi, s3d, bf, wf)
      if(status .ne. 0) goto 9999
      R(jwpx,jwz)  = (wf.px - w2.px) / dz
      R(jwpy,jwz)  = (wf.py - w2.py) / dz
      R(jwpz,jwz)  = (wf.pz - w2.pz) / dz
      R(jwe,jwz)  = (wf.e - w2.e) / dz
      R(jwx,jwz)  = (wf.x - w2.x) / dz
      R(jwy,jwz)  = (wf.y - w2.y) / dz
      R(jwz,jwz)  = (wf.z - w2.z) / dz
      wi.z = psave

      derivn_wtk_point = 0
      return

c     Error return
9999  derivn_wtk_point = status
      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:25  garren
c add rcs log line
c

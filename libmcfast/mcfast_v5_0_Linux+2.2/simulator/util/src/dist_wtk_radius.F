      integer function dist_wtk_radius(w, r, bf, slen)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Finds distance to radius r in an arbitrary B field.
c
c Inputs:
c  w       w track structure
c          Initial track parameters (px, py, pz, E, x0, y0, z0, pt, p, q)
c
c  r       DFLOAT variable
c          radius of cylinder
c
c  bf      B field structure
c          B field information
c
c  Outputs:
c  slen    Arc length structure
c          Arc length information
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "arc_struct.inc"

c     Externals
      external dist_wtk_radius_b0
      external dist_wtk_radius_bz
      integer  dist_wtk_radius_b0
      integer  dist_wtk_radius_bz

c     calling arguments
      DFLOAT r
      record /wtrack_struct/ w
      record /bfield_struct/ bf
      record /arc_struct/ slen

c     local variables
      integer status
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w.q .eq. 0.) goto 100

      goto (100, 999, 999, 999, 140, 999, 999, 999), bf.type + 1

 100  status = dist_wtk_radius_b0(w, r, bf, slen)
      goto 500

 140  status = dist_wtk_radius_bz(w, r, bf, slen)
      goto 500

 999  write(6,5000)
 5000 format('Bfield code ',i1,' not implemented')
      slen.s3d = 0
      slen.s = 0
      slen.cosps = 1.
      slen.sinps = 0.

 500  dist_wtk_radius = status

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:27  garren
c add rcs log line
c

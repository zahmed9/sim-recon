      subroutine trk_make_zsixy_hit(hep, trace, w, dev, lyr, lstrike,
     *                             bf, hit, error)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Make a hit in a silicon XY pixel plane
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

      save

#include "const.inc"
#include "hit_track.inc"
#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "trk_channel_struct.inc"
#include "trace.inc"
#include "hep_trace.inc"
#include "devtype.inc"
#include "sixy_disk.inc"

c     Externals
      external phi_norm, get_gauss, rann
      external dcalc_wtk_zsixy
      DFLOAT   phi_norm
      real     get_gauss, rann
      integer  dcalc_wtk_zsixy

c     Calling arguments
      integer hep, trace, dev, lyr, idpos(3), hit, error
      logical lstrike
      record /wtrack_struct/ w
      record /bfield_struct/ bf

c     Local variables
      integer nplane, pln, channel, type, npixel, status
      integer nsegm_x, nsegm_y, ncol_x, nrow_y
      DFLOAT phi, phi0, width_phi, xpos(3), s3d
      DFLOAT siga_x, siga_y, dcalc(2), eta(3), dpix(2)
      DFLOAT dpix_cov(2,2)
      DFLOAT dbeta, dpos0_x, dpos0_y, pitch_x, pitch_y
      DFLOAT coord0_x, coord0_y, xmin, xmax, ymin, ymax
      DFLOAT xpr, ypr
      real sn, cs
      record /trk_channel_struct/ chan
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      hit = 0

      eta(1) = 0.0
      eta(2) = 0.0
      eta(3) = 1.0
      xpos(1) = 0.
      xpos(2) = 0.
      xpos(3) = sixy_par(dev).lyr(lyr).z

      coord0_x = sixy_par(dev).lyr(lyr).coord0_x
      coord0_y = sixy_par(dev).lyr(lyr).coord0_y
      xmin = sixy_par(dev).lyr(lyr).xmin
      xmax = sixy_par(dev).lyr(lyr).xmax
      ymin = sixy_par(dev).lyr(lyr).ymin
      ymax = sixy_par(dev).lyr(lyr).ymax

      cs = cos(sixy_par(dev).lyr(lyr).stereo)
      sn = sin(sixy_par(dev).lyr(lyr).stereo)

c     See if track falls within [zmin, zmax] limits
c      if(w.z.lt.sib_par(dev).lyr(lyr).plane(pln).zmin .or.
c     *   w.z.gt.sib_par(dev).lyr(lyr).plane(pln).zmax) goto 9997

      if (.not.lstrike) goto 9997

      xpr = w.x*cs + w.y*sn
      ypr = w.y*cs - w.x*sn
      if (xpr .ge. xmin .and. xpr .lt. xmin+coord0_x) goto 9997
      if (xpr .gt. xmax-coord0_x .and. xpr .le. xmax) goto 9997
      if (ypr .ge. ymin .and. ypr .lt. ymin+coord0_y) goto 9997
      if (ypr .gt. ymax-coord0_y .and. ypr .le. ymax) goto 9997

c     Check efficiency
      if (rann(0) .gt. sixy_par(dev).lyr(lyr).eff_hit) goto 2000

c     Calculate x and y location on plane
      type = sixy_par(dev).lyr(lyr).type
c      status = dcalc_wtk_zsixy(w, xpos, eta, type, bf, dcalc, s3d)

      dcalc(1) = w.x
      dcalc(2) = w.y

c     Calculate pixel number in x and y
      dpos0_x = sixy_par(dev).lyr(lyr).coord0_x
      pitch_x = sixy_par(dev).lyr(lyr).pitch_x
      nsegm_x = sixy_par(dev).lyr(lyr).nsegm_x
      siga_x = sixy_par(dev).lyr(lyr).siga_x
      dpos0_y = sixy_par(dev).lyr(lyr).coord0_y
      pitch_y = sixy_par(dev).lyr(lyr).pitch_y
      nsegm_y = sixy_par(dev).lyr(lyr).nsegm_y
      siga_y = sixy_par(dev).lyr(lyr).siga_y

      ncol_x = int((dcalc(1) - dpos0_x) / pitch_x)
      nrow_y = int((dcalc(2) - dpos0_y) / pitch_y)
      npixel = ncol_x + nrow_y * nsegm_y

C      if(npixel .ge. nsegm_x * nsegm_y .or. npixel .lt. 0) goto 9997

      if(hit_trk_num .ge. hit_trk_max) goto 9998

      hit_trk_num = hit_trk_num + 1

      hit_trk(hit_trk_num).hep = hep
      hit_trk(hit_trk_num).trace = trace

c     Store device, layer, plane, strip info
      hit_trk(hit_trk_num).chan.devtype = jdev_pixelplane
      hit_trk(hit_trk_num).chan.devnum = dev
      hit_trk(hit_trk_num).chan.devlayer = lyr
      hit_trk(hit_trk_num).chan.devwid(1) = ncol_x
      hit_trk(hit_trk_num).chan.devwid(2) = nrow_y
      hit_trk(hit_trk_num).chan.devwid(3) = 0
      call geo_set_trkchan(hit_trk(hit_trk_num).chan)

c     Position, orientation of plane
      hit_trk(hit_trk_num).pos(1) = xpos(1)
      hit_trk(hit_trk_num).pos(2) = xpos(2)
      hit_trk(hit_trk_num).pos(3) = xpos(3)
      hit_trk(hit_trk_num).dircos(1) = eta(1)
      hit_trk(hit_trk_num).dircos(2) = eta(2)
      hit_trk(hit_trk_num).dircos(3) = eta(3)

      hit_trk(hit_trk_num).dtime_exact = 0.
      hit_trk(hit_trk_num).dtime = 0.
      hit_trk(hit_trk_num).dtime_sigma = 0
      hit_trk(hit_trk_num).dpix_exact(1) = dcalc(1)
      hit_trk(hit_trk_num).dpix_exact(2) = dcalc(2)

c     Smear the hit with the plane resolution
      dpix(1) = dcalc(1) + siga_x * get_gauss(0)
      dpix(2) = dcalc(2) + siga_y * get_gauss(0)

      hit_trk(hit_trk_num).dmeas_sigma = 0.
      hit_trk(hit_trk_num).dmeas = 0.
      hit_trk(hit_trk_num).dpix(1) = dpix(1)
      hit_trk(hit_trk_num).dpix(2) = dpix(2)
      hit_trk(hit_trk_num).dpix_cov(1,1) = cs**2*siga_x**2 + 
     &      sn**2*siga_y**2
      hit_trk(hit_trk_num).dpix_cov(2,2) = cs**2*siga_y**2 +
     &      sn**2*siga_x**2
      hit_trk(hit_trk_num).dpix_cov(1,2) = cs*sn*siga_y**2 -
     &      cs*sn*siga_x**2
      hit_trk(hit_trk_num).dpix_cov(2,1) = 
     &      hit_trk(hit_trk_num).dpix_cov(1,2)

c      call vzero(hit_trk(hit_trk_num).dpix_exact, 2*FLOAT_WORD)
c      call vzero(hit_trk(hit_trk_num).dpix, 2*FLOAT_WORD)
c      call vzero(hit_trk(hit_trk_num).dpix_cov, 2*2*FLOAT_WORD)

c     Normal exit
 1000 hit = hit_trk_num
      if(hep_trace(hep).nhit .eq. 0) then
        hep_trace(hep).first_hit = hit_trk_num
      endif
      hep_trace(hep).nhit = hep_trace(hep).nhit + 1

 2000 error = 0
      return

c     Outside active area
 9997 error = 0
      return

c     Too many hits
 9998 error = 1
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:39  eugenio
c Initial revision
c
c Revision 1.4  1997/05/02 14:42:31  mcbride
c gaussian smearing back into z plane silicon hits
c
c Revision 1.3  1997/04/04  20:30:29  garren
c add rcs log line
c

      subroutine trk_make_drift_hit(hep, trace, w, dev, lyr, bf, hit,
     *                              error)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Make a hit in a drift chamber layer
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

      save

#include "const.inc"
#include "hit_track.inc"
#include "drift.inc"
#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "trk_channel_struct.inc"
#include "trace.inc"
#include "hep_trace.inc"
#include "devtype.inc"

c     Externals
      external phi_norm, get_gauss, rann
      external dcalc_wtk_axial_exact, dcalc_wtk_stereo_exact
      DFLOAT   phi_norm
      real     get_gauss, rann
      integer  dcalc_wtk_axial_exact, dcalc_wtk_stereo_exact

c     Calling arguments
      integer hep, trace, dev, lyr, idpos(3), hit, error
      record /wtrack_struct/ w
      record /bfield_struct/ bf

c     Local variables
      integer nwire, wire, channel, status
      DFLOAT phi, phi0, r, cell_phi, xwire(3), s3d
      DFLOAT drift, dmeas, eta(3)
      DFLOAT drift_max, drift_scale, tant, cost, delz, phiw
      DFLOAT sigma
      record /trk_channel_struct/ chan

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      hit = 0

      if(w.z.lt.drf_par(dev).an(lyr).zmin .or.
     *   w.z.gt.drf_par(dev).an(lyr).zmax) goto 9999

      phi = phi_norm(atan2(w.y, w.x))
      phi0 = drf_par(dev).an(lyr).phi0
      cell_phi = drf_par(dev).an(lyr).cell_phi
      nwire = drf_par(dev).an(lyr).nwire
      wire = mod(nint(phi_norm(phi-phi0) / cell_phi), nwire)

      r = drf_par(dev).an(lyr).rcenter
      phiw = phi0 + wire * cell_phi
      xwire(1) = r*cos(phiw)
      xwire(2) = r*sin(phiw)
      xwire(3) = w.z

c     Check efficiency
      if(rann(0) .gt. drf_par(dev).an(lyr).eff_hit) goto 2000

      if(drf_par(dev).an(lyr).lstereo) then
        tant = drf_par(dev).an(lyr).tant
        cost = 1. / sqrt(1 + tant**2)
        delz = w.z - 0.5 * (drf_par(dev).an(lyr).zmin
     *                    + drf_par(dev).an(lyr).zmax)
        eta(1) = -xwire(2)/r * tant * cost
        eta(2) =  xwire(1)/r * tant * cost
        eta(3) = cost
        xwire(1) = xwire(1) + eta(1) * (delz/cost)
        xwire(2) = xwire(2) + eta(2) * (delz/cost)
        xwire(3) = w.z
        status  = dcalc_wtk_stereo_exact(w, xwire, eta, bf, drift, s3d)
      else
        eta(1) = 0.
        eta(2) = 0.
        eta(3) = 1.
        status  = dcalc_wtk_axial_exact(w, xwire, bf, drift, s3d)
      endif

      drift_max = 0.5 * drf_par(dev).an(lyr).cell_width

      if(hit_trk_num .ge. hit_trk_max) goto 9998

      hit_trk_num = hit_trk_num + 1

      hit_trk(hit_trk_num).hep = hep
      hit_trk(hit_trk_num).trace = trace

c     Store device, layer, wire info
      hit_trk(hit_trk_num).chan.devtype = jdev_driftbarrel
      hit_trk(hit_trk_num).chan.devnum = dev
      hit_trk(hit_trk_num).chan.devlayer = lyr
      hit_trk(hit_trk_num).chan.devwid(1) = wire
      hit_trk(hit_trk_num).chan.devwid(2) = 0
      hit_trk(hit_trk_num).chan.devwid(3) = 0
      call geo_set_trkchan(hit_trk(hit_trk_num).chan)

c     Position, orientation of wire
      hit_trk(hit_trk_num).pos(1) = xwire(1)
      hit_trk(hit_trk_num).pos(2) = xwire(2)
      hit_trk(hit_trk_num).pos(3) = xwire(3)
      hit_trk(hit_trk_num).dircos(1) = eta(1)
      hit_trk(hit_trk_num).dircos(2) = eta(2)
      hit_trk(hit_trk_num).dircos(3) = eta(3)

      hit_trk(hit_trk_num).dtime_exact = 0.
      hit_trk(hit_trk_num).dtime = 0.
      hit_trk(hit_trk_num).dtime_sigma = 0
      hit_trk(hit_trk_num).dmeas_exact = drift

c     Smear the hit with the layer resolution
      drift_scale = abs(drift / drift_max)
      sigma = drf_par(dev).an(lyr).siga
     *      + drf_par(dev).an(lyr).sigb * drift_scale
     *      + drf_par(dev).an(lyr).sigc * drift_scale**2
 10   dmeas = drift + sigma * get_gauss(0)
c      if(dmeas*drift .lt. 0.) goto 10

      hit_trk(hit_trk_num).dmeas_sigma = sigma
      hit_trk(hit_trk_num).dmeas = dmeas

      call vzero(hit_trk(hit_trk_num).dpix_exact, 2*FLOAT_WORD)
      call vzero(hit_trk(hit_trk_num).dpix, 2*FLOAT_WORD)
      call vzero(hit_trk(hit_trk_num).dpix_cov, 2*2*FLOAT_WORD)

c     Normal exit
 1000 hit = hit_trk_num
      if(hep_trace(hep).nhit .eq. 0) then
        hep_trace(hep).first_hit = hit_trk_num
      endif
      hep_trace(hep).nhit = hep_trace(hep).nhit + 1

 2000 error = 0
      return

c     Too many hits
 9998 error = 1
      return

c     Missed layer
 9999 error = 2
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:38  eugenio
c Initial revision
c
c Revision 1.3  1999/05/12 20:21:35  kutschke
c 21 files changed/added to implement ctk Kalman filter.
c
c Revision 1.2  1997/04/04  20:30:27  garren
c add rcs log line
c

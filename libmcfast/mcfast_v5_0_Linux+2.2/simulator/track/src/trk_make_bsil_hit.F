      subroutine trk_make_bsil_hit(hep, trace, w, dev, lyr, pln, bf,
     *                             hit, error)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Make a hit in a barrel silicon layer
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Input variables:
c
c	hep:   	integer variable
c		position in HEPEVT listc
c
c	trace: 	integer variable
c		position of trace point in CENTRAL trace list
c
c	w:     	w track structure
c		track pararmeters at this plane
c
c	dev:   	integer variable
c		silicon barrel number
c
c	lyr:	layer in silicon barrel
c
c       pln:  	plane or wedge in silicon barrel
c
c	bf:   	structure defining B field
c
c   Output variables:
c
c	hit: 	 integer variable
c            	 position in hit list
c
c       error: 	 integer variable
c            	 error code   error = 1  ==>  hit list is full
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c
c   note on coordinate zero for silicon barrel- 
c            position of 0th strip wrt the center of the wafer in local 
c            coordinates
c            type = 1 (r- phi measurement): coordinate 0 in coord0_x
c                       distance along etam direction
c                       to center of the zeroth strip 
c
c                     (stereo measurment):   coordinate 0 in coord0_x
c                       distance along etam direction
c
c            type = 2 (z measurement): coordinate 0 in coord0_y
c                       distance along etam
c              
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

      save

#include "const.inc"
#include "trace_params.inc"
#include "hit_track.inc"
#include "si_barrel.inc"
#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "trk_channel_struct.inc"
#include "trace.inc"
#include "hep_trace.inc"
#include "devtype.inc"

c     Externals
      external phi_norm, get_gauss, rann
      external dcalc_wtk_xyplane
      DFLOAT   phi_norm
      real     get_gauss, rann
      integer  dcalc_wtk_xyplane

c     Calling arguments
      integer hep, trace, dev, lyr, idpos(3), hit, error
      record /wtrack_struct/ w
      record /bfield_struct/ bf

c     Local variables
      integer nplane, pln, channel, type, strip, status
      DFLOAT phi, phi0, width_phi, xpos(3), s3d
      DFLOAT dcalc, dmeas, etan(3), etam(3)
      DFLOAT cos_st, sin_st
      DFLOAT sigma, dbeta, costh, dpos0, pitch
      record /trk_channel_struct/ chan
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      hit = 0

c     Normal to plane and point on plane through which normal passes
      etan(1) = sib_par(dev).lyr(lyr).plane(pln).eta(1)
      etan(2) = sib_par(dev).lyr(lyr).plane(pln).eta(2)
      etan(3) = sib_par(dev).lyr(lyr).plane(pln).eta(3)
      xpos(1) = sib_par(dev).lyr(lyr).plane(pln).xpos(1)
      xpos(2) = sib_par(dev).lyr(lyr).plane(pln).xpos(2)
      xpos(3) = sib_par(dev).lyr(lyr).plane(pln).xpos(3)

c     See if track falls within [zmin, zmax] limits
      if(w.z.lt.sib_par(dev).lyr(lyr).plane(pln).zmin .or.
     *   w.z.gt.sib_par(dev).lyr(lyr).plane(pln).zmax) goto 9997

c     Check efficiency
      if(rann(0) .gt. sib_par(dev).lyr(lyr).plane(pln).eff_hit)
     *   goto 2000

c     Calculate distance along plane. etam is measurement vector
c     Note that the type variable should be obsolete since the stereo
c     angle is specified
      type = sib_par(dev).lyr(lyr).plane(pln).type
      cos_st = sib_par(dev).lyr(lyr).plane(pln).cos_stereo
      sin_st = sib_par(dev).lyr(lyr).plane(pln).sin_stereo

c     Stereo angle is in local wafer coordinates. Calculate global
c     measurement vector
      if(type .eq. 1) then
        etam(1) = - cos_st * etan(2)
        etam(2) = cos_st * etan(1)
        etam(3) = sin_st
      else
        etam(1) = 0.
        etam(2) = 0.
        etam(3) = 1.
      endif
      status = dcalc_wtk_xyplane(w, xpos, etan, etam, bf, dcalc, s3d)

c     Calculate strip number
      if (type .eq. 1) then
         dpos0 = sib_par(dev).lyr(lyr).plane(pln).coord0_x
      else   
         dpos0 = sib_par(dev).lyr(lyr).plane(pln).coord0_y
      endif   
      pitch = sib_par(dev).lyr(lyr).plane(pln).pitch
      strip = (dcalc - dpos0) / pitch

      if(strip .ge. sib_par(dev).lyr(lyr).plane(pln).nstrip .or.
     *     strip .lt. 0) goto 9997

      if(hit_trk_num .ge. hit_trk_max) goto 9998

      hit_trk_num = hit_trk_num + 1

      hit_trk(hit_trk_num).hep = hep
      hit_trk(hit_trk_num).trace = trace

c     Store device, layer, plane, strip info
      hit_trk(hit_trk_num).chan.devtype = jdev_silbarrel
      hit_trk(hit_trk_num).chan.devnum = dev
      hit_trk(hit_trk_num).chan.devlayer = lyr
      hit_trk(hit_trk_num).chan.devwid(1) = pln
      hit_trk(hit_trk_num).chan.devwid(2) = strip
      hit_trk(hit_trk_num).chan.devwid(3) = 0
      call geo_set_trkchan(hit_trk(hit_trk_num).chan)

c     Position, orientation of plane
      hit_trk(hit_trk_num).pos(1) = xpos(1)
      hit_trk(hit_trk_num).pos(2) = xpos(2)
      hit_trk(hit_trk_num).pos(3) = xpos(3)
      hit_trk(hit_trk_num).dircos(1) = etam(1)
      hit_trk(hit_trk_num).dircos(2) = etam(2)
      hit_trk(hit_trk_num).dircos(3) = etam(3)

      hit_trk(hit_trk_num).dtime_exact = 0.
      hit_trk(hit_trk_num).dtime = 0.
      hit_trk(hit_trk_num).dtime_sigma = 0
      hit_trk(hit_trk_num).dmeas_exact = dcalc

c     Smear the hit with the plane resolution
      costh = w.pz / w.p
      sigma = sib_par(dev).lyr(lyr).plane(pln).siga
     *      + sib_par(dev).lyr(lyr).plane(pln).sigb*abs(costh)
     *      + sib_par(dev).lyr(lyr).plane(pln).sigc*costh**2
     
      dmeas = dcalc + sigma * get_gauss(0)

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

c     Outside active area
 9997 error = 0
      return

c     Too many hits
 9998 error = 1
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:38  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:30:26  garren
c add rcs log line
c

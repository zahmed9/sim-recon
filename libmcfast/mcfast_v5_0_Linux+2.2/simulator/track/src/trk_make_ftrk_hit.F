      subroutine trk_make_ftrk_hit ( hep, trace, w, dev, lyr, 
     +           lstrike, bf, hit, error )

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c   Make a hit in an FTRK plane
c
c   Stereo defined between -pi/2, pi/2
c   For positive stereo, layer local origin is at (xmin, ymax) corner.
c   For negitive stereo, layer local origni us at (xmin, ymin) corner.
c
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
#include "for_trk.inc"

c Input Arguments.  
c Not all arguments are used. The unused ones are kept for compatibility 
c with other trk_make* routines.

c     Stdhep track number.
      integer hep

c     Index into trace.inc for this point.
      integer trace

c     The point of intersection between the track and the plane.
      record /wtrack_struct/ w

c     Device and layer numbers of the plane.
      integer dev, lyr

c     Has this plane been hit.
      logical lstrike

c     Magnetic field at the point w.
      record /bfield_struct/ bf

c Output arguments.

c     Index into hit_track.inc for the hit which was created.
      integer hit

c     Error code.  0=success.
      integer error

c Local variables

c     Control the interpretation of the stereo angle.  This affects
c     the computation of pos and eta.
      integer type

c     Origin of layer local coordinate system.
c     This point and the direction of the measurement axis are
c     chosen such that, for all points within the active area,
c     nwire is a positive number.  It is possible to defeat this
c     alogrithm if xmin and ymin are improperly defined in the .db file.
      DFLOAT x0, y0

c     Temporaries used in the calculation of x0 and y0.
      real*8 x1, y1

c     Position of (w.x,w.y) in rotated frame of the plane.
      real*8 xl, yl

c     Local copies of geometry variables ( only for code readability ).
      DFLOAT stereo, cell_size, xmin, xmax, ymin, ymax, cs, ss
      DFLOAT siga, sigb, sigc
      integer ncell

c     Width of the dead region in x and y.
c     The geometry must be defined such that these are positive,
c     which will be true so long as the coord0 variable defines 
c     a point just inside of ( xmin, ymin ).
      DFLOAT xdead, ydead

c     A unit vector in the measurement direction.
      DFLOAT eta(3)

c     The number of the hit wire ( 0 ... ncell-1 ).
      integer nwire

c     Unsmeared distance from layer local origin to the point on the track.
      DFLOAT dcalc0

c     Unsmeared distance from the hit wire to the point on the track.
      DFLOAT dcalc

c     Unsmeared drift distance, normalized to the half cell size.
      DFLOAT dcalc_norm

c     Smeared drift distance.  This has the odd property that it
c     can represent a point in a neighbouring cell!
      DFLOAT dmeas

c     Draw a line along the measurment axis from the point on the track, 
c     w, to the hit wire.  This point is where that line crosses the wire.
c     So this is the "wire local" origin.
      DFLOAT pos(3)

c     Resolution for this hit.
      DFLOAT sigma

c     Functions called.
      real rann, get_gauss

      integer nwrite
      data nwrite / 0 /
      save nwrite

c ----------------

      hit = 0
 
c     Kept for backwards compatibility.  This routine should
c     not be called if .not.lstrike.
      if (.not.lstrike) goto 9999

      type      = ftrk_par(dev).lyr(lyr).type
      stereo    = ftrk_par(dev).lyr(lyr).stereo
      x0        = ftrk_par(dev).lyr(lyr).coord0_x
      y0        = ftrk_par(dev).lyr(lyr).coord0_y
      cell_size = ftrk_par(dev).lyr(lyr).cell_size
      xmin      = ftrk_par(dev).lyr(lyr).xmin
      xmax      = ftrk_par(dev).lyr(lyr).xmax
      ymin      = ftrk_par(dev).lyr(lyr).ymin
      ymax      = ftrk_par(dev).lyr(lyr).ymax
      siga      = ftrk_par(dev).lyr(lyr).siga
      sigb      = ftrk_par(dev).lyr(lyr).sigb
      sigc      = ftrk_par(dev).lyr(lyr).sigc
      ncell     = ftrk_par(dev).lyr(lyr).ncell
      cs        = ftrk_par(dev).lyr(lyr).cos_stereo
      ss        = ftrk_par(dev).lyr(lyr).sin_stereo

c     Size of dead region around the edge of the active area.
      xdead = x0 - xmin 
      ydead = y0 - ymin

c     Transform measured point into the rotated frame of the plane.
      if ( stereo .ne. 0. .and. (type .eq. 2 .or. type .eq. 3) ) then
         xl =  w.x*cs + w.y*ss
         yl = -w.x*ss + w.y*cs
      else
         xl = w.x
         yl = w.y
      endif

c     Is the point within the active region of the plane.
      if ( xl .lt. xmin+xdead .or. xl .gt. xmax-xdead ) goto 9999
      if ( yl .lt. ymin+ydead .or. yl .gt. ymax-ydead ) goto 9999

c     Define measurement axis and layer local origin, in world system.
      if ( type .eq. 2 ) then
         eta(1) = cs
         eta(2) = ss
         x1 = x0*cs - y0*ss
         y1 = x0*ss + y0*cs
         x0 = x1
         y0 = y1

      else if ( type .eq. 3 ) then
         eta(1) = -ss
         eta(2) =  cs
         x1 = x0*cs - y0*ss
         y1 = x0*ss + y0*cs
         x0 = x1
         y0 = y1

      else
         if (stereo .gt. 0.) then
            eta(1) =  ss
      	    eta(2) = -cs
            y0     =  ymax - ydead
         else
            eta(1) = -ss
            eta(2) =  cs
         endif
      endif
      eta(3) = 0.0

c     Find the hit wire.
      dcalc0 = ( w.x - x0 ) * eta(1) + ( w.y - y0 ) * eta(2)
      nwire  = int(dcalc0/cell_size)

      if ( nwire .lt. 0 .or. nwire .ge. ncell ) goto 9999

c     Finish the calculation of the exact drift distance.
      dcalc  = dcalc0 - (nwire+0.5)*cell_size

c     Define "wire local" origin.
      pos(1) = w.x - dcalc*eta(1)
      pos(2) = w.y - dcalc*eta(2)
      pos(3) = ftrk_par(dev).lyr(lyr).z

c     Check efficiency.  Apply this only after we know that the
c     hit is inside the active area of the layer.
      if (rann(0) .gt. ftrk_par(dev).lyr(lyr).eff_hit) goto 9999

c     Compute the resolution for this hit.
      if ( siga .eq. 0.0 .and. sigb .eq. 0.0 .and. sigc .eq. 0.0 ) then
        sigma      = cell_size / root12
      else
        dcalc_norm = abs(2.*dcalc/cell_size)
        sigma      = siga + sigb*dcalc_norm + sigc*dcalc_norm**2
      end if

c     Smear the hit.
      dmeas = dcalc + sigma * get_gauss(0)

c     Add the hit to hit_track.inc
      if(hit_trk_num .ge. hit_trk_max) goto 9998
      hit_trk_num = hit_trk_num + 1

      hit_trk(hit_trk_num).hep   = hep
      hit_trk(hit_trk_num).trace = trace

      hit_trk(hit_trk_num).chan.devtype   = jdev_driftplane
      hit_trk(hit_trk_num).chan.devnum    = dev
      hit_trk(hit_trk_num).chan.devlayer  = lyr
      hit_trk(hit_trk_num).chan.devwid(1) = nwire
      hit_trk(hit_trk_num).chan.devwid(2) = 0
      hit_trk(hit_trk_num).chan.devwid(3) = 0
      call geo_set_trkchan(hit_trk(hit_trk_num).chan)

      hit_trk(hit_trk_num).pos(1)        = pos(1)
      hit_trk(hit_trk_num).pos(2)        = pos(2)
      hit_trk(hit_trk_num).pos(3)        = pos(3)
      hit_trk(hit_trk_num).dircos(1)     = eta(1)
      hit_trk(hit_trk_num).dircos(2)     = eta(2)
      hit_trk(hit_trk_num).dircos(3)     = eta(3)

      hit_trk(hit_trk_num).dtime_exact   = 0.
      hit_trk(hit_trk_num).dtime         = 0.
      hit_trk(hit_trk_num).dtime_sigma   = 0

      hit_trk(hit_trk_num).dmeas         = dmeas
      hit_trk(hit_trk_num).dmeas_exact   = dcalc
      hit_trk(hit_trk_num).dmeas_sigma   = sigma
      
      hit_trk(hit_trk_num).dpix_exact(1) = 0.
      hit_trk(hit_trk_num).dpix_exact(2) = 0.
      hit_trk(hit_trk_num).dpix(1)       = 0.
      hit_trk(hit_trk_num).dpix(2)       = 0.
      hit_trk(hit_trk_num).dpix_cov(1,1) = 0.
      hit_trk(hit_trk_num).dpix_cov(1,2) = 0.
      hit_trk(hit_trk_num).dpix_cov(2,1) = 0.
      hit_trk(hit_trk_num).dpix_cov(2,2) = 0.

c     Normal return.
      hit = hit_trk_num
      if ( hep_trace(hep).nhit .eq. 0 ) then
         hep_trace(hep).first_hit = hit_trk_num
      endif
      hep_trace(hep).nhit = hep_trace(hep).nhit + 1
      return

c     Too many hits.
 9998 error = 1
      return

c     Outside active area or inefficient chamber.
 9999 error = 0
      return

      end
c
c$Id$
c
c$Log$
cRevision 1.1  2000/06/19 19:59:38  eugenio
cInitial revision
c
cRevision 1.10  2000/02/04 23:04:27  kutschke
cDo dead area properly.
c
c Revision 1.9  2000/01/26  00:45:05  kutschke
c Implement types 2 and 3.
c
c Revision 1.8  1998/01/21  23:18:36  yarba_j
c DFLOAT rann, get_gauss -> real rann, get_gauss since they're real, not double precision
c
c Revision 1.7  1997/12/05  21:25:35  kutschke
c Remove definition of root12. Now in const.inc
c
c Revision 1.6  1997/12/04  16:04:58  garren
c use calculated value of sqrt(12)
c
c Revision 1.5  1997/12/02  22:42:15  kutschke
c Total rewrite. Add Id and Log.
c
c Revision 1.3.4.1  1997/12/02  22:12:27  kutschke
c Total rewrite. Add Id and Log.
c
c

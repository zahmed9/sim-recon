      subroutine trk_make_siz_strip_hit(hep, trace, w, dev, lyr, wfr,
     *                                  lstrike, hit, error)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Make a hit in a rectangular silicon strip detector.
c
c  The full functionality of this is not yet implemented.
c
c  Inputs
c  hep      integer variable
c           Hep track number
c
c  trace    integer variable
c           Trace number
c
c  w        w track structure
c           Track parameters at the hit
c
c  dev      integer variable
c           Device ID
c
c  lyr      integer variable
c           Layer number
c
c  wfr      integer variable
c           Wafer number
c
c  lstrike  logical variable
c           TRUE  => Device was struck
c           FALSE => Device was not struck
c
c  Outputs
c  hit      integer variable
c           Hit number
c
c  error    integer variable
c           0 => No error
c           1 => Too many hits
c
c If either of the resolutions ( x or y ) are negative, then a
c user function will be called to fill the measurement and the
c covariance matrix.  Otherwise these are filled in this routine.
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

      save

#include "const.inc"
#include "hit_track.inc"
#include "wtrack_struct.inc"
#include "trk_channel_struct.inc"
#include "trace.inc"
#include "hep_trace.inc"
#include "devtype.inc"
#include "siz_rect.inc"

c     Externals
      external get_gauss, rann
      real     get_gauss, rann

c     Calling arguments
      integer hep, trace, dev, lyr, wfr, hit, error
      logical lstrike
      record /wtrack_struct/ w

c     Local variables.
      DFLOAT stereo, x0, y0, cell_size, sigma, xmin, xmax
      DFLOAT ymin, ymax
      DFLOAT xdead, ydead, eta(3), dcalc
      integer ncell, nstrip
      DFLOAT rotate, xc, yc, xl, yl, x1, y1, etar(3), test
      DFLOAT cr, sr

c     Variables used in the hack.
      DFLOAT siga_x, siga_y

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      hit = 0

c     Kept for backwards compatibility.  This routine should
c     not be called if .not.lstrike.
      if (.not.lstrike) goto 9999

c     Transform point on track into the local rest frame of the wafer.
      rotate = siz_rect_par(dev).lyr(lyr).rotate
      xc     = siz_rect_par(dev).lyr(lyr).xCenter
      yc     = siz_rect_par(dev).lyr(lyr).yCenter
      if ( rotate .eq. 0. ) then
         xl = w.x
         yl = w.y
         cr = 1.0
         sr = 0.0
      else
         cr = cos(rotate)
         sr = sin(rotate)
         xl =  ( w.x - xc )*cr + ( w.y - yc )*sr
         yl = -( w.x - xc )*sr + ( w.y - yc )*cr
      endif

c     In the reference frame of the wafer, compute the measurement
c     origin and the measurement direction and the boundaries of
c     the active area.
      stereo    = siz_rect_par(dev).lyr(lyr).wfr(wfr).stereo
      x0        = siz_rect_par(dev).lyr(lyr).wfr(wfr).coord0_x
      y0        = siz_rect_par(dev).lyr(lyr).wfr(wfr).coord0_y

      if ( siz_rect_par(dev).lyr(lyr).wfr(wfr).nsegm_x .gt. 1 ) then
         cell_size = siz_rect_par(dev).lyr(lyr).wfr(wfr).pitch_x
         ncell     = siz_rect_par(dev).lyr(lyr).wfr(wfr).nsegm_x
         sigma     = siz_rect_par(dev).lyr(lyr).wfr(wfr).siga_x
         if ( stereo .eq. 0. ) stereo = -pi/2.
      else if ( siz_rect_par(dev).lyr(lyr).wfr(wfr).nsegm_y .gt. 1 )then
         cell_size = siz_rect_par(dev).lyr(lyr).wfr(wfr).pitch_y
         ncell     = siz_rect_par(dev).lyr(lyr).wfr(wfr).nsegm_y
         sigma     = siz_rect_par(dev).lyr(lyr).wfr(wfr).siga_y
         if ( stereo .ne. 0. ) then
             print *,
     +        'trk_make_siz_strip_hit: Do not understand this angle.'
             stop
         endif
      else
         print *, 'trk_make_siz_strip_hit: Impossible detector.'
         stop
      endif

      xmin = siz_rect_par(dev).lyr(lyr).wfr(wfr).xLocal -
     +       siz_rect_par(dev).lyr(lyr).wfr(wfr).xlen/2.
      xmax = siz_rect_par(dev).lyr(lyr).wfr(wfr).xLocal +
     +       siz_rect_par(dev).lyr(lyr).wfr(wfr).xlen/2.
      ymin = siz_rect_par(dev).lyr(lyr).wfr(wfr).yLocal -
     +       siz_rect_par(dev).lyr(lyr).wfr(wfr).ylen/2
      ymax = siz_rect_par(dev).lyr(lyr).wfr(wfr).yLocal +
     +       siz_rect_par(dev).lyr(lyr).wfr(wfr).ylen/2

      xdead = x0 - xmin 
      ydead = y0 - ymin

c     Define measurement axis and layer local origin.
      if (stereo .gt. 0.) then
       	eta(1) =  sin(stereo)
      	eta(2) = -cos(stereo)
        y0     =  ymax - ydead
      else
        eta(1) = -sin(stereo)
        eta(2) =  cos(stereo)
      endif
      eta(3) = 0.0

c     Compute the measurement.
      dcalc = ( xl - x0 ) * eta(1) + ( yl - y0 ) * eta(2)

c     Check for being inside the active area.
      nstrip  = int(dcalc/cell_size)
      if ( nstrip .lt. 0 .or. nstrip .ge. ncell ) goto 9999
      if ( xl .lt. xmin+xdead .or. xl .gt. xmax-xdead ) goto 9999
      if ( yl .lt. ymin+ydead .or. yl .gt. ymax-ydead ) goto 9999
      
c     Check efficiency.  Apply this only after we know that the
c     hit is inside the active area of the layer.
      if (rann(0) .gt. siz_rect_par(dev).lyr(lyr).wfr(wfr).eff_hit)
     +   goto 9999

c     Rotate the reference point and measurement direction to the lab frame.
      x1 =  x0*cr - y0*sr + xc
      y1 =  x0*sr + y0*cr + yc
      etar(1) = eta(1)*cr - eta(2)*sr
      etar(2) = eta(1)*sr + eta(2)*cr
      etar(3) = 0.

c     Add the hit to hit_track.inc
      if(hit_trk_num .ge. hit_trk_max) goto 9998
      hit_trk_num = hit_trk_num + 1

      hit_trk(hit_trk_num).hep   = hep
      hit_trk(hit_trk_num).trace = trace

      hit_trk(hit_trk_num).chan.devtype   = jdev_silplane
      hit_trk(hit_trk_num).chan.devnum    = dev
      hit_trk(hit_trk_num).chan.devlayer  = lyr
      hit_trk(hit_trk_num).chan.devwid(1) = wfr
      hit_trk(hit_trk_num).chan.devwid(2) = nstrip
      hit_trk(hit_trk_num).chan.devwid(3) = 0
      call geo_set_trkchan(hit_trk(hit_trk_num).chan)

      hit_trk(hit_trk_num).pos(1)        = x1
      hit_trk(hit_trk_num).pos(2)        = y1
      hit_trk(hit_trk_num).pos(3)        = w.z
      hit_trk(hit_trk_num).dircos(1)     = etar(1)
      hit_trk(hit_trk_num).dircos(2)     = etar(2)
      hit_trk(hit_trk_num).dircos(3)     = etar(3)

      hit_trk(hit_trk_num).dtime_exact   = 0.
      hit_trk(hit_trk_num).dtime         = 0.
      hit_trk(hit_trk_num).dtime_sigma   = 0

      hit_trk(hit_trk_num).dmeas         = dcalc + sigma * get_gauss(0) 
      hit_trk(hit_trk_num).dmeas_exact   = dcalc
      hit_trk(hit_trk_num).dmeas_sigma   = sigma
      
c      The following is a hack to make these hits backwards compatible
c      with the BTeV baseline trigger code.  It only works for stereo = 0.
c      The correct, final lines are commented out.
c      hit_trk(hit_trk_num).dpix_exact(1) = 0.
c      hit_trk(hit_trk_num).dpix_exact(2) = 0.
c      hit_trk(hit_trk_num).dpix(1)       = 0.
c      hit_trk(hit_trk_num).dpix(2)       = 0.
c      hit_trk(hit_trk_num).dpix_cov(1,1) = 0.
c      hit_trk(hit_trk_num).dpix_cov(1,2) = 0.
c      hit_trk(hit_trk_num).dpix_cov(2,1) = 0.
c      hit_trk(hit_trk_num).dpix_cov(2,2) = 0.
      siga_x = siz_rect_par(dev).lyr(lyr).wfr(wfr).siga_x
      siga_y = siz_rect_par(dev).lyr(lyr).wfr(wfr).siga_y
      hit_trk(hit_trk_num).dpix_exact(1) = w.x
      hit_trk(hit_trk_num).dpix_exact(2) = w.y
      hit_trk(hit_trk_num).dpix(1) = w.x + 
     +                               siga_x * get_gauss(0)
      hit_trk(hit_trk_num).dpix(2) = w.y + 
     +                               siga_y * get_gauss(0)
      hit_trk(hit_trk_num).dpix_cov(1,1) = siga_x**2
      hit_trk(hit_trk_num).dpix_cov(2,2) = siga_y**2
      hit_trk(hit_trk_num).dpix_cov(2,1) = 0.
      hit_trk(hit_trk_num).dpix_cov(2,2) = 0.

      hit = hit_trk_num
      if ( hep_trace(hep).nhit .eq. 0 ) then
         hep_trace(hep).first_hit = hit_trk_num
      endif
      hep_trace(hep).nhit = hep_trace(hep).nhit + 1

c     Normal return.
      error = 0
      return

c     Too many hits.
 9998 error = 1
      return

c     Outside active area or inefficient chamber.
 9999 error = 0
      return

      end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:39  eugenio
c Initial revision
c
c Revision 1.6  2000/02/07 21:02:33  kutschke
c Set error code correctly at main return.
c
c Revision 1.5  2000/01/28  02:53:44  kutschke
c Allow rotated planes.
c
c Revision 1.4  2000/01/13  05:10:05  kutschke
c Device type is now jdev_silplane, not jdev_pixelplane.
c
c Revision 1.3  1999/03/26  17:37:57  kutschke
c Fill pixel hit info for trigger compatibility.
c
c Revision 1.2  1999/03/26  02:52:26  kutschke
c New file.
c
c

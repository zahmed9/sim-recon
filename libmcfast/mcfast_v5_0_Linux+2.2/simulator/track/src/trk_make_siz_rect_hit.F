      subroutine trk_make_siz_rect_hit(hep, trace, w, dev, lyr, wfr,
     *                                 lstrike, hit, error)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Make a hit in a rectangular silicon pixel disk
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

c     Local variables
      DFLOAT cosRot, sinRot
      integer type
      integer nsegm_x, nsegm_y, npix_x, npix_y
      DFLOAT siga_x, siga_y, dcalc(2)
      DFLOAT pitch_x, pitch_y
      DFLOAT coord0_x, coord0_y
      DFLOAT xpr, ypr
      DFLOAT xLayer, yLayer, xWafer, yWafer
      DFLOAT sin_stereo, cos_stereo
      record /trk_channel_struct/ chan
      real eps
      data eps/1.e-6/

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      hit = 0

c     No need to check if track hit wafer since this check has already
c     been done.
      if (.not.lstrike) goto 9997

      nsegm_x = siz_rect_par(dev).lyr(lyr).wfr(wfr).nsegm_x
      nsegm_y = siz_rect_par(dev).lyr(lyr).wfr(wfr).nsegm_y

c     Devices with a single pixel in one dimension are treated as
c     strip detectors.
      if ( nsegm_x .eq. 1 .or. nsegm_y .eq. 1 ) then
         call trk_make_siz_strip_hit (hep, trace, w, dev, lyr, wfr,
     *                                lstrike, hit, error)
         return
      endif

c Convert to Layer's local coordinate system
      cosRot = 1.
      sinRot = 0.
      if (abs(siz_rect_par(dev).lyr(lyr).rotate) .gt. eps) then
       cosRot = cos(siz_rect_par(dev).lyr(lyr).rotate)
       sinRot = sin(siz_rect_par(dev).lyr(lyr).rotate)
      end if
      xLayer = (w.x-siz_rect_par(dev).lyr(lyr).xCenter)*cosRot
     &       + (w.y-siz_rect_par(dev).lyr(lyr).yCenter)*sinRot
      yLayer =-(w.x-siz_rect_par(dev).lyr(lyr).xCenter)*sinRot
     &       + (w.y-siz_rect_par(dev).lyr(lyr).yCenter)*cosRot
c Go to wafer's coordinate system
      xWafer = xLayer-siz_rect_par(dev).lyr(lyr).wfr(wfr).xLocal
      yWafer = yLayer-siz_rect_par(dev).lyr(lyr).wfr(wfr).yLocal

c     Calculate hit coordinates using strips as x axis
      cos_stereo = 1.
      sin_stereo = 0.
      if (abs(siz_rect_par(dev).lyr(lyr).wfr(wfr).stereo) 
     &    .gt. eps) then
       cos_stereo = cos(siz_rect_par(dev).lyr(lyr).wfr(wfr).stereo)
       sin_stereo = sin(siz_rect_par(dev).lyr(lyr).wfr(wfr).stereo)
      end if
      xpr =  xWafer*cos_stereo + yWafer*sin_stereo
      ypr = -xWafer*sin_stereo + yWafer*cos_stereo

      type = siz_rect_par(dev).lyr(lyr).wfr(wfr).type

      dcalc(1) = xpr
      dcalc(2) = ypr

c     Calculate (x,y) pixel hits
      pitch_x = siz_rect_par(dev).lyr(lyr).wfr(wfr).pitch_x
      siga_x = siz_rect_par(dev).lyr(lyr).wfr(wfr).siga_x
      if ( siga_x .eq. 0. ) siga_x = pitch_x/root12

      pitch_y = siz_rect_par(dev).lyr(lyr).wfr(wfr).pitch_y
      siga_y = siz_rect_par(dev).lyr(lyr).wfr(wfr).siga_y
      if ( siga_y .eq. 0. ) siga_y = pitch_y/root12

      coord0_x = siz_rect_par(dev).lyr(lyr).wfr(wfr).coord0_x
      coord0_y = siz_rect_par(dev).lyr(lyr).wfr(wfr).coord0_y

      npix_x = int((dcalc(1) - coord0_x) / pitch_x) + 1
      npix_y = int((dcalc(2) - coord0_y) / pitch_y) + 1

c     Quit if hit is outside active wafer area
      if(npix_x .le. 0 .or. npix_x .gt. nsegm_x .or.
     *   npix_y .le. 0 .or. npix_y .gt. nsegm_y) goto 9997

c     Check efficiency
      if (rann(0) .gt. siz_rect_par(dev).lyr(lyr).wfr(wfr).eff_hit)
     *       goto 2000

      if(hit_trk_num .ge. hit_trk_max) goto 9998

      hit_trk_num = hit_trk_num + 1

      hit_trk(hit_trk_num).hep = hep
      hit_trk(hit_trk_num).trace = trace

c     Store device, layer, plane, strip info
      hit_trk(hit_trk_num).chan.devtype = jdev_pixelplane
      hit_trk(hit_trk_num).chan.devnum = dev
      hit_trk(hit_trk_num).chan.devlayer = lyr
      hit_trk(hit_trk_num).chan.devwid(1) = wfr
      hit_trk(hit_trk_num).chan.devwid(2) = npix_x
      hit_trk(hit_trk_num).chan.devwid(3) = npix_y
      call geo_set_trkchan(hit_trk(hit_trk_num).chan)

c     Position, orientation of plane
      hit_trk(hit_trk_num).pos(1) = 
     +                     siz_rect_par(dev).lyr(lyr).wfr(wfr).xLocal
      hit_trk(hit_trk_num).pos(2) = 
     +                     siz_rect_par(dev).lyr(lyr).wfr(wfr).yLocal
      hit_trk(hit_trk_num).pos(3) = 
     +                     siz_rect_par(dev).lyr(lyr).wfr(wfr).z

      hit_trk(hit_trk_num).dircos(1) = cos_stereo
      hit_trk(hit_trk_num).dircos(2) = sin_stereo
      hit_trk(hit_trk_num).dircos(3) = 0.

      hit_trk(hit_trk_num).dtime_exact = 0.
      hit_trk(hit_trk_num).dtime = 0.
      hit_trk(hit_trk_num).dtime_sigma = 0
      hit_trk(hit_trk_num).dpix_exact(1) = dcalc(1)
      hit_trk(hit_trk_num).dpix_exact(2) = dcalc(2)

      hit_trk(hit_trk_num).dmeas_sigma = 0.
      hit_trk(hit_trk_num).dmeas = 0.

      if ( siga_x .gt. 0. .and. siga_y .gt. 0. ) then

          hit_trk(hit_trk_num).dpix(1) = dcalc(1) + 
     +                                   siga_x * get_gauss(0)
          hit_trk(hit_trk_num).dpix(2) = dcalc(2) + 
     +                                   siga_y * get_gauss(0)

          hit_trk(hit_trk_num).dpix_cov(1,1) = cos_stereo**2*siga_x**2 + 
     &         sin_stereo**2*siga_y**2
          hit_trk(hit_trk_num).dpix_cov(2,2) = cos_stereo**2*siga_y**2 +
     &         sin_stereo**2*siga_x**2
          hit_trk(hit_trk_num).dpix_cov(1,2) =
     &         cos_stereo*sin_stereo*siga_y**2 -
     &         cos_stereo*sin_stereo*siga_x**2
          hit_trk(hit_trk_num).dpix_cov(2,1) = 
     &         hit_trk(hit_trk_num).dpix_cov(1,2)
      else
          call usr_siz_rect_res ( hep, w, dev, lyr, wfr,
     *         hit_trk(hit_trk_num) )
      endif

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
c Revision 1.7  1999/03/26 02:51:32  kutschke
c Implement strip detectors.  Clean up stale code.
c
c Revision 1.6  1999/03/16  23:50:07  kutschke
c Fix world/local bug
c
c Revision 1.5  1999/02/17  00:30:13  kutschke
c Add user call if sigma is negative.
c
c Revision 1.4  1997/10/23  21:31:26  yarba_j
c updated to account for new pixel geometry
c
c Revision 1.3  1997/10/06  23:10:34  yarba_j
c renamed rotate -> tilt
c
c Revision 1.2  1997/04/04  20:30:28  garren
c add rcs log line
c

      subroutine usr_siz_rect_res ( hep, w, dev, lyr, wfr, hit )
c
c
c User routine to override the default resolution of a pixel detector.
c This version just implements pitch/sqrt(12.) resolution in order
c to provide and example and some sensisble default behaviour.
c
c This routine will only be called if siga_x or siga_y is negative.
c
c Input:
c
c hep           - Index into /hepevt/
c w             - The track parameters at the intersection of the track and
c                 the pixel plane.
c dev, lyr, wfr - The identifies the wafer which has been hit.
c hit           - Hit on track structure.  All fields except
c                 dpix and dpix_cov are input.
c
c Output:
c hit           - Hit on track structure.
c                 This routine must fill the dpix and dpix_cov
c                 substructures.
c 
#include "const.inc"
#include "hit_track.inc"
#include "wtrack_struct.inc"
#include "siz_rect.inc"

      integer hep
      record  /wtrack_struct/ w
      integer dev, lyr,  wfr
      record  /hit_trk_s/ hit

      real get_gauss
      external get_gauss

c     Sine and cosine of the stereo angle of the pixels.
      DFLOAT sin_stereo, cos_stereo

c     Pitch and resolution in the two dimensions.
      DFLOAT pitch_x, pitch_y
      DFLOAT siga_x,  siga_y

      real eps
      parameter ( eps = 1.e-6 )

      cos_stereo = 1.
      sin_stereo = 0.
      if (abs(siz_rect_par(dev).lyr(lyr).wfr(wfr).stereo) 
     &    .gt. eps) then
       cos_stereo = cos(siz_rect_par(dev).lyr(lyr).wfr(wfr).stereo)
       sin_stereo = sin(siz_rect_par(dev).lyr(lyr).wfr(wfr).stereo)
      end if

c     Compute the resolutions.
      siga_x  = siz_rect_par(dev).lyr(lyr).wfr(wfr).siga_x
      if ( siga_x .le. 0. ) then
          pitch_x = siz_rect_par(dev).lyr(lyr).wfr(wfr).pitch_x
          siga_x = pitch_x/root12
      endif

      siga_y  = siz_rect_par(dev).lyr(lyr).wfr(wfr).siga_y
      if ( siga_y .le. 0. ) then
          pitch_y = siz_rect_par(dev).lyr(lyr).wfr(wfr).pitch_y
          siga_y = pitch_y/root12
      endif

c     Smear the hits.
      hit.dpix(1) = hit.dpix_exact(1) + siga_x * get_gauss(0)
      hit.dpix(2) = hit.dpix_exact(2) + siga_y * get_gauss(0)

c     Build the covariance matrix.
      hit.dpix_cov(1,1) = cos_stereo**2*siga_x**2 + 
     &     sin_stereo**2*siga_y**2
      hit.dpix_cov(2,2) = cos_stereo**2*siga_y**2 +
     &     sin_stereo**2*siga_x**2
      hit.dpix_cov(1,2) =
     &     cos_stereo*sin_stereo*siga_y**2 -
     &     cos_stereo*sin_stereo*siga_x**2
      hit.dpix_cov(2,1) = hit.dpix_cov(1,2)
      
      end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:41  eugenio
c Initial revision
c
c Revision 1.2  1999/02/17 19:41:29  kutschke
c Fixed undeclared variables.
c
c Revision 1.1  1999/02/17  00:31:07  kutschke
c New routine.
c
c

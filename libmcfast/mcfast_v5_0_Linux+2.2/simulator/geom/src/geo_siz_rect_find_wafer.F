      subroutine geo_siz_rect_find_wafer(point, dev, layer, 
     &                                   wafer, lstrike)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c  Find the wafer in a silicon rectangular device on which a given
c  point lies.
c
c  In this device a plane is composed of 1 or more small rectangles.
c  The rectangles may be staggered in z and may overlap in (x,y).
c  The intention is to model a pixel detector in which one plane is
c  built up from many small chips.  In such a detector the magnitude
c  of the stagger between planes will be of the order of a few hundred
c  microns - this scale drives the choice of the tolerance.
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "siz_rect.inc"

c     Calling arguments
      DFLOAT point(3)
      integer dev, layer, wafer
      logical lstrike

c     Local variables
      integer iwfr
      DFLOAT theta, sinTheta, cosTheta, xLayer, yLayer
      DFLOAT xRotate, yRotate, 
     &       xmax, ymax, xWafer, yWafer, zWafer

c     Tolerance with which projected z position should match
c     the actual z of the wafer.  Used to resolve the z stagger ( see above).
      DFLOAT eps
      parameter ( eps = 5.e-6*unit_meter )

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      lstrike = .FALSE.
      wafer = 0

c     Convert x and y coordinates to local layer coordinates
      theta = siz_rect_par(dev).lyr(layer).rotate
      sinTheta = sin(theta)
      cosTheta = cos(theta)
      xLayer = point(1) - siz_rect_par(dev).lyr(layer).xCenter
      yLayer = point(2) - siz_rect_par(dev).lyr(layer).yCenter

      xRotate = +xLayer*cosTheta + yLayer*sinTheta
      yRotate = -xLayer*sinTheta + yLayer*cosTheta

c     Quit if point falls into layer gap
      if(xRotate .gt. siz_rect_par(dev).lyr(layer).xGapMinLocal .and.
     *   xRotate .lt. siz_rect_par(dev).lyr(layer).xGapMaxLocal .and.
     *   yRotate .gt. siz_rect_par(dev).lyr(layer).yGapMinLocal .and.
     *   yRotate .lt. siz_rect_par(dev).lyr(layer).yGapMaxLocal) return

c     Loop over wafers and see if one is struck
      do iwfr=1,siz_rect_par(dev).lyr(layer).nwafer

c       First make sure point is at the right z
        zWafer = point(3)-siz_rect_par(dev).lyr(layer).wfr(iwfr).z

        if(abs(zWafer) .le. eps) then 

c         Check that point falls within wafer x- and y-boundaries
          xWafer = xRotate
     *            - siz_rect_par(dev).lyr(layer).wfr(iwfr).xLocal
          yWafer = yRotate
     *            - siz_rect_par(dev).lyr(layer).wfr(iwfr).yLocal
          xmax = 0.5 * siz_rect_par(dev).lyr(layer).wfr(iwfr).xlen
          ymax = 0.5 * siz_rect_par(dev).lyr(layer).wfr(iwfr).ylen
          if(abs(xWafer) .le. xmax .and. abs(yWafer) .le. ymax) then
            lstrike = .TRUE.
            wafer = iwfr
            return
          endif

        endif

      enddo

      return
      end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:23  eugenio
c Initial revision
c
c Revision 1.3  1998/08/11 18:15:51  kutschke
c Adjust zwafer tolerance to 5 microns.
c
c

      subroutine geo_trkorder_siz_rect

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add the silicon rectangular z devices to the list of radial and z
c  planes.
c
c  10/22/97  P. Avery   Creation of routine
c
c  11/13/97  P. McBride routine makes a Zplane for each new wafer with a
c                       new Z position or thickness in each layer
c
c  01/27/00  R. Kutschke Allow rotations of the plane.
c
c
c  Each siz_rect plane will produce at least one zplane.  If the wafers
c  which comprise the siz_rect plane occur at several different values
c  of z, or have different thickness, then a zplane will be created
c  for each distinct pair of z position and wafer thickness.  Each of
c  these is called a pseudo-plane.  All pseudo planes corresponding
c  to the same layer have the same limiting dimensions.
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none
#include "mcp_luns.inc"
#include "zplane.inc"
#include "rplane.inc"
#include "siz_rect.inc"
#include "material.inc"

c     Local variables
      integer i, lyr, wfr, nwafer, material
      integer index, iZT, nZT, WSave(max_siz_rect_wafer)
      real z, thick
      real xmin, xmax, ymin, ymax
      real ZSave(max_siz_rect_wafer),TSave(max_siz_rect_wafer)
      real c, s, rxmin, rxmax, rymin, rymax

c     Statement functions and their dummy arguments.
      real xrot, yrot
      real x, y
      
      real eps
      data eps / 1.e-4/

c     Statement functions.
      xrot(x,y) = x*c - y*s 
      yrot(x,y) = x*s + y*c

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (zpln_num .ge. zpln_max) return
 
c     Silicon rectangular z planes
      do i=1,siz_rect_num
        do lyr=1,siz_rect_par(i).nlayer
         nwafer =  siz_rect_par(i).lyr(lyr).nwafer

c        Create the first pseudo-plane.
         nZT = 1
         WSave(1) = 1
         ZSave(1) = siz_rect_par(i).lyr(lyr).wfr(1).z
         TSave(1) = siz_rect_par(i).lyr(lyr).wfr(1).zlen
 
c        Start the search for the limiting dimensions.
c        Ignore rotations for now.
         xmin = siz_rect_par(i).lyr(lyr).wfr(1).xLocal -
     &      0.5*siz_rect_par(i).lyr(lyr).wfr(1).xlen
         xmax = siz_rect_par(i).lyr(lyr).wfr(1).xLocal +
     &      0.5*siz_rect_par(i).lyr(lyr).wfr(1).xlen
         ymin = siz_rect_par(i).lyr(lyr).wfr(1).yLocal -
     &      0.5*siz_rect_par(i).lyr(lyr).wfr(1).ylen
         ymax = siz_rect_par(i).lyr(lyr).wfr(1).yLocal +
     &      0.5*siz_rect_par(i).lyr(lyr).wfr(1).ylen
     
c        Check other for wafers to find distinct pseudo planes and
c        to find the limiting dimensions of the full layer.  Continue
c        to ignore rotations.
         if (nwafer .gt. 1) then
            do wfr = 2, nwafer
               z     = siz_rect_par(i).lyr(lyr).wfr(wfr).z   
               thick = siz_rect_par(i).lyr(lyr).wfr(wfr).zlen
               do iZT = 1,nZT
                  if ((abs(ZSave(iZT)-z)     .lt. eps) .and. 
     &                 abs(TSave(iZT)-thick) .lt. eps) goto 200
               enddo
               nZT = nZT + 1
               ZSave(nZT) = z
               TSave(nZT) = thick
               WSave(nZT) = wfr

  200          continue
  
               xmin = min(xmin,
     &               siz_rect_par(i).lyr(lyr).wfr(wfr).xLocal -
     &               0.5*siz_rect_par(i).lyr(lyr).wfr(wfr).xlen)
               xmax = max(xmax,
     &               siz_rect_par(i).lyr(lyr).wfr(wfr).xLocal +
     &               0.5 * siz_rect_par(i).lyr(lyr).wfr(wfr).xlen)
               ymin = min(ymin,
     &               siz_rect_par(i).lyr(lyr).wfr(wfr).yLocal -
     &               0.5*siz_rect_par(i).lyr(lyr).wfr(wfr).ylen)
               ymax = max(ymax,
     &               siz_rect_par(i).lyr(lyr).wfr(wfr).yLocal +
     &               0.5*siz_rect_par(i).lyr(lyr).wfr(wfr).ylen)
            enddo
         endif

         c = cos(siz_rect_par(i).lyr(lyr).rotate)
         s = sin(siz_rect_par(i).lyr(lyr).rotate)

c        Now apply the rotation and find the true limiting dimensions.
         rxmin = min(xrot(xmin,ymin),
     *               xrot(xmin,ymax),
     *               xrot(xmax,ymax),
     *               xrot(xmax,ymin))
         rymin = min(yrot(xmin,ymin),
     *               yrot(xmin,ymax),
     *               yrot(xmax,ymax),
     *               yrot(xmax,ymin))
         rxmax = max(xrot(xmin,ymin),
     *               xrot(xmin,ymax),
     *               xrot(xmax,ymax),
     *               xrot(xmax,ymin))
         rymax = max(yrot(xmin,ymin),
     *               yrot(xmin,ymax),
     *               yrot(xmax,ymax),
     *               yrot(xmax,ymin))

c make "pseudo"-z-planes for the layers

         do iZT = 1,nZT
            wfr = WSave(iZT)
            if (zpln_num .ge. zpln_max) goto 9999
            zpln_num = zpln_num + 1
            zpln_par(zpln_num).type = jzpl_siz_rect
            zpln_par(zpln_num).pos(1) = i
            zpln_par(zpln_num).pos(2) = lyr
            zpln_par(zpln_num).pos(3) = 0
            zpln_par(zpln_num).z = siz_rect_par(i).lyr(lyr).wfr(wfr).z
            zpln_par(zpln_num).shape = 2
            zpln_par(zpln_num).rmin = 0.
            zpln_par(zpln_num).rmax = 1.e20
            zpln_par(zpln_num).xmin = 
     &                        siz_rect_par(i).lyr(lyr).xCenter + rxmin
            zpln_par(zpln_num).xmax = 
     &                        siz_rect_par(i).lyr(lyr).xCenter + rxmax
            zpln_par(zpln_num).ymin = 
     &                        siz_rect_par(i).lyr(lyr).yCenter + rymin
            zpln_par(zpln_num).ymax = 
     &                        siz_rect_par(i).lyr(lyr).yCenter + rymax
            material = siz_rect_par(i).lyr(lyr).wfr(wfr).material
            thick    = siz_rect_par(i).lyr(lyr).wfr(wfr).zlen
            zpln_par(zpln_num).col  = thick * mtl_par(material).coll_inv
            zpln_par(zpln_num).abs  = thick * mtl_par(material).abs_inv
            zpln_par(zpln_num).radl = thick * mtl_par(material).rad_inv
            zpln_par(zpln_num).dedx = thick * mtl_par(material).dedx
            write(zpln_par(zpln_num).name,5210) i, lyr, wfr
 5210       format('Silicon rect ',i3,'lyr ',i3,
     *             'wfr ',i3)
         end do
        end do
      end do

      return
            
 9999 write(6,5999) zpln_max, i, lyr, wfr
      write(mcp_llpt,5999) zpln_max, i, lyr, wfr
 5999 format('Z plane overflow in GEO_TRKORDER_SIZ_RECT: dev ',i3,
     *             'lyr ',i3,'wfr ',i3) 
 
      return
      end
      
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:23  eugenio
c Initial revision
c
c Revision 1.4  2000/01/28 02:51:31  kutschke
c Allow for rotated planes in computation of xmin and xmax.
c
c Revision 1.3  1998/02/13  21:10:58  mcbride
c add collision lengths to scattering planes
c

      subroutine geo_trkorder_for_trk

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add the forward drift chambers to the list of radial and z planes.
c
c  10/22/97  P. Avery   Creation of routine
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_luns.inc"
#include "zplane.inc"
#include "rplane.inc"
#include "for_trk.inc"
#include "material.inc"

c     Local variables
      integer i, ilyr, material
      real thick, z1, znext
      real xmi, xma, ymi, yma

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (zpln_num .ge. zpln_max) return

      do i=1,ftrk_num
        if (zpln_num .ge. zpln_max) goto 9999
        call geo_ftrk_xy_limits ( i, 1, xmi, xma, ymi, yma )
        zpln_num = zpln_num + 1
        zpln_par(zpln_num).type = jzpl_material
        zpln_par(zpln_num).pos(1) = i
        zpln_par(zpln_num).pos(2) = 1
        zpln_par(zpln_num).pos(3) = 0
        thick = ftrk_par(i).thick_boun(5)
        zpln_par(zpln_num).z = ftrk_par(i).zmin - thick/2.0
        zpln_par(zpln_num).shape = 100 + jzpl_drift 
        zpln_par(zpln_num).rmin = 0.
        zpln_par(zpln_num).rmax = 1.e20
        zpln_par(zpln_num).xmin = xmi
        zpln_par(zpln_num).xmax = xma
        zpln_par(zpln_num).ymin = ymi
        zpln_par(zpln_num).ymax = yma
        material = ftrk_par(i).mat_boun(5)
        zpln_par(zpln_num).col  = thick*mtl_par(material).coll_inv        
        zpln_par(zpln_num).abs  = thick*mtl_par(material).abs_inv
        zpln_par(zpln_num).radl = thick * mtl_par(material).rad_inv
        zpln_par(zpln_num).dedx = thick * mtl_par(material).dedx
        write(zpln_par(zpln_num).name,5217) i
 5217   format('forward trk ',i3,' z-boundary-zmin ')
        
        if (zpln_num .ge. zpln_max) goto 9999
        zpln_num = zpln_num + 1
        zpln_par(zpln_num).type = jzpl_material
        zpln_par(zpln_num).pos(1) = i
        zpln_par(zpln_num).pos(2) = 1
        zpln_par(zpln_num).pos(3) = 0
        thick = ftrk_par(i).lyr(1).z - ftrk_par(i).zmin
        z1 = ftrk_par(i).zmin
        if (thick .lt. 0.0) then
          thick = ftrk_par(i).lyr(1).z - ftrk_par(i).zmax
          z1 = ftrk_par(i).zmax
          if (thick .lt. 0.) then
           write (6,6001) i
 6001      format('geo_trkorder:  error in ftrk ',i3,' z info')
          endif       
        endif
        zpln_par(zpln_num).z = 0.5*(z1 + ftrk_par(i).lyr(1).z)
        zpln_par(zpln_num).shape = 100 + jzpl_drift
        zpln_par(zpln_num).rmin = 0.
        zpln_par(zpln_num).rmax = 1.e20
        zpln_par(zpln_num).xmin = xmi
        zpln_par(zpln_num).xmax = xma
        zpln_par(zpln_num).ymin = ymi
        zpln_par(zpln_num).ymax = yma
        material = ftrk_par(i).material
        zpln_par(zpln_num).col  = thick * mtl_par(material).coll_inv        
        zpln_par(zpln_num).abs  = thick * mtl_par(material).abs_inv
        zpln_par(zpln_num).radl = thick * mtl_par(material).rad_inv
        zpln_par(zpln_num).dedx = thick * mtl_par(material).dedx
        write(zpln_par(zpln_num).name,5218) i
 5218   format('forward trk ',i3,' fill at zmin ')
        
        do ilyr=1,ftrk_par(i).nlyr
          if (zpln_num .ge. zpln_max) goto 9999
          call geo_ftrk_xy_limits ( i, ilyr, xmi, xma, ymi, yma )
          zpln_num = zpln_num + 1
          zpln_par(zpln_num).type = jzpl_drift
          zpln_par(zpln_num).pos(1) = i
          zpln_par(zpln_num).pos(2) = ilyr
          zpln_par(zpln_num).pos(3) = 0
          zpln_par(zpln_num).z = ftrk_par(i).lyr(ilyr).z
          zpln_par(zpln_num).shape = 2
          zpln_par(zpln_num).rmin = 0.
          zpln_par(zpln_num).rmax = 1.e20
          zpln_par(zpln_num).xmin = xmi
          zpln_par(zpln_num).xmax = xma
          zpln_par(zpln_num).ymin = ymi
          zpln_par(zpln_num).ymax = yma
          zpln_par(zpln_num).col = 0.
          zpln_par(zpln_num).abs = 0.
          zpln_par(zpln_num).radl = 0.
          zpln_par(zpln_num).dedx = 0.
          write(zpln_par(zpln_num).name,5219) i, ilyr
 5219     format('forward trk ',i3,' layer ',i3)
 
          if (zpln_num .ge. zpln_max) goto 9999
          zpln_num = zpln_num + 1
          zpln_par(zpln_num).type = jzpl_material
          zpln_par(zpln_num).pos(1) = i
          zpln_par(zpln_num).pos(2) = ilyr
          zpln_par(zpln_num).pos(3) = 0
          if (ilyr.ne.ftrk_par(i).nlyr) then
            znext = ftrk_par(i).lyr(ilyr+1).z
          else
            znext = ftrk_par(i).zmax
          end if
          zpln_par(zpln_num).z = (ftrk_par(i).lyr(ilyr).z + znext)/2.0
          zpln_par(zpln_num).shape = 100 + jzpl_drift
          zpln_par(zpln_num).rmin = 0.
          zpln_par(zpln_num).rmax = 1.e20
          zpln_par(zpln_num).xmin = xmi
          zpln_par(zpln_num).xmax = xma
          zpln_par(zpln_num).ymin = ymi
          zpln_par(zpln_num).ymax = yma
          material = ftrk_par(i).material
          thick = abs(ftrk_par(i).lyr(ilyr).z - znext)
          zpln_par(zpln_num).col  = thick * mtl_par(material).coll_inv        
          zpln_par(zpln_num).abs  = thick * mtl_par(material).abs_inv
          zpln_par(zpln_num).radl = thick * mtl_par(material).rad_inv
          zpln_par(zpln_num).dedx = thick * mtl_par(material).dedx
          write(zpln_par(zpln_num).name,5220) i, ilyr
 5220     format('forward trk material',i3,' layer ',i3)
        end do
        if (zpln_num .ge. zpln_max) goto 9999
        zpln_num = zpln_num + 1
        zpln_par(zpln_num).type = jzpl_material
        zpln_par(zpln_num).pos(1) = i
        zpln_par(zpln_num).pos(2) = ftrk_par(i).nlyr
        zpln_par(zpln_num).pos(3) = 0
        zpln_par(zpln_num).z = ftrk_par(i).zmax
        zpln_par(zpln_num).shape = 100 + jzpl_drift
        zpln_par(zpln_num).rmin = 0.
        zpln_par(zpln_num).rmax = 1.e20
        zpln_par(zpln_num).xmin = xmi
        zpln_par(zpln_num).xmax = xma
        zpln_par(zpln_num).ymin = ymi
        zpln_par(zpln_num).ymax = yma
        zpln_par(zpln_num).col = 0.
        zpln_par(zpln_num).abs = 0.
        material = ftrk_par(i).mat_boun(6)
        thick = ftrk_par(i).thick_boun(6)
        zpln_par(zpln_num).col  = thick*mtl_par(material).coll_inv        
        zpln_par(zpln_num).abs  = thick*mtl_par(material).abs_inv
        zpln_par(zpln_num).radl = thick * mtl_par(material).rad_inv
        zpln_par(zpln_num).dedx = thick * mtl_par(material).dedx
        write(zpln_par(zpln_num).name,5221) i
 5221   format('forward trk ',i3,' z-boundary zmax')
      end do

      return
      
 9999 write(6,5999) zpln_max, i
      write(mcp_llpt,5999) zpln_max, i
 5999 format('Z plane overflow in GEO_TRKORDER_FOR_TRK: dev ',i3)
 
      return
      end
      
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:23  eugenio
c Initial revision
c
c Revision 1.5  2000/01/26 00:43:57  kutschke
c Use geo_ftrk_xy_limits.F to compute x and y limits.
c
c Revision 1.4  1999/03/24  02:08:22  mcbride
c add gaps to zplanes
c
c Revision 1.3  1998/02/13  21:10:56  mcbride
c add collision lengths to scattering planes
c

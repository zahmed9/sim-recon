      subroutine geo_trkorder_rich

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add rich detectors to the list of radial and z planes.
c
c  10/22/97  P. Avery   Creation of routine
c  11/13/97  P. McBride Start updates for adding RICH and its container
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_luns.inc"
#include "zplane.inc"
#include "rplane.inc"
#include "rich.inc"
#include "material.inc"

c     Local variables
      integer i, j, material
      real thick
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (zpln_num .ge. zpln_max) return

      do i=1,certh_num
        if (zpln_num .ge. zpln_max) goto 9999
        zpln_num = zpln_num + 1
        zpln_par(zpln_num).type = jzpl_material
        zpln_par(zpln_num).pos(1) = i
        zpln_par(zpln_num).pos(2) = 0
        zpln_par(zpln_num).pos(3) = 0
        zpln_par(zpln_num).z= certh_par(i).zmin
        zpln_par(zpln_num).shape = 1
        zpln_par(zpln_num).rmin = certh_par(i).rmin(1) 
        zpln_par(zpln_num).rmax = certh_par(i).rmax(1) 
        zpln_par(zpln_num).xmin = -1.e20
        zpln_par(zpln_num).xmax = 1.e20
        zpln_par(zpln_num).ymin = -1.e20
        zpln_par(zpln_num).ymax = 1.e20
        zpln_par(zpln_num).col = 0.
        zpln_par(zpln_num).abs = 0.
        zpln_par(zpln_num).radl = 0   ! walls are thin for now
        zpln_par(zpln_num).dedx = 0
        write(zpln_par(zpln_num).name,5000) i
 5000   format('Cerenkov',i2,' zmin ')
 
        if (zpln_num .ge. zpln_max) goto 9999
        zpln_num = zpln_num + 1
        zpln_par(zpln_num).type = jzpl_material
        zpln_par(zpln_num).pos(1) = i
        zpln_par(zpln_num).pos(2) = 0
        zpln_par(zpln_num).pos(3) = 0
        zpln_par(zpln_num).z=(certh_par(i).zmin+certh_par(i).zmax)/2.0
        zpln_par(zpln_num).shape = 1
        zpln_par(zpln_num).rmin = (certh_par(i).rmin(1) + 
     & certh_par(i).rmin(2))/2.0
        zpln_par(zpln_num).rmax = (certh_par(i).rmax(1) + 
     & certh_par(i).rmax(2))/2.0
        zpln_par(zpln_num).xmin = -1.e20
        zpln_par(zpln_num).xmax = 1.e20
        zpln_par(zpln_num).ymin = -1.e20
        zpln_par(zpln_num).ymax = 1.e20
        zpln_par(zpln_num).col = 0.
        zpln_par(zpln_num).abs = 0.
        thick = certh_par(i).thick_rad
        material = certh_par(i).mat_rad
        zpln_par(zpln_num).radl = thick * mtl_par(material).rad_inv
        zpln_par(zpln_num).dedx = thick * mtl_par(material).dedx
        write(zpln_par(zpln_num).name,5001) i
 5001   format('Cerenkov',i2,' midplane')
 
        if (zpln_num .ge. zpln_max) goto 9999
        zpln_num = zpln_num + 1
        zpln_par(zpln_num).type = jzpl_material
        zpln_par(zpln_num).pos(1) = i
        zpln_par(zpln_num).pos(2) = 0
        zpln_par(zpln_num).pos(3) = 0
        zpln_par(zpln_num).z = certh_par(i).zmax
        zpln_par(zpln_num).shape = 1
        zpln_par(zpln_num).rmin =  certh_par(i).rmin(2)
        zpln_par(zpln_num).rmax =  certh_par(i).rmax(2)
        zpln_par(zpln_num).xmin = -1.e20
        zpln_par(zpln_num).xmax = 1.e20
        zpln_par(zpln_num).ymin = -1.e20
        zpln_par(zpln_num).ymax = 1.e20
        zpln_par(zpln_num).col = 0.
        zpln_par(zpln_num).abs = 0.
        zpln_par(zpln_num).radl = 0
        zpln_par(zpln_num).dedx = 0
        write(zpln_par(zpln_num).name,5002) i
 5002   format('Cerenkov',i2,' zmax')
      end do

      return
      
 9999 write(6,5999) zpln_max, i
      write(mcp_llpt,5999) zpln_max, i
 5999 format('Z plane overflow in GEO_TRKORDER_RICH: dev ',i3)
 
      return
      end
      
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:23  eugenio
c Initial revision
c
c Revision 1.3  1998/02/13 21:10:57  mcbride
c add collision lengths to scattering planes
c

      subroutine geo_trkorder_volume

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add volume information to the list of radial and z planes.
c
c  10/22/97  P. Avery   Creation of routine
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_luns.inc"
#include "zplane.inc"
#include "rplane.inc"
#include "volume.inc"
#include "material.inc"

c     Local variables
      integer i, material
      real thick
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (rpln_num .ge. rpln_max) goto 200

c     Volumes ... 
c     This is for boundraries on drift chambers, beam pipe, solenoid...
      do i=1,vol_num
        if(vol_par(i).rmin .ne. 0.) then
          if (rpln_num .ge. rpln_max) goto 9998
          rpln_num = rpln_num + 1
          rpln_par(rpln_num).type = jrpl_material
          rpln_par(rpln_num).pos(1) = i
          rpln_par(rpln_num).pos(2) = 0
          rpln_par(rpln_num).pos(3) = 0
          thick    = vol_par(i).thick_rmin
          rpln_par(rpln_num).radius = vol_par(i).rmin - 0.5 * thick
          rpln_par(rpln_num).zmin = vol_par(i).zmin
          rpln_par(rpln_num).zmax = vol_par(i).zmax
          material = vol_par(i).mat_rmin
          rpln_par(rpln_num).col  = thick * mtl_par(material).coll_inv        
          rpln_par(rpln_num).abs  = thick * mtl_par(material).abs_inv
          rpln_par(rpln_num).radl = thick * mtl_par(material).rad_inv
          rpln_par(rpln_num).dedx = thick * mtl_par(material).dedx          
          write(rpln_par(rpln_num).name,5004) i, vol_par(i).name
 5004     format('Volume rmin',i2,' Name = ',a15)
        endif
        if(vol_par(i).rmax .ne. 0.) then
          if (rpln_num .ge. rpln_max) goto 9998
          rpln_num = rpln_num + 1
          rpln_par(rpln_num).type = jrpl_material
          rpln_par(rpln_num).pos(1) = i
          rpln_par(rpln_num).pos(2) = 0
          rpln_par(rpln_num).pos(3) = 0
          thick    = vol_par(i).thick_rmax
          rpln_par(rpln_num).radius = vol_par(i).rmax + 0.5 * thick
          rpln_par(rpln_num).zmin = vol_par(i).zmin
          rpln_par(rpln_num).zmax = vol_par(i).zmax
          material = vol_par(i).mat_rmax
          rpln_par(rpln_num).col  = thick * mtl_par(material).coll_inv        
          rpln_par(rpln_num).abs  = thick * mtl_par(material).abs_inv
          rpln_par(rpln_num).radl = thick * mtl_par(material).rad_inv
          rpln_par(rpln_num).dedx = thick * mtl_par(material).dedx          
          write(rpln_par(rpln_num).name,5005) i, vol_par(i).name
 5005     format('Volume rmax',i2,' Name = ',a15)
        endif
      enddo
      
  200 continue

c     z planes

      if (zpln_num .ge. zpln_max) return

      do i=1,vol_num
        if (zpln_num .ge. zpln_max) goto 9999
        zpln_num = zpln_num + 1
        zpln_par(zpln_num).type = jzpl_material
        zpln_par(zpln_num).pos(1) = i
        zpln_par(zpln_num).pos(2) = 3
        zpln_par(zpln_num).pos(3) = 0
        zpln_par(zpln_num).z = vol_par(i).zmin
        zpln_par(zpln_num).shape = 1
        zpln_par(zpln_num).rmin = vol_par(i).rmin
        zpln_par(zpln_num).rmax = vol_par(i).rmax
        zpln_par(zpln_num).xmin = -1.e20
        zpln_par(zpln_num).xmax =  1.e20
        zpln_par(zpln_num).ymin = -1.e20
        zpln_par(zpln_num).ymax =  1.e20
        zpln_par(zpln_num).col = 0.
        zpln_par(zpln_num).abs = 0.
        zpln_par(zpln_num).radl = 0.
        zpln_par(zpln_num).dedx = 0.
        write(zpln_par(zpln_num).name,5208) i
 5208   format('volume ',i1,' zmin ')

        if (zpln_num .ge. zpln_max) goto 9999
        zpln_num = zpln_num + 1
        zpln_par(zpln_num).type = jzpl_material
        zpln_par(zpln_num).pos(1) = i
        zpln_par(zpln_num).pos(2) = 3
        zpln_par(zpln_num).pos(3) = 0
        zpln_par(zpln_num).z = vol_par(i).zmax
        zpln_par(zpln_num).shape = 1
        zpln_par(zpln_num).rmin = vol_par(i).rmin
        zpln_par(zpln_num).rmax = vol_par(i).rmax
        zpln_par(zpln_num).xmin = -1.e20
        zpln_par(zpln_num).xmax =  1.e20
        zpln_par(zpln_num).ymin = -1.e20
        zpln_par(zpln_num).ymax =  1.e20
        zpln_par(zpln_num).col = 0.
        zpln_par(zpln_num).abs = 0.
        zpln_par(zpln_num).radl = 0.
        zpln_par(zpln_num).dedx = 0.
        write(zpln_par(zpln_num).name,5209) i
 5209   format('volume ',i1,' zmax ')
      enddo

      return
            
 9998 write(6,5998) rpln_max, i 
      write(mcp_llpt,5998) rpln_max, i
 5998 format('R plane overflow in GEO_TRKORDER_VOLUME: dev ',i3) 
 
      return
      
 9999 write(6,5999) zpln_max, i
      write(mcp_llpt,5999) zpln_max, i
 5999 format('Z plane overflow in GEO_TRKORDER_VOLUME: dev ',i3)
 
      return
      end
      
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:23  eugenio
c Initial revision
c
c Revision 1.3  1998/02/13 21:10:59  mcbride
c add collision lengths to scattering planes
c

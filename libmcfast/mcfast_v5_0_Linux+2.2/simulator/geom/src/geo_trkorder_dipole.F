      subroutine geo_trkorder_dipole

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add dipole magnets to the list of radial and z planes.
c
c  10/22/97  P. Avery   Creation of routine
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_luns.inc"
#include "zplane.inc"
#include "rplane.inc"
#include "dipole.inc"
#include "material.inc"

c     Local variables
      integer i, material
      real thick
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (zpln_num .ge. zpln_max) return

      do i=1,dip_num
        if (zpln_num .ge. zpln_max) goto 9999
        zpln_num = zpln_num + 1
        zpln_par(zpln_num).type = jzpl_magnet
        zpln_par(zpln_num).pos(1) = i
        zpln_par(zpln_num).pos(2) = 1
        zpln_par(zpln_num).pos(3) = 0
        zpln_par(zpln_num).z = dip_par(i).zmin
        zpln_par(zpln_num).shape = 2
        zpln_par(zpln_num).rmin = 0.
        zpln_par(zpln_num).rmax = 1.e20
        zpln_par(zpln_num).xmin = dip_par(i).xmin
        zpln_par(zpln_num).xmax = dip_par(i).xmax
        zpln_par(zpln_num).ymin = dip_par(i).ymin
        zpln_par(zpln_num).ymax = dip_par(i).ymax
        zpln_par(zpln_num).col = 0.
        zpln_par(zpln_num).abs = 0.
        zpln_par(zpln_num).radl = 0.
        zpln_par(zpln_num).dedx = 0.
        write(zpln_par(zpln_num).name,5201) i
 5201   format('dipole ',i1,' zmin ')

        if (zpln_num .ge. zpln_max) goto 9999
        zpln_num = zpln_num + 1
        zpln_par(zpln_num).type = jzpl_material
        zpln_par(zpln_num).pos(1) = i
        zpln_par(zpln_num).pos(2) = 0
        zpln_par(zpln_num).pos(3) = 0
        material = dip_par(i).mat_boun(5)
        thick = dip_par(i).thick_boun(5)
        zpln_par(zpln_num).z = dip_par(i).zmin-thick/2.0
        zpln_par(zpln_num).shape = 2
        zpln_par(zpln_num).rmin = 0.
        zpln_par(zpln_num).rmax = 1.e20
        zpln_par(zpln_num).xmin = dip_par(i).xmin
        zpln_par(zpln_num).xmax = dip_par(i).xmax
        zpln_par(zpln_num).ymin = dip_par(i).ymin
        zpln_par(zpln_num).ymax = dip_par(i).ymax
        zpln_par(zpln_num).col = 0.
        zpln_par(zpln_num).abs = 0.
        zpln_par(zpln_num).radl = thick * mtl_par(material).rad_inv
        zpln_par(zpln_num).dedx = thick * mtl_par(material).dedx
        write(zpln_par(zpln_num).name,5202) i
 5202   format('dipole ',i1,' z-boundary-zmin ')

        if (zpln_num .ge. zpln_max) goto 9999
        zpln_num = zpln_num + 1
        zpln_par(zpln_num).type = jzpl_material
        zpln_par(zpln_num).pos(1) = i
        zpln_par(zpln_num).pos(2) = 2
        zpln_par(zpln_num).pos(3) = 0
        zpln_par(zpln_num).z = (dip_par(i).zmax+dip_par(i).zmin)/2.0
        zpln_par(zpln_num).shape = 2
        zpln_par(zpln_num).rmin = 0.
        zpln_par(zpln_num).rmax = 1.e20
        zpln_par(zpln_num).xmin = dip_par(i).xmin
        zpln_par(zpln_num).xmax = dip_par(i).xmax
        zpln_par(zpln_num).ymin = dip_par(i).ymin
        zpln_par(zpln_num).ymax = dip_par(i).ymax
        zpln_par(zpln_num).col = 0.
        zpln_par(zpln_num).abs = 0.
        material = dip_par(i).mat_fill
        thick = abs(dip_par(i).zmax - dip_par(i).zmin)
        zpln_par(zpln_num).radl = thick * mtl_par(material).rad_inv
        zpln_par(zpln_num).dedx = thick * mtl_par(material).dedx
        write(zpln_par(zpln_num).name,5203) i
 5203   format('dipole ',i1,' z mid-point ')

        if (zpln_num .ge. zpln_max) goto 9999
        zpln_num = zpln_num + 1
        zpln_par(zpln_num).type = jzpl_magnet
        zpln_par(zpln_num).pos(1) = i
        zpln_par(zpln_num).pos(2) = 3
        zpln_par(zpln_num).pos(3) = 0
        zpln_par(zpln_num).shape = 2
        zpln_par(zpln_num).rmin = 0.
        zpln_par(zpln_num).rmax = 1.e20
        zpln_par(zpln_num).xmin = dip_par(i).xmin
        zpln_par(zpln_num).xmax = dip_par(i).xmax
        zpln_par(zpln_num).ymin = dip_par(i).ymin
        zpln_par(zpln_num).ymax = dip_par(i).ymax
        zpln_par(zpln_num).z = dip_par(i).zmax
        zpln_par(zpln_num).col = 0.
        zpln_par(zpln_num).abs = 0.
        zpln_par(zpln_num).radl = 0.
        zpln_par(zpln_num).dedx = 0.
        write(zpln_par(zpln_num).name,5204) i
 5204   format('dipole ',i1,' zmax ')

        if (zpln_num .ge. zpln_max) goto 9999
        zpln_num = zpln_num + 1
        zpln_par(zpln_num).type = jzpl_material
        zpln_par(zpln_num).pos(1) = i
        zpln_par(zpln_num).pos(2) = 0
        zpln_par(zpln_num).pos(3) = 0
        material = dip_par(i).mat_boun(6)
        thick = dip_par(i).thick_boun(6)
        zpln_par(zpln_num).z = dip_par(i).zmax+thick/2.0
        zpln_par(zpln_num).shape = 2
        zpln_par(zpln_num).rmin = 0.
        zpln_par(zpln_num).rmax = 1.e20
        zpln_par(zpln_num).xmin = dip_par(i).xmin
        zpln_par(zpln_num).xmax = dip_par(i).xmax
        zpln_par(zpln_num).ymin = dip_par(i).ymin
        zpln_par(zpln_num).ymax = dip_par(i).ymax
        zpln_par(zpln_num).col = 0.
        zpln_par(zpln_num).abs = 0.
        zpln_par(zpln_num).radl = thick * mtl_par(material).rad_inv
        zpln_par(zpln_num).dedx = thick * mtl_par(material).dedx
        write(zpln_par(zpln_num).name,5205) i
 5205   format('dipole ',i1,' z-boundary-zmax ')
      enddo

      return
      
 9999 write(6,5999) zpln_max, i
      write(mcp_llpt,5999) zpln_max, i
 5999 format('Z plane overflow in GEO_TRKORDER_DIPOLE: dev ',i3)
 
      return
      end

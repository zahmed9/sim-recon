      subroutine geo_trkorder_zsixy

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add old-style silicon pixel information to the list of 
c  radial and z planes. This routine is provided for backwards 
c  compatibility only.
c
c  11/12/97  Martin Lohner   Creation of routine
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "zplane.inc"
#include "rplane.inc"
#include "sixy_disk.inc"
#include "material.inc"

c     Local variables
      integer i, material, ilyr
      real thick
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      do i=1,sixy_num
        do ilyr=1,sixy_par(i).numlyr
          zpln_num = zpln_num + 1
c          zpln_par(zpln_num).type = jzpl_sixy
          zpln_par(zpln_num).type = jzpl_siz_rect
          zpln_par(zpln_num).pos(1) = i
          zpln_par(zpln_num).pos(2) = ilyr
          zpln_par(zpln_num).pos(3) = 0
          zpln_par(zpln_num).z = sixy_par(i).lyr(ilyr).z
          zpln_par(zpln_num).shape = 2
          zpln_par(zpln_num).rmin = 0.
          zpln_par(zpln_num).rmax = 1.e20
          zpln_par(zpln_num).xmin = sixy_par(i).lyr(ilyr).xmin
          zpln_par(zpln_num).xmax = sixy_par(i).lyr(ilyr).xmax
          zpln_par(zpln_num).ymin = sixy_par(i).lyr(ilyr).ymin
          zpln_par(zpln_num).ymax = sixy_par(i).lyr(ilyr).ymax
          zpln_par(zpln_num).col = 0.
          zpln_par(zpln_num).abs = 0.
          material = sixy_par(i).lyr(ilyr).material
          thick = sixy_par(i).lyr(ilyr).thick
          zpln_par(zpln_num).radl = thick * mtl_par(material).rad_inv
          zpln_par(zpln_num).dedx = thick * mtl_par(material).dedx
          write(zpln_par(zpln_num).name,5210) i, ilyr
 5210     format('silicon xy plane ',i3,'layer ',i3)
        end do
      end do

      return
      end

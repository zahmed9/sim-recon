      subroutine geo_trkorder_sicir_disk

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add the silicon circular z planes o the list of radial and z planes.
c
c  10/22/97  P. Avery   Creation of routine
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_luns.inc"
#include "zplane.inc"
#include "rplane.inc"
#include "sicir_disk.inc"
#include "material.inc"

c     Local variables
      integer i, ilyr, k, material
      real thick, zold
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (zpln_num .ge. zpln_max) return

      do i=1,sicir_num
        do ilyr=1,sicir_par(i).numlyr
          zold = 999999.
          do k=1,sicir_par(i).lyr(ilyr).numwedge
            if (sicir_par(i).lyr(ilyr).wedge(k).z.ne.zold) then
              zold = sicir_par(i).lyr(ilyr).wedge(k).z
              if (zpln_num .ge. zpln_max) goto 9999
              zpln_num = zpln_num + 1
              zpln_par(zpln_num).type = jzpl_sidisk
              zpln_par(zpln_num).pos(1) = i
              zpln_par(zpln_num).pos(2) = ilyr
              zpln_par(zpln_num).pos(3) = k
              zpln_par(zpln_num).z = sicir_par(i).lyr(ilyr).wedge(k).z
              zpln_par(zpln_num).shape = 1
              zpln_par(zpln_num).rmin = 
     &              sicir_par(i).lyr(ilyr).wedge(k).rmin
              zpln_par(zpln_num).rmax = 
     &              sicir_par(i).lyr(ilyr).wedge(k).rmax
              zpln_par(zpln_num).xmin = -1.e20
              zpln_par(zpln_num).xmax = 1.e20
              zpln_par(zpln_num).ymin = -1.e20
              zpln_par(zpln_num).ymax = 1.e20
              material = sicir_par(i).lyr(ilyr).wedge(k).material
              thick = sicir_par(i).lyr(ilyr).wedge(k).thick
              zpln_par(zpln_num).col  = thick*mtl_par(material).coll_inv        
              zpln_par(zpln_num).abs  = thick*mtl_par(material).abs_inv
              zpln_par(zpln_num).radl = thick*mtl_par(material).rad_inv
              zpln_par(zpln_num).dedx = thick*mtl_par(material).dedx
              write(zpln_par(zpln_num).name,5211) i, ilyr
 5211         format('silicon disk ',i3,'layer ',i3)
            endif
          enddo
        end do
      end do

      return
      
 9999 write(6,5999) zpln_max, i
      write(mcp_llpt,5999) zpln_max, i
 5999 format('Z plane overflow in GEO_TRKORDER_SICIR: dev ',i3)
 
      return
      end
      
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:23  eugenio
c Initial revision
c
c Revision 1.3  1998/02/13 21:10:58  mcbride
c add collision lengths to scattering planes
c

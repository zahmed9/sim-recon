      subroutine geo_trkorder_drift

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add the drift chamber information to the list of radial and z planes.
c
c  10/22/97  P. Avery   Creation of routine
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_luns.inc"
#include "zplane.inc"
#include "rplane.inc"
#include "drift.inc"
#include "material.inc"

c     Local variables
      integer i, j, material, num_anode
      real thick
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (rpln_num .ge. rpln_max) goto 200

      do i=1,drf_num
        if (rpln_num .ge. rpln_max) goto 9998
        rpln_num = rpln_num + 1
        rpln_par(rpln_num).type = jrpl_material
        rpln_par(rpln_num).pos(1) = i
        rpln_par(rpln_num).pos(2) = 0
        rpln_par(rpln_num).pos(3) = 0
c       We have assumed that the first anode wire is at the smallest R
        rpln_par(rpln_num).radius = 0.5 * 
     &            (drf_par(i).rmin + drf_par(i).an(1).radius)
        thick = drf_par(i).an(1).radius - drf_par(i).rmin 
        rpln_par(rpln_num).zmin = drf_par(i).zmin
        rpln_par(rpln_num).zmax = drf_par(i).zmax
        material = drf_par(i).material 
        rpln_par(rpln_num).col  = thick * mtl_par(material).coll_inv        
        rpln_par(rpln_num).abs  = thick * mtl_par(material).abs_inv
        rpln_par(rpln_num).radl = thick * mtl_par(material).rad_inv
        rpln_par(rpln_num).dedx = thick * mtl_par(material).dedx          
        write(rpln_par(rpln_num).name,5104) i
 5104   format('Chamber',i2,' Fill at rmin ')
        
        num_anode = drf_par(i).num_anode
c     Anodes
        do j=1,drf_par(i).num_anode
          if (rpln_num .ge. rpln_max) goto 9998
          rpln_num = rpln_num + 1
          rpln_par(rpln_num).type = jrpl_drf_anode
          rpln_par(rpln_num).pos(1) = i
          rpln_par(rpln_num).pos(2) = j
          rpln_par(rpln_num).pos(3) = 0
          rpln_par(rpln_num).radius = drf_par(i).an(j).radius
          rpln_par(rpln_num).zmin = drf_par(i).an(j).zmin
          rpln_par(rpln_num).zmax = drf_par(i).an(j).zmax
          rpln_par(rpln_num).col = 0.
          rpln_par(rpln_num).abs = 0.
          rpln_par(rpln_num).radl = 0.
          rpln_par(rpln_num).dedx = 0.
          write(rpln_par(rpln_num).name,5003) i, j
 5003     format('Drift chamber ',i2,' anode layer ',i3)
 
          if (j .lt.  drf_par(i).num_anode) then
           if (rpln_num .ge. rpln_max) goto 9998
           rpln_num = rpln_num + 1
           rpln_par(rpln_num).type = jrpl_material
           rpln_par(rpln_num).pos(1) = i
           rpln_par(rpln_num).pos(2) = j
           rpln_par(rpln_num).pos(3) = 0
c         We have assumed that the first anode wire is at the smallest R
           rpln_par(rpln_num).radius = 0.5 * 
     &            (drf_par(i).an(j).radius + drf_par(i).an(j+1).radius)   
           thick =  drf_par(i).an(j+1).radius - drf_par(i).an(j).radius
           rpln_par(rpln_num).zmin = drf_par(i).zmin
           rpln_par(rpln_num).zmax = drf_par(i).zmax
           material = drf_par(i).material 
           rpln_par(rpln_num).col  = thick * mtl_par(material).coll_inv        
           rpln_par(rpln_num).abs  = thick * mtl_par(material).abs_inv
           rpln_par(rpln_num).radl = thick * mtl_par(material).rad_inv
           rpln_par(rpln_num).dedx = thick * mtl_par(material).dedx          
           write(rpln_par(rpln_num).name,5105) i, j
 5105      format('Chamber',i2,' Fill at layer ', i3)
 	  endif
        enddo
        if (rpln_num .ge. rpln_max) goto 9998
        rpln_num = rpln_num + 1
        rpln_par(rpln_num).type = jrpl_material
        rpln_par(rpln_num).pos(1) = i
        rpln_par(rpln_num).pos(2) = 0
        rpln_par(rpln_num).pos(3) = 0
c       We have assumed that the first anode wire is at the smallest R
        rpln_par(rpln_num).radius = 0.5 * 
     &            (drf_par(i).rmax + drf_par(i).an(num_anode).radius)
        thick = drf_par(i).rmax - drf_par(i).an(num_anode).radius 
        rpln_par(rpln_num).zmin = drf_par(i).zmin
        rpln_par(rpln_num).zmax = drf_par(i).zmax
        material = drf_par(i).material 
        rpln_par(rpln_num).col  = thick*mtl_par(material).coll_inv        
        rpln_par(rpln_num).abs  = thick*mtl_par(material).abs_inv
        rpln_par(rpln_num).radl =  thick * mtl_par(material).rad_inv
        rpln_par(rpln_num).dedx = thick * mtl_par(material).dedx          
        write(rpln_par(rpln_num).name,5106) i
 5106   format('Chamber',i2,' Fill at rmax ')
      enddo
      
 200  continue

      return
      
 9998 write(6,5998) rpln_max, i 
      write(mcp_llpt,5998) rpln_max, i
 5998 format('R plane overflow in GEO_TRKORDER_DRIFT: dev ',i3) 
      return
      end
      
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:23  eugenio
c Initial revision
c
c Revision 1.3  1998/02/13 21:10:56  mcbride
c add collision lengths to scattering planes
c

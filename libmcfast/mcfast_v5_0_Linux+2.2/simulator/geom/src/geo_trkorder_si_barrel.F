      subroutine geo_trkorder_si_barrel

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add the silicon barrels to the list of radial and z planes.
c
c  10/22/97  P. Avery   Creation of routine
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_luns.inc"
#include "zplane.inc"
#include "rplane.inc"
#include "si_barrel.inc"
#include "material.inc"

c     Local variables
      integer i, j, material
      real thick
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (rpln_num .ge. rpln_max) return

c     Silicon barrels
      do i=1,sib_num
        do j=1,sib_par(i).numlyr
          if (rpln_num .ge. rpln_max) goto 9998
          rpln_num = rpln_num + 1
          rpln_par(rpln_num).type = jrpl_sibarrel
          rpln_par(rpln_num).pos(1) = i
          rpln_par(rpln_num).pos(2) = j
          rpln_par(rpln_num).pos(3) = 0
          rpln_par(rpln_num).radius = 0.5
     *       * (sib_par(i).lyr(j).plane(1).delta_min
     *       +  sib_par(i).lyr(j).plane(1).delta_max)
          
          rpln_par(rpln_num).zmin = sib_par(i).lyr(j).plane(1).zmin
          rpln_par(rpln_num).zmax = sib_par(i).lyr(j).plane(1).zmax
          material = sib_par(i).lyr(j).plane(1).material
          thick    = sib_par(i).lyr(j).plane(1).thick
          rpln_par(rpln_num).col  = thick * mtl_par(material).coll_inv        
          rpln_par(rpln_num).abs  = thick * mtl_par(material).abs_inv
          rpln_par(rpln_num).radl = thick * mtl_par(material).rad_inv
          rpln_par(rpln_num).dedx = thick * mtl_par(material).dedx          
          write(rpln_par(rpln_num).name,5002) i, j
 5002     format('Silicon barrel ',i2,' layer ',i3)
        enddo
      enddo


      return
      
 9998 write(6,5998) rpln_max, i, j 
      write(mcp_llpt,5998) rpln_max, i
 5998 format('R plane overflow in GEO_TRKORDER_SI_BARREL: dev ',i3) 
 
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

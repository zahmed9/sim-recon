      subroutine geo_trkorder_muon

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add the muon detectors to the list of radial and z planes.
c
c  10/22/97  P. Avery   Creation of routine
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_luns.inc"
#include "zplane.inc"
#include "rplane.inc"
#include "muon.inc"
#include "material.inc"

c     Local variables
      integer i, material
      real thick
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (rpln_num .ge. rpln_max) goto 200

      do i=1,muon_num
        if (rpln_num .ge. rpln_max) goto 9998
        rpln_num = rpln_num + 1
        rpln_par(rpln_num).type = jrpl_material
        rpln_par(rpln_num).pos(1) = i
        rpln_par(rpln_num).pos(2) = 0
        rpln_par(rpln_num).pos(3) = 0
        rpln_par(rpln_num).radius = 0.5 * (muon_par(i).rmin(1)
     *                                  +  muon_par(i).rmin(2))
        rpln_par(rpln_num).zmin = muon_par(i).zmin
        rpln_par(rpln_num).zmax = muon_par(i).zmax
        rpln_par(rpln_num).col = 0.
        rpln_par(rpln_num).abs = 0.
        rpln_par(rpln_num).radl = 0.
        rpln_par(rpln_num).dedx = 0.
        write(rpln_par(rpln_num).name,5018) i
 5018   format('Muon rmin',i2)

        if (rpln_num .ge. rpln_max) goto 9998
        rpln_num = rpln_num + 1
        rpln_par(rpln_num).type = jrpl_material
        rpln_par(rpln_num).pos(1) = i
        rpln_par(rpln_num).pos(2) = 0
        rpln_par(rpln_num).pos(3) = 0
        rpln_par(rpln_num).radius = 0.5 * (muon_par(i).rmax(1)
     *                                  +  muon_par(i).rmax(2))
        rpln_par(rpln_num).zmin = muon_par(i).zmin
        rpln_par(rpln_num).zmax = muon_par(i).zmax
        rpln_par(rpln_num).col = 0.
        rpln_par(rpln_num).abs = 0.
        rpln_par(rpln_num).radl = 0.
        rpln_par(rpln_num).dedx = 0.
        write(rpln_par(rpln_num).name,5019) i
 5019   format('Muon rmax',i2)
      enddo
      
  200 continue

c     z planes

      if (zpln_num .ge. zpln_max) return

      do i=1,muon_num
        if (muon_par(i).type.eq.1) then
          if (zpln_num .ge. zpln_max) goto 9999
          zpln_num = zpln_num + 1
          zpln_par(zpln_num).type = jzpl_material
          zpln_par(zpln_num).pos(1) = i
          zpln_par(zpln_num).pos(2) = 1
          zpln_par(zpln_num).pos(3) = 0
          zpln_par(zpln_num).z = muon_par(i).zmin
          zpln_par(zpln_num).shape = 1
          zpln_par(zpln_num).rmin = muon_par(i).rmin(1)
          zpln_par(zpln_num).rmax = muon_par(i).rmax(1)
          zpln_par(zpln_num).xmin = -1.e20
          zpln_par(zpln_num).xmax = 1.e20
          zpln_par(zpln_num).ymin = -1.e20
          zpln_par(zpln_num).ymax = 1.e20
          zpln_par(zpln_num).col = 0.
          zpln_par(zpln_num).abs = 0.
          zpln_par(zpln_num).radl = 0.
          zpln_par(zpln_num).dedx = 0.
          write(zpln_par(zpln_num).name,5225) i
 5225     format('muon- CYLN ',i2,' zmin')

          if (zpln_num .ge. zpln_max) goto 9999
          zpln_num = zpln_num + 1
          zpln_par(zpln_num).type = jzpl_material
          zpln_par(zpln_num).pos(1) = i
          zpln_par(zpln_num).pos(2) = 1
          zpln_par(zpln_num).pos(3) = 0
          zpln_par(zpln_num).z = muon_par(i).zmax
          zpln_par(zpln_num).shape = 1
          zpln_par(zpln_num).rmin = muon_par(i).rmin(2)
          zpln_par(zpln_num).rmax = muon_par(i).rmax(2)
          zpln_par(zpln_num).xmin = -1.e20
          zpln_par(zpln_num).xmax = 1.e20
          zpln_par(zpln_num).ymin = -1.e20
          zpln_par(zpln_num).ymax = 1.e20
          zpln_par(zpln_num).col = 0.
          zpln_par(zpln_num).abs = 0.
          zpln_par(zpln_num).radl = 0.
          zpln_par(zpln_num).dedx = 0.
          write(zpln_par(zpln_num).name,5226) i
 5226     format('muon - CYLN ',i2,' zmax')
        else
          if (zpln_num .ge. zpln_max) goto 9999
          zpln_num = zpln_num + 1
          zpln_par(zpln_num).type = jzpl_material
          zpln_par(zpln_num).pos(1) = i
          zpln_par(zpln_num).pos(2) = 1
          zpln_par(zpln_num).pos(3) = 0
          zpln_par(zpln_num).z=(muon_par(i).zmin+muon_par(i).zmax)/2.0
          zpln_par(zpln_num).shape = 1
          zpln_par(zpln_num).rmin = (muon_par(i).rmin(1) + 
     & muon_par(i).rmin(2))/2.0
          zpln_par(zpln_num).rmax = (muon_par(i).rmax(1) +
     & muon_par(i).rmax(2))/2.0
          zpln_par(zpln_num).xmin = -1.e20
          zpln_par(zpln_num).xmax = 1.e20
          zpln_par(zpln_num).ymin = -1.e20
          zpln_par(zpln_num).ymax = 1.e20
          zpln_par(zpln_num).col = 0.
          zpln_par(zpln_num).abs = 0.
          thick = abs(muon_par(i).zmax - muon_par(i).zmin)
          material = muon_par(i).material
          zpln_par(zpln_num).radl = thick * mtl_par(material).rad_inv
          zpln_par(zpln_num).dedx = thick * mtl_par(material).dedx
          write(zpln_par(zpln_num).name,5227) i
 5227     format('muon - CONE ',i2,' z-midpoint')
        end if
      end do

      return
            
 9998 write(6,5998) rpln_max, i 
      write(mcp_llpt,5998) rpln_max, i
 5998 format('R plane overflow in GEO_TRKORDER_MUON: dev ',i3) 
 
      return
      
 9999 write(6,5999) zpln_max, i
      write(mcp_llpt,5999) zpln_max, i
 5999 format('Z plane overflow in GEO_TRKORDER_MUON: dev ',i3)
 
      return
      end

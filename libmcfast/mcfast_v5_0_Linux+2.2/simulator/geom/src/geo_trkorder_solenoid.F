      subroutine geo_trkorder_solenoid

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add solenoid information to the list of radial and z planes.
c
c  10/22/97  P. Avery   Creation of routine
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_luns.inc"
#include "zplane.inc"
#include "rplane.inc"
#include "solenoid.inc"

c     Local variables
      integer i
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (rpln_num .ge. rpln_max) goto 200

c     Loop over solenoid magnets
      do i=1,sol_num
        if (rpln_num .ge. rpln_max) goto 9998
        rpln_num = rpln_num + 1
        rpln_par(rpln_num).type = jrpl_magnet
        rpln_par(rpln_num).pos(1) = i
        rpln_par(rpln_num).pos(2) = 0
        rpln_par(rpln_num).pos(3) = 0
        rpln_par(rpln_num).radius = sol_par(i).rmax
        rpln_par(rpln_num).zmin = sol_par(i).zmin
        rpln_par(rpln_num).zmax = sol_par(i).zmax
        rpln_par(rpln_num).col = 0.
        rpln_par(rpln_num).abs = 0.
        rpln_par(rpln_num).radl = 0.
        rpln_par(rpln_num).dedx = 0.
        write(rpln_par(rpln_num).name,5001) i
 5001   format('Solenoid magnet ',i1)
      enddo
      
  200 continue

c     z planes

      if (zpln_num .ge. zpln_max) return

      do i=1,sol_num
        if (zpln_num .ge. zpln_max) goto 9999
        zpln_num = zpln_num + 1
        zpln_par(zpln_num).type = jzpl_magnet
        zpln_par(zpln_num).pos(1) = i
        zpln_par(zpln_num).pos(2) = 1
        zpln_par(zpln_num).pos(3) = 0
        zpln_par(zpln_num).z = sol_par(i).zmin
        zpln_par(zpln_num).shape = 1
        zpln_par(zpln_num).rmin = sol_par(i).rmin
        zpln_par(zpln_num).rmax = sol_par(i).rmax
        zpln_par(zpln_num).xmin = -1.e20
        zpln_par(zpln_num).xmax =  1.e20
        zpln_par(zpln_num).ymin = -1.e20
        zpln_par(zpln_num).ymax =  1.e20
        zpln_par(zpln_num).col = 0.
        zpln_par(zpln_num).abs = 0.
        zpln_par(zpln_num).radl = 0.
        zpln_par(zpln_num).dedx = 0.
        write(zpln_par(zpln_num).name,5206) i
 5206   format('solenoid ',i1,' zmin ')

        if (zpln_num .ge. zpln_max) goto 9999
        zpln_num = zpln_num + 1
        zpln_par(zpln_num).type = jzpl_magnet
        zpln_par(zpln_num).pos(1) = i
        zpln_par(zpln_num).pos(2) = 3
        zpln_par(zpln_num).pos(3) = 0
        zpln_par(zpln_num).z = sol_par(i).zmax
        zpln_par(zpln_num).shape = 1
        zpln_par(zpln_num).rmin = sol_par(i).rmin
        zpln_par(zpln_num).rmax = sol_par(i).rmax
        zpln_par(zpln_num).xmin = -1.e20
        zpln_par(zpln_num).xmax =  1.e20
        zpln_par(zpln_num).ymin = -1.e20
        zpln_par(zpln_num).ymax =  1.e20
        zpln_par(zpln_num).col = 0.
        zpln_par(zpln_num).abs = 0.
        zpln_par(zpln_num).radl = 0.
        zpln_par(zpln_num).dedx = 0.
        write(zpln_par(zpln_num).name,5207) i
 5207   format('solenoid ',i1,' zmax ')
      enddo

      return
            
 9998 write(6,5998) rpln_max, i 
      write(mcp_llpt,5998) rpln_max, i
 5998 format('R plane overflow in GEO_TRKORDER_SOLENOID: dev ',i3) 
 
      return
      
 9999 write(6,5999) zpln_max, i
      write(mcp_llpt,5999) zpln_max, i
 5999 format('Z plane overflow in GEO_TRKORDER_SOLENOID: dev ',i3)
 
      return
      end

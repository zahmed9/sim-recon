      subroutine geo_trkorder_absorber

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add absorber information to the list of radial and z planes.
c
c  10/22/97  P. Avery   Creation of routine
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none
      
#include "mcp_luns.inc"
#include "zplane.inc"
#include "rplane.inc"
#include "absorber.inc"
#include "material.inc"

c     Local variables
      integer i, j, material
      real thick
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (rpln_num .ge. rpln_max) goto 200

      do i=1,absorber_num
       if (absorber_par(i).type .eq. 41) then
c     This is Central Absorber of type 'scatter';
c     all others ignored
        if (rpln_num .ge. rpln_max) goto 9998
        rpln_num = rpln_num + 1
        rpln_par(rpln_num).type = jrpl_material
        rpln_par(rpln_num).pos(1) = i
        rpln_par(rpln_num).pos(2) = 0
        rpln_par(rpln_num).pos(3) = 0
        rpln_par(rpln_num).radius = 0.5 * (absorber_par(i).rmin(1)
     *                                  +  absorber_par(i).rmin(2))
        rpln_par(rpln_num).zmin = absorber_par(i).zmin
        rpln_par(rpln_num).zmax = absorber_par(i).zmax
        rpln_par(rpln_num).col = 0.
        rpln_par(rpln_num).abs = 0.
        material = absorber_par(i).material
        thick    = 0.25 * abs((absorber_par(i).rmax(1) 
     &           +  absorber_par(i).rmax(2)) 
     &           - (absorber_par(i).rmin(1) 
     &           +  absorber_par(i).rmin(2))) 
        rpln_par(rpln_num).col = thick * mtl_par(material).coll_inv
        rpln_par(rpln_num).abs = thick * mtl_par(material).abs_inv
        rpln_par(rpln_num).radl =  thick * mtl_par(material).rad_inv
        rpln_par(rpln_num).dedx =  thick * mtl_par(material).dedx 
        write(rpln_par(rpln_num).name,5016) i
 5016   format('Absorber rmin',i2)

        if (rpln_num .ge. rpln_max) goto 9998
        rpln_num = rpln_num + 1
        rpln_par(rpln_num).type = jrpl_material
        rpln_par(rpln_num).pos(1) = i
        rpln_par(rpln_num).pos(2) = 0
        rpln_par(rpln_num).pos(3) = 0
        rpln_par(rpln_num).radius = 0.5 * (absorber_par(i).rmax(1)
     *                                  +  absorber_par(i).rmax(2))
        rpln_par(rpln_num).zmin = absorber_par(i).zmin
        rpln_par(rpln_num).zmax = absorber_par(i).zmax
        rpln_par(rpln_num).col = 0.
        rpln_par(rpln_num).abs = 0.
c
c	Same thing for outer surface of this thin absorber. 
c	(if not thin, the multiple scattering is estimated at the wrong 
c	surface.)
c
        rpln_par(rpln_num).radl = thick * mtl_par(material).rad_inv
        rpln_par(rpln_num).dedx = thick * mtl_par(material).dedx 
        write(rpln_par(rpln_num).name,5017) i
 5017   format('Absorber rmax',i2)
       end if
      enddo
      
  200 continue

c     z planes

      if (zpln_num .ge. zpln_max) return

      do i=1,absorber_num
        if (absorber_par(i).type.eq.42) then
c     Forward Absorber of type 'scatter'
          if (zpln_num .ge. zpln_max) goto 9999
          zpln_num = zpln_num + 1
          zpln_par(zpln_num).type = jzpl_material
          zpln_par(zpln_num).pos(1) = i
          zpln_par(zpln_num).pos(2) = 1
          zpln_par(zpln_num).pos(3) = 0
          zpln_par(zpln_num).z = absorber_par(i).zmin
          if (absorber_par(i).shape .eq. 'BOX') then
	   do j = 1,2
	     if ((absorber_par(i).xlimit_gap(j) .ne. 0.0) .or. 
     &           (absorber_par(i).ylimit_gap(j) .ne. 0.0)) then
    	          zpln_par(zpln_num).shape = 100 + jzpl_material   ! there is a gap
	     else
                  zpln_par(zpln_num).shape = 2
	     end if
           enddo
           zpln_par(zpln_num).rmin = 0.
           zpln_par(zpln_num).rmax = 1.e20
           zpln_par(zpln_num).xmin = absorber_par(i).xlimit(1)
           zpln_par(zpln_num).xmax = absorber_par(i).xlimit(2)
           zpln_par(zpln_num).ymin = absorber_par(i).ylimit(1)
           zpln_par(zpln_num).ymax = absorber_par(i).ylimit(2)
          else
           zpln_par(zpln_num).shape = 1
           zpln_par(zpln_num).rmin = absorber_par(i).rmin(1)
           zpln_par(zpln_num).rmax = absorber_par(i).rmax(1)
           zpln_par(zpln_num).xmin = -1.e20
           zpln_par(zpln_num).xmax = 1.e20
           zpln_par(zpln_num).ymin = -1.e20
           zpln_par(zpln_num).ymax = 1.e20
          end if
          thick = 0.5*abs(absorber_par(i).zmax - absorber_par(i).zmin)
          material = absorber_par(i).material
          zpln_par(zpln_num).col  = thick * mtl_par(material).coll_inv
          zpln_par(zpln_num).abs  = thick * mtl_par(material).abs_inv
          zpln_par(zpln_num).radl = thick * mtl_par(material).rad_inv
          zpln_par(zpln_num).dedx = thick * mtl_par(material).dedx
          write(zpln_par(zpln_num).name,5222) i
 5222     format('Absorber ',i2,' zmin')

          if (zpln_num .ge. zpln_max) goto 9999
          zpln_num = zpln_num + 1
          zpln_par(zpln_num).type = jzpl_material
          zpln_par(zpln_num).pos(1) = i
          zpln_par(zpln_num).pos(2) = 1
          zpln_par(zpln_num).pos(3) = 0
          zpln_par(zpln_num).z = absorber_par(i).zmax
          if (absorber_par(i).shape .eq. 'BOX') then
	   do j = 1,2
	     if ((absorber_par(i).xlimit_gap(j) .ne. 0.0) .or. 
     +           (absorber_par(i).ylimit_gap(j) .ne. 0.0)) then
    	          zpln_par(zpln_num).shape = 100 + jzpl_material   ! there is a gap
	     else
                  zpln_par(zpln_num).shape = 2
	     end if
           enddo
           zpln_par(zpln_num).rmin = 0.
           zpln_par(zpln_num).rmax = 1.e20
           zpln_par(zpln_num).xmin = absorber_par(i).xlimit(1)
           zpln_par(zpln_num).xmax = absorber_par(i).xlimit(2)
           zpln_par(zpln_num).ymin = absorber_par(i).ylimit(1)
           zpln_par(zpln_num).ymax = absorber_par(i).ylimit(2)
          else
           zpln_par(zpln_num).shape = 1
           zpln_par(zpln_num).rmin = absorber_par(i).rmin(2)
           zpln_par(zpln_num).rmax = absorber_par(i).rmax(2)
           zpln_par(zpln_num).xmin = -1.e20
           zpln_par(zpln_num).xmax = 1.e20
           zpln_par(zpln_num).ymin = -1.e20
           zpln_par(zpln_num).ymax = 1.e20
          end if
          zpln_par(zpln_num).col  = thick * mtl_par(material).coll_inv
          zpln_par(zpln_num).abs  = thick * mtl_par(material).abs_inv
          zpln_par(zpln_num).radl = thick * mtl_par(material).rad_inv
          zpln_par(zpln_num).dedx = thick * mtl_par(material).dedx
          write(zpln_par(zpln_num).name,5223) i
 5223     format('Absorber ',i2,' zmax')
        end if
      end do

      return
            
 9998 write(6,5998) rpln_max, i 
      write(mcp_llpt,5998) rpln_max, i
 5998 format('R plane overflow in GEO_TRKORDER_ABSORBER: dev ',i3) 
 
      return
      
 9999 write(6,5999) zpln_max, i
      write(mcp_llpt,5999) zpln_max, i
 5999 format('Z plane overflow in GEO_TRKORDER_ABSORBER: dev ',i3)
 
      return
      end
      
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:23  eugenio
c Initial revision
c
c Revision 1.5  1999/03/24 02:08:36  mcbride
c add gaps to zplanes
c
c Revision 1.4  1998/02/13  23:22:33  mcbride
c fix collision length for z absorbers
c
c Revision 1.3  1998/02/13  21:10:56  mcbride
c add collision lengths to scattering planes
c

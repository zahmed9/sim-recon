      subroutine geo_trkorder_fordisk

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add the forward silicon disks to the list of radial and z planes.
c
c  10/22/97  P. Avery   Creation of routine
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_luns.inc"
#include "zplane.inc"
#include "rplane.inc"
#include "fordisk.inc"
#include "material.inc"

c     Local variables
      integer i, ilyr, k, material, nlyr
      real thick, z1, zold, znext
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (zpln_num .ge. zpln_max) return

      do i=1,fordisk_num
        if (zpln_num .ge. zpln_max) goto 9999
        zpln_num = zpln_num + 1
        zpln_par(zpln_num).type = jzpl_material
        zpln_par(zpln_num).pos(1) = i
        zpln_par(zpln_num).pos(2) = 0
        zpln_par(zpln_num).pos(3) = 0
        thick = fordisk_par(i).thick_boun(3)
        zpln_par(zpln_num).z = fordisk_par(i).zmin - thick/2.0
        zpln_par(zpln_num).shape = 1
        zpln_par(zpln_num).rmin = fordisk_par(i).rmin
        zpln_par(zpln_num).rmax = fordisk_par(i).rmax
        zpln_par(zpln_num).xmin = -1.e20
        zpln_par(zpln_num).xmax = 1.e20
        zpln_par(zpln_num).ymin = -1.e20
        zpln_par(zpln_num).ymax = 1.e20
        material = fordisk_par(i).mat_boun(3)
        zpln_par(zpln_num).col  = thick * mtl_par(material).coll_inv        
        zpln_par(zpln_num).abs  = thick * mtl_par(material).abs_inv
        zpln_par(zpln_num).radl = thick * mtl_par(material).rad_inv
        zpln_par(zpln_num).dedx = thick * mtl_par(material).dedx
        write(zpln_par(zpln_num).name,5212) i
 5212   format('forward disk ',i3,' z-boundary-zmin ')
 
        thick = fordisk_par(i).lyr(1).slice(1).z - fordisk_par(i).zmin
        z1 = fordisk_par(i).zmin
        if (thick .lt. 0.0) then
          thick = fordisk_par(i).lyr(1).slice(1).z - fordisk_par(i).zmax
          z1 = fordisk_par(i).zmax
          if (thick .lt. 0.) then
           write (6,6000) i
 6000      format('geo_trkorder:  error in fordisk ',i3,' z info')
          endif       
        endif
        if (zpln_num .ge. zpln_max) goto 9999
        zpln_num = zpln_num + 1
        zpln_par(zpln_num).type = jzpl_material
        zpln_par(zpln_num).pos(1) = i
        zpln_par(zpln_num).pos(2) = 0
        zpln_par(zpln_num).pos(3) = 0
        zpln_par(zpln_num).z = (z1 + fordisk_par(i).lyr(1).slice(1).z)/2.
        zpln_par(zpln_num).shape = 1
        zpln_par(zpln_num).rmin =  fordisk_par(i).rmin
        zpln_par(zpln_num).rmax =  fordisk_par(i).rmax
        zpln_par(zpln_num).xmin = -1.e20
        zpln_par(zpln_num).xmax =  1.e20
        zpln_par(zpln_num).ymin = -1.e20
        zpln_par(zpln_num).ymax =  1.e20
        material = fordisk_par(i).material
        zpln_par(zpln_num).col  = thick * mtl_par(material).coll_inv        
        zpln_par(zpln_num).abs  = thick * mtl_par(material).abs_inv
        zpln_par(zpln_num).radl = thick * mtl_par(material).rad_inv
        zpln_par(zpln_num).dedx = thick * mtl_par(material).dedx
        write(zpln_par(zpln_num).name,5213) i
 5213   format('forward disk ',i3,' fill before first plane ')
 
        do ilyr=1,fordisk_par(i).numlyr
          zold = 999999.
          do k=1,fordisk_par(i).lyr(ilyr).numslice
            if (fordisk_par(i).lyr(ilyr).slice(k).z.ne.zold) then
              zold = fordisk_par(i).lyr(ilyr).slice(k).z
              if (zpln_num .ge. zpln_max) goto 9999
              zpln_num = zpln_num + 1
              zpln_par(zpln_num).type = jzpl_sidisk
              zpln_par(zpln_num).pos(1) = i
              zpln_par(zpln_num).pos(2) = ilyr
              zpln_par(zpln_num).pos(3) = k
              zpln_par(zpln_num).z = fordisk_par(i).lyr(ilyr).slice(k).z
              zpln_par(zpln_num).shape = 1
              zpln_par(zpln_num).rmin = 
     &              fordisk_par(i).lyr(ilyr).slice(k).rmin
              zpln_par(zpln_num).rmax = 
     &              fordisk_par(i).lyr(ilyr).slice(k).rmax
              zpln_par(zpln_num).xmin = -1.e20
              zpln_par(zpln_num).xmax = 1.e20
              zpln_par(zpln_num).ymin = -1.e20
              zpln_par(zpln_num).ymax = 1.e20
              zpln_par(zpln_num).col = 0.
              zpln_par(zpln_num).abs = 0.
              zpln_par(zpln_num).radl = 0.
              zpln_par(zpln_num).dedx = 0.
              write(zpln_par(zpln_num).name,5214) i, ilyr
 5214         format('forward disk ',i3,'layer ',i3)
            endif
          enddo
          if (zpln_num .ge. zpln_max) goto 9999
          zpln_num = zpln_num + 1
          zpln_par(zpln_num).type = jzpl_material
          zpln_par(zpln_num).pos(1) = i
          zpln_par(zpln_num).pos(2) = ilyr
          zpln_par(zpln_num).pos(3) = 0
          if (ilyr.ne.fordisk_par(i).numlyr) then
            znext = fordisk_par(i).lyr(ilyr+1).slice(1).z
          else
            nlyr = fordisk_par(i).numlyr
            if(fordisk_par(i).zmax - 
     &         fordisk_par(i).lyr(nlyr).slice(1).z .ge. 0.)then
               znext =  fordisk_par(i).zmax
            else 
               znext =  fordisk_par(i).zmin
            endif
          end if
          zpln_par(zpln_num).z = 
     &        (fordisk_par(i).lyr(ilyr).slice(1).z + znext)/2.0
          zpln_par(zpln_num).shape = 1
          zpln_par(zpln_num).rmin = fordisk_par(i).rmin
          zpln_par(zpln_num).rmax = fordisk_par(i).rmax
          zpln_par(zpln_num).xmin = -1.e20
          zpln_par(zpln_num).xmax = 1.e20
          zpln_par(zpln_num).ymin = -1.e20
          zpln_par(zpln_num).ymax = 1.e20
          zpln_par(zpln_num).col = 0.
          zpln_par(zpln_num).abs = 0.
          material = fordisk_par(i).material
          thick = abs(fordisk_par(i).lyr(ilyr).slice(1).z - znext)
          zpln_par(zpln_num).col  = thick * mtl_par(material).coll_inv        
          zpln_par(zpln_num).abs  = thick * mtl_par(material).abs_inv
          zpln_par(zpln_num).radl = thick * mtl_par(material).rad_inv
          zpln_par(zpln_num).dedx = thick * mtl_par(material).dedx
          write(zpln_par(zpln_num).name,5215) i, ilyr
 5215     format('forward disk material',i3,' layer ',i3)
        end do
                
        if (zpln_num .ge. zpln_max) goto 9999
        zpln_num = zpln_num + 1
        zpln_par(zpln_num).type = jzpl_material
        zpln_par(zpln_num).pos(1) = i
        zpln_par(zpln_num).pos(2) = 0
        zpln_par(zpln_num).pos(3) = 0
        thick = fordisk_par(i).thick_boun(4)
        zpln_par(zpln_num).z = fordisk_par(i).zmax + thick/2.0
        zpln_par(zpln_num).shape = 1
        zpln_par(zpln_num).rmin = fordisk_par(i).rmin
        zpln_par(zpln_num).rmax = fordisk_par(i).rmax
        zpln_par(zpln_num).xmin =  -1.e20
        zpln_par(zpln_num).xmax =  1.e20
        zpln_par(zpln_num).ymin =  -1.e20
        zpln_par(zpln_num).ymax =  1.e20
        material = fordisk_par(i).mat_boun(4)
        zpln_par(zpln_num).col  = thick*mtl_par(material).coll_inv        
        zpln_par(zpln_num).abs  = thick*mtl_par(material).abs_inv
        zpln_par(zpln_num).radl = thick * mtl_par(material).rad_inv
        zpln_par(zpln_num).dedx = thick * mtl_par(material).dedx
        write(zpln_par(zpln_num).name,5216) i
 5216   format('forward disk ',i3,' z-boundary zmax')
      end do
      
      return
      
 9999 write(6,5999) zpln_max, i
      write(mcp_llpt,5999) zpln_max, i
 5999 format('Z plane overflow in GEO_TRKORDER_FORDISK: dev ',i3)
 
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

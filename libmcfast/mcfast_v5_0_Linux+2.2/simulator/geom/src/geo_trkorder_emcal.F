      subroutine geo_trkorder_emcal

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add the EM calorimeters to the list of radial and z planes.
c
c  10/22/97  P. Avery   Creation of routine
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_luns.inc"
#include "zplane.inc"
#include "rplane.inc"
#include "emcal.inc"

c     Local variables
      integer i, j, material
      real thick
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


      if (rpln_num .ge. rpln_max) goto 200

      do i=1,emcal_num       
       if (emcal_par(i).shape .ne. 'BOX') then
c     Central tracing is NOT possible for BOX-shaped calorimeters
        if (rpln_num .ge. rpln_max) goto 9998
        rpln_num = rpln_num + 1
        rpln_par(rpln_num).type = jrpl_emcal
        rpln_par(rpln_num).pos(1) = i
        rpln_par(rpln_num).pos(2) = 0
        rpln_par(rpln_num).pos(3) = 0
        rpln_par(rpln_num).radius = min(emcal_par(i).rmin(1),
     *                                  emcal_par(i).rmin(2))
        rpln_par(rpln_num).zmin = emcal_par(i).zmin
        rpln_par(rpln_num).zmax = emcal_par(i).zmax
        rpln_par(rpln_num).col = 0.
        rpln_par(rpln_num).abs = 0.
c
c    DEDX and RADL have been set to 0. as a warning since 
c    this method does not handle volumes properly
c
        rpln_par(rpln_num).radl = 0.
        rpln_par(rpln_num).dedx = 0.
        write(rpln_par(rpln_num).name,5118) i
 5118   format('Emcal rmin',i2)
       end if
      enddo

  200 continue
  
c     z planes

      if (zpln_num .ge. zpln_max) return

      do i=1,emcal_num
        if (mod(emcal_par(i).type,100) .eq. 1) then
          if (zpln_num .ge. zpln_max) goto 9999
          zpln_num = zpln_num + 1
          zpln_par(zpln_num).type = jzpl_emcal
          zpln_par(zpln_num).pos(1) = i
          zpln_par(zpln_num).pos(2) = 1
          zpln_par(zpln_num).pos(3) = 0
          zpln_par(zpln_num).z = emcal_par(i).zmin
          if (emcal_par(i).shape .eq. 'BOX') then
           zpln_par(zpln_num).shape = 2
           zpln_par(zpln_num).rmin = 0.
           zpln_par(zpln_num).rmax = 1.e20
           zpln_par(zpln_num).xmin = emcal_par(i).xlimit(1)
           zpln_par(zpln_num).xmax = emcal_par(i).xlimit(2)
           zpln_par(zpln_num).ymin = emcal_par(i).ylimit(1)
           zpln_par(zpln_num).ymax = emcal_par(i).ylimit(2)
          else
           zpln_par(zpln_num).shape = 1
           zpln_par(zpln_num).rmin = emcal_par(i).rmin(1)
           zpln_par(zpln_num).rmax = emcal_par(i).rmax(1)
           zpln_par(zpln_num).xmin = -1.e20
           zpln_par(zpln_num).xmax = 1.e20
           zpln_par(zpln_num).ymin = -1.e20
           zpln_par(zpln_num).ymax = 1.e20
          end if
          zpln_par(zpln_num).col = 0.
          zpln_par(zpln_num).abs = 0.
c
c    DEDX and RADL have been set to 0. as a warning since 
c    this method does not handle volumes properly
c
          zpln_par(zpln_num).radl = 0.
          zpln_par(zpln_num).dedx = 0.
          if(emcal_par(i).type .lt. 100) then
            write(zpln_par(zpln_num).name,5228) i
 5228       format('emcal  ',i2,' zmin')
          else
            write(zpln_par(zpln_num).name,6228) i
 6228       format('absorber  ',i2,' zmin')
          endif

          if (zpln_num .ge. zpln_max) goto 9999
          zpln_num = zpln_num + 1
          zpln_par(zpln_num).type = jzpl_emcal
          zpln_par(zpln_num).pos(1) = i
          zpln_par(zpln_num).pos(2) = 1
          zpln_par(zpln_num).pos(3) = 0
          zpln_par(zpln_num).z = emcal_par(i).zmax
          if (emcal_par(i).shape .eq. 'BOX') then
           zpln_par(zpln_num).shape = 2
           zpln_par(zpln_num).rmin = 0.
           zpln_par(zpln_num).rmax = 1.e20
           zpln_par(zpln_num).xmin = emcal_par(i).xlimit(1)
           zpln_par(zpln_num).xmax = emcal_par(i).xlimit(2)
           zpln_par(zpln_num).ymin = emcal_par(i).ylimit(1)
           zpln_par(zpln_num).ymax = emcal_par(i).ylimit(2)
          else
           zpln_par(zpln_num).shape = 1
           zpln_par(zpln_num).rmin = emcal_par(i).rmin(2)
           zpln_par(zpln_num).rmax = emcal_par(i).rmax(2)
           zpln_par(zpln_num).xmin = -1.e20
           zpln_par(zpln_num).xmax = 1.e20
           zpln_par(zpln_num).ymin = -1.e20
           zpln_par(zpln_num).ymax = 1.e20
          end if
          zpln_par(zpln_num).col = 0.
          zpln_par(zpln_num).abs = 0.
c
c    DEDX and RADL have been set to 0. as a warning since 
c    this method does not handle volumes properly
c
          zpln_par(zpln_num).radl = 0.
          zpln_par(zpln_num).dedx = 0.
          if(emcal_par(i).type .lt. 100) then
            write(zpln_par(zpln_num).name,5229) i
 5229       format('emcal  ',i2,' zmax')
          else
            write(zpln_par(zpln_num).name,6229) i
 6229       format('absorber  ',i2,' zmax')
          endif
        else
          if (zpln_num .ge. zpln_max) goto 9999
          zpln_num = zpln_num + 1
          zpln_par(zpln_num).type = jzpl_emcal
          zpln_par(zpln_num).pos(1) = i
          zpln_par(zpln_num).pos(2) = 1
          zpln_par(zpln_num).pos(3) = 0
          if (emcal_par(i).zmin .ge. 0. .and.
     *        emcal_par(i).zmax .ge. 0.) then
           zpln_par(zpln_num).z = emcal_par(i).zmin
          else
           zpln_par(zpln_num).z = emcal_par(i).zmax
          end if
          if (emcal_par(i).shape .eq. 'BOX') then
           zpln_par(zpln_num).shape = 2
           zpln_par(zpln_num).rmin = 0.
           zpln_par(zpln_num).rmax = 1.e20
           zpln_par(zpln_num).xmin = emcal_par(i).xlimit(1)
           zpln_par(zpln_num).xmax = emcal_par(i).xlimit(2)
           zpln_par(zpln_num).ymin = emcal_par(i).ylimit(1)
           zpln_par(zpln_num).ymax = emcal_par(i).ylimit(2)
          else
           zpln_par(zpln_num).shape = 1
           zpln_par(zpln_num).rmin = min(emcal_par(i).rmin(1),
     &                                   emcal_par(i).rmin(2))
           zpln_par(zpln_num).rmax = min(emcal_par(i).rmax(1), 
     &                                   emcal_par(i).rmax(2))
           zpln_par(zpln_num).xmin = -1.e20
           zpln_par(zpln_num).xmax = 1.e20
           zpln_par(zpln_num).ymin = -1.e20
           zpln_par(zpln_num).ymax = 1.e20
          end if
          zpln_par(zpln_num).col = 0.
          zpln_par(zpln_num).abs = 0.
c
c    DEDX and RADL have been set to 0. since 
c    we have NO FINAL idea how to handle volumes
c
          zpln_par(zpln_num).radl = 0.
          zpln_par(zpln_num).dedx = 0.
          if(emcal_par(i).type .lt. 100) then
            write(zpln_par(zpln_num).name,5229) i
 5230       format('emcal ',i2,' min z')
          else
            write(zpln_par(zpln_num).name,6229) i
 6230       format('absorber  ',i2,' min z')
          endif
        end if
      end do

      return
            
 9998 write(6,5998) rpln_max, i 
      write(mcp_llpt,5998) rpln_max, i
 5998 format('R plane overflow in GEO_TRKORDER_EMCAL: dev ',i3) 
 
      return
      
 9999 write(6,5999) zpln_max, i
      write(mcp_llpt,5999) zpln_max, i
 5999 format('Z plane overflow in GEO_TRKORDER_EMCAL: dev ',i3)
 
      return
      end

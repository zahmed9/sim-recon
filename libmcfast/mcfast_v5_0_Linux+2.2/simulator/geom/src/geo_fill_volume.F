c
      subroutine geo_fill_volume
c
      implicit none
c
#include "mcp_luns.inc"
c
#include "volume.inc"
c
#include "volxy.inc"
c
#include "beampipe.inc"
c
#include "dipole.inc"
c
#include "solenoid.inc"
c
#include "drift.inc"
c
#include "for_trk.inc"
c
#include "material.inc"
c
      integer i, i_vol, i_count, j, m, id_mat, max_an
c
      i_vol = 0
c
c     fill volume structure for beampipe  (allow 1 for now)
c
      do i = 1, beampipe_num
       if (beampipe_par(i).rmax .gt. 0. 
     >    .and. beampipe_par(i).zmin .lt. beampipe_par(i).zmax) then
        i_vol = i_vol + 1
c
        vol_par(i_vol).rmin = beampipe_par(i).rmin
        vol_par(i_vol).rmax = beampipe_par(i).rmax
        vol_par(i_vol).zmin = beampipe_par(i).zmin
        vol_par(i_vol).zmax = beampipe_par(i).zmax
        vol_par(i_vol).thick_rmin = beampipe_par(i).thick_boun(1)
        vol_par(i_vol).thick_rmax = beampipe_par(i).thick_boun(2)
        vol_par(i_vol).thick_zmin = beampipe_par(i).thick_boun(3)
        vol_par(i_vol).thick_zmax = beampipe_par(i).thick_boun(4)
c
        vol_par(i_vol).mat_fill = beampipe_par(i).material
c
        vol_par(i_vol).mat_rmin = beampipe_par(i).mat_boun(1)
        vol_par(i_vol).mat_rmax = beampipe_par(i).mat_boun(2)
        vol_par(i_vol).mat_zmin = beampipe_par(i).mat_boun(3)
        vol_par(i_vol).mat_zmax = beampipe_par(i).mat_boun(4)
c
        vol_par(i_vol).name    = 'beampipe'
       endif 
      enddo 
c
c
c
      if (sol_num .gt. 0) then
c
c     fill volume structure for solenoid
c
      do i = 1,sol_num
       i_vol = i_vol + 1
       vol_par(i_vol).rmin = sol_par(i).rmin
       vol_par(i_vol).rmax = sol_par(i).rmax
       vol_par(i_vol).zmin = sol_par(i).zmin
       vol_par(i_vol).zmax = sol_par(i).zmax
c
       vol_par(i_vol).mat_fill = sol_par(i).mat_fill
c
       vol_par(i_vol).mat_rmin = sol_par(i).mat_boun(1)
       vol_par(i_vol).mat_rmax = sol_par(i).mat_boun(2)
       vol_par(i_vol).mat_zmin = sol_par(i).mat_boun(3)
       vol_par(i_vol).mat_zmax = sol_par(i).mat_boun(4)
c
       vol_par(i_vol).name = 'solenoid'
c
      end do
      end if
c
c
      if (drf_num .gt. 0) then
c
c     fill volume structure for drift chambers
c
      do i = 1,drf_num
       i_vol = i_vol + 1
       vol_par(i_vol).rmin = drf_par(i).rmin
       max_an = drf_par(i).num_anode
       vol_par(i_vol).rmax = drf_par(i).rmax
       vol_par(i_vol).zmin = drf_par(i).zmin
       vol_par(i_vol).zmax = drf_par(i).zmax
       vol_par(i_vol).mat_fill = drf_par(i).material
c
       vol_par(i_vol).thick_rmin = drf_par(i).thick_boun(1)
       vol_par(i_vol).thick_rmax = drf_par(i).thick_boun(2)
       vol_par(i_vol).thick_zmin = drf_par(i).thick_boun(3)
       vol_par(i_vol).thick_zmax = drf_par(i).thick_boun(4)
c
       vol_par(i_vol).mat_rmin = drf_par(i).mat_boun(1)
       vol_par(i_vol).mat_rmax = drf_par(i).mat_boun(2)
       vol_par(i_vol).mat_zmin = drf_par(i).mat_boun(3)
       vol_par(i_vol).mat_zmax = drf_par(i).mat_boun(4)
c
       vol_par(i_vol).name = 'drift_chamber'
      enddo
      endif 
c
      vol_num = i_vol
      
      i_vol= 0

      if (dip_num .gt. 0) then
c
c     fill volume structure for dipole
c
      do i = 1,dip_num
       i_vol = i_vol + 1
       volxy_par(i_vol).xmin = dip_par(i).xmin
       volxy_par(i_vol).xmax = dip_par(i).xmax
       volxy_par(i_vol).ymin = dip_par(i).ymin
       volxy_par(i_vol).ymax = dip_par(i).ymax
       volxy_par(i_vol).zmin = dip_par(i).zmin
       volxy_par(i_vol).zmax = dip_par(i).zmax
c       
       volxy_par(i_vol).mat_fill = dip_par(i).mat_fill
c
       do j = 1, 6
         volxy_par(i_vol).thick_boun(j) = dip_par(i).thick_boun(j)
         volxy_par(i_vol).mat_boun(j)   = dip_par(i).mat_boun(j)
       enddo   
c
       volxy_par(i_vol).name = 'dipole'
      end do
      end if
c
      if (ftrk_num .gt. 0) then
c
c     fill volume structure for drift chambers
c
      do i = 1,ftrk_num
       i_vol = i_vol + 1
       volxy_par(i_vol).xmin = ftrk_par(i).xmin
       volxy_par(i_vol).xmax = ftrk_par(i).xmax
       volxy_par(i_vol).ymin = ftrk_par(i).ymin
       volxy_par(i_vol).ymax = ftrk_par(i).ymax
       volxy_par(i_vol).zmin = ftrk_par(i).zmin
       volxy_par(i_vol).zmax = ftrk_par(i).zmax
       volxy_par(i_vol).mat_fill = ftrk_par(i).material
c
       do j= 1, 6
         volxy_par(i_vol).thick_boun(j) = ftrk_par(i).thick_boun(j)
         volxy_par(i_vol).mat_boun(j) = ftrk_par(i).mat_boun(j)
       enddo   
c
       volxy_par(i_vol).name = 'forward_chamber'
c
      end do
      end if
c
      volxy_num = i_vol
c
      do i=1, volxy_num
      write(6,*) (volxy_par(i).thick_boun(j),j=1,6)
      enddo
c      
      return
c

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:22  eugenio
c Initial revision
c
c Revision 1.4  1999/04/24 22:39:20  mcbride
c update to allow multiple beampipes
c
c Revision 1.3  1997/04/04  20:29:42  garren
c add rcs log line
c

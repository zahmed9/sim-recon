      subroutine geo_mother_volume

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c  Make mother region.
c    Determine the maximum region over which tracking should be done.
c      This should include all tracking detectors and any possible
c      primary vertex. 
c
c  Modified M. Procario 12 Jan 1995
c
c  Modified by J.Yarba 4-15-96 - Calorimeters added
c
c  Modified by plm 10-1-96 -- bug fixes for calorimeters and solenoids
c 
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "drift.inc"
#include "si_barrel.inc"
#include "siz_rect.inc"
#include "sicir_disk.inc"
#include "for_trk.inc"
#include "volume.inc"
#include "track_region.inc"
#include "detector_region.inc"
#include "absorber.inc"
#include "solenoid.inc"
#include "dipole.inc"
#include "beam_vertex.inc"
#include "gnr_params.inc"
#include "emcal.inc"
#include "hadcal.inc"

c     local variables
      real trkv(6), detv(6), beamvtx_min, beamvtx_max
      integer i, j, k, nlyr, nwfr
      real sizLimitLocal(4), sizLimitGlobal(4), cosRot, sinRot
      
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Tracking volume
      trkv(1) =  1.E10
      trkv(2) = -1.E10
      trkv(3) =  1.E10
      trkv(4) = -1.E10
      trkv(5) =  1.E10
      trkv(6) = -1.E10

c     Detector volume
      detv(1) =  1.E10
      detv(2) = -1.E10
      detv(3) =  1.E10
      detv(4) = -1.E10
      detv(5) =  1.E10
      detv(6) = -1.E10
c
c     Make sure that the primary vertex is included in the tracking/detector
c     region.  Take the central region +/- 5 sigma in order to get 
c     everything
c
      beamvtx_min = gnr_vtx(1)-5.*gnr_dvtx(1)
      beamvtx_min = min(beamvtx_min,
     *                  beam_vertex.pos(1)-5.*beam_vertex.sigma(1)) 
      trkv(1) = min(trkv(1), beamvtx_min )
      beamvtx_max = gnr_vtx(1)+5.*gnr_dvtx(1)
      beamvtx_max = max(beamvtx_max,
     *                  beam_vertex.pos(1)+5.*beam_vertex.sigma(1)) 
      trkv(2) = max(trkv(2), beamvtx_max)

      beamvtx_min = gnr_vtx(2)-5.*gnr_dvtx(2)
      beamvtx_min = min(beamvtx_min,
     *                  beam_vertex.pos(2)-5.*beam_vertex.sigma(2)) 
      trkv(3) = min(trkv(3), beamvtx_min) 
      beamvtx_max = gnr_vtx(2)+5.*gnr_dvtx(2)
      beamvtx_max = max(beamvtx_max,
     *                  beam_vertex.pos(2)+5.*beam_vertex.sigma(2)) 
      trkv(4) = max(trkv(4), beamvtx_max)

      beamvtx_min = gnr_vtx(3)-5.*gnr_dvtx(3)
      beamvtx_min = min(beamvtx_min,
     *                  beam_vertex.pos(3)-5.*beam_vertex.sigma(3)) 
      trkv(5) = min(trkv(5), beamvtx_min)
      beamvtx_max = gnr_vtx(3)+5.*gnr_dvtx(3)
      beamvtx_max = max(beamvtx_max,
     *                  beam_vertex.pos(3)+5.*beam_vertex.sigma(3)) 
      trkv(6) = max(trkv(6), beamvtx_max)
      do i = 1,6
       detv(i) = trkv(i)
      end do
c
c     Solenoids
c
      do i=1,sol_num
        trkv(1) = min(trkv(1), -sol_par(i).rmax)
        trkv(2) = max(trkv(2),  sol_par(i).rmax)
        trkv(3) = min(trkv(3), -sol_par(i).rmax)
        trkv(4) = max(trkv(4),  sol_par(i).rmax)
        trkv(5) = min(trkv(5),  sol_par(i).zmin)
        trkv(6) = max(trkv(6),  sol_par(i).zmax)

        detv(1) = min(detv(1), -sol_par(i).rmax)
        detv(2) = max(detv(2),  sol_par(i).rmax)
        detv(3) = min(detv(3), -sol_par(i).rmax)
        detv(4) = max(detv(4),  sol_par(i).rmax)
        detv(5) = min(detv(5),  sol_par(i).zmin)
        detv(6) = max(detv(6),  sol_par(i).zmax)
      enddo
C
C     Silicon rectangular z planes
C
      do i = 1, siz_rect_num
        nlyr = siz_rect_par(i).nlayer
        sizLimitGlobal(1) =  1.e10
        sizLimitGlobal(2) = -1.e10
        sizLimitGlobal(3) =  1.e10
        sizLimitGlobal(4) = -1.e10
        do j = 1, nlyr
          nwfr = siz_rect_par(i).lyr(j).nwafer
          sizLimitLocal(1) =  1.e10
          sizLimitLocal(2) = -1.e10
          sizLimitLocal(3) =  1.e10
          sizLimitLocal(4) = -1.e10
          do k=1,nwfr
c First find (xy)-limits in Layer's local coord.system
            sizLimitLocal(1) = min(sizLimitLocal(1),
     &             siz_rect_par(i).lyr(j).wfr(k).xLocal
     &             - 0.5*siz_rect_par(i).lyr(j).wfr(k).xlen)
            sizLimitLocal(2) = max(sizLimitLocal(2),
     &             siz_rect_par(i).lyr(j).wfr(k).xLocal
     &             + 0.5*siz_rect_par(i).lyr(j).wfr(k).xlen)
            sizLimitLocal(3) = min(sizLimitLocal(3),
     &             siz_rect_par(i).lyr(j).wfr(k).yLocal
     &             - 0.5*siz_rect_par(i).lyr(j).wfr(k).ylen)
            sizLimitLocal(4) = max(sizLimitLocal(4),
     &             siz_rect_par(i).lyr(j).wfr(k).yLocal
     &             + 0.5*siz_rect_par(i).lyr(j).wfr(k).ylen)

            trkv(5) = min(trkv(5), siz_rect_par(i).lyr(j).wfr(k).z
     &                       - 0.5*siz_rect_par(i).lyr(j).wfr(k).zlen)
            trkv(6) = max(trkv(6), siz_rect_par(i).lyr(j).wfr(k).z
     &                       + 0.5*siz_rect_par(i).lyr(j).wfr(k).zlen)

          enddo
c Rotate to Global Coordinate system
          if (siz_rect_par(i).lyr(j).rotate .ne. 0.) then
           cosRot = cos(siz_rect_par(i).lyr(j).rotate)
           sinRot = sin(siz_rect_par(i).lyr(j).rotate)
           sizLimitGlobal(1) = min(sizLimitGlobal(1),
     &        (sizLimitLocal(1)*cosRot-sizLimitLocal(3)*sinRot)
     &        +siz_rect_par(i).lyr(j).xCenter)
           sizLimitGlobal(1) = min(sizLimitGlobal(1),
     &        (sizLimitLocal(1)*cosRot-sizLimitLocal(4)*sinRot)
     &        +siz_rect_par(i).lyr(j).xCenter)
           sizLimitGlobal(1) = min(sizLimitGlobal(1),
     &        (sizLimitLocal(2)*cosRot-sizLimitLocal(3)*sinRot)
     &        +siz_rect_par(i).lyr(j).xCenter)
           sizLimitGlobal(1) = min(sizLimitGlobal(1),
     &        (sizLimitLocal(2)*cosRot-sizLimitLocal(4)*sinRot)
     &        +siz_rect_par(i).lyr(j).xCenter)
           sizLimitGlobal(2) = max(sizLimitGlobal(2),
     &        (sizLimitLocal(1)*cosRot-sizLimitLocal(3)*sinRot)
     &        +siz_rect_par(i).lyr(j).xCenter)
           sizLimitGlobal(2) = max(sizLimitGlobal(2),
     &        (sizLimitLocal(1)*cosRot-sizLimitLocal(4)*sinRot)
     &        +siz_rect_par(i).lyr(j).xCenter)
           sizLimitGlobal(2) = max(sizLimitGlobal(2),
     &        (sizLimitLocal(2)*cosRot-sizLimitLocal(3)*sinRot)
     &        +siz_rect_par(i).lyr(j).xCenter)
           sizLimitGlobal(2) = max(sizLimitGlobal(2),
     &        (sizLimitLocal(2)*cosRot-sizLimitLocal(4)*sinRot)
     &        +siz_rect_par(i).lyr(j).xCenter)
           sizLimitGlobal(3) = min(sizLimitGlobal(3),
     &        (sizLimitLocal(1)*sinRot+sizLimitLocal(3)*cosRot)
     &        +siz_rect_par(i).lyr(j).yCenter)
           sizLimitGlobal(3) = min(sizLimitGlobal(3),
     &        (sizLimitLocal(2)*sinRot+sizLimitLocal(3)*cosRot)
     &        +siz_rect_par(i).lyr(j).yCenter)
           sizLimitGlobal(3) = min(sizLimitGlobal(3),
     &        (sizLimitLocal(1)*sinRot+sizLimitLocal(4)*cosRot)
     &        +siz_rect_par(i).lyr(j).yCenter)
           sizLimitGlobal(4) = max(sizLimitGlobal(4),
     &        (sizLimitLocal(2)*sinRot+sizLimitLocal(4)*cosRot)
     &        +siz_rect_par(i).lyr(j).yCenter)
           sizLimitGlobal(4) = max(sizLimitGlobal(4),
     &        (sizLimitLocal(2)*sinRot+sizLimitLocal(3)*cosRot)
     &        +siz_rect_par(i).lyr(j).yCenter)
           sizLimitGlobal(4) = max(sizLimitGlobal(4),
     &        (sizLimitLocal(1)*sinRot+sizLimitLocal(4)*cosRot)
     &        +siz_rect_par(i).lyr(j).yCenter)
           sizLimitGlobal(4) = max(sizLimitGlobal(4),
     &        (sizLimitLocal(2)*sinRot+sizLimitLocal(4)*cosRot)
     &        +siz_rect_par(i).lyr(j).yCenter)
          else
           sizLimitGlobal(1) = sizLimitLocal(1)
     &                       + siz_rect_par(i).lyr(j).xCenter
           sizLimitGlobal(2) = sizLimitLocal(2)
     &                       + siz_rect_par(i).lyr(j).xCenter
           sizLimitGlobal(3) = sizLimitLocal(3)
     &                       + siz_rect_par(i).lyr(j).yCenter
           sizLimitGlobal(4) = sizLimitLocal(4)
     &                       + siz_rect_par(i).lyr(j).yCenter
          end if
          trkv(1) = min(trkv(1),sizLimitGlobal(1))
          trkv(2) = max(trkv(2),sizLimitGlobal(2))
          trkv(3) = min(trkv(3),sizLimitGlobal(3))
          trkv(4) = max(trkv(4),sizLimitGlobal(4))
          detv(1) = min(trkv(1),detv(1))
          detv(2) = max(trkv(2),detv(2))
          detv(3) = min(trkv(3),detv(3))
          detv(4) = max(trkv(4),detv(4))
          detv(5) = min(trkv(5),detv(5))
          detv(6) = max(trkv(6),detv(6))
        enddo
      enddo
C
C     Silicon disks 
C
      do i = 1, sicir_num
        nlyr = sicir_par(i).numlyr
        do j = 1, nlyr
          trkv(1) = min(trkv(1),-sicir_par(i).lyr(j).wedge(1).rmax)
          trkv(2) = max(trkv(2), sicir_par(i).lyr(j).wedge(1).rmax)
          trkv(3) = min(trkv(3),-sicir_par(i).lyr(j).wedge(1).rmin)
          trkv(4) = max(trkv(4), sicir_par(i).lyr(j).wedge(1).rmax)
          trkv(5) = min(trkv(5), sicir_par(i).lyr(j).wedge(1).z-
     $                           sicir_par(i).lyr(j).wedge(1).thick)
          trkv(6) = max(trkv(6), sicir_par(i).lyr(j).wedge(1).z+
     $                           sicir_par(i).lyr(j).wedge(1).thick)
*
          detv(1) = min(detv(1),-sicir_par(i).lyr(j).wedge(1).rmax)
          detv(2) = max(detv(2), sicir_par(i).lyr(j).wedge(1).rmax)
          detv(3) = min(detv(3),-sicir_par(i).lyr(j).wedge(1).rmax)
          detv(4) = max(detv(4), sicir_par(i).lyr(j).wedge(1).rmax)
          detv(5) = min(detv(5), sicir_par(i).lyr(j).wedge(1).z-
     $                           sicir_par(i).lyr(j).wedge(1).thick)
          detv(6) = max(detv(6), sicir_par(i).lyr(j).wedge(1).z+
     $                           sicir_par(i).lyr(j).wedge(1).thick)
        enddo
      enddo
C
C     Forward tracking detectors - drift, pwc, fibers
C
      do i = 1, ftrk_num
        trkv(1) = min(trkv(1), ftrk_par(i).xmin)
        trkv(2) = max(trkv(2), ftrk_par(i).xmax)
        trkv(3) = min(trkv(3), ftrk_par(i).ymin)
        trkv(4) = max(trkv(4), ftrk_par(i).ymax)
        trkv(5) = min(trkv(5), ftrk_par(i).zmin)
        trkv(6) = max(trkv(6), ftrk_par(i).zmax)
*
        detv(1) = min(detv(1), ftrk_par(i).xmin)
        detv(2) = max(detv(2), ftrk_par(i).xmax)
        detv(3) = min(detv(3), ftrk_par(i).ymin)
        detv(4) = max(detv(4), ftrk_par(i).ymax)
        detv(5) = min(detv(5), ftrk_par(i).zmin)
        detv(6) = max(detv(6), ftrk_par(i).zmax)
      enddo
C
C     Silicon barrels
C
      do i=1,sib_num
        nlyr = sib_par(i).numlyr
        do j = 1, nlyr
          trkv(1) = min(trkv(1), -sib_par(i).lyr(j).plane(1).delta_max)
          trkv(2) = max(trkv(2),  sib_par(i).lyr(j).plane(1).delta_max)
          trkv(3) = min(trkv(3), -sib_par(i).lyr(j).plane(1).delta_max)
          trkv(4) = max(trkv(4),  sib_par(i).lyr(j).plane(1).delta_max)
          trkv(5) = min(trkv(5),  sib_par(i).lyr(j).plane(1).zmin)
          trkv(6) = max(trkv(6),  sib_par(i).lyr(j).plane(1).zmax)

          detv(1) = min(detv(1), -sib_par(i).lyr(j).plane(1).delta_max)
          detv(2) = max(detv(2),  sib_par(i).lyr(j).plane(1).delta_max)
          detv(3) = min(detv(3), -sib_par(i).lyr(j).plane(1).delta_max)
          detv(4) = max(detv(4),  sib_par(i).lyr(j).plane(1).delta_max)
          detv(5) = min(detv(5),  sib_par(i).lyr(j).plane(1).zmin)
          detv(6) = max(detv(6),  sib_par(i).lyr(j).plane(1).zmax)
        enddo
      enddo

c     Drift chambers
      do i=1,drf_num
        trkv(1) = min(trkv(1), -drf_par(i).rmax)
        trkv(2) = max(trkv(2),  drf_par(i).rmax)
        trkv(3) = min(trkv(3), -drf_par(i).rmax)
        trkv(4) = max(trkv(4),  drf_par(i).rmax)
        trkv(5) = min(trkv(5),  drf_par(i).zmin)
        trkv(6) = max(trkv(6),  drf_par(i).zmax)

        detv(1) = min(detv(1), -drf_par(i).rmax)
        detv(2) = max(detv(2),  drf_par(i).rmax)
        detv(3) = min(detv(3), -drf_par(i).rmax)
        detv(4) = max(detv(4),  drf_par(i).rmax)
        detv(5) = min(detv(5),  drf_par(i).zmin)
        detv(6) = max(detv(6),  drf_par(i).zmax)
      enddo

c     EM Calorimeters
      do i = 1,emcal_num

       if ( emcal_par(i).shape(1:3) .ne. 'BOX') then
cc Tube/Cone-shaped calorimeters

        trkv(1) = min(trkv(1),
     *                min(-emcal_par(i).rmax(1),-emcal_par(i).rmax(2)))
        trkv(2) = max(trkv(2), 
     *                max( emcal_par(i).rmax(1), emcal_par(i).rmax(2)))
        trkv(3) = trkv(1)
        trkv(4) = trkv(2)

        detv(1) = min(detv(1),
     *                min(-emcal_par(i).rmax(1),-emcal_par(i).rmax(2)))
        detv(2) = max(detv(2), 
     *                max( emcal_par(i).rmax(1), emcal_par(i).rmax(2)))
        detv(3) = detv(1)
        detv(4) = detv(2)

       else
cc Box-shaped calorimeters

        trkv(1) = min(trkv(1),emcal_par(i).xlimit(1))
        trkv(2) = max(trkv(2),emcal_par(i).xlimit(2))
        trkv(3) = min(trkv(3),emcal_par(i).ylimit(1))
        trkv(4) = max(trkv(4),emcal_par(i).ylimit(2))

        detv(1) = trkv(1)
        detv(2) = trkv(2)
        detv(3) = trkv(3)
        detv(4) = trkv(4)

       end if

       trkv(5) = min(trkv(5),emcal_par(i).zmin)
       trkv(6) = max(trkv(5),emcal_par(i).zmax)

       detv(5) = min(detv(5),emcal_par(i).zmin)
       detv(6) = max(detv(6),emcal_par(i).zmax)

      end do

c     HAD Calorimeters
      do i = 1,hcal_num

       trkv(1) = min(trkv(1),
     *               min(-hcal_par(i).rmax(1),-hcal_par(i).rmax(2)))
       trkv(2) = max(trkv(2), 
     *               max( hcal_par(i).rmax(1), hcal_par(i).rmax(2)))
       trkv(3) = trkv(1)
       trkv(4) = trkv(2)
       trkv(5) = min(trkv(5),hcal_par(i).zmin)
       trkv(6) = max(trkv(5),hcal_par(i).zmax)

       detv(1) = min(detv(1),
     *               min(-hcal_par(i).rmax(1),-hcal_par(i).rmax(2)))
       detv(2) = max(detv(2), 
     *               max( hcal_par(i).rmax(1), hcal_par(i).rmax(2)))
       detv(3) = detv(1)
       detv(4) = detv(2)
       detv(5) = min(detv(5),hcal_par(i).zmin)
       detv(6) = max(detv(6),hcal_par(i).zmax)

      end do

c     Volumes
      do i=1,vol_num

        detv(1) = min(detv(1), -vol_par(i).rmax)
        detv(2) = max(detv(2),  vol_par(i).rmax)
        detv(3) = min(detv(3), -vol_par(i).rmax)
        detv(4) = max(detv(4),  vol_par(i).rmax)
        detv(5) = min(detv(5),  vol_par(i).zmin)
        detv(6) = max(detv(6),  vol_par(i).zmax)

      enddo

c     Absorbers
      do i=1,absorber_num
        detv(1) = min(detv(1), -absorber_par(i).rmax(1))
        detv(2) = max(detv(2),  absorber_par(i).rmax(1))
        detv(3) = min(detv(3), -absorber_par(i).rmax(1))
        detv(4) = max(detv(4),  absorber_par(i).rmax(1))
        detv(5) = min(detv(5),  absorber_par(i).zmin)
        detv(6) = max(detv(6),  absorber_par(i).zmax)

        detv(1) = min(detv(1), -absorber_par(i).rmax(2))
        detv(2) = max(detv(2),  absorber_par(i).rmax(2))
        detv(3) = min(detv(3), -absorber_par(i).rmax(2))
        detv(4) = max(detv(4),  absorber_par(i).rmax(2))
        detv(5) = min(detv(5),  absorber_par(i).zmin)
        detv(6) = max(detv(6),  absorber_par(i).zmax)

      enddo

c     Dipoles
      do i=1,dip_num
        trkv(1) = min(trkv(1),  dip_par(i).xmin)
        trkv(2) = max(trkv(2),  dip_par(i).xmax)
        trkv(3) = min(trkv(3),  dip_par(i).ymin)
        trkv(4) = max(trkv(4),  dip_par(i).ymax)
        trkv(5) = min(trkv(5),  dip_par(i).zmin)
        trkv(6) = max(trkv(6),  dip_par(i).zmax)

        detv(1) = min(detv(1),  dip_par(i).xmin)
        detv(2) = max(detv(2),  dip_par(i).xmax)
        detv(3) = min(detv(3),  dip_par(i).ymin)
        detv(4) = max(detv(4),  dip_par(i).ymax)
        detv(5) = min(detv(5),  dip_par(i).zmin)
        detv(6) = max(detv(6),  dip_par(i).zmax)
      enddo

c     Solenoids
      do i=1,sol_num
        trkv(1) = min(trkv(1), -sol_par(i).rmax)
        trkv(2) = max(trkv(2),  sol_par(i).rmax)
        trkv(3) = min(trkv(3), -sol_par(i).rmax)
        trkv(4) = max(trkv(4),  sol_par(i).rmax)
        trkv(5) = min(trkv(5),  sol_par(i).zmin)
        trkv(6) = max(trkv(6),  sol_par(i).zmax)

        detv(1) = min(detv(1), -sol_par(i).rmax)
        detv(2) = max(detv(2),  sol_par(i).rmax)
        detv(3) = min(detv(3), -sol_par(i).rmax)
        detv(4) = max(detv(4),  sol_par(i).rmax)
        detv(5) = min(detv(5),  sol_par(i).zmin)
        detv(6) = max(detv(6),  sol_par(i).zmax)
       enddo


c     Put in tracking volume
      trk_reg.xmin = trkv(1)
      trk_reg.xmax = trkv(2)
      trk_reg.ymin = trkv(3)
      trk_reg.ymax = trkv(4)
      trk_reg.zmin = trkv(5)
      trk_reg.zmax = trkv(6)


c     Put in detector volume
      det_reg.xmin = detv(1)
      det_reg.xmax = detv(2)
      det_reg.ymin = detv(3)
      det_reg.ymax = detv(4)
      det_reg.zmin = detv(5)
      det_reg.zmax = detv(6)

c     normal exit
1000  continue
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:23  eugenio
c Initial revision
c
c Revision 1.14  1998/03/23 20:26:26  mcbride
c merge another v2_6_2 change with dev version
c
c Revision 1.13  1998/03/23  17:10:55  mcbride
c merge v2_6_2 changes and dev version
c
c Revision 1.9  1997/10/27  23:23:50  yarba_j
c bug fixes for new pixels
c
c Revision 1.8  1997/10/24  17:56:24  yarba_j
c update and minor bug fixes related to new pixel geometry
c
c Revision 1.7  1997/04/04  20:29:44  garren
c add rcs log line
c

      subroutine geo_trkorder

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Make ordered lists of the radial and z plane track and material
c  information. These lists are used by the tracing and tracking
c  routines.
c
c  This version handles silicon XY planes, forward drift chambers,
c  forward absorbers, forward emcals, forward hcals, forward muons
c  and dipoles.
c
c  8/18/95  T. Wenaus   Si disks added. 
c  10/06/95 J. Yarba    R- & Z-planes ordering has been modified for EMCAL
c  8/13/95  P. Lebrun   Included rad. length and dedx for absorber, if type 41
c						or 42 
c  11/19/96 plm         
c
c  10/14/97 J.Yarba     Account for new pixels geometry (siz_rect) 
c  10/23/97 P.Avery     Split into 1 routine per device
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "zplane.inc"
#include "rplane.inc"
#include "trace_params.inc"

c     Local variables
      integer i
      real radius(rpln_max), zpos(zpln_max)
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      rpln_num = 0
      zpln_num = 0

c     Build list of radial and z material and measurement planes

      call geo_trkorder_si_barrel    ! Silicon barrels
      call geo_trkorder_drift        ! Drift chambers
      call geo_trkorder_solenoid     ! Solenoids
      call geo_trkorder_volume       ! Volumes
      call geo_trkorder_absorber     ! Absorbers
      call geo_trkorder_muon         ! Muon detectors
      if (.not.trk_lintegrated) then
         call geo_trkorder_emcal        ! Emcal detectors
      end if
      call geo_trkorder_dipole       ! Dipole magnets
#ifdef OLD_ZSIXY /* provided for backwards compatibility */
      call geo_trkorder_sixy         ! Silicon rectangular z devices - old style
#else
      call geo_trkorder_siz_rect     ! Silicon rectangular z devices
#endif
      call geo_trkorder_sicir_disk   ! Silicon circular z planes
      call geo_trkorder_fordisk      ! Forward silicon disks
      call geo_trkorder_for_trk      ! Forward drift chambers
      call geo_trkorder_rich         ! Rich detectors

c     Sort the radial planes by increasing radius
      do i=1,rpln_num
        radius(i) = rpln_par(i).radius
        rpln_up(i) = i
      enddo
      call sortup_float(radius, rpln_up, rpln_num)

c     Sort the z planes by increasing and decreasing z values
      do i=1,zpln_num
        zpos(i) = zpln_par(i).z
        zpln_up(i) = i
        zpln_dn(i) = i
      enddo
      call sortup_float(zpos, zpln_up, zpln_num)
      call sortdn_float(zpos, zpln_dn, zpln_num)

c     Normal exit
1000  continue
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:23  eugenio
c Initial revision
c
c Revision 1.22  1998/06/29 21:38:39  yarba_j
c do not include calorimeters and absorbers in r/z-list if using integrated tracing algorithm - they'll be added later
c
c Revision 1.21  1997/10/24  05:44:48  mcbride
c update geo_trkorder, add new routines, add Paul A's changes to geo routines
c
c Revision 1.20  1997/10/23  21:28:17  yarba_j
c updated to account for new pixel geometry
c
c Revision 1.18  1997/04/04  20:29:46  garren
c add rcs log line
c

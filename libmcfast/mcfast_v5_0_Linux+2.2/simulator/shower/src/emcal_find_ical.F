      subroutine emcal_find_ical(w, ical, lstrike)
c
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c    Checks is the point xyz belongs to the current calorimeter.  
c
c  Inputs:
c
c  w          current track status in W-form 
c
c  ical       calorimeter number (w.x,w.y,w.z) should belong to
c
c  Outputs:
c
c  lstrike    logical variable
c             TRUE if track falls within detector boundaries
c
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "emcal.inc"
#include "wtrack_struct.inc"

c     Calling arguments  
      record /wtrack_struct/ w
      integer ical 
      logical lstrike

c     Local variables
      integer i
      DFLOAT SHIFT_PROPAGATION
      parameter (SHIFT_PROPAGATION = 0.1D-4) 
c                          Move 100 microns along track
      DFLOAT xyz(3)
      DFLOAT temp
      DFLOAT radius, rmin(2), rmax(2), zmin, zmax
      DFLOAT rmin_at_z, rmax_at_z

c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      lstrike = .false.

      if (ical .le. 0 .or. ical .gt. emcal_num) return
      
      temp = 0.

      if (w.p .gt. 0.1D-4) then
       temp = SHIFT_PROPAGATION * unit_meter / w.p   
                  !Move 100 microns along track for non-zero momentum
       xyz(1) = w.x + w.px*temp
       xyz(2) = w.y + w.py*temp
       xyz(3) = w.z + w.pz*temp
      else
       xyz(1) = w.x 
       xyz(2) = w.y 
       xyz(3) = w.z 
      end if

c     Handle Conical/Cylindrical Calorimeters
      if (emcal_par(ical).shape .ne. 'BOX') then
       radius = dsqrt(xyz(1)*xyz(1) + xyz(2)*xyz(2)) 
       do i = 1,2
        rmin(i) = emcal_par(ical).rmin(i)
        rmax(i) = emcal_par(ical).rmax(i)
       end do
       zmin=emcal_par(ical).zmin
       zmax=emcal_par(ical).zmax
       rmin_at_z = rmin(1) 
     *           + (xyz(3) - zmin) * (rmin(2) - rmin(1))
     *           / (zmax - zmin)
       rmax_at_z = rmax(1)
     *           + (xyz(3) - zmin) * (rmax(2) - rmax(1))
     *           / (zmax - zmin) 
       if (radius .ge. rmin_at_z .and. radius .le. rmax_at_z .and.
     *     xyz(3) .ge. zmin .and. xyz(3) .le. zmax) then
        lstrike = .true.
       end if
c     Handle BOX-shaped Calorimeters
      else
c     Fisrt, check if the point is whithin z-limits
       if (xyz(3) .ge. emcal_par(ical).zmin .and.
     *     xyz(3) .le. emcal_par(ical).zmax) then
c     Then check if the inner gap exists & whether xyz ends up there
        if (emcal_par(ical).xlimit_gap(1) .ne.
     *      emcal_par(ical).xlimit_gap(2) .and.
     *      emcal_par(ical).ylimit_gap(1) .ne.
     *      emcal_par(ical).ylimit_gap(2)) then
         if (xyz(1) .ge. emcal_par(ical).xlimit_gap(1) .and.
     *       xyz(1) .le. emcal_par(ical).xlimit_gap(2) .and.
     *       xyz(2) .ge. emcal_par(ical).ylimit_gap(1) .and.
     *       xyz(2) .le. emcal_par(ical).ylimit_gap(2)) then
          return
         end if
        end if
c     OK, either there's no inner gap or xyz is not inside it
c     Check if xyz is inside outer calorimeter boundaries
        if (xyz(1) .ge. emcal_par(ical).xlimit(1) .and.
     *      xyz(1) .le. emcal_par(ical).xlimit(2) .and.
     *      xyz(2) .ge. emcal_par(ical).ylimit(1) .and.
     *      xyz(2) .le. emcal_par(ical).ylimit(2)) then
          lstrike = .true.
        end if
       end if
      end if

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:28  eugenio
c Initial revision
c
c Revision 1.13  1998/04/01 17:25:39  bphyslib
c restore log line
c
c Revision 1.11  1997/10/27  23:28:17  yarba_j
c protection against handling zero-momentum showers
c
c Revision 1.10  1997/04/04  20:30:09  garren
c add rcs log line
c


      subroutine calor_trace_mip(hep,ical,w_in,length,w_out,path)

c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    
c     Author : Julia Yarba, FNAL/CD
c              8-6-96
c
c
c     Rewrite : Robert Kutschke & Julia Yarba , FNAL/CD
c               1-30-97
c
c     Tracing minimum ionizing particles through calorimeter volume;
c     tracing stopes if either the whole kinetic energy (w.e-mass) 
c     has been lost or particle exits the volume 
c     The distance length will normaly be one of
c     a) step length to the point at which the particle decays
c     b) step length to the shower conversion point
c     c) step length to the exit point from the calorimeter
c     plus there's one more option
c     d) step length to the point where the particle's lost all energy
c
c     Julia Yarba, 8-7-97 : implemented multiple scattering
c
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


      implicit none

#include "const.inc"
#include "material.inc"
#include "emcal.inc"
#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "path_struct.inc"

#include "control_shower.inc"
#include "trace_params.inc"

c     Calling arguments
      integer hep                  ! STDHEP track #
      integer ical                 ! Calorimeter #
      record /wtrack_struct/ w_in  ! Input track in w representation
      DFLOAT length                ! Maximum length to step in this Cal.
      record /wtrack_struct/ w_out ! Output track in w representation
      record /path_struct/ path    ! 

c     Externals
      external num_cal_hits, calor_sampling_factor, move_wtk_arc
      integer  num_cal_hits, move_wtk_arc
      real calor_sampling_factor

c     Local variables     
      record /bfield_struct/ bf    ! B field at the entry to the calorimeter
      record /wtrack_struct/ w_hit ! 
      DFLOAT step, step_hit
      ! Kinetic energy at the begining of each step
      ! Energy deposited at each step
      ! Mass and Mass**2 of the particle
      ! p_save is a miscellaneous
      DFLOAT e_kine, e_dep, mass, mass2, p_save, eta(3)
      ! Deposited energy scaled with respect to sampling factor
      real e_dep_scaled
      ! Calorimete stuff
      integer ical1, material, active_material
      integer status
      real sampling_factor
      logical lstrike
      integer num_hit_previous

c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      call ucopy(w_in, w_out, WTRACK_WORD)
      path.arc = 0.
      path.time = 0.
      path.tau = 0.

      if (ical .le. 0 .or. ical .gt. emcal_num) return

      call emcal_find_ical(w_in,ical,lstrike)
      if (.not.(lstrike)) return

      mass2 = (w_in.e+w_in.p) * (w_in.e-w_in.p)
      if (mass2 .le. 0.) return

      mass = sqrt(mass2)

      e_kine = w_in.e - mass
      e_dep = 0.
      status = 0
      step = 0.

      ical1 = ical - 1
      if (hit_generation) then
       num_hit_previous = num_cal_hits(%val(ical1)) - 1
      end if

      call trk_next_bfield(w_in, bf)
       
c     Define materials and sampling factor, if necessary

      material = emcal_par(ical).material
      active_material = emcal_par(ical).active_material

      sampling_factor = calor_sampling_factor(material,active_material)

      do while (e_kine .gt. 0. .and. 
     *          lstrike .and. path.arc .lt. length)

       step = mtl_par(material).rad_len

c   Check if we step over length
       if (path.arc+step .gt. length) then
        step = length-path.arc
       end if

c   Apply multiple scattering 
c   (if required by user and for non-zero momentum particles only)
       if (w_out.p .gt. 0. .and. trk_lscat) then              
        eta(1) = w_out.p / w_out.px
        eta(2) = 0.
        eta(3) = 0.
        call wtk_mscat(w_out, step/mtl_par(material).rad_len, eta, 
     *                 w_out)
       end if

c   Check if still inside the volume after this step
       status = move_wtk_arc(w_out,step,bf,w_out)
       if (status .eq. 0) then
        call emcal_find_ical(w_out,ical,lstrike)
       else
c   Can't move ! Break the loop !
        return
       end if
       if (.not.lstrike) then
c   We step out of volume;
c   step limitation due to geometry;
c   move step back; find exit from this volume. 
        status = move_wtk_arc(w_out,-step,bf,w_out)
        call emcal_find_path(w_out,ical,1,w_out,step)
       end if
       if (step .eq. 0.) then
c   Can't find exit from volume ! Break the loop !
        return
       end if

c   Define energy loss at the step
       e_dep = mtl_par(material).dedx * step

       if (e_dep .gt. e_kine) then
c   Step limitaion by ranging out
        step = step * e_kine/e_dep
        e_dep = e_kine
        e_kine = 0.
       else
c   Update energy
        e_kine = e_kine - e_dep
       end if

c   Generate hit for non-zero edep and "sensitive" calorimeter,
c   if 'hit_generation' is ON
       if (e_dep .gt. 0. .and. 
     &     emcal_par(ical).type .le. 100 .and.
     &     hit_generation) then
c   Move back to the middle of step and generate hit there
        step_hit = 0.5 * step
        status = move_wtk_arc(w_out,-step_hit,bf,w_hit)
        if (status .eq. 0) then
c   Moving OK; account for sampling fraction, if any, and generate hit
         e_dep_scaled = e_dep * sampling_factor
         call emcal_find_cell(ical,e_dep_scaled,w_hit.x,'MIP')
        end if
       end if

c   Do updates
       path.arc  = path.arc  + step
       path.time = path.time + step*w_out.e/w_out.p/clight
       path.tau  = path.tau  + step*mass   /w_out.p/clight
       w_out.e  = e_kine + mass        
       p_save = w_out.p
       w_out.p  = sqrt(max(0.d0,(w_out.e*w_out.e - mass2)))
       w_out.px = w_out.px * (w_out.p/p_save)
       w_out.py = w_out.py * (w_out.p/p_save)
       w_out.pz = w_out.pz * (w_out.p/p_save)
       w_out.pt = w_out.pt * (w_out.p/p_save)

      end do

c   Handle hit generation for "sensitive" calorimeters only,
c   if 'hit_generation' is ON ! 
      if (emcal_par(ical).type .le. 100 .and.
     &    hit_generation) then
       call Collect_shower_hits(%val(ical1),
     *                          %val(num_hit_previous),
     *                          %val(hep))    
      end if

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:27  eugenio
c Initial revision
c
c Revision 1.7  1997/07/09 20:45:35  yarba_j
c mult.scattering implemented
c
c Revision 1.6  1997/04/04  20:30:07  garren
c add rcs log line
c

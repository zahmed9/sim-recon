      subroutine emcal_make_hit(ical,shw_in,shw_out)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c   4/1/96  Julia Yarba
c
c     modified 05/25/96 ASB -- adapted to modified cal hit structure
c
c   5/29/96 - Julia Yarba : modified to adapt to shower_trace_struct
c
c   1/14/97 - Julia Yarba : modified to incorporate absorbers;
c   for your information, now we treat absorbers as "pseudocalorimeters",
c   i.e."calorimeters" which do not produce any hits; the "insensitivity" 
c   id is 101 for central and 102 for forward "pseudocalorimeters" (these
c   ids are set during geometry loading stage); nevertheless, we still 
c   generate shower development (transverse profile) in absorbers in case
c   a part of such shower touches neighboring calorimeter(s).
c
c   4/29/97 - Julia Yarba : modified to make all updates of shower-structure
c                           depend only on the shower current status and 
c                           energy deposited at the current step
c                           + some minor clean up
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "material.inc"
#include "stdhep.inc"
#include "emcal.inc"
#include "shower_trace_struct.inc"

#include "control_shower.inc"

C     Calling arguments
      integer ical       
      record /shower_trace_struct/ shw_in, shw_out

c     Externals
      external rann, phi_norm, get_gauss, 
     *         calor_sampling_factor
      real rann, get_gauss, calor_sampling_factor
      DFLOAT phi_norm

c     Local variables
      integer i, id_part
      DFLOAT  phi_part,
     *        cos_theta_part, sin_theta_part, 
     *        cos_phi_part, sin_phi_part
      integer material, active_material
      real    z, ci_em, ec, alpha_em, beta_em, tmax_em
      real    alpha_had, beta_had, c_had, d_had, w_had, tmax_had
      real    tmax, e_norm
      real    step, lambda, 
     *        e_current, e_start_shw, 
     *        e_now, e_before, e_dep, e_dep_scaled, r_dep, phi_dep,
     *        e_thresh, 
     *        step_tmp
      DFLOAT  exit
      integer ndep 
      real    rm, sigma_n, sigma_w, amp_ratio, amp_thresh
      real    rlim_em, rlim_had     
      parameter (rlim_em  = 4.5)    !EM shower max trans. spread (in # of X0).
                                    !Negotiable. I just place smthng reasonable.
      parameter (rlim_had = 35.0)   !HAD shower max trans. spread (in # of X0)
                                    !Negotiable. I just place smthng reasonable.
      
      DFLOAT xyz_local(3), xyz_global(3)
      record /wtrack_struct/ w

      logical lstrike
      logical lstrike_cal(max_emcal)
      integer ical_fill, ical_collect

c     Things related to hits generation/collection
      integer icalm1, num_hit_previous(max_emcal)
      external num_cal_hits
      integer num_cal_hits

      real    ares, bres, sampling_factor, smear_factor, x_smear
      data    x_smear /0./
      save    x_smear

      real em_had_ratio

      data    beta_em  /0.5/
      data    beta_had /0.2198/
      data    w_had    /0.4634/

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


      call ucopy (shw_in.w, shw_out.w, WTRACK_WORD)

      if (ical .le. 0 .or. ical .gt. emcal_num) return

c Protect against handling zero-momentun
      if (shw_in.w.p .le. 0. .or. shw_in.w.e .le. 0.) return 

c	Initialisation: set an array of flags to indicate wich neighboring 
c	calorimeter go hit,... if 'hit_generation' is ON !
      
      if (hit_generation) then
       do i = 0, emcal_num-1
        lstrike_cal(i+1) = .FALSE.
        num_hit_previous(i+1) = num_cal_hits(%val(i)) - 1
       end do
       if (emcal_par(ical).type .le. 100) lstrike_cal(ical) = .TRUE.
      end if
      
      id_part = idhep(shw_in.hep)

      shw_out.hep = shw_in.hep

      call vzero(xyz_local, 3*FLOAT_WORD)
      call vzero(xyz_global,3*FLOAT_WORD)
      e_dep = 0.
      e_dep_scaled = 0.
      r_dep = 0.
      lstrike = .true.
      ndep = 0
      e_start_shw = 0.
      e_now    = 0.
      e_before = 0.
      ical_fill = 0

      smear_factor    = 1.
      ares            = 0.
      bres            = 0. 

      e_current = shw_in.w.E

c     Define material(s) 
      material = emcal_par(ical).material
      active_material = emcal_par(ical).active_material
      z = mtl_par(material).z

c     Define directions for the shower core

      if (shw_in.w.pt .ne. 0.) then
        phi_part   = phi_norm(atan2(shw_in.w.py, shw_in.w.px))
      else
        phi_part = 0.
      end if
      cos_phi_part = dcos(phi_part)
      sin_phi_part = dsin(phi_part)

      cos_theta_part = shw_in.w.pz/shw_in.w.p
      sin_theta_part = shw_in.w.pt/shw_in.w.p

c     Define sampling factor
      sampling_factor = calor_sampling_factor(material,active_material)

c     Define resolution parameters if necessary
      if (abs(id_part) .eq. 11 .or. abs(id_part) .eq. 22) then
        ares = emcal_par(ical).siga_em
        bres = emcal_par(ical).sigb_em
      else
        ares = emcal_par(ical).siga_had
        bres = emcal_par(ical).sigb_had
cc Since we originally matched our simulation against GEANT-Gheisha
cc which is known to induce energy dependece of e/pi ration,
cc we provide the possibility to reproduce this effect regardless
cc the fact that GEANT-FLUKA does not show this effect;
cc according to private communications with CMS/HADCal people, 
cc e/h ratio DOES depend on the incident energy;
cc however, we're not 100% sure how the effect should be reproduced
cc and choose to skip it utill we compare to real data and have
cc better understanding of the whole picture
        em_had_ratio = emcal_par(ical).em_had_ratio
cc     *               * (0.29*exp(-0.22*shw_in.w.e)
cc     *               +  1.07*exp(-0.0004*shw_in.w.e))
        sampling_factor = sampling_factor / em_had_ratio
      end if

      if (shw_in.n_radlen_pass .le. 0.) then 
c     Shower starts in this calorimeter
       e_start_shw = e_current
      else
c     Shower started in a previous volume and conitunes in this calorimeter
       e_start_shw = shw_in.e_original
      end if

      shw_out.E_original = e_start_shw
      
c     Define shower parameters in the material 

      if (id_part .eq. 22) then
       ci_em = -0.5
      else if (abs(id_part) .eq. 11) then
       ci_em =  0.5
      else
       ci_em = 0.
      end if
c
      ec = .8 / (z + 1.2)
      rm = 0.021 / ec
      e_norm = e_start_shw / ec
      tmax_em = alog(e_norm) + ci_em
      alpha_em = 1. + beta_em * tmax_em
      alpha_had = 0.6165 + 0.3183*alog(e_start_shw)
      c_had = alpha_had
      d_had = 0.9099 - 0.0237*alog(e_start_shw)
      tmax_had = mtl_par(material).abs_len*(0.7+0.2*alog(e_start_shw))

      if (abs(id_part) .ne. 13) then
       if (abs(id_part) .eq. 11 .or. abs(id_part) .eq. 22) then
        tmax = tmax_em
       else
        tmax = tmax_had
       end if
      end if
c
c     Do the job for particles to start showering inside EMC volume
c
c     Define smear factor (with respect to resolution formula) 
c
      if (shw_in.n_radlen_pass .eq. 0.) then
       x_smear = get_gauss(0)
      end if
      smear_factor = sqrt(e_start_shw*ares**2+(bres*e_start_shw)**2) 
     *             * x_smear
      smear_factor = 1. + smear_factor / e_start_shw
c     
c     Do NOT shower very low energy particles; 
c     deposit energy here at the conversion point
c
      if (tmax .le. 0. .or. 
     *    ((abs(id_part).ne.11.and.abs(id_part).ne.22) .and.
     *    alpha_had.le.0.)) then
c
       e_dep = e_current
       e_current = 0.
c     Redefine the deposited energy with respect to
c     sampling ratio, e/pi ratio, and resolution formula
cc--  NOTE : it's still under question how we want to do the smearing
cc--       e_dep_scaled = (e_dep 
cc--     *              +  sqrt(e_dep*ares**2+(e_dep*bres)**2)*get_gauss(0))
cc--     *              *  sampling_factor
       e_dep_scaled = e_dep * sampling_factor * smear_factor
       if (e_dep_scaled .gt. 0.) then
c     Do updates and hit generation for non-zero e_dep_scaled only !
        call emcal_find_ical(shw_in.w,ical,lstrike)
        if (lstrike) then
            ical_fill = ical
        else
            call emcal_get_ical(shw_in.w,ical_fill)
        end if
        if (ical_fill .gt. 0) then 
         if (emcal_par(ical_fill).type .le. 100 .and.
     *       hit_generation) then
          lstrike_cal(ical_fill) = .TRUE.
c    Do hit generation for "sensitive" calorimeters only
          if (abs(id_part) .eq. 11 .or. abs(id_part) .eq. 22) then
           call emcal_find_cell(ical_fill,e_dep_scaled,shw_in.w.x,'EM')
          else
           call emcal_find_cell(ical_fill,e_dep_scaled,shw_in.w.x,'HAD')
          end if
         end if
	end if
c     Update shower-structure before giving up
        shw_out.w.E = 0.
        shw_out.E_original = 0.
        shw_out.w.px = 0.
        shw_out.w.py = 0.
        shw_out.w.pz = 0.
        shw_out.w.pt = 0.
        shw_out.w.p  = 0.
       end if

       do ical_collect = 0, emcal_num-1
        if (lstrike_cal(ical_collect+1))
     &	call Collect_shower_hits(%val(ical_collect),
     &              %val(num_hit_previous(ical_collect+1)), 
     &                        %val(shw_in.hep)) 
       end do             

       return   

      end if

c     OK, the particle energy is still high enough to start shower
c
c     Do energy deposition according shower longitudinal profile till
c     the remaining energy is greater than 5% of the incident energy

      e_thresh  = thresh * e_start_shw

      step = 0.
      e_before = 0.

c     Shower may have started in a previous volume;
c     this must be taken into account for longitudinal
c     and transverse profiles calculation
      step_tmp = shw_in.n_radlen_pass 

      do while (lstrike .and.
     *          e_current .gt. e_thresh)

c     Define the "default" step
       step = mtl_par(material).rad_len

       xyz_local(3) = dble(step)
       xyz_local(1) = 0.
       xyz_local(2) = 0.
       call rotate_to_global(xyz_local,
     *                       cos_phi_part,sin_phi_part, 
     *                       cos_theta_part,sin_theta_part,
     *                       xyz_global)
       shw_out.w.x = shw_out.w.x + xyz_global(1)
       shw_out.w.y = shw_out.w.y + xyz_global(2)
       shw_out.w.z = shw_out.w.z + xyz_global(3)
       call emcal_find_ical(shw_out.w,ical,lstrike)
c      Check if still inside volume
       if (.not.lstrike) then
c      We step out of volume;
c      step limitation due to geometry;
c      move step back and try to find exit from the volume
        call ucopy(shw_out.w,w,WTRACK_WORD)
        w.x = w.x - xyz_global(1)
        w.y = w.y - xyz_global(2)
        w.z = w.z - xyz_global(3)
        call emcal_find_path(w,ical,0,w,exit)
        step = sngl(exit)
        if (step .eq. 0.) then
c      Can't find exit; collect hits and break the loop !
         shw_out.N_radlen_pass = dble(step_tmp)
         shw_out.w.y  = w.x
         shw_out.w.y  = w.y
         shw_out.w.z  = w.z
         shw_out.w.e  = 0.
         shw_out.w.px = 0.
         shw_out.w.py = 0.
         shw_out.w.pz = 0.
         shw_out.w.pt = 0.
         shw_out.w.p  = 0.
         if (hit_generation) then
          do ical_collect = 0, emcal_num-1
           if (lstrike_cal(ical_collect+1))
     &	   call Collect_shower_hits(%val(ical_collect),
     &                 %val(num_hit_previous(ical_collect+1)), 
     &                 %val(shw_in.hep)) 
          end do             
         end if
         return
        end if
       end if

c     No anomalies, do "regular" shower generation

c     Update # of X0 passed by the shower, if any
       step_tmp = step_tmp + step / mtl_par(material).rad_len

c      Below is a temporary fix min(step_tmp,40.) to avoid floating point 
c      exception failing;
c      Fix maybe NOT final if we come up with better solution

       if (abs(id_part) .eq. 11 .or. abs(id_part) .eq. 22) then
c     Electron/Gamma case
         sigma_n = -1. 
     *           / ( (60.0/rm)*exp((-1.0/rm)*min(step_tmp,40.))
     *           +     2.     *exp( -0.02   *min(step_tmp,40.)) )
         sigma_w = -1. 
     *           / ( (5.0/rm)*exp(-0.25*min(step_tmp,40.)) )
         amp_ratio = 0.01 * min(step_tmp,40.)
c     The deposition point inside EMC volume
         call em_long_prof(step_tmp,e_start_shw,alpha_em,beta_em,e_now)
       else 
c     Hadron case
         sigma_n = -1. 
     *           / (exp(-0.700 - 0.364*min(step_tmp,40.))
     *           +  exp(-0.560 - 0.060*min(step_tmp,40.)))
         sigma_w = -1. / exp(-2.500 - 0.250*min(step_tmp,40.))
         if (sigma_w .lt. -2000.) sigma_w = -2000.
         amp_ratio = exp(-1.750 - 0.450*min(step_tmp,40.))
         lambda = step_tmp*mtl_par(material).rad_len
     *          / mtl_par(material).abs_len
         call had_long_prof(step_tmp,lambda,e_start_shw,
     *                      alpha_had,beta_had,c_had,d_had,w_had,
     *                      e_now)
       end if
       if (e_now .gt. e_start_shw) then
        e_now = e_start_shw
       end if
       e_dep = e_now - e_before 
       e_before = e_now
       if (e_dep .gt. e_current) e_dep = e_current
       e_current = e_current - e_dep
c   If the remaining enery is less that min.visible energy
c   deposit it here, too
       if (e_current .lt. e_vis_min) then
        e_dep = e_dep + e_current
        e_current = 0.
       end if

       amp_thresh    = amp_ratio*sigma_w
     *               / (amp_ratio*sigma_w+sigma_n)

       if (e_dep .gt. 0.) then
c     Define hit position (in a middle of the step, i.e. a half step back)
        xyz_local(3) = - 0.5*dble(step)
c     Redefine deposited energy with respect to
c     sampling ratio, e/pi ratio, and resolution formula
cc--  NOTE : it's still under question how we want to do the smearing
cc--         e_dep_scaled = (e_dep 
cc--     *                +  sqrt(e_dep*ares**2+(e_dep*bres)**2)*get_gauss(0))
cc--     *                *  sampling_factor
        e_dep_scaled = e_dep * sampling_factor * smear_factor
        if (e_dep_scaled .lt. 0.) e_dep_scaled = 0.
       end if

       if (e_dep_scaled .gt. 0.) then
c     Do transverse profile generation and updates for non-zero e_dep_scaled only !
        ndep = min(int(e_dep_scaled/e_vis_min),max_ndep)       

        if (ndep .gt. 1 .and. shw_trans) then

         e_dep_scaled = e_dep_scaled/float(ndep)
c     Distribute dep. energy according to shower trans. profile if needed
         do i = 1,ndep
          if (abs(id_part) .eq. 11 .or. abs(id_part) .eq. 22) then
c     Electron/Gamma case
           call shw_trans_prof(rlim_em*rm,sigma_n,sigma_w,amp_thresh,
     *                        r_dep,phi_dep)
          else
c     Hadron case
           call shw_trans_prof(rlim_had*rm,sigma_n,sigma_w,amp_thresh,
     *                        r_dep,phi_dep)
          end if
          r_dep = r_dep * mtl_par(material).rad_len
          xyz_local(1) = dble(r_dep * cos(phi_dep))
          xyz_local(2) = dble(r_dep * sin(phi_dep))
c     Reconvert to global system
          call rotate_to_global(xyz_local,
     *                          cos_phi_part,sin_phi_part,
     *                          cos_theta_part,sin_theta_part,
     *                          xyz_global)
          call ucopy(shw_out.w, w, WTRACK_WORD)             
          w.x = w.x + xyz_global(1)
          w.y = w.y + xyz_global(2)
          w.z = w.z + xyz_global(3)
          call emcal_find_ical(w,ical,lstrike)
          if (lstrike) then
           ical_fill = ical
          else
           call emcal_get_ical(w,ical_fill)
          end if
c     Do hit generation only for "sensitive" calorimeters 
c     and if 'hit_generation' is ON !
          if (ical_fill .gt. 0) then 
            if (emcal_par(ical_fill).type .le. 100 .and.
     *         hit_generation) then
c     Find eta_phi cell
            if (abs(id_part) .eq. 11 .or. abs(id_part) .eq. 22) then
             call emcal_find_cell(ical_fill,e_dep_scaled,w.x,'EM')
            else
             call emcal_find_cell(ical_fill,e_dep_scaled,w.x,'HAD')
            end if
            lstrike_cal(ical_fill) = .TRUE.
           end if
	  end if
         end do

        else

c     Apply the deposited energy at the point

c     Reconvert to global system
         call rotate_to_global(xyz_local,
     *                         cos_phi_part,sin_phi_part,
     *                         cos_theta_part,sin_theta_part,
     *                         xyz_global)
         call ucopy(shw_out.w, w, WTRACK_WORD)             
         w.x = w.x + xyz_global(1)
         w.y = w.y + xyz_global(2)
         w.z = w.z + xyz_global(3)
         call emcal_find_ical(w,ical,lstrike)
         if (lstrike) then
          ical_fill = ical
         else
          call emcal_get_ical(w,ical_fill)
         end if
c     Do hit generation only for "sensitive" calorimeters 
c     and if 'hit_generation' is ON !
         if (ical_fill .gt. 0) then
          if (emcal_par(ical_fill).type .le. 100 .and.
     *        hit_generation) then
c     Find eta_phi cell
           if (abs(id_part) .eq. 11 .or. abs(id_part) .eq. 22) then
            call emcal_find_cell(ical_fill,e_dep_scaled,w.x,'EM')
           else
            call emcal_find_cell(ical_fill,e_dep_scaled,w.x,'HAD')
           end if
           lstrike_cal(ical_fill) = .TRUE.
          end if
	 end if
        end if
       end if

c Update energy, momentum, and # of rad.lengths passed
       if (e_dep .gt. 0.) then
        shw_out.w.E  = e_current
        shw_out.w.px = shw_out.w.px 
     *               * shw_out.w.E/(shw_out.w.E+e_dep)
        shw_out.w.py = shw_out.w.py 
     *               * shw_out.w.E/(shw_out.w.E+e_dep)
        shw_out.w.pz = shw_out.w.pz 
     *               * shw_out.w.E/(shw_out.w.E+e_dep)
        shw_out.w.pt = shw_out.w.pt 
     *               * shw_out.w.E/(shw_out.w.E+e_dep)
        shw_out.w.p  = shw_out.w.p  
     *               * shw_out.w.E/(shw_out.w.E+e_dep)
        shw_out.N_radlen_pass = dble(step_tmp)
       end if

c Reset lstrike if needed
       call emcal_find_ical(shw_out.w, ical, lstrike)

      end do

c     OK, we come here if either :
c     1. e_current .le. e_thresh => pick up the remaining energy and deposit here
c     2. shower core is about the leave the CAL volume => collect hits and give up
c     3. both the above => collect hits and give up

      if (lstrike) then
c     We're still inside the CAL volume, 
c     i.e. we get here because the remaining energy 
c     is below threshold (=5% of the original energy) 

c     Check if energy and/or momentum still above minimum visible energy
       if (e_current .le. e_vis_min) then
c     If not, pick up the remaining energy and deposite right here
        e_dep = e_current
        e_current = 0.
        step = 0.
       else
c     Find exit (remaining path length) for particles of reasonable energies
        call emcal_find_path(shw_out.w,ical,0,shw_out.w,exit)
        step = sngl(exit)
       end if

       if (step .le. 0.) then
c      Can't find exit or energy is too low; collect hits and break the loop !
         shw_out.N_radlen_pass = dble(step_tmp)
         shw_out.w.y  = w.x
         shw_out.w.y  = w.y
         shw_out.w.z  = w.z
         shw_out.w.e  = 0.
         shw_out.w.px = 0.
         shw_out.w.py = 0.
         shw_out.w.pz = 0.
         shw_out.w.pt = 0.
         shw_out.w.p  = 0.
         if (hit_generation) then
          do ical_collect = 0, emcal_num-1
           if (lstrike_cal(ical_collect+1))
     &	   call Collect_shower_hits(%val(ical_collect),
     &                 %val(num_hit_previous(ical_collect+1)), 
     &                 %val(shw_in.hep)) 
          end do             
         end if
         return
       end if 

c     Update # of X0 passed by the shower
       step_tmp = step_tmp + step / mtl_par(material).rad_len

c      Below is a temporary fix min(itsep_tmp,40.) to avoid floating 
c      point exception failing;
c      Fix maybe NOT final if we come up with better solution

       if (abs(id_part) .eq. 11 .or. abs(id_part) .eq. 22) then
c     Electron/Gamma case
        call em_long_prof(step_tmp,e_start_shw,
     *                    alpha_em,beta_em,e_now)
        step_tmp = step_tmp - step / mtl_par(material).rad_len
	step_tmp = step_tmp + min((step/mtl_par(material).rad_len),1.)
        sigma_n = -1. 
     *          / ( (60.0/rm)*exp((-1.0/rm)*min(step_tmp,40.))
     *          +     2.     *exp( -0.02   *min(step_tmp,40.)) )
        sigma_w = -1. 
     *          / ( (5.0/rm)*exp(-0.25*min(step_tmp,40.)) )
        amp_ratio = 0.01 * min(step_tmp,40.)
       else
c     Hadron case
        lambda = step_tmp * mtl_par(material).rad_len
     *         / mtl_par(material).abs_len
         call had_long_prof(step_tmp,lambda,e_start_shw,
     *                      alpha_had,beta_had,c_had,d_had,w_had,
     *                      e_now)
        step_tmp = step_tmp - step / mtl_par(material).rad_len
	step_tmp = step_tmp + min((step/mtl_par(material).rad_len),1.)
        sigma_n = -1. 
     *          / (exp(-0.700 - 0.364*min(step_tmp,40.))
     *          +  exp(-0.560 - 0.060*min(step_tmp,40.)))
        sigma_w = -1. / exp(-2.500 - 0.250*min(step_tmp,40.))
        if (sigma_w .lt. -2000.) sigma_w = -2000.
        amp_ratio = exp(-1.750 - 0.450*min(step_tmp,40.))
       end if

       if (e_now .gt. e_start_shw) then
        e_now = e_start_shw
       end if
       e_dep = e_now - e_before
       e_before = e_now
       if (e_dep .gt. e_current) e_dep = e_current
       e_current = e_current - e_dep
c   If the remaining enery is less that min.visible energy
c   deposit it here, too
       if (e_current .lt. e_vis_min) then
        e_dep = e_dep + e_current
        e_current = 0.
       end if

       amp_thresh    = amp_ratio*sigma_w
     *               / (amp_ratio*sigma_w+sigma_n)

       xyz_local (1) = 0.
       xyz_local(2) = 0.
       if (e_current .gt. 0.) then
        xyz_local(3) = -0.5*dble(step)
       else
        xyz_local(3) = dble(-0.5*min(step,mtl_par(material).rad_len))
       end if

       if (e_dep .gt. 0.) then
c     Do smearing for non-zero e_dep only !
c     Redefine deposited energy with respect to 
c     sampling ratio, e/pi ratio, and resolution formula
cc--  NOTE : it's still under question how we want to do the smearing
cc--         e_dep = (e_dep 
cc--     *         +  sqrt(e_dep*ares**2+(e_dep*bres)**2)*get_gauss(0))
cc--     *         *  sampling_factor
        e_dep_scaled = e_dep * sampling_factor * smear_factor
        if (e_dep_scaled .lt. 0.) e_dep_scaled = 0.
       end if

       if (e_dep_scaled .gt. 0.) then
c     Do transverse profile generation for non-zero e_dep_scaled only !
        ndep = min(int(e_dep_scaled/e_vis_min),max_ndep)

        if (ndep .gt. 1 .and. shw_trans) then
         e_dep_scaled = e_dep_scaled/float(ndep)
c     Distribute dep. energy according to shower trans. profile if needed
         do i = 1,ndep
          if (abs(id_part) .eq. 11 .or. abs(id_part) .eq. 22) then
c     Electron/Gamma case
           call shw_trans_prof(rlim_em*rm,sigma_n,sigma_w,amp_thresh,
     *                         r_dep,phi_dep)
          else
c     Hadron case
           call shw_trans_prof(rlim_had*rm,sigma_n,sigma_w,amp_thresh,
     *                         r_dep,phi_dep)
          end if
          r_dep = r_dep * mtl_par(material).rad_len
          xyz_local(1) = r_dep * cos(phi_dep)
          xyz_local(2) = r_dep * sin(phi_dep)
c     Reconvert to global system
          call rotate_to_global(xyz_local,
     *                          cos_phi_part,sin_phi_part,
     *                          cos_theta_part,sin_theta_part,
     *                          xyz_global)
          call ucopy(shw_out.w, w, WTRACK_WORD)             
          w.x = w.x + xyz_global(1)
          w.y = w.y + xyz_global(2)
          w.z = w.z + xyz_global(3)
          call emcal_find_ical(w,ical,lstrike)
          if (lstrike) then
           ical_fill = ical
          else
           call emcal_get_ical(w,ical_fill)
          end if
c     Do hit generation only for "sensitive" calorimeters 
c     and if 'hit_generation' is ON !
          if (ical_fill .gt. 0) then 
           if (emcal_par(ical_fill).type .le. 100 .and.
     *         hit_generation) then
c     Find eta_phi cell
            if (abs(id_part) .eq. 11 .or. abs(id_part) .eq. 22) then
             call emcal_find_cell(ical_fill,e_dep_scaled,w.x,'EM')
            else
             call emcal_find_cell(ical_fill,e_dep_scaled,w.x,'HAD')
            end if
            lstrike_cal(ical_fill) = .TRUE.
           end if
	  end if
         end do

        else
c     Apply the deposited energy at the point
         xyz_local(1) = 0.
         xyz_local(2) = 0.
         call rotate_to_global(xyz_local,
     *                         cos_phi_part,sin_phi_part,
     *                         cos_theta_part,sin_theta_part,
     *                         xyz_global)
         call ucopy(shw_out.w, w, WTRACK_WORD)             
         w.x = w.x + xyz_global(1)
         w.y = w.y + xyz_global(2)
         w.z = w.z + xyz_global(3)
         call emcal_find_ical(w,ical,lstrike)
         if (lstrike) then
          ical_fill = ical
         else
          call emcal_get_ical(w,ical_fill)
         end if
c     Do hit generation only for "sensitive" calorimeters 
c     and if 'hit_generation' is ON !
         if (ical_fill .gt. 0) then
          if (emcal_par(ical_fill).type .le. 100 .and.
     *        hit_generation) then
c     Find eta_phi cell
           if (abs(id_part) .eq. 11 .or. abs(id_part) .eq. 22) then
            call emcal_find_cell(ical_fill,e_dep_scaled,w.x,'EM')
           else
            call emcal_find_cell(ical_fill,e_dep_scaled,w.x,'HAD')
           end if
           lstrike_cal(ical_fill) = .TRUE.
          end if
	 end if

        end if

       end if

c     Update "shower-w-struct" as it stops or leaves CAL volume

       shw_out.w.E  = e_current
       shw_out.w.px = shw_out.w.px * shw_out.w.E/(shw_out.w.E+e_dep)
       shw_out.w.py = shw_out.w.py * shw_out.w.E/(shw_out.w.E+e_dep)
       shw_out.w.pz = shw_out.w.pz * shw_out.w.E/(shw_out.w.E+e_dep)
       shw_out.w.pt = shw_out.w.pt * shw_out.w.E/(shw_out.w.E+e_dep)
       shw_out.w.p  = shw_out.w.p  * shw_out.w.E/(shw_out.w.E+e_dep)
       shw_out.N_radlen_pass = dble(step_tmp)

      end if


      if (hit_generation) then
       do ical_collect = 0, emcal_num-1
        if (lstrike_cal(ical_collect+1))
     &	call Collect_shower_hits(%val(ical_collect),
     &              %val(num_hit_previous(ical_collect+1)), 
     &                        %val(shw_in.hep)) 
       end do             
      end if

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:28  eugenio
c Initial revision
c
c Revision 1.20  1998/06/09 23:14:22  yarba_j
c fixed energy deposition on shower tail; commented out e/h ratio dependnce on incident energy; minor cleanup
c

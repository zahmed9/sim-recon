      integer function trk_trace_central(hep, lifetime)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Trace a track through the r-cylinders in the central direction, with
c   multiple scattering and energy loss at each material cylinder.
c
c  Inputs:
c  hep       integer variable
c            Position of track in HEPEVT list
c
c  lifetime  DFLOAT variable
c            proper lifetime if the particle will decay
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "path_struct.inc"
#include "bfield_struct.inc"
#include "trace.inc"
#include "trace_central.inc"
#include "trace_params.inc"
#include "trace_types.inc"
#include "trace_path.inc"
#include "rplane.inc"
#include "solenoid.inc"
#include "detector_region.inc"
#include "volume.inc"
#include "stdhep.inc"
#include "vtxhep.inc"
#include "si_barrel.inc"

c     Externals
      external trk_trace_gamma
      external move_wtk_radius, move_wtk_arc
      external move_wtk_zplane, move_wtk_xyplane
      external trk_add_final_trace, trk_add_rpln_trace
      external trk_add_dummy_trace, trk_brem_photon, trk_sec_int
      external wtk_radius_curvature
      external geo_in_detector, shw_conv_point

      integer  trk_trace_gamma
      integer  move_wtk_radius, move_wtk_arc
      integer  move_wtk_zplane, move_wtk_xyplane
      integer  trk_add_final_trace, trk_add_rpln_trace
      integer  trk_add_dummy_trace, trk_brem_photon, trk_sec_int
      DFLOAT   wtk_radius_curvature
      integer  geo_in_detector, shw_conv_point

c     Calling arguments
      integer hep
      DFLOAT lifetime

c     Local variables
      integer id, status, i, j, ipln, first_r, plane, planes(2), convert
      integer error, lyr, dev, type, hit
      logical ltrace, lsame, lstrike, lstrikes(2)
      DFLOAT r, radius, radius_save, radl, dedx
      DFLOAT arc, eta(3), etas(3,2), chrg, mass, s3d

      integer ical, int_type
      DFLOAT coll, absl, wtime

      integer istep, nstep, nstep1, nstep2, trace_save, direct
      DFLOAT rcurve, angle, step, tconv
      DFLOAT zmin_sol, zmax_sol, zmin_det, zmax_det
      DFLOAT zexit, s3d_z, xpos(3)
      integer backup_z

      record /wtrack_struct/ w, w1, w2, wsave, wbrem
      record /path_struct/ path
      record /bfield_struct/ bf
      record /path_list_struct/ path_list
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(hep.le.0 .or. hep.gt.nhep) goto 9999     !Require track in range
      if(isthep(hep) .ne. 1) goto 9999            !Particle must be stable

c     Don't trace neutrinos
      id = idhep(hep)
      if(abs(id).eq.12 .or. abs(id).eq.14 .or.abs(id).eq.16) then
        status = 0
        goto 1000
      endif

      if(sol_num .gt. 0) then
        zmin_sol = sol_par(1).zmin
        zmax_sol = sol_par(1).zmax
      else
        zmin_sol = -1.e10
        zmax_sol =  1.e10
      endif
      zmin_det = det_reg.zmin
      zmax_det = det_reg.zmax

      call hep_to_w(hep, w1)                      !Create track parameters
      call ucopy(w1, w, WTRACK_WORD)              !Save initial track

      path.arc = 0.                               !Total path length
      path.time = vtx_pos(4,ipvhep(hep)) / clight !Set initial clock
      path.tau = 0.                               !Total proper time
      call vzero(path_list, PATH_LIST_WORD)

c     Find first radial plane to trace to
      r = sqrt(w.x**2 + w.y**2)
      radius = r
      do i=1,rpln_num
        ipln = rpln_up(i)
        if(rpln_par(ipln).radius .gt. r) goto 50
      enddo
      status = 0
      goto 1000

  50  first_r = i

      if (abs(id) .eq. 11) then
         mass = 0.000511
      else if (abs(id) .eq. 13) then
         mass = 0.105658
      else
         mass = phep(5,hep)
      end if


      chrg = w.q

c  **************************************************************************
c     Trace track until we exit tracking volume

      do i=first_r,rpln_num

        trace_save = trace_cent_num

c     Check to see if track is still in tracking volume
        if(geo_in_detector(w.x) .eq. 0) goto 1000

        ipln = rpln_up(i)

        type = rpln_par(ipln).type
c
        radl = rpln_par(ipln).radl
        dedx = rpln_par(ipln).dedx

c
c  add collision length to see if secondary interacion occurs
	coll = rpln_par(ipln).col 
	absl = rpln_par(ipln).abs 
	
c     Check if track should be traced to this layer
        if(chrg .ne. 0.) then
          ltrace = trk_lhits .or. (radl.ne.0. .or. dedx.ne.0.) !Charged
        else if(id .eq. 22) then
c
c  type.eq.jrpl_emcaladded 
c  because radl & dedx set to 0. for EMCAL 
c
          ltrace = radl.ne.0. .or. dedx.ne.0. .or.          !Gammas
     *             type .eq. jrpl_emcal

        else
          ltrace = radl.ne.0. .or. dedx.ne.0. .or.              !Other neutrals
     *             type .eq. jrpl_emcal       
        endif

c       Always go to last plane and to field boundaries
c -        ltrace = ltrace .or. (i.eq.rpln_num) .or. type.eq.jrpl_magnet
        ltrace = ltrace .or. (i.eq.rpln_num) 
        if(.not.ltrace) goto 100

        radius_save = radius
        radius = rpln_par(ipln).radius
        lsame = radius .eq. radius_save
        dev = rpln_par(ipln).pos(1)
        lyr = rpln_par(ipln).pos(2)

        ical = 0

c       Get B field
 70     call trk_next_bfield(w, bf)

c     Only move track if radius is different (e.g., double sided silicon)
        if(.not.lsame) then
          rcurve = wtk_radius_curvature(w, bf)  !Radius of curvature
          direct = 1
          if (w.x**2 + w.y**2 .gt. radius**2) then
             direct = -1
          endif
          status = move_wtk_radius(w, radius, direct, bf, w2, s3d)
          if(status .ne. 0) goto 1000
          angle = s3d * (w.pt/w.p) / rcurve
          nstep1 = int(s3d/step_max_distance) + 1
          nstep2 = int(angle/step_max_angle) + 1   
          nstep = max(nstep1, nstep2)
          if(w.q*bf.bmag .eq. 0.) nstep = 1
          if(direct .lt. 0) nstep = 1
          if (nstep .gt. 1000) nstep = 1000
          step = s3d / nstep

c     Move the track in steps (if more than 1 needed)
          do istep=1,nstep
            status = move_wtk_arc(w, step, bf, w)
            if(status .ne. 0) goto 1000

            call path_update(w, mass, step, path)  !Update path info

c     Check to see if track exited in z from solenoid or detector.
c     If so, move it to the exit point.
c     This is kind of a kludge
            backup_z = 0
            if(w.q*bf.bmag .ne. 0.) then    !Charged tracks in B field
              if(w.z .le. zmin_sol) then
                backup_z = 1
                zexit = zmin_sol
              else if(w.z .ge. zmax_sol) then
                backup_z = 1
                zexit = zmax_sol
              endif
            else                            !No field or neutrals
              if(w.z .le. zmin_det) then
                backup_z = 2
                zexit = zmin_det
              else if(w.z .ge. zmax_det) then
                backup_z = 2
                zexit = zmax_det
              endif
            endif

            if(backup_z .gt. 0) then
              status = move_wtk_zplane(w, zexit, bf, w, s3d_z)
              call path_update(w, mass, s3d_z, path)
              if(.not. trk_ldecays .or. path.tau.le.lifetime) then
                status = trk_add_dummy_trace(hep, w, path, 1)
                if(status .ne. 0) goto 9998
              endif
            endif

c     If track decays during the move, move it to the place where it
c     will decay and do the decay.
            if(path_list.shower .eq. 0) then
             if(trk_ldecays .and. path.tau.gt.lifetime) then
               arc = (path.tau - lifetime) * (w.p * clight) / mass
               call path_update(w, mass, -arc, path)
               path.tau = lifetime
               status = move_wtk_arc(w, -arc, bf, w)
               status = trk_add_final_trace(hep, w, 0, path, 1,
     *                                      jtrace_decay)
               if(status .ne. 0) goto 9998
               path_list.decay = trace_cent_num
               goto 1000        !We're done with this track
             endif
            endif
          
c     Quit if exiting detector
c     If exited solenoid, try the jump again from the exit point
            if(backup_z .eq. 2) then
              goto 1000
            else if(backup_z .eq. 1) then
              goto 70
            endif

c     If multiple steps are made, save the intermediate points in
c     the trace list.
            if(istep .ne. nstep) then
              status = trk_add_dummy_trace(hep, w, path, 1)
              if(status .ne. 0) goto 9998
            endif

          enddo

        endif

c     Barrel silicon layer ... find which plane was hit
c     This portion of the code allows overlapping strips, so it finds
c     2 planes.
        if(type .eq. jrpl_sibarrel) then

          call trk_find_bsil_plane(w, path.arc, bf, dev, lyr, planes, 
     *                             lstrikes, etas)

          do j=1,2
            if(lstrikes(j)) then

c     Move the track to the plane
              xpos(1) = sib_par(dev).lyr(lyr).plane(planes(j)).xpos(1)
              xpos(2) = sib_par(dev).lyr(lyr).plane(planes(j)).xpos(2)
              xpos(3) = sib_par(dev).lyr(lyr).plane(planes(j)).xpos(3)
              status = move_wtk_xyplane(w, xpos, etas(1,j), bf, w, s3d)
              call path_update(w, mass, s3d, path)  !Update path info

              if(chrg .ne. 0.) then
                call trk_make_bsil_hit(hep, trace_cent_num+1, w, dev,
     *                         lyr, planes(j), bf, hit, error)

                if(error .eq. 1) goto 9999
              else if(trk_lpair .and. id .eq. 22) then
                hit = 0
                status = trk_trace_gamma(hep, path, w, 1, ipln, convert)
                if(status .ne. 0) goto 9999
                if(convert .ne. 0) then
                  path_list.convert  = trace_cent_num
                  goto 1000
                endif
              else
                hit = 0
              endif
              status = trk_add_rpln_trace(hep, w, ipln, 
     *                                    etas(1,j), path, hit)
              if(status .ne. 0) goto 9998

c     Secondary interactions of hadrons
            if(trk_lint .and. coll .gt. 0.0 .and. abs(id).gt.100 ) then
                wtime = path.time
                status = trk_sec_int(w,hep,coll,absl,etas(1,j),
     *		                     wtime,w,int_type)         
                if(int_type.eq.2.or.w.p.eq.0) then
                  go to 1000
                endif
             endif 
	       
c     Scatter and energy correct charged track
              if(chrg .ne. 0. .and. (trk_lscat .or. trk_ldedx)) then
                if(.not.trk_lscat) radl = 0.
                if(.not.trk_ldedx) dedx = 0.
                if(abs(id) .ne. 11) then
                  call wtk_mscat_dedx(w, radl, dedx, eta, w)
                  if(w.p .eq. 0.) goto 1000

c     If electron, make brem event and add photon to the HEPEVT list
                else
                  call ucopy(w, wsave, WTRACK_WORD)
                  call wtk_mscat_brem_elec(w, radl, eta, trk_min_brem,
     *                                     w)
                  if(wsave.p .gt. w.p) then
                    call wtk_photon_brem(wsave, w, wbrem)
                    status = trk_brem_photon(hep, wbrem, path)
                    if(status .ne. 0) goto 9998
                  endif
                  if(w.p .eq. 0.) goto 1000
                endif
              endif

            endif
          enddo

c     Drift chamber anode
        else if(type .eq. jrpl_drf_anode) then
          if(chrg .ne. 0.) then
            call trk_make_drift_hit(hep, trace_cent_num+1, w, dev,
     *                          lyr, bf, hit, error)
            if(error .eq. 1) goto 9999

            eta(1) = w.x / radius
            eta(2) = w.y / radius
            eta(3) = 0.
            status = trk_add_rpln_trace(hep, w, ipln, eta, path, hit)
            if(status .ne. 0) goto 9998
          else if(trk_lpair .and. id .eq. 22) then
            hit = 0
            status = trk_trace_gamma(hep, path, w, 1, ipln, convert)
            if(status .ne. 0) goto 9999
            if(convert .ne. 0) then
               path_list.convert  = trace_cent_num
               goto 1000
            endif
          endif

c     EM calorimeter... shower electrons, photons, and hadrons; 
c                       muons deposit energy
        else if(type .eq. jrpl_emcal) then
          ical = dev
          call emcal_find_ical(w, ical, lstrike)
          if (lstrike) then
           status = trk_add_final_trace(hep, w, ipln, path, 1, 
     &                                  jtrace_calor)
           if (status .ne. 0) goto 9998
           if (path_list.shower .eq. 0.) then
             status = shw_conv_point(id,ical,w,tconv,w1)
             if (tconv .gt. 0. .and. status .eq. 0) then
              call ucopy(w1, w, WTRACK_WORD)
              call path_update(w, mass, tconv, path)  !Update path info
c     If track decays during the move, move it to the place where it
c     will decay and do the decay.
              if(trk_ldecays .and. path.tau .gt. lifetime) then
                 arc = (path.tau - lifetime) * (w.p * clight) / mass
                 call path_update(w, mass, -arc, path)
                 path.tau = lifetime
                 status = move_wtk_arc(w, -arc, bf, w)
                 status = trk_add_final_trace(hep, w, 0, path, 1,
     *                                      jtrace_decay)
                 if(status .ne. 0) goto 9998
                 path_list.decay = trace_cent_num
                 goto 1000        !We're done with this track
              else
                 status = trk_add_final_trace(hep, w, ipln, path, 1, 
     *                    jtrace_shower)
                 if (status .ne. 0) goto 9998
                 path_list.shower = trace_cent_num
              endif
             end if
           end if
          endif

c     Magnet boundary
        else if(type .eq. jrpl_magnet) then
          hit = 0
          eta(1) = w.x / radius
          eta(2) = w.y / radius
          eta(3) = 0.
          status = trk_add_rpln_trace(hep, w, ipln, eta, path, hit)
          if(status .ne. 0) goto 9998

c     Material
        else if(type .eq. jrpl_material) then
          if(w.z.ge.vol_par(dev).zmin .and.
     *       w.z.le.vol_par(dev).zmax .and.
     *       radl.ne.0.) then
            hit = 0
            eta(1) = w.x / radius
            eta(2) = w.y / radius
            eta(3) = 0.

c     Multiple scattering or pair conversion
            if(trk_lpair .and. id .eq. 22) then
c
             if (path_list.shower .eq. 0) then
               status = trk_trace_gamma(hep, path, w, 1, ipln, convert)
               if(status .ne. 0) goto 9999
               if(convert .ne. 0) then
                path_list.convert  = trace_cent_num
                goto 1000
               endif                
              end if
            endif
            status = trk_add_rpln_trace(hep, w, ipln, eta, path, hit)
            if(status .ne. 0) goto 9998

c     Secondary interactions of hadrons
            if(trk_lint .and. coll .gt. 0.0 .and. abs(id).gt.100 ) then
                wtime = path.time
                status = trk_sec_int(w,hep,coll,absl,eta,wtime,w,
     *		                     int_type)         
                if(int_type.eq.2.or.w.p.eq.0) then
                  go to 1000
                endif
             endif 
	       
c     Scatter and energy correct charged track
            if(chrg .ne. 0. .and. (trk_lscat .or. trk_ldedx)) then
              if(.not.trk_lscat) radl = 0.
              if(.not.trk_ldedx) dedx = 0.
              if(abs(id) .ne. 11) then
                call wtk_mscat_dedx(w, radl, dedx, eta, w)
                if(w.p .eq. 0.) goto 1000

c     If electron, make brem event and add photon to the HEPEVT list
              else
                call ucopy(w, wsave, WTRACK_WORD)
                call wtk_mscat_brem_elec(w, radl, eta, trk_min_brem, w)
                if(wsave.p .gt. w.p) then
                  call wtk_photon_brem(wsave, w, wbrem)
                  status = trk_brem_photon(hep, wbrem, path)
                  if(status .ne. 0) goto 9998
                endif
                if(w.p .eq. 0.) goto 1000
              endif
            endif

          endif

        endif

c     Add trace if last layer and nothing added
 100    continue
        if(i.eq. rpln_num .and. trace_save .eq. trace_cent_num) then
          status = trk_add_dummy_trace(hep, w, path, 1)
        endif

      enddo

c     Normal return
 1000 trk_trace_central = 0
      if (trace_cent_num .gt. trace_save) then
        path_list.end_trace = trace_cent_num
      endif
      return


c     Too many track intersections
 9998 trk_trace_central = 1
      return

c     Too many hits
 9999 trk_trace_central = 2
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:39  eugenio
c Initial revision
c
c Revision 1.14  1998/02/13 16:14:55  mcbride
c merged changes from v2_6_2 into dev
c
c Revision 1.13  1997/04/04  20:30:33  garren
c add rcs log line
c

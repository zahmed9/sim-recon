      integer function trk_trace_forward(hep, lifetime)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Trace a track through the z-planes in the forward direction, with
c   multiple scattering and energy loss at each material plane.
c
c  Inputs:
c  hep       integer variable
c            Position of track in HEPEVT list
c
c  lifetime  DFLOAT variable
c            proper lifetime if the particle will decay
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none
      
#include "mcp_summary.inc"
#include "const.inc"
#include "wtrack_struct.inc"
#include "path_struct.inc"
#include "bfield_struct.inc"
#include "trace.inc"
#include "trace_forward.inc"
#include "trace_params.inc"
#include "trace_types.inc"
#include "trace_path.inc"
#include "for_trk.inc"
#include "zplane.inc"
#include "solenoid.inc"
#include "devtype.inc"
#include "volume.inc"
#include "stdhep.inc"
#include "vtxhep.inc"
#include "dipole.inc"
#include "emcal.inc"

c     Externals
      external trk_trace_gamma, trk_add_final_trace
      external move_wtk_zplane, move_wtk_arc
      external geo_in_detector, shw_conv_point
      external trk_add_zpln_trace, trk_add_dummy_trace
      external trk_brem_photon, trk_sec_int
      external wtk_radius_curvature, wtk_max_radius
      external move_wtk_radius

      integer  trk_trace_gamma, trk_add_final_trace
      integer  move_wtk_zplane, move_wtk_arc
      integer  geo_in_detector, shw_conv_point
      integer  trk_add_zpln_trace, trk_add_dummy_trace
      integer  trk_brem_photon, trk_sec_int
      DFLOAT   wtk_radius_curvature, wtk_max_radius
      integer  move_wtk_radius

c     Calling arguments
      integer hep
      DFLOAT lifetime

c     Local variables
      integer id, status, i, j, ipln, first_z, plane, convert
      integer error, dev, lyr, wfr, type, hit, idau1, idip
      integer inc, last_z, iwedge, jwedge
      logical ltrace, lsame, lstrike, lyoke
      DFLOAT z, zcheck, z_save, radl, dedx, xnow(3)
      DFLOAT arc, eta(3), chrg, mass, s3d, tconv
      DFLOAT small_step
      parameter(small_step = 1.e-12)

c     This tolerance was measured using the BTeV EOI detector.
      DFLOAT small_diff
      parameter (small_diff = 0.00001 )

      integer istep, nstep, nstep1, nstep2, trace_save
      DFLOAT rcurve, angle, step, rmax_sol, rsq, pz_save
      DFLOAT zexit, s3d_r, rmax, delta_s, rad
      integer backup_r, strike
      integer dtype, shape

      integer ical, jcal, bdev_save, int_type
      DFLOAT coll, absl, wtime

      DFLOAT tauprod, taudecay, tauyoke
      record /wtrack_struct/ w, w1, w2, wmag, wsave, wbrem
      record /path_struct/ path
      record /bfield_struct/ bf
      record /path_list_struct/ path_list
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(hep.le.0 .or. hep.gt.nhep) goto 9999     !Require track in range

      if(isthep(hep).eq.1) then
        continue
      else if (isthep(hep).eq.2) then
        tauprod = vhep(4,hep)
        idau1 = jdahep(1,hep)
        taudecay = vhep(4,idau1)
        if (taudecay-tauprod.lt.0.001) goto 9999  !Needn't be *too* stable
      else
        goto 9999                                 !Particle must be stable
      end if

c     Don't trace neutrinos
      id = idhep(hep)
      if(abs(id).eq.12 .or. abs(id).eq.14 .or.abs(id).eq.16) then
        status = 0
        goto 1000
      endif

      if(sol_num .gt. 0) then
        rmax_sol = sol_par(1).rmax
      else
        rmax_sol = 1.e10
      endif

      call hep_to_w(hep, w1)                      !Create track parameters
      call ucopy(w1, w, WTRACK_WORD)              !Save initial track

      path.arc = 0.                               !Total path length
      path.time = vtx_pos(4,ipvhep(hep)) / clight !Set initial clock
      path.tau = 0.                               !Total proper time
      call vzero(path_list, PATH_LIST_WORD)

c     Find first z plane to trace to
      zcheck = w.z
      z = w.z
*
*     Trace go go in either increasing z or decreasing z depending on
*       the track's z momentum
*     
      if (w.pz.gt.0) then
        inc = 1                 ! Increment in increasing z direction
        last_z = zpln_num 
        do i=1,zpln_num
          ipln = zpln_up(i)
          if (zpln_par(ipln).z .ge. zcheck) goto 50
        enddo
      else if (w.pz .lt. 0.) then
        inc = -1                ! Increment in decreasing z direction
        last_z = 1
        do i = zpln_num, 1, -1
          ipln = zpln_up(i)
          if (zpln_par(ipln).z .le. zcheck) goto 50
        enddo
      endif
      status = 0
      goto 1000

  50  first_z = i

      if (abs(id) .eq. 11) then
         mass = 0.000511
      else if (abs(id) .eq. 13) then
         mass = 0.105658
      else
         mass = phep(5,hep)
      end if

      chrg = w.q
      bdev_save = 0
      lyoke = .false.                       !Does particle cross dipole yoke
      tauyoke = 0.
c
c  **************************************************************************
c     Trace track until we exit tracking volume

      do i = first_z, last_z, inc

        trace_save = trace_for_num
        pz_save = w.pz
        

C
C     Check to see if track is still in tracking volume
C
        xnow(1) = w.x
	xnow(2) = w.y
	xnow(3) = w.z
        if(geo_in_detector(xnow) .eq. 0) then
           goto 1000
        end if

        ipln = zpln_up(i)
        type = zpln_par(ipln).type
        radl = zpln_par(ipln).radl
        dedx = zpln_par(ipln).dedx
c
c  add collision length to see if secondary interacion occurs
	coll = zpln_par(ipln).col 
	absl = zpln_par(ipln).abs 
	
c     Check if track should be traced to this layer
        if(chrg .ne. 0) then
          ltrace = trk_lhits .or. (radl.ne.0. .or. dedx.ne.0.)   !Charged
        else if(id .eq. 22) then
c
c     type.eq.jzpl_emcal added
c     because radl & dedx set to 0. for EMCAL & HCAL
c
          ltrace = radl.ne.0. .or. dedx.ne.0. .or.
     *             type.eq.jzpl_emcal        
        else
          ltrace = radl.ne.0. .or. dedx.ne.0. .or.              !Other neutrals
     *             type.eq.jzpl_emcal
        endif

c       Always go to last plane and to field boundaries
        ltrace = ltrace .or. (i.eq.last_z) .or. type.eq.jzpl_magnet
        if(.not.ltrace) goto 100

        z_save = z
        z = zpln_par(ipln).z
        lsame = z .eq. z_save
        dev = zpln_par(ipln).pos(1)
        lyr = zpln_par(ipln).pos(2)
        iwedge = zpln_par(ipln).pos(3)
        wfr = zpln_par(ipln).pos(3)

        ical = 0

c       Get B field
 70     call trk_next_bfield(w, bf)

        if ( bf.devnum .ne. bdev_save ) then
          if (w.q.ne.0.0 .and. bf.devtype .eq. 2) 
     &        call trk_find_dipole_exit(w,bf,mass,path,lifetime,
     &             tauyoke,lyoke)
          bdev_save = bf.devnum
        end if

c     Only move track if z is different

        if(.not.lsame) then
          rcurve = wtk_radius_curvature(w, bf)  !Radius of curvature
          rsq    = w.x**2 + w.y**2
          status = move_wtk_zplane(w, z, bf, w2, s3d)
          if (lyoke .and. tauyoke .gt. path.tau) then
            arc = (tauyoke - path.tau) * (w.p * clight) / mass
            if (arc .lt. s3d .or. s3d .eq. 0.0) then
              s3d = arc
              status = move_wtk_arc(w, s3d , bf, w2)
            endif
          endif
          if(status .ne. 0 .or. s3d .eq. 0.) goto 1000
          angle = s3d * (w.pt/w.p) / rcurve
          nstep1 = int(s3d/step_max_distance) + 1 
          nstep2 = int(angle/step_max_angle) + 1 
          nstep = max(nstep1, nstep2)
          if(w.q*bf.bmag .eq. 0.) nstep = 1
          if(nstep .gt. 100) nstep = 100
          step = s3d / nstep

c     Move the track in steps (if more than 1 needed)
          do istep=1,nstep
            rsq    = w.x**2 + w.y**2
            if (istep.ne.nstep) then
              status = move_wtk_arc(w, step, bf, w)
              if(w.pz*pz_save .lt. 0.) goto 1000   ! track has turned around 
            else
              call ucopy(w2, w, WTRACK_WORD)
            end if
            if(status .ne. 0) goto 1000

            call path_update(w, mass, step, path)  !Update path info

c     Check to see if track exited in radius from solenoid
c     If so, move it back to the exit point.
            backup_r = 0
            if(w.q*bf.bmag .ne. 0. .and.bf.type.eq.4) then
              rmax = wtk_max_radius(w, bf)    ! maximum radius of helix from (0,0)
c             check to see if path exits the solenoid              
              if(rsq  .lt. rmax_sol**2 .and. rmax .gt. rmax_sol ) then
                status = move_wtk_radius(w, rmax_sol,-1, bf, wmag,s3d_r) ! back up
                if(status .ne. 0) goto 1000
                if (s3d_r .lt. 0. .and. abs(s3d_r) .lt. step) then
                   delta_s = step + s3d_r       !  should be positive if boundary crossed
                   if((inc.gt.0 .and. wmag.z.lt.z .or.
     *                 inc.lt.0 .and. wmag.z.gt.z) .and.
     *                 delta_s .gt. small_step) then
                       status = move_wtk_zplane(w, wmag.z, bf, w, s3d_r)
                       call path_update(w, mass, s3d_r, path)
                       backup_r = 1
                   endif
                endif
              endif  
            endif

              if(backup_r .gt. 0) then
                if(.not. trk_ldecays .or. path.tau.le.lifetime) then
                  status = trk_add_dummy_trace(hep, w, path, 1)
                  if(status .ne. 0) goto 9998
                endif
              endif

c     If track decays during the move, move it to the place where it
c     will decay and do the decay.
            if(path_list.shower .eq. 0) then
              if(trk_ldecays .and.  path.tau.gt.lifetime) then
                arc = (path.tau - lifetime) * (w.p * clight) / mass
                call path_update(w, mass, -arc, path)
                path.tau = lifetime
                status = move_wtk_arc(w, -arc, bf, w)
                status = trk_add_final_trace(hep, w, 0, path, 2,
     *                                      jtrace_decay)
                if(status .ne. 0) goto 9998
                path_list.decay = trace_for_num
                goto 1000        !We're done with this track

c     If track passes through the dipole yoke, stop tracing (muons exempt)
              else if (lyoke .and. path.tau .ge. tauyoke) then

                if ( abs(id) .eq. 13) then
                  status = trk_add_dummy_trace(hep, w, path, 2)
                  if(status .ne. 0) goto 9998
                  lyoke = .false.
                  goto 70
                endif 
                     
                status = trk_add_final_trace(hep, w, ipln, path, 2,
     *                                     jtrace_absorb)
                if(status .ne. 0) goto 9998
                goto 1000        !We're done with this track
              endif
            endif

            if(backup_r .gt. 0) goto 70

c     If multiple steps are made, save the intermediate points in
c     the trace list.
            if(istep .ne. nstep) then
              status = trk_add_dummy_trace(hep, w, path, 2)
              if(status .ne. 0) goto 9998
            endif

          enddo

        endif

c     XY rectangular pixel plane layer ... find if wafer was hit

        if(type .eq. jzpl_siz_rect) then

          call trk_find_siz_rect(w, dev, lyr, wfr, lstrike, eta)

          if(lstrike .and. wfr .gt. 0 ) then
            if(chrg .ne. 0.) then
              call trk_make_siz_rect_hit(hep, trace_for_num+1, w, dev,
     *                          lyr, wfr, lstrike, hit, error)
              if(error .eq. 1) goto 9999
            else if(trk_lpair .and. id .eq. 22) then
              hit = 0
              status = trk_trace_gamma(hep, path, w, 2, ipln, convert)
              if(status .ne. 0) goto 9999
              if(convert .ne. 0) then
                path_list.convert  = trace_for_num
                goto 1000
              endif
            else
              hit = 0
            endif
            status = trk_add_zpln_trace(hep, w, ipln, eta, path, hit)
            if(status .ne. 0) goto 9998

c     Secondary interactions of hadrons
            if(trk_lint .and. coll .gt. 0.0 .and. abs(id).gt.100 ) then
                wtime = path.time
                status = trk_sec_int(w,hep,coll,absl,eta,wtime,w,
     *		                     int_type)         
                if(int_type.eq.2.or.w.p.eq.0) goto 1000
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
          else
ccc too many traces with this in            
c	    status = trk_add_dummy_trace(hep, w, path, 2)
          endif

c     Si disk layer ... find which plane was hit

        else if(type .eq. jzpl_sidisk) then
          
          call trk_find_sidisk_plane(w, dev, lyr, iwedge, jwedge, 
     *                               lstrike, eta)

          if(lstrike) then
            if(chrg .ne. 0.) then
              call trk_make_sidisk_hit(hep, trace_for_num+1, w, dev,
     *                          lyr, jwedge, lstrike, bf, hit, error)
              if(error .eq. 1) goto 9999
            else if(trk_lpair .and. id .eq. 22) then
              hit = 0
              status = trk_trace_gamma(hep, path, w, 2, ipln, convert)
              if(status .ne. 0) goto 9999
              if(convert .ne. 0) then
                path_list.convert  = trace_for_num
                goto 1000
              endif
            else
              hit = 0
            endif
            status = trk_add_zpln_trace(hep, w, ipln, eta, path, hit)
            if(status .ne. 0) goto 9998

c     Secondary interactions of hadrons
            if(trk_lint .and. coll .gt. 0.0 .and. abs(id).gt.100 ) then
                wtime = path.time
                status = trk_sec_int(w,hep,coll,absl,eta,wtime,w,
     *		                     int_type)         
                if(int_type.eq.2.or.w.p.eq.0) go to 1000
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
          else
            status = trk_add_dummy_trace(hep, w, path, 2)
          endif

c     Forward Drift chamber
        else if(type .eq. jzpl_drift) then

          call trk_find_ftrk_plane(w, dev, lyr, lstrike, eta)
          if (lstrike) then
            if(chrg .ne. 0.) then
              call trk_make_ftrk_hit(hep, trace_for_num+1, w, dev,
     *                          lyr, lstrike, bf, hit, error)
              if(error .eq. 1) goto 9999
            else if(trk_lpair .and. id .eq. 22) then
              hit = 0
              status = trk_trace_gamma(hep, path, w, 2, ipln, convert)
              if(status .ne. 0) goto 9999
              if(convert .ne. 0) then
                path_list.convert  = trace_for_num
                goto 1000
              endif
            else
              hit = 0
            endif
            status = trk_add_zpln_trace(hep, w, ipln, eta, path, hit)
            if(status .ne. 0) goto 9998
          else
            status = trk_add_dummy_trace(hep, w, path, 2)
          endif

c     EM calorimeter... shower electrons, photons, and hadrons;
c     muons do dedx
        else if(type .eq. jzpl_emcal) then
          ical = dev
          call emcal_find_ical(w, ical, lstrike)           
          if (lstrike) then                                            
           status = trk_add_final_trace(hep, w, ipln, path, 2,         
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
                 status = trk_add_final_trace(hep, w, 0, path, 2,
     *                                      jtrace_decay)
                 if(status .ne. 0) goto 9998
                 path_list.decay = trace_for_num
                 goto 1000        !We're done with this track
              else
                 status = trk_add_final_trace(hep, w, ipln, path, 2, 
     *                    jtrace_shower)
                 if (status .ne. 0) goto 9998
                 path_list.shower = trace_for_num
              endif
             end if
           end if
          end if

c     Magnet boundary
        else if(type .eq. jzpl_magnet) then
          hit = 0
          eta(1) = 0.
          eta(2) = 0.
          eta(3) = 1.
          status = trk_add_zpln_trace(hep, w, ipln, eta, path, hit)
          if(status .ne. 0) goto 9998
c         exit if it is a dipole face
          if (zpln_par(ipln).shape .eq. 2) then
             if (dev .gt. 0 .and. dev .le. dip_num) then
               if (w.x .gt. 
     &             dip_par(dev).xmax+dip_par(dev).thick_boun(2) .or. 
     &           w.x .lt. 
     &             dip_par(dev).xmin-dip_par(dev).thick_boun(1) .or. 
     &           w.y .gt. 
     &             dip_par(dev).ymax+dip_par(dev).thick_boun(4) .or. 
     &           w.y .lt. 
     &             dip_par(dev).ymin-dip_par(dev).thick_boun(3))
     &           goto 1000
             endif
             if (abs(id) .ne. 13 .and.
     &          (w.x .gt. zpln_par(ipln).xmax .or. 
     &           w.x .lt. zpln_par(ipln).xmin .or. 
     &           w.y .gt. zpln_par(ipln).ymax .or. 
     &           w.y .lt. zpln_par(ipln).ymin)) goto 1000
          endif

c     Material
        else if(type .eq. jzpl_material) then

          rad = sqrt(w.x**2 + w.y**2)
	  
c Fix for holes in detectors...	  
	  shape = zpln_par(ipln).shape
	  if (zpln_par(ipln).shape .ge. 100) then
	    shape = 2 
	  endif
c Fix for holes in detectors...	
  
          if( abs(w.z-zpln_par(ipln).z).le.small_diff .and.
     &      ((shape.eq.1 .and. rad.ge.zpln_par(ipln).rmin .and.
     &      rad.le.zpln_par(ipln).rmax) .or. (shape.eq.2
     &      .and. w.x.ge.zpln_par(ipln).xmin
     &      .and. w.x.le.zpln_par(ipln).xmax .and. 
     &      w.y.ge.zpln_par(ipln).ymin .and.
     &      w.y.le.zpln_par(ipln).ymax))) then
            
	    lstrike = .true.
	    
c Fix for holes in detectors...	  
	    if (zpln_par(ipln).shape .ge. 100) then
	      dtype  = zpln_par(ipln).shape - 100
	      if (dtype .eq. jzpl_drift) then
      	         call trk_find_ftrk_plane(w, dev, lyr, lstrike, eta)
              else if (dtype .eq. jzpl_material) then	      
	         call trk_find_absorber(w,dev,lstrike)
              endif
	    endif
c Fix for holes in detectors...
	
	    if (lstrike) then
              hit = 0
              eta(1) = 0.
              eta(2) = 0.
              eta(3) = 1.

c     Pair conversion
              if(trk_lpair .and. id .eq. 22) then
               if (path_list.shower .eq. 0) then
                status = trk_trace_gamma(hep, path, w, 2, ipln, convert)
                if(status .ne. 0) goto 9999
                if(convert .ne. 0) then
                  path_list.convert  = trace_for_num
                  goto 1000
                endif                
               end if
c
              endif
              status = trk_add_zpln_trace(hep, w, ipln, eta, path, hit)
              if(status .ne. 0) goto 9998

c     Secondary interactions of hadrons
              if(trk_lint .and. coll .gt. 0.0 .and. abs(id).gt.100 )then
                  wtime = path.time
                  status = trk_sec_int(w,hep,coll,absl,eta,wtime,w,
     *		                     int_type)         
                  if(int_type.eq.2.or.w.p.eq.0) goto 1000
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
                  call wtk_mscat_brem_elec(w, radl, eta, trk_min_brem,w)
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
        endif

c     Add trace if last layer and nothing added
 100    continue
 
        if(w.pz*pz_save .lt. 0.) goto 1000   ! track has turned around 
 
        if(i.eq. last_z .and. trace_save .eq. trace_for_num) then
          status = trk_add_dummy_trace(hep, w, path, 2)
        endif

      enddo

c     Normal return
 1000 trk_trace_forward = 0
      if (trace_for_num .gt. trace_save) then
        path_list.end_trace = trace_for_num
      endif
      return

c     Too many track intersections
 9998 trk_trace_forward = 1
      return

c     Too many hits
 9999 trk_trace_forward = 2
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:39  eugenio
c Initial revision
c
c Revision 1.31  1999/03/24 02:11:18  mcbride
c add check for gaps in zplanes
c
c Revision 1.30  1998/06/02  23:09:47  kutschke
c Initialize tauyoke.
c
c Revision 1.29  1998/03/17  18:15:07  yarba_j
c minor cleanup (v2.6.2 vs dev)
c
c Revision 1.27  1998/02/13  16:14:56  mcbride
c merged changes from v2_6_2 into dev
c
c Revision 1.26  1997/11/14  06:18:52  mcbride
c fix call to trk_make_siz_rect_hit
c
c Revision 1.25  1997/10/28  04:59:13  kutschke
c Fix precision bug in test for z matching.
c
c Revision 1.24  1997/10/24  05:47:24  mcbride
c remove reference to siz_rect
c
c Revision 1.23  1997/10/23  21:31:27  yarba_j
c updated to account for new pixel geometry
c
c Revision 1.22  1997/04/04  20:30:34  garren
c add rcs log line
c

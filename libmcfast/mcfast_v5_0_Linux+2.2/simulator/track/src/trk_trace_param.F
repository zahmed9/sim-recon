      integer function trk_trace_param(hep)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Trace a track through the detector for the parametrized version
c   of the Monte Carlo. The work is passed to other routines.
c
c  Inputs:
c  hep       integer variable
c            Position of track in HEPEVT list
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "detector_general.inc"
#include "mcp_summary.inc"
#include "stdhep.inc"
#include "vtxhep.inc"
#include "trace.inc"
#include "trace_central.inc"
#include "trace_forward.inc"
#include "trace_types.inc"
#include "trace_params.inc"
#include "hep_trace.inc"
#include "wtrack_struct.inc"
#include "path_struct.inc"
#include "shower_trace_struct.inc"
#include "hit_track.inc"
#include "zplane.inc"
#include "rplane.inc"

c     Externals
      external trk_lifetime
      external trk_trace_central, trk_trace_forward
      external trk_decay, trk_pair_convert
      external trk_add_prod_trace

      DFLOAT   trk_lifetime
      integer  trk_trace_central, trk_trace_forward
      integer  trk_decay, trk_pair_convert
      integer  trk_add_prod_trace

c     Calling variables
      integer hep

c     Local variables
      DFLOAT lifetime
      real arc_trace(30000)
      integer index_trace(30000), offset, itrace
      DFLOAT arc_prev, arc

      integer i, ihit, ntrace
      integer status, trace_sum
      integer type, error
      integer r_num, z_num, caltype
      logical lstrike

      integer itrace_next, type_next
      DFLOAT  arc_next, length
      integer ical, ipln

      integer plane_type
      parameter ( plane_type = 3 )

      record /wtrack_struct/ w, w_out_volume
      record /path_struct/ path, path_mip
      record /shower_trace_struct/ shower_in, shower_out

      logical lfor

      logical shw_init
      data shw_init /.true./
      save shw_init
 
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      hep_trace(hep).nhit = 0
      hep_trace(hep).ntrace = 0
      ntrace = 0
      lifetime = 1.e20

      trace_for_num = 0   
      trace_cent_num = 0
c
      shw_init = .true.
      call clear_shower_trace(shower_in)
      call clear_shower_trace(shower_out)
c
c  If particles are to be decayed, establish the proper decay time
c
      path.arc = 0.                               !Total path length
      path.time = vtx_pos(4,ipvhep(hep)) / clight !Set initial clock
      path.tau = 0.                               !Total proper time
      
      call hep_to_w(hep, w)                       !Create track parameters
      status = trk_add_prod_trace(hep, w, path)   !Put prod. pnt in trace list
      if(hep_trace(hep).ntrace .eq. 0) then
        hep_trace(hep).ntrace = hep_trace(hep).ntrace + 1
        hep_trace(hep).first_trace = trace_num
      endif

      if (trk_ldecays) lifetime = trk_lifetime(idhep(hep))  !Generate lifetime

c  Do all the tracing for forward and central separately
c  Do not do central tracing in forward geometries for now
      if (.not. (trk_ldedx.or.trk_lscat) .and. 
     *           det_general.geom_id .ne. 'FORWARD') then
        status = trk_trace_central(hep, lifetime)
      end if
      if (.not. (trk_ldedx.or.trk_lscat) .or. 
     *           det_general.geom_id .eq. 'FORWARD') then
        status = trk_trace_forward(hep, lifetime)
      end if
      
      if (status .ne. 0) goto 9999
 
c  Now interleave the traces.  If one of the traces is a particle decay,
c  a photon conversion, or an absorption then stop storing the traces:
      trace_sum = trace_for_num + trace_cent_num
      
c  Sort the traces in increasing order of arc length
      offset = trace_cent_num
      do i=1,trace_cent_num
        arc_trace(i) = trace_cent_par(i).path
      enddo

      do i=1,trace_for_num
        arc_trace(i+offset)  = trace_for_par(i).path
      enddo

      call sortup_float(arc_trace, index_trace, trace_sum)

      call vzero(w_out_volume, WTRACK_WORD)

      arc_prev = -1.
      do 500 i=1,trace_sum
        itrace = index_trace(i)
        if(itrace .le. offset) then
          arc =  trace_cent_par(itrace).path
          type = trace_cent_par(itrace).type
          lfor = .false.
        else
          arc = trace_for_par(itrace-offset).path
          type = trace_for_par(itrace-offset).type
          lfor = .true.
        endif
        if (i .lt. trace_sum) then
         itrace_next = index_trace(i+1)
         if(itrace_next .le. offset) then
          arc_next =  trace_cent_par(itrace_next).path
          type_next = trace_cent_par(itrace_next).type
         else
          arc_next = trace_for_par(itrace_next-offset).path
          type_next = trace_for_par(itrace_next-offset).type
         endif
        end if

c        if(arc - arc_prev .le. 1.e-8) goto 500   !Require non-negl. step
        arc_prev = arc
        
        if (trace_num .ge. trace_max) goto 9998
        trace_num = trace_num + 1

        if(itrace .le. offset) then
          call trk_trace_copy(trace_cent_par(itrace),
     *                        trace_par(trace_num))
        else
          call trk_trace_copy(trace_for_par(itrace-offset),
     *                        trace_par(trace_num))
        endif
        hep_trace(hep).ntrace = hep_trace(hep).ntrace + 1
        
        ihit = trace_par(trace_num).hit
        if (ihit .ne. 0) then
          hit_trk(ihit).trace = trace_num
        endif 
 
        if (w_out_volume.e .ne. 0.) then
         call ucopy(w_out_volume, trace_par(trace_num).w,
     *              WTRACK_WORD)
         call vzero(w_out_volume, WTRACK_WORD)
        end if
 
        if((type .eq. jtrace_decay .and. trk_ldecays) .or.
     *     (type .eq. jtrace_pair .and. trk_lpair) .or.
     *     (type .eq. jtrace_absorb)) then
          goto 510      ! jump out of loop here at first chance
        end if

c
c     Do Calorimetry if necessary
c
        if (type .eq. jtrace_calor) then

c     We are at the calorimeter "face" ;
c     Let's find the calorimeter #
         ical = 0
         ipln = trace_par(trace_num).plane
         if (lfor) then
           ical = zpln_par(ipln).pos(1)
         else
           ical = rpln_par(ipln).pos(1)
         end if

c     Let's see if shower has NOT started yet,
c     then do MIP case - for CHARGED particles ONLY !
c      otherwise skip...
         if (shower_out.n_radlen_pass .eq. 0. .and.
     *       w.q .ne. 0.) then

          length = 0.    ! init length of path as MIP, if needed

c     Let's check if the particle is going to decay or start a shower
c     in the calorimeter or it travels through as MIP

          if ((type_next .eq. jtrace_shower .or.
     *        type_next .eq. jtrace_decay) .and.
     *        i .lt. trace_sum) then
c      Particle is going to decay or shower
           length = arc_next - arc
          else 
c     MIP behaviour; find length of path in the calorimeter
           call emcal_find_path(trace_par(trace_num).w,ical,1,
     *                          w_out_volume,length)
          end if

c      Do Minimum Ionizing until the particle 
c      reaches decay or conv. point or exits the calorimeter      
          call calor_trace_mip(hep,ical,trace_par(trace_num).w,
     *                        length,w_out_volume,path_mip)
          if ( w_out_volume.p .le. 1.e-3 ) then
             path_mip.arc  = path_mip.arc  + trace_par(trace_num).path
             path_mip.time = path_mip.time + trace_par(trace_num).time
             path_mip.tau  = path_mip.tau  + trace_par(trace_num).tau
             hep_trace(hep).ntrace = hep_trace(hep).ntrace + 1
             call trk_add_final_trace ( hep, w_out_volume, 
     *                 ipln, path_mip, plane_type, jtrace_absorb )
             goto 510
          endif
         end if

        end if

        if (type.eq.jtrace_shower .and. 
     *      shower_out.n_radlen_pass.gt.0.) then
c     Second conversion point happens due to "double" tracing; 
c     shower has already started;
c     clear out and skip this trace !
         call clear_trace_par(trace_num)
         trace_num = trace_num - 1
         hep_trace(hep).ntrace = hep_trace(hep).ntrace - 1
        end if

        if ((type.eq.jtrace_shower.and.
     *       shower_out.n_radlen_pass.eq.0.) .or.
     *      (type.eq.jtrace_calor.and.
     *       shower_out.n_radlen_pass.gt.0.)) then

c      OK, now do showering if necessary

         if (shw_init) then
c     First calorimeter in trace
          shower_in.hep = hep
          call ucopy(trace_par(trace_num).w, shower_in.w, 
     &               WTRACK_WORD)
          shw_init = .false.
         else
c     Continue showering 
c     (it only happens if particle/shower has NOT deposited 
c      its whole energy in the previous CAL)
          shower_in.hep = shower_out.hep
          shower_in.n_radlen_pass = shower_out.n_radlen_pass
          shower_in.E_original = shower_out.E_original
          shower_in.w.E  = shower_out.w.E
          shower_in.w.p  = shower_out.w.p
          shower_in.w.px = shower_out.w.px
          shower_in.w.py = shower_out.w.py
          shower_in.w.pz = shower_out.w.pz
          shower_in.w.pt = shower_out.w.pt
          shower_in.w.x  = trace_par(trace_num).w.x
          shower_in.w.y  = trace_par(trace_num).w.y
          shower_in.w.z  = trace_par(trace_num).w.z

c         Clear out trace record if SHOWERING continues in the next volume.
          call clear_trace_par(trace_num)
          trace_num = trace_num - 1
          hep_trace(hep).ntrace = hep_trace(hep).ntrace - 1

         end if

c     Do energy deposition and create hits in the calorimeter ICAL
         call emcal_make_hit(ical, shower_in, shower_out)

         if (shower_out.w.E .le. 0.) then
c     Particle/shower has deposited its whole energy; give up
           goto 520
         end if
c
        end if

 500  continue

 510  if (type .eq. jtrace_decay) then                !particle decay
        error = trk_decay(hep, trace_par(trace_num).w, trace_par
     &     (trace_num).path)
      else if (type .eq. jtrace_pair) then            !gamma conversion
        status = trk_pair_convert(hep, trace_par(trace_num).w, 
     &     trace_par(trace_num).path)
      else if (type .eq. jtrace_absorb) then          !absorption
        continue
      end if
      
 520  trk_trace_param = 0
      return

9998  trk_trace_param = 1
      write(6,5000) mcp_all.event, hep,
     &     trace_max, trace_cent_num, trace_for_num
5000  format('trk_trace_param: event ', i6, ' at track ', i5,'.',
     &    'Event exceeds maximum number',i5', of traces allowed, ',
     &    'central traces= ', i5,' forward traces= ',i5)
      return
      
9999  trk_trace_param = 2
      write(6, 5001) mcp_all.event, status, hep, trace_num, hit_trk_num
5001  format('trk_trace_param: Tracing aborted during event ', i6,
     &           ' with status ',i3,
     &           'for track ',i5,', trace ',i5 ', hit ',i5,'.')
      return

      end
      
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:39  eugenio
c Initial revision
c
c Revision 1.23  1998/02/13 16:14:56  mcbride
c merged changes from v2_6_2 into dev
c

      integer function klm_fit_ctk(hep)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c  Run the ctrack Kalman filter on the HEPEVT track "hep".
c
c  See CLEO CBX 96-20 for details of the algorithm.
c
c  Inputs:
c  hep        integer variable
c             Hep track number
c
c  Outputs:  arrays filled in offline_track.inc and track_central.inc.
c
c  Return:
c             0 ==> all OK
c             1 ==> offline track list overflowed
c           >=2 ==> fit failedc

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "ctrack_struct.inc"
#include "bfield_struct.inc"
#include "stdhep.inc"
#include "hep_trace.inc"
#include "hep_point.inc"
#include "trace.inc"
#include "offline_track.inc"
#include "track_central.inc"
#include "track_minhit.inc"
#include "hit_track.inc"
#include "fit_params.inc"
#include "trace_params.inc"

c     Calling arguments
      integer hep

c     Externals
      integer  move_ctk_dc_point_cov
      integer  klm_addhit_ctk_cov
      integer  cvt_wtk_ctk, cvt_ctk_wtk, ccov_to_wcov
      integer  ctk_mscat_cov
      integer  ctk_dedx_cov
      real*4   prob

      external move_ctk_dc_point_cov
      external klm_addhit_ctk_cov
      external cvt_wtk_ctk, cvt_ctk_wtk, ccov_to_wcov
      external ctk_mscat_cov
      external ctk_dedx_cov
      external prob

c     Local variables

c     Maximum number of trace points on one track.
      integer MAX_TRACE
      parameter (MAX_TRACE = 1000)

c     Number of track parameters = dimensions of covariance matrix.
      integer MPAR
      parameter (MPAR = 5)

c     Position in trace.inc of first trace point on the track and the total
c     number of trace points on the track. They are stored contiguously.
      integer first, num_trace

c     Number of hits of any type on the track.  All hit types count
c     as 1.  Used only in the initial scan so see if there are enough hits
c     to bother doing the fit.
      integer nhit

c     Arc length from track beginning to this trace point.  Used as 
c     a sort key to sort trace points into order of increasing arc length.
      real paths(MAX_TRACE)

c     Sorted array of indices into paths.  This is also an index
c     into trace_par, with an offset of first.
      integer index_path(MAX_TRACE)

c     For last hit on track.  
c       last: Index into index_path
c      ilast: Index into trace_par
      integer last, ilast

c     The index into trace_par of the current trace point.
      integer next

c     Track parameters in neighbourhood of current point are c+dc.
c     dc is the linearized correction.
      record /ctrack_struct/ c
      DFLOAT dc(MPAR)

c     Covariance matrix of the current track parameters.
      DFLOAT ccov(MPAR,MPAR)

c     Starting values of the covariance matrix.
      DFLOAT ccov_init(MPAR,MPAR), sig_init(MPAR)

c     Total chi-squared of the track and the contribution of this hit.
      real*8 chisq, dchisq

c     Number terms in chisq for different types of hits on this track.
c     Pixel devices count as 2, all others as 1.
      integer hits, hits_sil, hits_stereo

c     Mass of the particle being fitted.
      DFLOAT mass

c     Arc length moved by move routine.  Not used for anything.
      DFLOAT s3d

c     Index into hit_trk of the hit at this trace point.
c     If no hit, then hit=0.
      integer hit

c     Hit information passed back from klm_addhit_ftk_cov.
      integer hit_list(3)

c     Control whether or not derivatives are evaluated at the seed
c     track or at the present value.
      logical update

c     Criteria to start updating:
c     - a minimum number of hits already added to the track.
c     - the fractional error on the curvature less than 10% ( f1 ).
c     - the correction to the curvature not too much bigger than the
c       curvature itself ( f2 ).
      integer min_hit_update
      DFLOAT update_f1, update_f2
      parameter ( min_hit_update = 10    )
      parameter ( update_f1      =  0.01 )
      parameter ( update_f2      = 10.   )

c     Number of hits added to the track when the update started.
      integer nh_start_update

c     Next origin to which to transport.
      DFLOAT next_origin(3)

c     Magnetic field at the current hit.
      record /bfield_struct/ bf

c     Direction control for energy loss routines.
      integer outwards
      integer inwards
      integer direction
      parameter ( outwards  = +1 )
      parameter ( inwards   = -1 )
      parameter ( direction = inwards )

c     Indexology
      integer i

c     Function return values.
      integer status

c     Initialization control.
      logical init

      data init/.TRUE./
      data sig_init / 10., 10.0, 10.0, 10., 10./
      save sig_init, ccov_init, init

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Calculate initial covariance matrix.
      if(init) then
        init = .FALSE.
        call vzero(ccov_init, MPAR*MPAR*FLOAT_WORD)
        do i=1,MPAR
          ccov_init(i,i) = sig_init(i)**2
        enddo
      endif

c     Check for room in output arrays.
      if (trk_off_num .ge. trk_off_max) goto 9998
      if (trc_num     .ge. max_trc    ) goto 9998

c     Number of trace points on the track.
      first     = hep_trace(hep).first_trace
      num_trace = hep_trace(hep).ntrace
      if ( num_trace .gt. MAX_TRACE ) then
         num_trace = MAX_TRACE
         print *, 'klm_fit_ctk Warning: trace list truncated.'
      endif

c     Check for minimum number of hits.
      nhit = 0
      do i=1,num_trace
        next = i + first - 1
        if(trace_par(next).hit .gt. 0) nhit = nhit + 1
        paths(i) = trace_par(next).path
      enddo
      if ( nhit .lt. trk_minhit.all ) goto 9997

c     Sort trace points by path length.
      call sortup_float(paths, index_path, num_trace)

c     Find last hit.
      last = 0
      do i=num_trace,1,-1
        ilast = index_path(i)+first-1
        if(trace_par(ilast).hit .gt. 0) then
          last = i
          goto 200
        endif
      enddo
      goto 9997
 200  continue

c     Get magnetic field at the outermost hit on the track.
      call get_bfield(trace_par(ilast).w.x, bf)

c     Compute starting value of the track parameters: use the generated
c     value at the outermost hit.
      status = cvt_wtk_ctk(trace_par(ilast).w, 
     +                     trace_par(ilast).w.x, bf, c )

c     Initialize covariance matrix and all the rest.
      call ucopy(ccov_init, ccov, MPAR*MPAR*FLOAT_WORD)
      call vzero(dc, MPAR*FLOAT_WORD)
      update          = .false.
      chisq           = 0.
      hits            = 0
      hits_sil        = 0
      hits_stereo     = 0
      nh_start_update = 0
      mass            = phep(5,hep)

c     Main loop over all trace points.
      do i=last, 1, -1

        next = index_path(i) + first - 1
        hit   = trace_par(next).hit

c       Transport the track and covariance matrix to the next intersection.
        call trk_next_bfield(trace_par(next).w,bf)
        call klm_select_origin ( next, next_origin )
        status = move_ctk_dc_point_cov(c, dc, ccov, next_origin,
     *                                 c, dc, ccov, s3d )
        if(status .ne. 0) goto 9996

c       If material, take care of dedx and energy loss.
        if ( i .ne. last ) then

           if ( trace_par(next).radl .ne. 0. .and. trk_lscat ) then
              status = ctk_mscat_cov(c, ccov, mass, 
     +                               trace_par(next).radl,
     +                               trace_par(next).eta, ccov)
              if  (status .ne. 0 ) goto 9995
           endif

           if ( abs(trace_par(next).dedx) .ne. 0. .and. trk_ldedx ) then
              status = ctk_dedx_cov (c, ccov, mass, 
     +                               trace_par(next).dedx,
     +                               trace_par(next).eta,
     +                               direction )
              if  (status .ne. 0 ) goto 9995
           endif

        endif

c       If hit, add measurement to covariance matrix
        if ( hit .gt. 0) then

          status = klm_addhit_ctk_cov(c, dc, ccov, hit_trk(hit), 
     &             trace_par(next), bf, hit_list, dc, ccov, dchisq )
          if(status .ne. 0) goto 9999

          chisq       = chisq + dchisq
          hits        = hits + hit_list(1)
          hits_sil    = hits_sil + hit_list(2)
          hits_stereo = hits_stereo + hit_list(3)

c         Check to see if we should start updating.
          if ( .not. update .and. hits .gt. min_hit_update ) then
               update  = abs(ccov(1,1)) .le. update_f1**c.cu*c.cu .and.
     &                   update_f2*abs(dc(1)) .lt. abs(c.cu)
             if ( update ) nh_start_update = hits
          endif

          if ( update .and. update_f2*abs(dc(1)) .gt. abs(c.cu) )
     +       update = .false.

c         Do the update.
          if ( update ) then
             call ctk_add_delta ( c, dc, bf, c )
             call vzero ( dc, MPAR*FLOAT_WORD)
          endif

        endif

 500    continue

      enddo

c     Final update if necessary.
      if ( .not. update ) then
         call ctk_add_delta ( c, dc, bf, c )
         call vzero ( dc, MPAR*FLOAT_WORD)
      endif

c     Call the diagnostic routines.
      if ( fit_ctk_diag )
     +   call klm_fit_ctk_diag ( hep, c, ccov, chisq,
     +                           hits, hits_sil, hits_stereo, 
     +                           nh_start_update, sig_init )

c     Add track to offline fitted list.
      status = cvt_ctk_wtk (c, mass, trk_off(trk_off_num+1).w)
      if ( status .ne. 0 ) goto 9994
      status = ccov_to_wcov(c, ccov, trk_off(trk_off_num+1).w,
     +                               trk_off(trk_off_num+1).cov )
      if ( status .ne. 0 ) goto 9994
      trk_off_num = trk_off_num + 1
      trk_off(trk_off_num).icov        = 1
      trk_off(trk_off_num).mass        = mass
      trk_off(trk_off_num).hep         = hep
      trk_off(trk_off_num).chisq       = chisq
      trk_off(trk_off_num).nhit        = hits
      trk_off(trk_off_num).nhit_sil    = hits_sil
      trk_off(trk_off_num).nhit_stereo = hits_stereo
      hep_off(hep)                     = trk_off_num

c     Add track to list of central fitted tracks.
      trc_num = trc_num + 1
      call ucopy(c,    trc_par(trc_num).c,            CTRACK_WORD)
      call ucopy(ccov, trc_par(trc_num).cov, MPAR*MPAR*FLOAT_WORD)
      trc_par(trc_num).icov = 1
      trc_par(trc_num).mass = mass
      trc_par(trc_num).ihep = hep
      hep_cen(hep)          = trc_num

c     Normal return.
 1000 klm_fit_ctk = 0
      return

c     Error converting to w format.
 9994 klm_fit_ctk = 6
      return

c     Error in mscat or dedx
 9995 klm_fit_ctk = 5
      return

c     Error transporting track during fit.
 9996 klm_fit_ctk = 4
      return

c     Not enough hits.
 9997 klm_fit_ctk = 3
      return

c     Too many offline tracks.
 9998 klm_fit_ctk = 1
      return

c     Error in fit.
 9999 klm_fit_ctk = 2
      return
      end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:15  eugenio
c Initial revision
c
c Revision 1.2  1999/05/13 19:30:19  kutschke
c See development release notes for May 13, 1999
c
c Revision 1.1  1999/05/12  20:21:33  kutschke
c 21 files changed/added to implement ctk Kalman filter.
c
c

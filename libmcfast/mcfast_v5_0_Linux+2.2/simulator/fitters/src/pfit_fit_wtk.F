      integer function pfit_fit_wtk(hep)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Do the track fit for HEPEVT track "hep" using the w parametrization
c  for the complete fit.

c  Inputs:
c  hep        integer variable
c             Hep track number
c
c  Outputs:
c
c  Return:
c             0 ==> all OK
c             1 ==> offline track list overflowed
c             2 ==> fit failed
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "ctrack_struct.inc"
#include "bfield_struct.inc"
#include "stdhep.inc"
#include "vtxhep.inc"
#include "hep_trace.inc"
#include "hep_point.inc"
#include "trace.inc"
#include "trace_types.inc"
#include "offline_track.inc"
#include "track_minhit.inc"

c     Externals
      integer  move_wtk_point, move_wtk_point_cov
      integer  pfit_addhit_wtk_cov, wcov_to_wcov_point
      integer  cvt_wtk_ctk, ccov_to_wcov, wcov_to_ccov
      external move_wtk_point, move_wtk_point_cov
      external pfit_addhit_wtk_cov, wcov_to_wcov_point
      external cvt_wtk_ctk, ccov_to_wcov, wcov_to_ccov

c     Calling arguments
      integer hep

c     Local variables
      integer MAXHIT, MPAR
      parameter (MAXHIT = trace_max)
      parameter (MPAR = 7)

      integer hit, i, num_trace, last, first, next, status, this1
      integer type, plane, hits, hit_list(3), hits_sil, hits_stereo
      integer index_path(MAXHIT), nhit, iv
      integer tmpindx
      logical init
      real paths(MAXHIT)
      DFLOAT xpos(3), wcov(MPAR,MPAR), wcov_init(MPAR,MPAR)
      DFLOAT wcovc(MPAR,MPAR), wcovcmp(MPAR,MPAR)
      DFLOAT ccov(5,5), ccovc(5,5), ccovcmp(5,5)
      DFLOAT x(3), sig_init(MPAR), den, mass, s3d, soverp
      DFLOAT psq, ptsq

      record /bfield_struct/ bf
      record /wtrack_struct/ w, w_out, w_gen
      record /ctrack_struct/ c

c     Does a track have momentum information?
c     It will have momentum information if either of the following is true:
c        a) there is at least one hit inside the magnetic field
c           ( eg, BTeV style detector ).
c        b) there are hits on both sides of a region with a non-zero field.
c           ( classic fixed target dipole geometry ). 
c     The next few variables implement this algorithm.

      ! Number of hits inside any region with non-zero field.
      integer hits_inside_b

      ! Divide the trajectory into regions with different magnetic fields.
      ! Count the hits in each region.
      integer max_b_zone
      parameter ( max_b_zone = 20 )
      integer hits_b_zone(max_b_zone )

      ! Index to current region of the b field.
      integer b_zone
 
      ! Value of bf.devnum at previous point.
      integer dev_last

      ! Number of bins of hits_b_zone with at least one hit.
      ! If we have hits in two or more zones, then we have momentum
      ! information.
      integer n_zone

      ! icov=1 for normal track; icov=2 if no momentum information.
      integer icov

      save wcov_init, init

      data init/.TRUE./
      data sig_init/3*1.E1, 1.E5, 3*1.E2/
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      psq = trace_par(1).w.p**2

c     Calculate initial covariance matrix. Ignore energy for now.
c
c     dE = (dpx*px + dpy*py + dpz*pz) / E

c     Initialize the covariance matrix depending on momentum
      call vzero(wcov_init, MPAR*MPAR*FLOAT_WORD)
      wcov_init(1,1) = sig_init(1)**2 * psq
      wcov_init(2,2) = sig_init(2)**2 * psq
      wcov_init(3,3) = sig_init(3)**2 * psq
      wcov_init(4,4) = sig_init(4)**2
      wcov_init(5,5) = sig_init(5)**2
      wcov_init(6,6) = sig_init(6)**2
      wcov_init(7,7) = sig_init(7)**2

      mass = phep(5,hep)

c     Get # of intersections and position of first one
      num_trace   = hep_trace(hep).ntrace
      first = hep_trace(hep).first_trace

c     Check min number of hits
      nhit = 0
      do i=1,num_trace
        next = i + first - 1
        if(trace_par(next).hit .gt. 0) nhit = nhit + 1
      enddo
      if(nhit.lt.trk_minhit.all .or. nhit.eq.0) goto 9997

c     Sort them by path length
      do i=1, num_trace
        this1 = first+i-1
        paths(i) = trace_par(this1).path
      enddo
      call sortup_float(paths, index_path, num_trace)

c     Find last hit
      last = 0
      do i=num_trace,1,-1
        tmpindx = index_path(i)+first-1
        if(trace_par(tmpindx).hit .gt. 0) then
          last = i
          goto 200
        endif
      enddo
      goto 9997

 200  continue

c     We are going to fit in the w parametrization

c     Starting at the last hit, go backwards and add contributions
c     to the track covariance matrix from measurements and multiple
c     scattering

      call ucopy(wcov_init, wcov, MPAR*MPAR*FLOAT_WORD)
      tmpindx = index_path(last)+first-1
      call ucopy(trace_par(tmpindx).w, w, WTRACK_WORD)

      hits = 0
      hits_sil = 0
      hits_stereo = 0
      hits_inside_b = 0
      b_zone        = 0
      call vzero ( hits_b_zone, max_b_zone )

      do i=last, 1, -1
        next = index_path(i) + first - 1
        hit = trace_par(next).hit       !Hit # in hit list
        type = trace_par(next).type     !1 (2) for radial (z) plane
        plane = trace_par(next).plane   !Plane # in radial or z list

c     Check the B field we have to move through
        call trk_next_bfield(trace_par(next).w,bf)

c       Has the magnetic field changed since the previous trace point?
        if ( b_zone .eq. 0 .or. bf.devnum .ne. dev_last ) then
             b_zone   = min(b_zone + 1, max_b_zone )
             dev_last = bf.devnum
        endif

c     Transport the track and covariance matrix to the next intersection
        if(i .ne. last) then
          status = move_wtk_point_cov(w, wcov, trace_par(next).w.x,
     *                                bf, w, wcov, s3d)
        endif

c     Use the value of w that was generated at the plane
        call ucopy(trace_par(next).w, w, WTRACK_WORD)

c     If material, add its contribution to covariance matrix
        if(trace_par(next).radl .ne. 0. .and. i .ne. last ) then
          call wtk_mscat_cov(w, wcov, trace_par(next).radl,
     *              trace_par(next).eta, wcov)
        endif

c     If hit, add measurement to covariance matrix
        if(hit .gt. 0) then
          status = pfit_addhit_wtk_cov(w, wcov, hit, next, bf, 
     &             hit_list, wcov)
          if(status .ne. 0) goto 9999
          hits = hits + hit_list(1)
          hits_sil = hits_sil + hit_list(2)
          hits_stereo = hits_stereo + hit_list(3)
          if ( bf.bmag .ne. 0. ) hits_inside_b = hits_inside_b + 1
          hits_b_zone(b_zone) = hits_b_zone(b_zone) + 1
        endif

 500    continue

      enddo

c     Is there momentum information on this track?
      icov = 2
      if ( hits_inside_b .gt. 0 ) then
         icov = 1
      else
         n_zone = 0
         do i = 1, b_zone
            if ( hits_b_zone(i) .gt. 0 ) n_zone = n_zone + 1
         enddo
         if ( n_zone .gt. 1 ) icov = 1
      endif

c     Move the track and covariance matrix to the true production point
c      iv = ipvhep(hep)
c      status = move_wtk_point_cov(w, wcov, vtx_pos(1,iv),
c     *                            bf, w, wcov, s3d)

c     Compress the covariance matrix by evaluating it near a point
      status = wcov_to_wcov_point(w, wcov, bf, wcov)

c     Get rid of energy parts of the cov. matrix
      do i=1,7
        wcov(i,4) = 0.
        wcov(4,i) = 0.
      enddo
      wcov(4,4) = 0.01

c     Smear the generated track parameters
      call hep_to_w(hep, w_gen)
      call m_smear7(wcov, MPAR, MPAR, w_gen, w_out)

c     Force energy constraint in covariance matrix
c     dE = (dpx*px + dpy*py + dpz*pz) / E
      call wtk_cov_Econstr(w, wcov)

      ptsq = w_out.px**2 + w_out.py**2
      psq = ptsq + w_out.pz**2
      w_out.E = sqrt(psq + mass**2)
      w_out.pt = sqrt(ptsq)
      w_out.p = sqrt(psq)
      w_out.q = w.q

c     Try some tests
c      status = cvt_wtk_ctk(w, w.x, bf, c)
c      status = wcov_to_ccov(w, wcov, c, ccov)
c      status = wcov_to_ccov(w, wcovcmp, c, ccovcmp)
c      status = ccov_to_wcov(c, ccov, w, wcovc)
c      status = wcov_to_ccov(w, wcovc, c, ccovc)

c     Add track to offline fitted list
      if(trk_off_num .ge. trk_off_max) goto 9998
      trk_off_num = trk_off_num + 1
      trk_off(trk_off_num).icov = icov
      trk_off(trk_off_num).mass = mass
      trk_off(trk_off_num).hep = hep
      trk_off(trk_off_num).nhit = hits
      trk_off(trk_off_num).nhit_sil = hits_sil
      trk_off(trk_off_num).nhit_stereo = hits_stereo
      call ucopy(w_out, trk_off(trk_off_num).w, WTRACK_WORD)
      call ucopy(wcov, trk_off(trk_off_num).cov, MPAR*MPAR*FLOAT_WORD)

      hep_off(hep) = trk_off_num          ! Point to this track from hep list
      
c     Normal exit
 1000 pfit_fit_wtk = 0
      return

c     Not enough hits
 9997 pfit_fit_wtk = 3
      return

c     Too many offline tracks
 9998 pfit_fit_wtk = 1
      return

c     Error in fit
 9999 pfit_fit_wtk = 2
      return
      end
c
c$Id$
c
c$Log$
cRevision 1.1  2000/06/19 19:59:18  eugenio
cInitial revision
c
cRevision 1.12  1998/06/23 23:47:39  bphyslib
cfix references to renamed routines
c
c Revision 1.11  1998/06/23  22:41:51  bphyslib
c rename routines moved from track to fitters library
c
c Revision 1.10  1997/03/27  05:03:54  kutschke
c Zero hits_b_zone at start of event.
c
c Revision 1.9  1997/03/24  17:36:34  kutschke
c Set icov=2 if no momentum info
c

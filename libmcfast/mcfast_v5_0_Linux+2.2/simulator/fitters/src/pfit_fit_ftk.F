      integer function pfit_fit_ftk(hep)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Do the track fit for HEPEVT track "hep" using the f parametrization
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
#include "ftrack_struct.inc"
#include "bfield_struct.inc"
#include "stdhep.inc"
#include "vtxhep.inc"
#include "hep_point.inc"
#include "hep_trace.inc"
#include "prim_vertex.inc"
#include "trace.inc"
#include "trace_types.inc"
#include "offline_track.inc"
#include "track_forward.inc"
#include "track_minhit.inc"
C
C     Externals
C
      integer  move_ftk_zplane_cov
      integer  pfit_addhit_ftk_cov
      integer  cvt_wtk_ftk, cvt_ftk_wtk, fcov_to_wcov
      DFLOAT   phi_norm
      external move_ftk_zplane_cov
      external pfit_addhit_ftk_cov
      external cvt_wtk_ftk, cvt_ftk_wtk, fcov_to_wcov
      external phi_norm

c     Calling arguments
      integer hep

c     Local variables
      integer MAXHIT, MPAR
      parameter (MAXHIT = trace_max)
      parameter (MPAR = 5)

      integer hit, i, num_trace, last, first, next, status, this1
      integer type, plane, hits, hit_list(3), hits_sil, hits_stereo
      integer index_path(MAXHIT), nhit, iv
      integer tmpindx
      logical init
      real paths(MAXHIT)
      DFLOAT xpos(3), wcov(7,7), fcov_init(MPAR,MPAR)
      DFLOAT fcov(MPAR, MPAR)
      DFLOAT x(3), sig_init(MPAR), den, mass, s3d
      DFLOAT psq, ptsq, vtxivpos

      record /bfield_struct/ bf
      record /wtrack_struct/ w, w_out
      record /ftrack_struct/ f, f_out, f_gen

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

      ! Number of bins of hits_b_zone with a non-zero value.
      integer n_zone

      ! icov=1 for normal track; icov=2 if no momentum information.
      integer icov

      save fcov_init, init

      data init/.TRUE./
c      data sig_init/5*0./
      data sig_init/3*1.E0, 1., 1./
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Calculate initial covariance matrix. Ignore energy for now.
c
c     dE = (dpx*px + dpy*py + dpz*pz) / E
      if(init) then
        init = .FALSE.
        call vzero(fcov_init, MPAR*MPAR*FLOAT_WORD)
        do i=1,MPAR
          fcov_init(i,i) = sig_init(i)**2
        enddo
      endif

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
c
c     Sort them by path length
c
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

c     We are going to fit in the f parametrization

c     Starting at the last hit, go backwards and add contributions
c     to the track covariance matrix from measurements and multiple
c     scattering

      tmpindx = index_path(last)+first-1
      call ucopy(trace_par(tmpindx).w, w, WTRACK_WORD)
      call ucopy(fcov_init, fcov, MPAR*MPAR*FLOAT_WORD)
      status = cvt_wtk_ftk(w, f)

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

c     Find B field we have to move through
        call trk_next_bfield(trace_par(next).w,bf)

c       Has the magnetic field changed since the previous trace point?
        if ( b_zone .eq. 0 .or. bf.devnum .ne. dev_last ) then
             b_zone   = min(b_zone + 1, max_b_zone )
             dev_last = bf.devnum
        endif

c     Transport the track and covariance matrix to the next intersection
        if (i .ne. last) then 
          status = move_ftk_zplane_cov(f, fcov, trace_par(next).w.z,bf,
     *                              f, fcov, s3d)
        endif
        
c     If material, add its contribution to covariance matrix
        if(trace_par(next).radl .ne. 0. .and. i .ne. last ) then
          call ftk_mscat_cov(f, fcov, mass, trace_par(next).radl,
     *              trace_par(next).eta, fcov)
        endif

c     If hit, add measurement to covariance matrix
        if(hit .gt. 0) then

          status = pfit_addhit_ftk_cov(f, fcov, hit, next, bf, 
     &             hit_list, fcov)

          if(status .ne. 0) goto 9999
          hits = hits + hit_list(1)
          hits_sil = hits_sil + hit_list(2)
          hits_stereo = hits_stereo + hit_list(3)
          if ( bf.bmag .ne. 0. ) hits_inside_b = hits_inside_b + 1
          hits_b_zone(b_zone) = hits_b_zone(b_zone) + 1

        endif
        
 500   continue

      enddo

      if ( fcov(1,1) .le. 0. ) goto 9999
      if ( fcov(2,2) .le. 0. ) goto 9999
      if ( fcov(3,3) .le. 0. ) goto 9999
      if ( fcov(4,4) .le. 0. ) goto 9999
      if ( fcov(5,5) .le. 0. ) goto 9999

      call ucopy(trace_par(next).w, w, WTRACK_WORD)
      status = cvt_wtk_ftk( w, f_gen)

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

c    Convert the covariance matrix to w form
      status = fcov_to_wcov(f_gen, fcov, w, wcov)

      if ( wcov(1,1) .le. 0. ) goto 9999
      if ( wcov(2,2) .le. 0. ) goto 9999
      if ( wcov(3,3) .le. 0. ) goto 9999
      if ( wcov(4,4) .le. 0. ) goto 9999
      if ( wcov(5,5) .le. 0. ) goto 9999
      if ( wcov(6,6) .le. 0. ) goto 9999

c     Smear the track parameters
      call m_smear(fcov, MPAR, MPAR, f_gen, f_out)
      if(f_out.alpha .eq. 0.) then
        f_out.pt = 0.
        f_out.p = 0.
        f_out.q = f.q
      else
        f_out.alpha = f_out.alpha * sign(ONE, f_out.alpha*f.alpha)
        f_out.pt = sqrt(f_out.xslp**2+f_out.yslp**2)/abs(f_out.alpha)
        f_out.p = sqrt(f_out.pt**2 + 1.0/f_out.alpha**2)
        f_out.q = f.q * sign(ONE, f_out.alpha*f.alpha)
      endif
      f_out.zp = f.zp

      status = cvt_ftk_wtk(f_out, mass, w_out)
c
c     Add track to offline fitted list
c
      if(trk_off_num .ge. trk_off_max) goto 9998
      trk_off_num = trk_off_num + 1
      trk_off(trk_off_num).icov = icov
      trk_off(trk_off_num).mass = mass
      trk_off(trk_off_num).hep = hep
      trk_off(trk_off_num).nhit = hits
      trk_off(trk_off_num).nhit_sil = hits_sil
      trk_off(trk_off_num).nhit_stereo = hits_stereo
      call ucopy(w_out, trk_off(trk_off_num).w, WTRACK_WORD)
      call ucopy(wcov, trk_off(trk_off_num).cov, 7*7*FLOAT_WORD)
      hep_off(hep) = trk_off_num          ! Point to this track from hep list
c
c     Move the track's z0 reference to the primary vertex z
c
      status = move_ftk_zplane_cov(f_out, fcov, prim_vertex(3,1), bf,
     *                             f_out, fcov, s3d)
c
c     Now copy the forward tracks to the trf_par
c
      if(trf_num .ge. max_trf) goto 9998
      trf_num = trf_num + 1
      trf_par(trf_num).icov = icov
      trf_par(trf_num).mass = mass
      trf_par(trf_num).ihep = hep
      call ucopy(f_out, trf_par(trf_num).f, FTRACK_WORD)
      call ucopy(fcov, trf_par(trf_num).cov, MPAR*MPAR*FLOAT_WORD)
      hep_for(hep) = trf_num              ! Point to this track from hep list
c
c     Normal exit
c
 1000 pfit_fit_ftk = 0
      return

c     Not enough hits
 9997 pfit_fit_ftk = 3
      return

c     Too many offline tracks
 9998 pfit_fit_ftk = 1
      return

c     Error in fit
 9999 pfit_fit_ftk = 2
      return
      end
c
c$Id$
c
c$Log$
cRevision 1.1  2000/06/19 19:59:18  eugenio
cInitial revision
c
cRevision 1.15  1999/04/08 05:44:46  kutschke
cAbort fitter if diagonal elements of cov are negative.
c
c Revision 1.14  1998/06/23  23:47:39  bphyslib
c fix references to renamed routines
c
c Revision 1.13  1998/06/23  22:41:51  bphyslib
c rename routines moved from track to fitters library
c
c Revision 1.12  1998/02/13  23:08:49  kutschke
c Be consistent with new ftk_mscat_cov.
c
c Revision 1.11  1997/05/10  01:24:17  bphyslib
c can't call function
c
c Revision 1.10  1997/05/09  02:36:18  kutschke
c Smear about f_gen, not f.  Also fcov to wcov using f_gen.
c
c Revision 1.9  1997/03/27  05:03:51  kutschke
c Zero hits_b_zone at start of event.
c
c Revision 1.8  1997/03/24  17:36:31  kutschke
c Set icov=2 if no momentum info
c

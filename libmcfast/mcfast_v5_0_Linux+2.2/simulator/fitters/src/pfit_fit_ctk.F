      integer function pfit_fit_ctk(hep)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Do the track fit for HEPEVT track "hep" using the c parametrization
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
#include "track_central.inc"
#include "track_minhit.inc"
#include "prim_vertex.inc"

c     Externals
      integer  move_ctk_point_cov
      integer  pfit_addhit_ctk_cov, ctk_mscat_cov
      integer  cvt_wtk_ctk, cvt_ctk_wtk, ccov_to_wcov
      DFLOAT   phi_norm

      external move_ctk_point_cov
      external pfit_addhit_ctk_cov, ctk_mscat_cov
      external cvt_wtk_ctk, cvt_ctk_wtk, ccov_to_wcov
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
      DFLOAT xpos(3), wcov(7,7), ccov_init(MPAR,MPAR)
      DFLOAT ccov(MPAR,MPAR)
      DFLOAT x(3), sig_init(MPAR), den, mass, s3d, soverp
      DFLOAT psq, ptsq

      record /bfield_struct/ bf
      record /wtrack_struct/ w, w_out
      record /ctrack_struct/ c, c_out, c_gen

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

      save ccov_init, init

      data init/.TRUE./
      data sig_init/3*1.E0, 1., 1./
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Calculate initial covariance matrix. Ignore energy for now.
c
c     dE = (dpx*px + dpy*py + dpz*pz) / E
      if(init) then
        init = .FALSE.
        call vzero(ccov_init, MPAR*MPAR*FLOAT_WORD)
        do i=1,MPAR
          ccov_init(i,i) = sig_init(i)**2
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

c     We are going to fit in the c parametrization

c     Starting at the last hit, go backwards and add contributions
c     to the track covariance matrix from measurements and multiple
c     scattering

      tmpindx = index_path(last)+first-1
      call ucopy(trace_par(tmpindx).w, w, WTRACK_WORD)
      call ucopy(ccov_init, ccov, MPAR*MPAR*FLOAT_WORD)
      call get_bfield(w.x, bf)
      status = cvt_wtk_ctk(w, w.x, bf, c)

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

c     Get the B field we have to move through
        call trk_next_bfield(trace_par(next).w,bf)

c       Has the magnetic field changed since the previous trace point?
        if ( b_zone .eq. 0 .or. bf.devnum .ne. dev_last ) then
             b_zone   = min(b_zone + 1, max_b_zone )
             dev_last = bf.devnum
        endif

c     Transport the track and covariance matrix to the next intersection
        if(i .ne. last) then
          status = move_ctk_point_cov(c, ccov, trace_par(next).w.x,
     *                                c, ccov, s3d)
          if(status .ne. 0) goto 9996
        endif

      
c     Use the value of c that was generated at the plane
      status = cvt_wtk_ctk(trace_par(next).w, trace_par(next).w.x,
     *                     bf, c)

c     If material, add its contribution to covariance matrix
        if(trace_par(next).radl .ne. 0. .and. i .ne. last ) then
          status = ctk_mscat_cov(c, ccov, mass, trace_par(next).radl,
     *              trace_par(next).eta, ccov)
          if ( status .ne. 0 ) goto 9995
        endif

c     If hit, add measurement to covariance matrix
        if(hit .gt. 0) then
          status = pfit_addhit_ctk_cov(c, ccov, hit, next, bf, 
     &             hit_list, ccov)
          if(status .ne. 0) goto 9999
          hits = hits + hit_list(1)
          hits_sil = hits_sil + hit_list(2)
          hits_stereo = hits_stereo + hit_list(3)
          if ( bf.bmag .ne. 0. ) hits_inside_b = hits_inside_b + 1
          hits_b_zone(b_zone) = hits_b_zone(b_zone) + 1
        endif

 500    continue

      enddo

      call ucopy(trace_par(next).w, w, WTRACK_WORD)

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

c     Covariance matrix already at true production point
      iv = ipvhep(hep)
      status = cvt_wtk_ctk(w, vtx_pos(1,iv), bf, c_gen)

c     Convert the covariance matrix to w form
      status = ccov_to_wcov(c_gen, ccov, w, wcov)

c     Smear the generated track parameters
      call m_smear(ccov, MPAR, MPAR, c_gen, c_out)

      c_out.phi0 = phi_norm(c_out.phi0)
      c_out.u0 = cos(c_out.phi0)
      c_out.v0 = sin(c_out.phi0)
      if(c_out.cu .eq. 0.) then
        c_out.pt = 0.
      else
c        c_out.pt = 0.5*c_b*bf.bmag*c.q/c_out.cu  ! wrong if curvature changes
c                                                 ! sign
         c_out.pt = abs(0.5*c_b*bf.bmag*c.q/c_out.cu)
      endif
      call ucopy(c_gen.xref, c_out.xref, 3*FLOAT_WORD)
      c_out.p = c_out.pt * sqrt(1.+c_out.ct**2)  
c      c_out.q = c.q
      c_out.q = c.q * sign(ONE,c_out.cu * c.cu)


      status = cvt_ctk_wtk(c_out, mass, w_out)


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
      call ucopy(wcov, trk_off(trk_off_num).cov, 7*7*FLOAT_WORD)

      hep_off(hep) = trk_off_num          ! Point to this track from hep list
c
c     Now move the track's reference point to the primary vertex
c
      status = move_ctk_point_cov(c_out, ccov, prim_vertex(1,1),
     *                            c_out, ccov, s3d)
c
c     Now copy the central tracks into trc_par structures     
c
      if (trc_num.ge.max_trc) goto 9998
      trc_num = trc_num + 1
      trc_par(trc_num).icov = icov
      trc_par(trc_num).mass = mass
      trc_par(trc_num).ihep = hep
      call ucopy(c_out, trc_par(trc_num).c,            CTRACK_WORD)
      call ucopy(ccov,  trc_par(trc_num).cov, MPAR*MPAR*FLOAT_WORD)

      hep_cen(hep) = trc_num              ! Point to this track from hep list

 1000 pfit_fit_ctk = 0
      return

c     Error in multiple scattering code.
 9995 pfit_fit_ctk = 4
      return

c     Error transporting track during fit
 9996 pfit_fit_ctk = 4
      return

c     Not enough hits
 9997 pfit_fit_ctk = 3
      return

c     Too many offline tracks
 9998 pfit_fit_ctk = 1
      return

c     Error in fit
 9999 pfit_fit_ctk = 2
      return
      end
c
c$Id$
c
c$Log$
cRevision 1.1  2000/06/19 19:59:18  eugenio
cInitial revision
c
cRevision 1.14  1999/05/12 22:28:06  kutschke
cCall ctk_mscat_cov as a function.
c
c Revision 1.13  1998/06/23  23:47:38  bphyslib
c fix references to renamed routines
c
c Revision 1.12  1998/06/23  22:41:51  bphyslib
c rename routines moved from track to fitters library
c
c Revision 1.11  1997/05/09  02:36:14  kutschke
c Use c_gen, not c to covert ccov to wcov
c
c Revision 1.10  1997/03/27  05:03:49  kutschke
c Zero hits_b_zone at start of event.
c
c Revision 1.9  1997/03/24  17:36:27  kutschke
c Set icov=2 if no momentum info
c

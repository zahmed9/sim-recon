      subroutine klm_fit_ctk_diag ( hep, c, ccov, chisq,
     +                              hits, hits_sil, hits_stereo, 
     +                              nh_start_update, sig_init )

      implicit none

c
c Inputs:
c hep         - integer
c               Index into /hepevt/ for this track.
c
c c           - ctrack structure
c               The track parameters.
c
c ccov        - DFLOAT array
c               Covariance matrix of c
c
c chisq       - DFLOAT
c               Chisq of the fit.
c
c hits        - integer
c               Number of terms in the chisq.  Pixel devices count for 2
c               per hit; all others count for 1 per hit.
c
c hits_sil    - integer
c               Number of terms in the chisq which come from silicon 
c               devices.  Pixel devices count for 2.
c
c hits_stereo - integer
c               Number of terms in chisq which measure z.
c
c nh_start_update - integer
c                   The number of hits added to the track when the update
c                   was started.
c
c sig_init    - DFLOAT array
c               Starting values of the covariance matrix.
c
c Outputs: none
c
c Return value: none
c

#include "const.inc"
#include "wtrack_struct.inc"
#include "ctrack_struct.inc"
#include "bfield_struct.inc"
#include "stdhep.inc"
#include "vtxhep.inc"
#include "detector_general.inc"

c     Externals
      external cvt_wtk_ctk
      external prob
      external v3mag_d, pt_d, eta_d, phi_small

      integer  cvt_wtk_ctk
      real*4   prob
      DFLOAT   v3mag_d, pt_d, eta_d, phi_small

c     Number of track parameters = dimensions of covariance matrix.
      integer MPAR
      parameter ( MPAR = 5 )

c     Calling arguments.
      integer hep
      record /ctrack_struct/ c
      DFLOAT ccov(MPAR,MPAR)
      DFLOAT chisq
      integer hits, hits_sil, hits_stereo
      integer nh_start_update
      DFLOAT sig_init(MPAR)

c     The generated track in two different representations.
      record /wtrack_struct/ w_gen
      record /ctrack_struct/ c_gen

c     The magnetic field at the point at which the track was generated.
      record /bfield_struct/ bf

c     Difference between fitted and generated track parameters.
      DFLOAT del(MPAR)

c     Error on a track parameter and normalized residual on it.
      DFLOAT sig, resid

c     Ratio of final error to starting error on a track parameter.
      DFLOAT ratio

c     Prob(chisq,ndof) for the track fit.
      real*4 ppp

c     Temporary for checking name of detector.
      character*40 up_name

c     If the detector name contains the string D0 then we want
c     to change the histogram limits from their CDF defaults.
      logical D0

c     Stack for histogram directory.
      character*30 dir

c     Paw directory to hold these histograms.
      character*(*) pawdir
      parameter ( pawdir = '//PAWC/ctk_diag' )

c     Indexology.
      integer i

c     Stuff.
      integer status

c     Initialization control.
      logical init
      data init /.true./
      save init

c     Store the current directory.
      call hcdir ( dir, 'R' )

      if ( init ) then
        init = .false.

        call cmd_upcase ( det_general.name, up_name )
        D0 = index( up_name, 'D0') .ne. 0

c       Create the hbook directory.
        call hmdir  ( pawdir, 'S' )

        call hbook1 (  1, 'momentum ',   100,  0., 100., 0. )
        call hbook1 (  2, 'pt',          100,  0.,  20., 0. )
        call hbook1 (  3, 'eta',         100, -8.,   8., 0. )
        call hbook1 (  4, 'hits',        100,  0., 100., 0. )
        call hbook1 (  5, 'hits_stereo',  50,  0.,  50., 0. )
        call hbook1 (  6, 'hits_sil',     50,  0.,  50., 0. )
        call hbook1 (  7, 'chisq',       100,  0., 200., 0. )
        call hbook1 (  8, 'prob(chisq,ndof)', 100, 0., 1., 0. )
        call hbook1 (  9, 'hit at update start, all', 100, 0., 100., 0.)
        call hbook1 ( 10, 'Cov error bit mask',      12,   0.,  6., 0. )
        call hbook1 ( 11, 'normalized residual cu', 100, -10., 10., 0. )
        call hbook1 ( 12, 'normalized residual fi', 100, -10., 10., 0. )
        call hbook1 ( 13, 'normalized residual da', 100, -10., 10., 0. )
        call hbook1 ( 14, 'normalized residual ct', 100, -10., 10., 0. )
        call hbook1 ( 15, 'normalized residual z0', 100, -10., 10., 0. )
        if ( .not. D0 ) then
          call hbook1 ( 16, 'sigma cu', 100,   0.,      0.00020,  0. )
          call hbook1 ( 17, 'sigma fi', 100,   0.,      0.030,    0. )
          call hbook1 ( 18, 'sigma da', 100,   0.,      0.10,     0. )
          call hbook1 ( 19, 'sigma ct', 100,   0.,      0.06,     0. )
          call hbook1 ( 20, 'sigma z0', 100,   0.,      0.30,     0. )
          call hbook1 ( 21, 'del cu',   100,  -0.00020, 0.00020,  0. )
          call hbook1 ( 22, 'del fi',   100,  -0.030,   0.030,    0. )
          call hbook1 ( 23, 'del da',   100,  -0.10,    0.10,     0. )
          call hbook1 ( 24, 'del ct',   100,  -0.06,    0.06,     0. )
          call hbook1 ( 25, 'del z0',   100,  -0.30,    0.30,     0. )
        else
          call hbook1 ( 16, 'sigma cu', 100,   0.,      0.0006,   0. )
          call hbook1 ( 17, 'sigma fi', 100,   0.,      0.045,    0. )
          call hbook1 ( 18, 'sigma da', 100,   0.,      0.20,     0. )
          call hbook1 ( 19, 'sigma ct', 100,   0.,      0.15,     0. )
          call hbook1 ( 20, 'sigma z0', 100,   0.,      0.60,     0. )
          call hbook1 ( 21, 'del cu',   100,  -0.0006,  0.0006,   0. )
          call hbook1 ( 22, 'del fi',   100,  -0.045,   0.045,    0. )
          call hbook1 ( 23, 'del da',   100,  -0.20,    0.20,     0. )
          call hbook1 ( 24, 'del ct',   100,  -0.15,    0.15,     0. )
          call hbook1 ( 25, 'del z0',   100,  -0.60,    0.60,     0. )
        endif
        call hbook1 ( 26, 'log Err Ratio cu   ', 100, -10., 0., 0. )
        call hbook1 ( 27, 'log Err Ratio phi0 ', 100, -10., 0., 0. )
        call hbook1 ( 28, 'log Err Ratio da   ', 100, -10., 0., 0. )
        call hbook1 ( 29, 'log Err Ratio ct   ', 100, -10., 0., 0. )
        call hbook1 ( 30, 'log Err Ratio z0   ', 100, -10., 0., 0. )
        call hbook1 ( 31, 'log Err Ratio cu   ', 100, -10., 0., 0. )
        call hbook1 ( 32, 'log Err Ratio phi0,si ', 100, -10., 0., 0. )
        call hbook1 ( 33, 'log Err Ratio da,si   ', 100, -10., 0., 0. )
        call hbook1 ( 34, 'log Err Ratio ct,si   ', 100, -10., 0., 0. )
        call hbook1 ( 35, 'log Err Ratio z0,si   ', 100, -10., 0., 0. )

      else
         call hcdir ( pawdir, ' ' )

      endif

c     Fill per track histograms.
      ppp = prob( sngl(chisq), hits-5 )
      call hf1 ( 1, sngl(v3mag_d(phep(1,hep))), 1. )
      call hf1 ( 2, sngl(pt_d   (phep(1,hep))), 1. )
      call hf1 ( 3, sngl(eta_d  (phep(1,hep))), 1. )
      call hf1 ( 4, float(hits),                1. )
      call hf1 ( 5, float(hits_stereo),         1. )
      call hf1 ( 6, float(hits_sil),            1. )
      call hf1 ( 7, sngl(chisq),                1. )
      call hf1 ( 8, ppp,                        1. )
      call hf1 ( 9, float(nh_start_update),     1. )

      if ( ppp  .gt. 0.001 ) then

c        Compute generated parameters and deviations.
         call get_bfield(vtx_pos(1,ipvhep(hep)), bf)
         call hep_to_w(hep, w_gen)
         status = cvt_wtk_ctk(w_gen, vtx_pos(1,ipvhep(hep)), bf, c_gen)

         del(1) = c.cu - c_gen.cu
         del(2) = phi_small(c.phi0 - c_gen.phi0)
         del(3) = c.da - c_gen.da
         del(4) = c.ct - c_gen.ct
         del(5) = c.z0 - c_gen.z0

c        Fill the per track parameter histograms.
         do i = 1, MPAR

             if ( ccov(i,i) .gt. 0. ) then
               sig   = sqrt(ccov(i,i))
               resid = ( del(i) ) / sig
               ratio = sqrt(ccov(i,i))/sig_init(i)
               call hf1 ( 10+i, sngl(resid),         1. )
               call hf1 ( 15+i, sngl(sig),           1. ) 
               call hf1 ( 20+i, sngl(del(i)),        1. )
               call hf1 ( 25+i, sngl(dlog10(ratio)), 1. )
               if ( hits_sil .ge. 4 ) 
     +         call hf1 ( 30+i, sngl(dlog10(ratio)), 1. )
            else
               call hf1 ( 10, float(i), 1. )
            endif
         enddo
      endif

c     Restore previous hbook environment.
      call hcdir ( dir, ' ' )

c     Normal return.
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

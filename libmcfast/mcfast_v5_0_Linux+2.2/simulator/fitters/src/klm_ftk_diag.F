      subroutine klm_ftk_diag ( fit_status, w_gen, f, cov, chisq,
     +                          hits, icov, fill_res, node )
c
c Fill some diagnostic histograms about the fits of individual tracks.
c
c The hit level diagnostics are done in a separate routine written
c in c because the access to the hits requires a language with
c pointers.
c
      implicit none

#include "const.inc"
#include "ftrack_struct.inc"
#include "wtrack_struct.inc"
#include "hit_track_struct.inc"
#include "klm_smooth_struct.inc"
#include "devtype.inc"

c Arguments.

c     Input: Status flag from fitter.
      integer fit_status

c     Input: Generated track parameters.
      record /wtrack_struct/ w_gen

c     Input: Fitted track parameters.
      record /ftrack_struct/ f

c     Input: Covariance matrix of f.
      DFLOAT cov(FTRACK_NPAR,FTRACK_NPAR)

c     Input: Chisquared of the fit.
      DFLOAT chisq

c     Input: Number of degrees of freedom in the fit.
      integer hits(3)

c     Input: Flag saying if momentum was measured or not.
      integer icov

c     Input: 1 = fill the residual histograms
c            0 = do not fill them
      integer fill_res

c     Input: This is a kalman_node_struct which is passed through to 
c            klm_ftk_res_diag.  It be the node closest to the
c            production point of the track.  klm_ftk_res_diag actually
c            needs the address of this node; so it does not matter 
c            what data type we call this - the address is passed through.
      integer node

c Local variables.

c     Stack for histogram directory.
      character*30 dir

c     Directory into which these histograms go.
      character*(*) pawdir
      parameter ( pawdir = '//PAWC/ftk_diag' )

c     Number of degrees of freedom in the fit.
      integer ndof

c     Number of silicon strip or pixel hits.
c     Number of hits measuring some y information.
      integer hits_sil, hits_stereo

c     Starting values of the parameter errors used in the fit.
      DFLOAT sig_init(FTRACK_NPAR)

c     Confidence level of the fit.
      real*4 cl

c     Generated track parameters as input track parameters.
      record /ftrack_struct/ f_gen

c     Used in computing the residuals etc.
      DFLOAT resid, sig, del(5)
      real*4 res

c     The ratio of the final parameter error to the starting
c     value of that error.  Values larger than about 0.01 indicate
c     some bias towards the starting parameters.
      DFLOAT ratio

c     The histogram id of the error bitmap.
      integer id_err
      parameter ( id_err = 10 )

c     The histogram id of the error
      integer base_id_res
      parameter ( base_id_res = 36 )

c     Functions called.
      integer cvt_wtk_ftk
      real*4 prob
      real*8 v3mag_d, pt_d, eta_d

c     Miscellany.
      integer status, i, id

      logical init
      data init /.true./
      save init, sig_init

c     Store the current directory.
      call hcdir ( dir, 'R' )

      if ( init ) then
        init = .false.

c       Create the hbook subdirectory.
        call hmdir  ( pawdir, 'S' )

        call hbook1 (  1, 'fit status',   40, -10.,  10., 0. )
        call hbook1 (  2, 'momentum ',   100,   0., 500., 0. )
        call hbook1 (  3, 'pt',          100,   0.,  75., 0. )
        call hbook1 (  4, 'eta',         100,  -8.,   8., 0. )
        call hbook1 (  5, 'hits_stereo', 100,   0., 200., 0. )
        call hbook1 (  6, 'hits_sil',    100,   0., 200., 0. )
        call hbook1 (  7, 'chisq',       100,   0., 200., 0. )
        call hbook1 (  8, 'ndof',        100,   0., 200., 0. )
        call hbook1 (  9, 'prob(chisq,ndof)',  100, 0.,  1., 0. )

        call hbook1 ( id_err, 'Cov error bit mask', 24, 0., 12., 0. )

        call hbook1 ( 11, 'norm residual alpha', 100, -10., 10., 0. )
        call hbook1 ( 12, 'norm residual xslp',  100, -10., 10., 0. )
        call hbook1 ( 13, 'norm residual yslp',  100, -10., 10., 0. )
        call hbook1 ( 14, 'norm residual xp',    100, -10., 10., 0. )
        call hbook1 ( 15, 'norm residual yp',    100, -10., 10., 0. )

        call hbook1 ( 16, 'sigma alpha', 100,   0.,      0.00040,  0. )
        call hbook1 ( 17, 'sigma xslp',  100,   0.,      0.002,    0. )
        call hbook1 ( 18, 'sigma yslp',  100,   0.,      0.002,    0. )
        call hbook1 ( 19, 'sigma xp',    100,   0.,      0.01,     0. )
        call hbook1 ( 20, 'sigma yp',    100,   0.,      0.01,     0. )

        call hbook1 ( 21, 'del alpha',   100,  -0.00040, 0.00040,  0. )
        call hbook1 ( 22, 'del xslp',    100,  -0.002,   0.002,    0. )
        call hbook1 ( 23, 'del yslp',    100,  -0.002,   0.002,   0. )
        call hbook1 ( 24, 'del xp',      100,  -0.01,    0.01,     0. )
        call hbook1 ( 25, 'del yp',      100,  -0.01,    0.01,     0. )

        call hbook1 ( 26, 'log Err Ratio cu   ', 100, -10., 0., 0. )
        call hbook1 ( 27, 'log Err Ratio phi0 ', 100, -10., 0., 0. )
        call hbook1 ( 28, 'log Err Ratio da   ', 100, -10., 0., 0. )
        call hbook1 ( 29, 'log Err Ratio ct   ', 100, -10., 0., 0. )
        call hbook1 ( 30, 'log Err Ratio z0   ', 100, -10., 0., 0. )

        call hbook1 ( 31, 'log Err Ratio cu,good  ', 100, -10., 0., 0. )
        call hbook1 ( 32, 'log Err Ratio phi0,good', 100, -10., 0., 0. )
        call hbook1 ( 33, 'log Err Ratio da,good  ', 100, -10., 0., 0. )
        call hbook1 ( 34, 'log Err Ratio ct,good  ', 100, -10., 0., 0. )
        call hbook1 ( 35, 'log Err Ratio z0,good  ', 100, -10., 0., 0. )

        call hbook1 ( base_id_res,   'Normalized Residual, pixels.', 
     +                100, -10., 10., 0. )
        call hbook1 ( base_id_res+1, 'Normalized Residual, forward sil', 
     +                100, -10., 10., 0. )
        call hbook1 ( base_id_res+2, 'Normalized Residual, ftrk.', 
     +                100, -10., 10., 0. )
        call hbook1 ( base_id_res+3, 'Normalized Residual, other.', 
     +                100, -10., 10., 0. )

        call klm_get_start_param_errors ( sig_init )

      else
        call hcdir ( pawdir, ' ' )

      endif

c     Fill per track histograms.
      call hf1 ( 1, float(fit_status), 1. )
      if ( fit_status .ne. 0. ) return

      ndof        = hits(1) - 5
      hits_sil    = hits(2)
      hits_stereo = hits(3)

      call hf1 ( 2, sngl(v3mag_d(w_gen)), 1. )
      call hf1 ( 3, sngl(pt_d   (w_gen)), 1. )
      call hf1 ( 4, sngl(eta_d  (w_gen)), 1. )
      call hf1 ( 5, float(hits_stereo),   1. )
      call hf1 ( 6, float(hits_sil),      1. )
      call hf1 ( 7, sngl(chisq),          1. )
      call hf1 ( 8, float(ndof),          1. )

      if ( ndof .gt. 0 ) then
          cl = prob( sngl(chisq), ndof )
      else if ( ndof .eq. 0 ) then
          cl = 0.99999
      else
          return
      endif
      call hf1 ( 9, cl, 1. )

      if ( cl .gt. 0.001 ) then

c        Compute generated ftrack parameters and the deviations
c        between fitted and generated.
         status = cvt_wtk_ftk(w_gen, f_gen )

         del(1) = f.alpha - f_gen.alpha
         del(2) = f.xslp  - f_gen.xslp
         del(3) = f.yslp  - f_gen.yslp
         del(4) = f.xp    - f_gen.xp
         del(5) = f.yp    - f_gen.yp

         do i = 1, FTRACK_NPAR

             if ( cov(i,i) .gt. 0. ) then
               sig   = sqrt(cov(i,i))
               resid = ( del(i) ) / sig
               ratio = sqrt(cov(i,i))/sig_init(i)
               call hf1 ( 10+i, sngl(resid),         1. )
               call hf1 ( 15+i, sngl(sig),           1. ) 
               call hf1 ( 20+i, sngl(del(i)),        1. )
               call hf1 ( 25+i, sngl(dlog10(ratio)), 1. )
               if ( hits_sil .gt. 4 .and. icov .eq. 1 .and.
     +              ndof     .gt. 20 .and. hits_stereo .gt. 6 ) 
     +         call hf1 ( 30+i, sngl(dlog10(ratio)), 1. )
            else
               call hf1 ( 10, float(i), 1. )
            endif
         enddo

      endif

c     Fill the residual histograms.
      if ( fill_res .eq. 1) 
     +     call klm_ftk_res_diag ( id_err, base_id_res, node )

c     Restore previous hbook environment.
      call hcdir ( dir, ' ' )

      end
c
c $Id$
c 
c $Log$
c Revision 1.1  2000/06/19 19:59:16  eugenio
c Initial revision
c
c Revision 1.3  2000/01/22 22:30:11  kutschke
c Change selection for histos 31...35.  Add icov arg.
c
c Revision 1.2  2000/01/14  02:45:08  kutschke
c Now call klm_ftk_res_diag to do residuals.  Change arg list.
c
c

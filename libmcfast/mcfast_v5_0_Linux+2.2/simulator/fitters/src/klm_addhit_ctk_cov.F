      integer function klm_addhit_ctk_cov(c, dc1, ccov1, hit, trace, 
     *                                    bf, types, dc2, ccov2, chisq )
c
c  Add a hit to a track, update the covariance matrix and update
c  the linearized track parameter corrections.
c
c  This is the repeating step in the kalman filter.
c
c  The routine assumes that the track has already been projected to
c  the hit.
c
c  Inputs:
c
c  c       c track structure
c          Input track parameters
c
c  dc1     DFLOAT array
c          Linearized correction to c.
c
c  ccov1   DFLOAT array
c          Initial 5x5 covariance matrix for c
c
c  hit     hit structure
c          Describes this hit.
c
c  trace   trace structure 
c          Describes this trace point.
c
c  bf      b field structure
c          B field info
c
c  Outputs:
c  types   integer array
c          types(1) ndof of hits added
c          types(2) ndof of silicon hits added
c          types(3) ndof of z info added
c          ndof = number of degrees of freedom
c          See note 1).
c
c  dc2     DFLOAT array
c          Updated linearized correction to c.
c
c  ccov2   DFLOAT array
c          Updated 5x5 covariance matrix for c
c
c  chisq   DFLOAT variable
c          Contribution of this hit to track chi-squared.
c
c  Return value:
c          0     = all ok
c          other = error
c
c Notes:
c 1) In most cases ndof=1.  However for pixel detectors, ndof=2, provided
c    information from both views is added to the track.  In
c    pfit_fit_ftk, the types variable returned the number of hits
c    not ndof.
c 2) It is allowed that dc1 and dc2 may share storage.
c    Also true for ccov1 and ccov2
c 3) The basic algorithm is:
c     A) Device dependent part:
c          i) compute weigth from sigma.
c         ii) compute measurement, dcalc0.
c        iii) compute derivatives of measurement wrt track parameters.
c         iv) compute types.
c     B) Device independent.
c          i) update covariance matrix.
c         ii) update dc.
c 4) I checked to see which detectors needed a full computation of
c    the measurement and its derivatives.  It was only necessary for the
c    drift chamber stereo wires.  In particular the barrel and forward
c    silicon devices did not need them;  this may need to be revisited
c    if we allow arbitrarily aligned detectors.  The checks were done
c    by looking at prob(chisq,ndof) with multiple scattering and
c    energy loss turned off.  I also made sure to run high statistics
c    runs at extreme angles and exteremely low momenta.
c
      implicit none

#include "const.inc"
#include "ctrack_struct.inc"
#include "bfield_struct.inc"
#include "hit_track_struct.inc"
#include "trace_struct.inc"
#include "devtype.inc"

c     Externals
      external dcalc_ctk_xyplane
      external dcalc_ctk_axial
      external dcalc_ctk_xyplane_drv
      external dcalc_ctk_axial_drv
      external dcalc_ctk_zplane_drv
      external dcalc_ctk_zplane
      external dcalc_ctk_stereo_drv_exact
      external addhit_1
      external cov_addhit_1

      integer  dcalc_ctk_xyplane
      integer  dcalc_ctk_axial
      integer  dcalc_ctk_xyplane_drv
      integer  dcalc_ctk_axial_drv
      integer  dcalc_ctk_zplane_drv
      integer  dcalc_ctk_zplane
      integer  dcalc_ctk_stereo_drv_exact
      integer  addhit_1
      integer  cov_addhit_1

c     Number of track parameters; also dimension of arrays.
      integer MPAR
      parameter (MPAR = 5)

c     Calling arguments
      record /ctrack_struct/ c
      DFLOAT dc1(MPAR), dc2(MPAR)
      DFLOAT ccov1(MPAR,MPAR), ccov2(MPAR,MPAR)
      record /bfield_struct/ bf
      record /hit_trk_s/ hit
      record /trace_s/   trace
      integer types(3)
      DFLOAT chisq

c     Local variables

c     Return status of called routines
      integer status

c     Does this hit contain stereo information.
      logical lstereo

c     Inverse of error**2.
      DFLOAT weight

c     Derivatives of measurement wrt track parameters.
      DFLOAT derv(MPAR)

c     Predicted measurement using only c ( not c + dc ).
      DFLOAT dcalc0

c     Arc length moved by a move routine.  Never used.
      DFLOAT s3d

c     The weight matrix of the input track parameters.
c     Used in chi2 calculation.  Most be computed before ccov
c     is updated ( in case ccov1 and ccov2 share the same storage ).
      DFLOAT fwt(MPAR,MPAR)

c     Position of the wire in the local coordinate system.  We have 
c     already transported to ensure that that the origin is a point
c     on the wire.  So this is trivially (0.,0.,0.).
      real*8 orig(3)

      data orig / 0., 0.,  0. /
      save orig

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(trace.type .ne. 1 .and. trace.type .ne. 2) goto 9998

      types(1) = 0
      types(2) = 0
      types(3) = 0
      chisq    = 0.

      call invert_sym_d(ccov1, fwt)

c     Silicon barrel plane
      if(hit.chan.devtype .eq. jdev_silbarrel) then

        if(hit.dmeas_sigma .eq. 0.) goto 9997
        weight = 1. / hit.dmeas_sigma**2

        types(1) = 1
        types(2) = 1
        if ( hit.dircos(3) .eq. 0. ) then
          types(3) = 0
        else
          types(3) = 1
        endif

        status = dcalc_ctk_xyplane_drv(c, hit.pos, trace.eta, 
     +                                 hit.dircos, derv)
        if ( status .ne. 0 ) goto 9999
        status = dcalc_ctk_xyplane(c, hit.pos, trace.eta,
     *                             hit.dircos, bf, dcalc0, s3d )
        if ( status .ne. 0 ) goto 9999

c     Drift layer
      else if(hit.chan.devtype .eq. jdev_driftbarrel) then

        if(hit.dmeas_sigma .eq. 0.) goto 9997
        weight  = 1. / hit.dmeas_sigma**2

        lstereo = hit.dircos(1).ne.0. .or. hit.dircos(2).ne.0.
          
        if(.not.lstereo) then
          types(1) = 1
          types(2) = 0
          types(3) = 0
          status = dcalc_ctk_axial(c, hit.pos, bf, dcalc0, s3d)
          if ( status .ne. 0 ) goto 9999
          status = dcalc_ctk_axial_drv(c, hit.pos, bf, derv)
          if ( status .ne. 0 ) goto 9999

        else
          types(1) = 1
          types(2) = 0
          types(3) = 1
          status = dcalc_ctk_stereo_drv_exact ( c, orig, hit.dircos,
     *                                      dcalc0, derv, s3d )
          if ( status .ne. 0 ) goto 9999

        endif

c     Silicon disk
      else if(hit.chan.devtype .eq. jdev_sildisk)  then

        if(hit.dmeas_sigma .eq. 0.) goto 9997
        weight = 1. / hit.dmeas_sigma**2

        types(1) = 1
        types(2) = 1
        types(3) = 1

        status = dcalc_ctk_zplane_drv(c, hit.dircos, derv)
        if ( status .ne. 0 ) goto 9999
        status = dcalc_ctk_zplane(c, hit.pos, hit.dircos, dcalc0, s3d )
        if ( status .ne. 0 ) goto 9999

      else
        goto 9996

      endif

c     Update the covariance matrix.
      status = cov_addhit_1(ccov1, derv, weight, ccov2, MPAR, MPAR)
      if ( status .ne. 0 ) goto 9999

c     Update the linearized track parameters and compute chi2.
      status = addhit_1 ( dc1, ccov2, derv, dcalc0, hit.dmeas, 
     &                    hit.dmeas_sigma**2, dc2, fwt, chisq )
      if ( status .ne. 0 ) goto 9999

c     Normal exit
 1000 klm_addhit_ctk_cov = 0
      return

c     Unknown device.
 9996 klm_addhit_ctk_cov = 4
      write(6,*) 'klm_addhit_ctk_cov  Unknown device type:', 
     +           hit.chan.devtype
      return
      
c     No error for this hit
 9997 klm_addhit_ctk_cov = 3
      write(6,5000) hit.chan.devtype, hit.chan.devnum, hit.chan.devlayer
 5000 format(
     *  'klm_addhit_ctk_cov: No measurement sigma for device type',
     *  i5,' device # ',i5,' layer= ', i5)
      return

c     Illegal plane type
 9998 klm_addhit_ctk_cov = 2
      return

c     Error from lower routine.
 9999 klm_addhit_ctk_cov = status
      
      end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:15  eugenio
c Initial revision
c
c Revision 1.2  1999/06/18 16:46:36  kutschke
c Now uses trace.eta for sibarrel.  No refs remain to geometry db
c
c Revision 1.1  1999/05/12  20:21:32  kutschke
c 21 files changed/added to implement ctk Kalman filter.
c
c

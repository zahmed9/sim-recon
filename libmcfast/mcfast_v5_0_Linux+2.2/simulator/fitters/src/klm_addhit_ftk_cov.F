      integer function klm_addhit_ftk_cov(f, df1, fcov1, hit, 
     *                                    bf, types, df2, fcov2, chisq)
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add a hit to a track, updating both the covariance matrix and the
c  linearized correction. This is he repeating step in the kalman filter.
c
c  The routine assumes that the track has already beem projected to
c  a point close to the hit.  "Close" is defined to be close enough
c  that the measured quantity and the derivatives can be computed
c  using a straight line approximation.
c
c  Inputs:
c
c  f       f track structure
c          Input track parameters
c
c  df      DFLOAT array
c          Input linearized correction to track parameters.
c
c  fcov1   DFLOAT array
c          Initial 5x5 covariance matrix for f
c
c  hit     Hit structure.
c          The information for this hit.
c
c  bf      b field structure
c          B field info
c
c  Outputs:
c  types   integer array
c          types(1) = Number of degrees of freedom added
c          types(2) = Number of silicon degrees of freedom added
c          types(3) = Number of stereo degrees of freedom added
c
c  df      DFLOAT array
c          Output linearized correction to track parameters.
c
c  fcov2   DFLOAT array
c          Updated 5x5 covariance matrix for f
c
c  chisq   DFLOAT
c          Chi**2 contribution of this hit.
c
c  Return:
c          0     ==> all ok
c          Other ==> error
c
c  Notes:
c  (1) The types argument is different from that used in the pfit fitters.
c      Now it counts degrees of freedom, rather than being a true/false
c      flag for what sort of information was added.
c  (2) The definition of "stereo" is not really very good.  It really
c      means that the hit contains y information.
c      A better treatment requires knowing a lot more about the particular
c      detector being studied.
c  (3) Silicon strip detectors are treated as a special case of 
c      pixel planes.
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
      implicit none

#include "const.inc"
#include "devtype.inc"
#include "ftrack_struct.inc"
#include "bfield_struct.inc"
#include "hit_track_struct.inc"

c     Externals
      external dcalc_ftk_xyplane_drv
      external dcalc_ftk_zpixel_drv
      external dcalc_ftk_axial_drv
      external dcalc_ftk_stereo_drv
      external dcalc_ftk_zplane_drv
      external dcalc_ftk_zpixel
      external cov_addhit_1
      external cov_addhit_2
      external addhit_1
      external addhit_2
      external invert_sym_d

      integer  dcalc_ftk_xyplane_drv
      integer  dcalc_ftk_zpixel_drv
      integer  dcalc_ftk_axial_drv
      integer  dcalc_ftk_stereo_drv
      integer  dcalc_ftk_zplane_drv
      integer  dcalc_ftk_zpixel
      integer  cov_addhit_1
      integer  cov_addhit_2
      integer  addhit_1
      integer  addhit_2
      integer  invert_sym_d

      integer MPAR
      parameter (MPAR = 5)

c     Calling arguments
      record /ftrack_struct/ f
      DFLOAT fcov1(MPAR,MPAR), fcov2(MPAR,MPAR)
      record /bfield_struct/ bf
      integer types(3)
      DFLOAT df1(MPAR), df2(MPAR), chisq

      record /hit_trk_s/ hit

c     Local variables
      integer status, isc
      integer dev_type, dev_id, dev_layer, pln, wfr
      integer nsegm_x, nsegm_y
      integer si_type
      logical lstereo

      DFLOAT s3d, dcalc, derv(MPAR)
      DFLOAT weight, derv2(MPAR,2)
      DFLOAT etan(3)
      DFLOAT cos_st, sin_st

      ! For 1d and 2d measurements.  The value of the measurement
      ! computed using the current value of the seed parameters,
      ! that is, without the linearized correction added in.
      DFLOAT dcalc0, dcalc2_1(2)

      ! A temporary in the calculation of dcalc2_1.  This is the same
      ! quantity but in the world coordinate system.
      DFLOAT dcalc2_0(2)

      ! The weight matrix of the input track parameters.
      ! Used in chi2 calculation.  Most be computed before fcov1
      ! is updated.
      DFLOAT fwt(MPAR,MPAR)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      dev_type   = hit.chan.devtype
      dev_id     = hit.chan.devnum
      dev_layer  = hit.chan.devlayer

c     Silicon disk
      if(dev_type .eq. jdev_sildisk) then
          if(hit.dmeas_sigma .eq. 0.) goto 9997
          weight = 1. / hit.dmeas_sigma**2
          types(1) = 1
          types(2) = 1
          types(3) = 1
          status = dcalc_ftk_zplane_drv(f, hit.dircos, derv)
          isc=cov_addhit_1(fcov1, derv, weight, fcov2, 5, 5)

c     Silicon XY pixel plane
      else if(dev_type .eq. jdev_pixelplane ) then

          if ( hit.dpix_cov(1,1) .eq. 0.) goto 9997
          if ( hit.dpix_cov(2,2) .eq. 0.) goto 9997

          types(1) = 2
          types(2) = 2
          types(3) = 1

          status = dcalc_ftk_zpixel_drv(f, derv2)
          if( status .ne. 0 ) goto 9998

          status = dcalc_ftk_zpixel(f, hit.pos(3),
     *                              dcalc2_0, s3d)
          if( status .ne. 0 ) goto 9998

          call world_to_local_2d
     *            ( dcalc2_0, hit.pos, hit.dircos, dcalc2_1)

          status = invert_sym_d(fcov1, fwt)
          if ( status .ne. 0 ) goto 9996

c         Update the covariance matrix.
          status = cov_addhit_2(fcov1, derv2, hit.dpix_cov,
     *                          fcov2, 5, 5)
          if( status .ne. 0 ) goto 9998

c         Update the linearized track parameters and compute chi2.
          status =  addhit_2 ( df1, fcov2, derv2, dcalc2_1,
     *                         hit.dpix, 
     *                         hit.dpix_cov,
     *                         df2, fwt, chisq )
          if( status .ne. 0 ) goto 9998

c     A strip detector, not a pixel detector.
      else if(dev_type .eq. jdev_silplane ) then

          if ( hit.dmeas_sigma .eq. 0.) goto 9997
          weight = 1./hit.dmeas_sigma**2

          types(1) = 1
          types(2) = 1
          if ( hit.dircos(2) .eq. 0. ) then
             types(3) = 0
          else
             types(3) = 1
          endif

          status = dcalc_ftk_zplane_drv(f, hit.dircos, derv)
          if( status .ne. 0 ) goto 9998

          dcalc0 = (f.xp-hit.pos(1))*hit.dircos(1) +
     *             (f.yp-hit.pos(2))*hit.dircos(2)

          status = invert_sym_d(fcov1, fwt)
          if ( status .ne. 0 ) goto 9997

          ! Update the covariance matrix.
          status = cov_addhit_1(fcov1, derv, weight, fcov2, 5, 5)
          if( status .ne. 0 ) goto 9998

          ! Update the linearized track parameters and compute chi2.
          status = addhit_1 ( df1, fcov2, derv, dcalc0,
     *                        hit.dmeas,
     *                        hit.dmeas_sigma**2,
     *                        df2, fwt, chisq )
          if( status .ne. 0 ) goto 9998

c     Forward drift plane
      else if(dev_type .eq. jdev_driftplane) then

          if(hit.dmeas_sigma .eq. 0.) goto 9997
          weight = 1./hit.dmeas_sigma**2

          types(1) = 1
          types(2) = 0
          if ( hit.dircos(2) .eq. 0. ) then
             types(3) = 0
          else
             types(3) = 1
          endif

          status = dcalc_ftk_zplane_drv(f, hit.dircos, derv)
          if( status .ne. 0 ) goto 9998

          ! The routine dcalc_ftk_zplane.F returns distances
          ! referred to the global origin, not to the local origin.
          ! Need to fix this so that we can deal (f.z .ne. z of plane).
          dcalc0 = (
     *      ( f.xp-hit.pos(1) ) * hit.dircos(1) +
     *      ( f.yp-hit.pos(2) ) * hit.dircos(2)   )

          status = invert_sym_d(fcov1, fwt)
          if ( status .ne. 0 ) goto 9996

          ! Update the covariance matrix.
          status = cov_addhit_1(fcov1, derv, weight, fcov2, 5, 5)
          if( status .ne. 0 ) goto 9998

          ! Update the linearized track parameters and compute chi2.
          status = addhit_1 ( df1, fcov2, derv, dcalc0,
     *                        hit.dmeas, 
     *                        hit.dmeas_sigma**2,
     *                        df2, fwt, chisq )
          if( status .ne. 0 ) goto 9998

      else
          goto 9999

      endif

c     normal exit
 1000 klm_addhit_ftk_cov = 0
      return

c     Error inverting covariance matrix.
 9996 klm_addhit_ftk_cov = 4
      return

c     No error for this hit
 9997 klm_addhit_ftk_cov = 3
      write(6,5000) dev_type, dev_id, dev_layer
 5000 format('klm_addhit_ftk_cov: No measurement sigma for device type', 
     *           i5,' device # ',i5,' layer= ', i5)
      return      

c     Error returned from lower routine.
 9998 klm_addhit_ftk_cov = status
      return

c     Do not know how to deal with this device.
 9999 klm_addhit_ftk_cov = 5
      write(6,*) 'klm_addhit_ftk_cov: Unimplemented device type: ', 
     +           dev_type
      return

      end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:15  eugenio
c Initial revision
c
c Revision 1.8  2000/01/13 05:04:00  kutschke
c Remove all references to geometry commons.
c
c Revision 1.7  1999/04/07  01:57:09  kutschke
c types(2)=1 for strip detectors.
c
c Revision 1.6  1999/03/26  02:49:50  kutschke
c Updates for strip detectors.
c
c Revision 1.5  1999/03/16  23:51:49  kutschke
c Fix world/local bug.
c
c Revision 1.4  1998/11/11  05:08:34  kutschke
c Hit common to argument list.  Implement strip detectors. Check error codes.
c
c Revision 1.3  1998/09/08  16:22:37  kutschke
c Check status of invert_sym_d and abort if needed.
c
c Revision 1.2  1998/03/16  20:33:36  garren
c AIX complains if you call a function and that function is also declared external
c
c Revision 1.1  1998/02/13  23:08:40  kutschke
c New routine.
c
c

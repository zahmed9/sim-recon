      integer function pfit_addhit_ctk_cov(c, ccov1, hit, trace, bf,
     *                                    types, ccov2)
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add a hit to a track and update the covariance matrix only. This is
c  the repeating step in the kalman filter.
c
c  The routine assumes that the track has already beem projected to
c  the hit.
c
c  Inputs:
c
c  c       c track structure
c          Input track parameters
c
c  ccov1   DFLOAT array
c          Initial 5x5 covariance matrix for c
c
c  hit     integer variable
c          Hit # in hit list
c
c  trace   integer variable
c          Current trace #
c
c  bf      b field structure
c          B field info
c
c  Outputs:
c  types   integer array
c          types(1) = 1 ==> hit was added
c          types(2) = 1 ==> silicon hit was added
c          types(3) = 1 ==> z info hit was added
c
c  ccov2   DFLOAT array
c          Updated 5x5 covariance matrix for c
c
c  Return:
c          0 ==> all ok
c          1 ==> error
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
      implicit none

#include "const.inc"
#include "ctrack_struct.inc"
#include "bfield_struct.inc"
#include "si_barrel.inc"
#include "drift.inc"
#include "for_trk.inc"
#include "devtype.inc"
#include "hit_track.inc"
#include "trace.inc"

c     Externals
      external dcalc_ctk_xyplane_drv
      external dcalc_ctk_axial_drv
      external dcalc_ctk_stereo_drv
      external dcalc_ctk_zpixel_drv
      external dcalc_ctk_zplane_drv
      external cov_addhit_1

      integer  dcalc_ctk_xyplane_drv
      integer  dcalc_ctk_axial_drv
      integer  dcalc_ctk_stereo_drv
      integer  dcalc_ctk_zpixel_drv
      integer  dcalc_ctk_zplane_drv
      integer  cov_addhit_1

c     Calling arguments
      record /ctrack_struct/ c
      DFLOAT ccov1(5,5), ccov2(5,5)
      record /bfield_struct/ bf
      integer hit, types(3), trace

      integer MPAR
      parameter (MPAR = 5)

c     Local variables
      integer i, status, isc
      integer plane_type, plane_id
      integer dev_type, dev_id, dev_layer, pln
      integer si_type
      logical lstereo

      DFLOAT dpar(MPAR), s3d
      DFLOAT derv(MPAR), derv2(MPAR,2)
      DFLOAT xp, weight, etan(3), etam(3)
      DFLOAT cos_st, sin_st, stereo
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(hit .le. 0) goto 9999

      plane_type = trace_par(trace).type        !Radial or z plane
      plane_id = trace_par(trace).plane         !Position in radial or z list

      dev_type = hit_trk(hit).chan.devtype      !Device type
      dev_id = hit_trk(hit).chan.devnum         !Device #
      dev_layer = hit_trk(hit).chan.devlayer    !Layer # in device

c     Get the calculated distance to the point and its derivatives
      if(plane_type .ne. 1 .and. plane_type .ne. 2) goto 9998

c     Silicon barrel plane
      if(dev_type .eq. jdev_silbarrel) then
        if(hit_trk(hit).dmeas_sigma .eq. 0.) goto 9997
        weight = 1. / hit_trk(hit).dmeas_sigma**2
        si_type = sib_par(dev_id).lyr(dev_layer).plane(1).type

        pln = hit_trk(hit).chan.devwid(1)
        cos_st = sib_par(dev_id).lyr(dev_layer).plane(pln).cos_stereo
        sin_st = sib_par(dev_id).lyr(dev_layer).plane(pln).sin_stereo

c     Stereo angle is in local wafer coordinates. Calculate global
c     measurement vector.
c     Note that the type variable should be obsolete since the stereo
c     angle is specified
        etan(1) = sib_par(dev_id).lyr(dev_layer).plane(pln).eta(1)
        etan(2) = sib_par(dev_id).lyr(dev_layer).plane(pln).eta(2)
        etan(3) = sib_par(dev_id).lyr(dev_layer).plane(pln).eta(3)

        status = dcalc_ctk_xyplane_drv(c, hit_trk(hit).pos,
     *                                 etan, hit_trk(hit).dircos, 
     *                                 derv)
        types(1) = 1
        types(2) = 1
        if(si_type.eq.1 .and. sin_st.eq.0.) then
          types(3) = 0
        else
          types(3) = 1
        endif
        isc=cov_addhit_1(ccov1, derv, weight, ccov2, 5, 5)

c     Drift layer
      else if(dev_type .eq. jdev_driftbarrel) then
        if(hit_trk(hit).dmeas_sigma .eq. 0.) goto 9997
        weight = 1. / hit_trk(hit).dmeas_sigma**2
        lstereo = drf_par(dev_id).an(dev_layer).lstereo
        if(.not.lstereo) then
          status = dcalc_ctk_axial_drv(c, hit_trk(hit).pos,
     *                                 bf, derv)
          types(1) = 1
          types(2) = 0
          types(3) = 0
          isc=cov_addhit_1(ccov1, derv, weight, ccov2, 5, 5)

        else
          status = dcalc_ctk_stereo_drv(c, hit_trk(hit).pos,
     *                                  hit_trk(hit).dircos, bf,
     *                                  derv)
          types(1) = 1
          types(2) = 0
          types(3) = 1
          isc=cov_addhit_1(ccov1, derv, weight, ccov2, 5, 5)
        endif

c     Silicon disk
      else if(dev_type .eq. jdev_sildisk)  then
        if(hit_trk(hit).dmeas_sigma .eq. 0.) goto 9997
        weight = 1. / hit_trk(hit).dmeas_sigma**2
        types(1) = 1
        types(2) = 1
        types(3) = 1
        status = dcalc_ctk_zplane_drv(c, hit_trk(hit).dircos, derv)
        isc=cov_addhit_1(ccov1, derv, weight, ccov2, 5, 5)

c     Silicon pixel plane
      else if(dev_type .eq. jdev_pixelplane.or.
     +        dev_type .eq. jdev_silplane      ) then
        types(1) = 1
        types(2) = 1
        types(3) = 1
        status = dcalc_ctk_zpixel_drv(c, derv2)

        call cov_addhit_2(ccov1, derv2, hit_trk(hit).dpix_cov,
     *                    ccov2, 5, 5)

c     Forward drift plane
      else if(dev_type .eq. jdev_driftplane) then
        types(1) = 1
        types(2) = 0
        types(3) = 1
        stereo = ftrk_par(dev_id).lyr(dev_layer).stereo
        if (stereo .gt. 0.) then
          etam(1) = -sin(stereo)  
          etam(2) = cos(stereo)
          etam(3) = 0.0
        else
          etam(1) = sin(stereo)
          etam(2) = -cos(stereo)
          etam(3) = 0.0
        endif
       
        status = dcalc_ctk_zplane_drv(c, etam, derv)     
        isc=cov_addhit_1(ccov1, derv, weight, ccov2, 5, 5)

      endif

c     normal exit
 1000 pfit_addhit_ctk_cov = 0
      return
      
c     No error for this hit
 9997 pfit_addhit_ctk_cov = 3
      write(6,5000) dev_type, dev_id, dev_layer
 5000 format('pfit_addhit_ctk_cov: No measurement sigma for device type', 
     *           i5,' device # ',i5,' layer= ', i5)
      return      

c     Illegal plane type
 9998 pfit_addhit_ctk_cov = 2
      return

c     Illegal hit
 9999 pfit_addhit_ctk_cov = 1
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:18  eugenio
c Initial revision
c
c Revision 1.10  2000/01/13 05:06:56  kutschke
c Check for jdev_silplane devices.
c
c Revision 1.9  1998/06/23  22:41:50  bphyslib
c rename routines moved from track to fitters library
c
c Revision 1.8  1998/03/16  20:44:06  garren
c make it compile on AIX
c
c Revision 1.7  1998/03/16  20:33:36  garren
c AIX complains if you call a function and that function is also declared external
c
c Revision 1.6  1997/04/04  20:30:17  garren
c add rcs log line
c

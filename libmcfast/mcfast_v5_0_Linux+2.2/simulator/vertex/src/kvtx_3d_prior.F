      integer function kvtx_3d_prior(ntrk, itrk, update, 
     *           lusez, zi, vzi, z, vz, chisq)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Performs a vertex fit to several tracks in the KN list using the
C  position and covariance matrix of another vertex to constrain the fit.
C
C  NTRK    integer variable (read)
C          # of tracks to fit (length of ITRK)
C
C  ITRK    integer  array (read)
C          list of tracks in KN list to fit (length = NTRK)
C
C  UPDATE  integer variable (read)
C          0 ==> do not update input track parameters (just calculate chisq)
C          1 ==> update input track parameters only
C          2 ==> update input track parameters & covariance matrices and
C                replace the original unconstrainted parameters by the
C                new ones. ****** This is a dangerous option. ******
C
C  LUSEZ   logical variable (read)
C          TRUE  ==> use the value of Z as the starting value
C          FALSE ==> use the value of ZI as the starting value
C
C  ZI      real array (read)
C          Position of known vertex
C
C  VZI     real array (read)
C          3x3 covariance matrix of known matrix ZI
C
C *Z       real array (read/write)
C          On input,  initial values of (x,y,z)
C          On output, updated values of (x,y,z)
C
C *VZ      real array (write)
C          3x3 covariance matrix of z(1-3)
C
C *CHISQ   real variable (write)
C          Chisquare of fit
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
c created 11/21/94 A. Boehnlein from P. Avery CLEO routine KVTXCV
      implicit none
#include "const.inc"
#include "wtrack_struct.inc"
#include "track_kine.inc"
#include "kine_vtx_cnst.inc"
#include "kine_chi.inc"
#include "track_dx.inc"

C     Calling arguments
      integer ntrk, itrk(*), update
      logical lusez, lerror
      DFLOAT chisq, zi(3), vzi(3,3), z(3), vz(3,3)
C
C     Local variables
      integer il, it, i, status
      DFLOAT zv(3)
      DFLOAT dz(3), vdedz(2), dchisq
      integer  kvtx_3d, kvtx_average
      external kvtx_3d, kvtx_average
      integer kvtx_dx_update,ksub_update,kvtx_cov_update
      external kvtx_dx_update,ksub_update,kvtx_cov_update
      integer ksub_overwrite
      external ksub_overwrite
      
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C     Use input Z if requested, otherwise use the vertex position in I
      if(lusez) then
        zv(1) = z(1)
        zv(2) = z(2)
        zv(3) = z(3)
      else
        zv(1) = zi(1)
        zv(2) = zi(2)
        zv(3) = zi(3)
      endif

C     First find vertex without initial vertex constraint
      status = kvtx_3d(ntrk, itrk, update, .true., zv,
     *                 vz, chisq, lerror)
      if(status.ne.0) goto 9999

C     Do weighted average with initial vertex
      status = kvtx_average(zv, vz, zi, vzi, z, vz, dchisq)
      if(dchisq .lt. 0.) goto 9999
      chisq = chisq + dchisq

C     Update tracks again
C     xnew = xold - Vx0 * D(t) * VD * E * dz
C          = xold - DVX * VDE * dz
      if(update .ne. 0) then
        dz(1) = z(1) - zv(1)
        dz(2) = z(2) - zv(2)
        dz(3) = z(3) - zv(3)
        do 200 il=1,ntrk
          it = itrk(il)
          vdedz(1) = vtx_cnst.trk_cnst(it).vde(1,1)*dz(1)
     *             + vtx_cnst.trk_cnst(it).vde(1,2)*dz(2)
     *             + vtx_cnst.trk_cnst(it).vde(1,3)*dz(3)
          vdedz(2) = vtx_cnst.trk_cnst(it).vde(2,1)*dz(1)
     *             + vtx_cnst.trk_cnst(it).vde(2,2)*dz(2)
     *             + vtx_cnst.trk_cnst(it).vde(2,3)*dz(3)
          status = kvtx_dx_update(it, vdedz, .false.)
          status = ksub_update(it, trk_dx(it), .true.)
        if(update .ge. 2) then
          status = kvtx_cov_update(it)
          status = ksub_overwrite(it)
        endif
200     continue
      endif

C     Put into Common
      zv(1) = z(1)
      zv(2) = z(2)
      zv(3) = z(3)

c     normal exit
1000  continue
      kvtx_3d_prior = 0
      chif = chisq
      nconf = 2*ntrk
      ndegf = nconf
      return

C     Error exit
9999  continue
      kvtx_3d_prior = 1
      lerror = .true.
      chisq = -1.
      chif = chisq
      nconf = 0
      ndegf = 0
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:47  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:32:11  garren
c add rcs log line
c

      integer function kvtx_3d_fix(it, update, z, chisq)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     Refit a track to go through a fixed x,y,z point.
C
C  IT      integer variable (read)
C          Number of the track to be fit
C
C  UPDATE  integer variable (read)
C          0 ==> do not update input track parameters (just calculate chisq)
C          1 ==> update input track parameters only
C          2 ==> update input track parameters & covariance matrices and
C                replace the original unconstrainted parameters by the
C                new ones. ****** This is a dangerous option. ******
C
C  Z       real array (read)
C          Point through which the track must pass
C
C *CHISQ   real variable (write)
C          Chisquare of fit
C
C  returns kvtx_3d_fix = 1 for error
C
C  Created 10/25/94 A.Boehnlein from P. Avery KN CLEO code, KFVTX3
C  Modified 9/5/95 ASB--added call to kvtx_fill_p1 for rotating tracks 
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
      implicit none
#include "const.inc"
#include "wtrack_struct.inc"
#include "track_kine.inc"
#include "kine_vtx_cnst.inc"
#include "kine_chi.inc"
#include "track_dx.inc"

C
C     Calling arguments
      integer it
      integer update
      DFLOAT z(3), chisq
C     Local variables
      integer i,status
      integer ksub_overwrite, kvtx_cov_update,ksub_update
      integer kvtx_dx_update, kvtx_vdfill, kvtx_dfill
      external ksub_overwrite, kvtx_cov_update,ksub_update
      external kvtx_dx_update, kvtx_vdfill, kvtx_dfill
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C     Quit if nothing to do
      if(it .le. 0) goto 9999

C     Calculate matrices using W parametrization
      vtx_cnst.zv(1) = z(1)
      vtx_cnst.zv(2) = z(2)
      vtx_cnst.zv(3) = z(3)

C     Copy into temporary arrays
c     call ucopy(trk_kine(it).w, p1(it), WTRACK_WORD)
c     call ucopy(trk_kine(it).w0, p0(it), WTRACK_WORD)
      call kvtx_fill_p1(it)         
     

C     Iteration begins here
      choldf = 1.e20
      iterf = 0
100   iterf = iterf + 1
      status = kvtx_dfill(it)
      if(status.ne.0) goto 9999
      status = kvtx_vdfill(it)
      if(status.ne.0) goto 9999

C     chisq = dx(t) * Vx0(inv) * dx
C           = lam0(t) * VD(inv) * lam0
C           = lam0(t) * (D*x0 + d)
C     We have already set D*x0 + d ==> d
      chisq = vtx_cnst.trk_cnst(it).lam0(1)
     *      * vtx_cnst.trk_cnst(it).d1(1)
     *      + vtx_cnst.trk_cnst(it).lam0(2)
     *      * vtx_cnst.trk_cnst(it).d1(2)

C     Calculate x = x0 - Vx0*D(t)*lam0
C                 = x0 + dx
C     If fixed mass particle, update energy carefully
      status = kvtx_dx_update(it, vtx_cnst.trk_cnst(it).lam0(1),
     *                        .true.)
      p1(it).px = p0(it).px + trk_dx(it).px
      p1(it).py = p0(it).py + trk_dx(it).py
      p1(it).pz = p0(it).pz + trk_dx(it).pz
      p1(it).e  = p0(it).e  + trk_dx(it).e
      p1(it).x  = p0(it).x  + trk_dx(it).x
      p1(it).y  = p0(it).y  + trk_dx(it).y
      p1(it).z  = p0(it).z  + trk_dx(it).z

      if(trk_kine(it).fixed_mass.eq.1) then
        p1(it).e = sqrt(p1(it).px**2 + p1(it).py**2
     *           + p1(it).pz**2 + trk_kine(it).mass**2)
      endif

      if(choldf-chisq.gt.max_del_chisq .and. iterf.lt.max_iter) then
        choldf = chisq
        goto 100
      endif

C     Find change in track parameters
      if(update .ne. 0) then
        status = ksub_update(it, trk_dx(it), .true.)
        if(update .ge. 2) then
          status = kvtx_cov_update(it)
          status = ksub_overwrite(it)
        endif
      endif

c     normal exit
1000  kvtx_3d_fix = 0
      chif = chisq
      nconf = 2
      ndegf = 2
      return

c     error exit
9999  kvtx_3d_fix = 1
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

      integer function kvtx_3d_do(ntrk, itrk, update, z, vz, chisq)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Performs a vertex fit to several tracks in the KN list.
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
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
C   Side effects
C     Vertex variables in the temporary include area KNVTEMP are updated for
C     possible later use in kinematic fitting.
C
C
C     The constraint equations are:
C
C       0 = dely*Px - delx*Py - 0.5*a*(delx**2 + dely**2)
C       0 = z - z0 - (Pz/a) * arcsin[a*(delx*Px + dely*Py)/Pt**2]
C
C      where a = c_b*B*Q
C            c_b = B field bending constant = -0.002998 (using lengths in cm)
C            B = magnetic field in Tesla
C            Q = charge of particle
C            delx = x - x0
C            dely = y - y0
C
C  We expand to first order to evaluate (see notes P. C-5)
C
C 1. 0 = (dy-dy0)*Px + dely*dPx - (dx-dx0)*Py - delx*dPy  -
C        a*[delx*(dx-dx0) + dely*(dy-dy0)] + d1
C
C 2. 0 =  dz - dz0 - dPz/a * arcsin[a*S] - Pz/sqrt(1-a**2*S**2){} + d2
C
C  S  = (delx*Px + dely*Py)/Pt**2
C  {} = -2*(Px*dPx + Py*dPy)(S/Pt**2 +
C       [(dx-dx0)*Px+delx*dPx+(dy-dy0)*Py+dely*dPy]/Pt**2
C
C     where d1 and d2 are the values of the constraint equations before
C     the fit.
C
C        The fitting algorithm is as follows. Let the track parameters be
C     called x and the vertex parameters be called z. We assume that the
C     original x parameters and their covariance matrix are available from
C     an earlier fit. The following chisquare equation must be minimized:
C
C        chisq = (x-x0)(t) * Vx0(inv) * (x-x0) + 2*lam(t)*(D*x + E*z + d1),
C
C     where lam are the Lagrange multipliers, x0 are the original parameters,
C     x are the final parameters, z are the vertex parameters and Vx0(inv)
C     is the inverse of the original covariance matrix. The parameters z
C     only appear in the constraint equation  D*x +E*z + d1 = 0, so special
C     handling is required. The solution that minimizes this chisquare is
C
C                 lam0 = VD * (D*x0 + d1),
C                 z = -Vz * E(t)*lam0
C                 lam = lam0 + VD*E*z
C                 x = x0 - Vx0*D(t)*lam,
C                 VD = [D * Vx0 * D(t)](inv).
C
C     The covariance matrices are given by
C
C                 Vz = [E(t) * VD * E](inv)
C                 Vlam = VD - VD * E * Vz * E(t) * VD.
C                 Vx = Vx0 - Vx0 * D(t) * Vlam * D * Vx0.
C
C        The above solution is completely general for any set of parameters
C     appearing in a constraint equation. However, in vertex fitting the
C     elements of the matrices D, E and d do not "mix" tracks so we only
C     have to invert small 2x2 matrices local to each track.
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Created 10/10/94  A. Boehnlein from P. Avery CLEO routine KVRTX3 
C  modified 6/7/95 -- added call to kvtx_fill_p1 for rotating tracks and
C  vertex
C
      implicit none
#include "const.inc"
#include "wtrack_struct.inc"
#include "track_kine.inc"
#include "kine_vtx_cnst.inc"
#include "kine_chi.inc"
#include "track_dx.inc"

C     Calling arguments
      integer ntrk, itrk(*), update
      DFLOAT chisq, z(3), vz(3,3)

C     Local variables
      integer il, it, i, status, ifail
      integer kvtx_dfill, kvtx_vdfill, kvtx_efill, kvtx_evefill
      integer kvtx_dx_update,ksub_update,kvtx_cov_update
      integer ksub_overwrite
      external kvtx_dfill, kvtx_vdfill, kvtx_efill, kvtx_evefill
      external kvtx_dx_update,ksub_update,kvtx_cov_update
      external ksub_overwrite
      DFLOAT sumz(3), ez(2,max_trk), d2(2),  dz(3)
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C     Quit if illegal argument
      if(ntrk .lt. 2) goto 9999

      vtx_cnst.zv(1) = z(1)
      vtx_cnst.zv(2) = z(2)
      vtx_cnst.zv(3) = z(3)        
      
      

C     Copy into temporary arrays
      do 15 il=1,ntrk
        it = itrk(il)
c        call ucopy(trk_kine(it).w, p1(it), WTRACK_WORD)
c        call ucopy(trk_kine(it).w0, p0(it), WTRACK_WORD)
         call kvtx_fill_p1(it)         
15    continue

C     Iteration begins here
      choldf = 1.e20
      iterf = 0
100   iterf = iterf + 1
c     loop over tracks to accumulate matrices for z and vz.
      call vzero(sumz,  3*FLOAT_WORD)
      call vzero(vz, 3*3*FLOAT_WORD)
      do 120 il=1,ntrk
        it = itrk(il)

C     Compute D, D1, VD, LAM0, E, E(t)*LAM0, E(t)*VD*E
        status = kvtx_dfill(IT)
        IF(status.ne.0) GOTO 9999
        status = kvtx_vdfill(it)
        IF(status.ne.0) GOTO 9999
        status = kvtx_efill(it)
        IF(status.ne.0) GOTO 9999
        status = kvtx_evefill(it)
        IF(status.ne.0) GOTO 9999

        

C     Sum of E(t)*lam0, E(t)*VD*E
        sumz(1) = sumz(1) + vtx_cnst.trk_cnst(it).elam(1)
        sumz(2) = sumz(2) + vtx_cnst.trk_cnst(it).elam(2)
        sumz(3) = sumz(3) + vtx_cnst.trk_cnst(it).elam(3)

        vz(1,1) = vz(1,1) + vtx_cnst.trk_cnst(it).eve(1,1)
        vz(2,1) = vz(2,1) + vtx_cnst.trk_cnst(it).eve(2,1)
        vz(3,1) = vz(3,1) + vtx_cnst.trk_cnst(it).eve(3,1)
        vz(2,2) = vz(2,2) + vtx_cnst.trk_cnst(it).eve(2,2)
        vz(3,2) = vz(3,2) + vtx_cnst.trk_cnst(it).eve(3,2)
        vz(3,3) = vz(3,3) + vtx_cnst.trk_cnst(it).eve(3,3)

120   CONTINUE

C     Fill rest of matrix
        vz(1,2) = vz(2,1)
        vz(1,3) = vz(3,1)
        vz(2,3) = vz(3,2)
C     Calculate Vz = [SUM (E(t) * VD * E)](inv) = VZ(inv)
      call dsynv2(vz, 3, 3, ifail)

C     Calculate z = -Vz * SUM( E(t) * lam0 ) = -Vz * SUMZ
      do 10 i=1,3
        dz(i) = -vz(1,i)*sumz(1) - vz(2,i)*sumz(2) - vz(3,i)*sumz(3)
        vtx_cnst.zv(i) = vtx_cnst.zv(i) + dz(i)
        z(i) = vtx_cnst.zv(i)
10    continue

C     chisq = dx(t) * Vx0(inv) * dx
C           = lam(t) * VD(inv) * lam
C           = lam(t) * (D*x0 + E*z + d1)
C           = lam0(t)* (D*x0 + E*z + d1) (actually true)
C     We have already set D*x0 + d1 ==> d1
C     Define D*x0 + E*z + d1 ==> D2
      chisq = 0.
      do 150 il=1,ntrk
        it = itrk(il)
        ez(1,it) = vtx_cnst.trk_cnst(it).e(1,1)*dz(1)
     *           + vtx_cnst.trk_cnst(it).e(2,1)*dz(2)
     *           + vtx_cnst.trk_cnst(it).e(3,1)*dz(3)
        ez(2,it) = vtx_cnst.trk_cnst(it).e(1,2)*dz(1)
     *           + vtx_cnst.trk_cnst(it).e(2,2)*dz(2)
     *           + vtx_cnst.trk_cnst(it).e(3,2)*dz(3)

        d2(1) = vtx_cnst.trk_cnst(it).d1(1) + ez(1,it)
        d2(2) = vtx_cnst.trk_cnst(it).d1(2) + ez(2,it)
        
        chisq = chisq + vtx_cnst.trk_cnst(it).lam0(1)*d2(1)
     *        + vtx_cnst.trk_cnst(it).lam0(2)*d2(2)
150   continue

C     Compute lam = lam0 + VD*E*dz = lam0 + VD*EZ
C     Calculate x = x0 - Vx0*D(t)*lam
C     If fixed mass particle, update energy carefully
C                 = x0 + dx
      do 401 il=1,ntrk
        it = itrk(il)
        vtx_cnst.trk_cnst(it).lam(1) = vtx_cnst.trk_cnst(it).lam0(1)
     *         + vtx_cnst.trk_cnst(it).vd(1,1)*ez(1,it)
     *         + vtx_cnst.trk_cnst(it).vd(2,1)*ez(2,it)
        vtx_cnst.trk_cnst(it).lam(2) = vtx_cnst.trk_cnst(it).lam0(2)
     *         + vtx_cnst.trk_cnst(it).vd(2,1)*ez(1,it)
     *         + vtx_cnst.trk_cnst(it).vd(2,2)*ez(2,it)
     
        status = kvtx_dx_update(it, vtx_cnst.trk_cnst(it).lam(1),
     *                         .true.)
          p1(it).px = p0(it).px + trk_dx(it).px
          p1(it).py = p0(it).py + trk_dx(it).py
          p1(it).pz = p0(it).pz + trk_dx(it).pz
          p1(it).e  = p0(it).e  + trk_dx(it).e
          p1(it).x  = p0(it).x  + trk_dx(it).x
          p1(it).y  = p0(it).y  + trk_dx(it).y
          p1(it).z  = p0(it).z  + trk_dx(it).z

        if(trk_kine(it).fixed_mass.eq.1) then
          p1(it).e = sqrt(p1(it).px**2 + p1(it).py**2
     *                    + p1(it).pz**2 + trk_kine(it).mass**2)
        endif
401   continue

      if(choldf-chisq.gt.max_del_chisq .and. iterf.lt.max_iter) then
        choldf = chisq
        goto 100
      endif

      if(update .eq. 0) goto 1000

C     Update track parameters
      do 200 il=1,ntrk
        it = itrk(il)
        status = ksub_update(it, trk_dx(it), .true.)
        if(update .ge. 2) then
          status = kvtx_cov_update(it)
          status = ksub_overwrite(it)
        endif
200   continue

C     Normal exit
1000  kvtx_3d_do = 0
      chif = chisq
      nconf = 2*ntrk
      ndegf = nconf - 3
      return

C     Error exit
9999  kvtx_3d_do = 1
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
c Revision 1.3  1997/04/04 20:32:10  garren
c add rcs log line
c

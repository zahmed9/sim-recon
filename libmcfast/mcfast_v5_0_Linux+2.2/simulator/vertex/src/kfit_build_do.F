      integer function kfit_build_do(ntrk, itrk, ivopt,
     *                  update, vtx, vz, lcovar,
     *                  lvertx, chisq, pw, vp, mvp)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Build a new particle from several particles with a vertex constraint.
C  The vertex, however, has an initial covariance matrix, i.e. beam spot.
C  The covariance matrix of the new track is calculated.
C
C  Note: If there are fewer than 2 tracks with IVOPT = 2, then ZI is
C        treated as a fixed vertex and all tracks with IVOPT > 0 are
C        required to go through it.
C
C  NTRK      Integer variable (read)
C            # of input tracks
C
C  ITRK      Integer array (read)
C            List of KN tracks.
C
C  IVOPT     Integer array (read)
C            IVOPT(IL) = 0  => Track ITRK(IL) has no position info at all
C            IVOPT(IL) = 1  => Track ITRK(IL) is not used to determine vertex
C                              but is constrained to pass through vertex
C            IVOPT(IL) = 2  => Track ITRK(IL) is used to determine vertex
C
C  UPDATE    integer variable (read)
C            0 ==> do not update input track parameters (just calculate chisq)
C            1 ==> update input track parameters only
C            2 ==> update input track parameters & covariance matrices and
C                  replace the original unconstrainted parameters by the
C                  new ones. ****** This is a dangerous option. ******
C
C  Z         real array (read)
C            (x,y,z) vertex
C
C  VZ        real array (read)
C            3x3 covariance matrix of Z
C
C  LCOVAR    logical variable (read)
C            TRUE  ==> compute PW covariance matrix
C            FALSE ==> do not compute PW covariance matrix
C
C  LVERTX   logical variable (read)
C            TRUE  ==> vertex is variable
C            FALSE ==> vertex is fixed
C
C *CHISQ     real variable (write)
C            Chisq of fit.
C
C *PW        real array (write)
C            Fitted particle in W format (Px,Py,Pz,E,X,Y,Z)
C
C *VP        real array (write)
C            Covariance matrix of PW
C
C  MVP       integer variable (read)
C            First dimension of VP (must be at least 7)
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
C   The virtual particle has track parameters
C
C          | P |
C      W = |   |
C          | z |
C
C   where P is the 4-momentum and z is the (x,y,z) vertex of its production
C   point. The covariance matrix of the virtual particle is
C
C          | G + T*Vz*T(t)  -T*Vz |
C     Vw = |                      |    variable vertex
C          | -Vz*T(t)         Vz  |
C
C          | G                 0  |
C     Vw = |                      |    fixed vertex
C          | 0                 0  |
C
C   G = sum[Ai*Vx0i*Ai(t)) - S1i*VDi*S1i(t)]
C
C      S1i = Ai * Vx0i * Di
C      S2i = Ai * Vx0i * Di * VDi      = S1i * VDi
C      S3i = Ai * Vx0i * Di * VDi * Ei = S2i * Ei = S1i * VDi * Ei
C
C       T  = -B + sum(S3i)
C
C             |1  0  0  0   0   aiz -aiy|
C             |0  1  0  0 -aiz   0   aix|
C       Ai =  |0  0  1  0  aiy -aix   0 |
C             |0  0  0  1   0    0    0 |
C
C             |    0      -sum(aiz)    sum(aiy)|
C        B =  | sum(aiz)      0       -sum(aix)|
C             |-sum(aiy)   sum(aix)       0    |
C             |    0          0           0    |
C
C   where aix = c_b * Qi * Bx, with Qi = charge and (Bx,By,Bz) =
C   the components of the B field.
C  created 10/17/94 A. Boehnlein from P. Avery's CLEO KN routine KBUILD
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      IMPLICIT NONE
#include "const.inc"
#include "wtrack_struct.inc"
#include "track_kine.inc"
#include "kine_vtx_cnst.inc"
#include "kine_chi.inc"
#include "track_dx.inc"
#include "kine_bfld.inc"

C     Calling arguments
      integer ntrk, itrk(*), ivopt(*), update, mvp
      logical lcovar, lvertx
      DFLOAT vtx(3), vz(3,3), chisq, vp(mvp,mvp)
      record /wtrack_struct/ pw

C     Local variables
      integer il, it, i, j,status, gamma
      DFLOAT ptsq, psq, s1(4,2), s2(4,2), s3(4,3)
      DFLOAT t(4,3), tvz(4,3), chi, a(3), q, qsum
      DFLOAT delx, dely, delz
      DFLOAT axx, axy, axz, ayy, ayz, azz, sumx, sumy, sumz
      integer kvtx_3d_fix
      external kvtx_3d_fix
      data gamma /22/
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C     Force rest of tracks to pass through vertex & calculate updated tracks
      call vzero(pw, wtrack_word)
      call vzero(vp, mvp*mvp*float_word)
      qsum = 0.

      do 20 il=1,ntrk
        it = itrk(il)
        q = trk_kine(it).w.q
        qsum = qsum + q
        if(ivopt(il).eq.1 .and. trk_kine(it).pos_info.eq.1) then
          status = kvtx_3d_fix(it, update, vtx, chi)
          if(status.ne.0) goto 9999
          chisq = chisq + chi
        endif


C     Correct charged tracks, photons and all others
        if(ivopt(il).ge.1 .and. trk_kine(it).pos_info.eq.1) then
          if(trk_kine(it).pos_info.eq.1.and. q.ne.0) then
C
C Tomasz: field has been aligned along z by subroutines calling
C         this one (not reflected in bdir)
C
C            a(1) = c_b * q * kine_bfld.bmag*kine_bfld.bdir(1)
C            a(2) = c_b * q * kine_bfld.bmag*kine_bfld.bdir(2)
C            a(3) = c_b * q * kine_bfld.bmag*kine_bfld.bdir(3)
C
            a(1) = 0.
            a(2) = 0.
            a(3) = c_b * q * kine_bfld.bmag
C
C Tomasz: cannot use trk_kine since it was not rotated
C
C            delx = vtx(1) - trk_kine(it).w.x
C            dely = vtx(2) + trk_kine(it).w.y
C            delz = vtx(3) - trk_kine(it).w.z
            delx = vtx(1) - p0(it).x
            dely = vtx(2) - p0(it).y
            delz = vtx(3) - p0(it).z
            p1(it).px = p1(it).px - a(3)*dely + a(2)*delz
            p1(it).py = p1(it).py - a(1)*delz + a(3)*delx
            p1(it).pz = p1(it).pz - a(2)*delx + a(1)*dely
          endif
C------------------------CLEO SPECIFIC---COMMENTED OUT FOR NOW--------
C        else if(abs(trk_kine(it).id) .eq. gamma) then
C          CALL KSHCOR(IT, VTX, P1(1,IT))
C----------------------------------------------------------------------
        else
C
C Tomasz: cannot use trk_kine since it was not rotated
C
C          p1(it).px = trk_kine(it).w.px
C          p1(it).py = trk_kine(it).w.py
C          p1(it).pz = trk_kine(it).w.pz
          p1(it).px = p0(it).px
          p1(it).py = p0(it).py
          p1(it).pz = p0(it).pz
        endif
        p1(it).e = sqrt(p1(it).px**2 + p1(it).py**2 + p1(it).pz**2
     *                + trk_kine(it).mass**2)
        pw.px = pw.px + p1(it).px
        pw.py = pw.py + p1(it).py
        pw.pz = pw.pz + p1(it).pz
        pw.e  = pw.e  + p1(it).e
20    continue

      pw.x = vtx(1)
      pw.y = vtx(2)
      pw.z = vtx(3)
      pw.pt = sqrt(pw.px**2+pw.py**2)
      pw.p  = sqrt(pw.pt**2 + pw.pz**2)
      pw.q  = qsum

C     Update input photons (tracks going through vertex already updated)
      if(update .ne. 0) then
        do 50 il=1,ntrk
          it = itrk(il)
          if(abs(trk_kine(it).id).ne.gamma .or. 
     *    (abs(trk_kine(it).id).eq.gamma .and.
     *         trk_kine(it).origin.ne.jtrk_anlcccsh .and.
     *         trk_kine(it).origin.ne.jtrk_anlcxbg)) goto 50
          call ucopy(p1(it), trk_kine(it).w, wtrack_word)
          ptsq = p1(it).px**2 + p1(it).py**2
          psq = ptsq + p1(it).pz**2
          trk_kine(it).w.pt = sqrt(ptsq)
          trk_kine(it).w.p = sqrt(psq)
          if(update .eq. 2) call ksub_overwrite(it)
50      continue
      endif

C     Calculate new track's covariance matrix
C          | G + T*Vz*T(t)  -T*Vz |
C     Vw = |                      |    variable vertex
C          | -Vz*T(t)         Vz  |
C
C          | G                 0  |
C     Vw = |                      |    fixed vertex
C          | 0                 0  |
C
C   G = sum[Ai*Vx0i*Ai(t)) - S1i*VDi*S1i(t)]
C     = sum[Ai*Vx0i*Ai(t)) - S2i*S1i(t)]
C
C      S1i = Ai * Vx0i * Di
C      S2i = Ai * Vx0i * Di * VDi
C      S3i = Ai * Vx0i * Di * VDi * Ei
C
C       T  = -B + sum(S3i)

      if(.not.lcovar) goto 1000
      call vzero(t, 4*3*float_word)
      sumx = 0.
      sumy = 0.
      sumz = 0.
      do 400 il=1,ntrk
        it = itrk(il)
        q = trk_kine(it).w.q
C
C Tomasz: same problem as above
C
C        a(1) = c_b * q * kine_bfld.bmag*kine_bfld.bdir(1)
C        a(2) = c_b * q * kine_bfld.bmag*kine_bfld.bdir(2)
C        a(3) = c_b * q * kine_bfld.bmag*kine_bfld.bdir(3)
        a(1) = 0.
        a(2) = 0.
        a(3) = c_b * q * kine_bfld.bmag
        sumx = sumx + a(1)
        sumy = sumy + a(2)
        sumz = sumz + a(3)
        do 320 i=1,4
          do 315 j=1,i
C
C Tomasz: 
C
C            vp(j,i) = vp(j,i) + trk_kine(it).cov(j,i)
             vp(j,i) = vp(j,i) + p1c(it).cov(j,i)
315       continue
320     continue

C     From this point on, only use tracks involved with vertex
        if(ivopt(il).eq.0 .or.
     *    (ivopt(il).eq.1.and.
     *     abs(trk_kine(it).id).eq.gamma)) goto 400
        if(q .ne. 0.) then
C
C Tomasz : below two bugs cancelled each other
C                 
C       field was rotated but flag was not changed :    
C          if(kine_bfld.type.eq.4) then
C
          if( a(1).eq.0.0 .and. a(2).eq.0.0 ) then
            azz = a(3)**2
C
C Tomasz : trk_kine was not rotated
C
C              vp(1,1) = vp(1,1) + 2.*a(3)*trk_kine(it).cov(1,6)
C       *              + azz*trk_kine(it).cov(6,6)
            vp(1,1) = vp(1,1) + 2.*a(3)*p1c(it).cov(1,6)
     *              + azz*p1c(it).cov(6,6)
            vp(1,2) = vp(1,2) + a(3)*(p1c(it).cov(2,6)
     *                               -p1c(it).cov(1,5))
     *                        - azz * p1c(it).cov(5,6)
            vp(1,3) = vp(1,3) + a(3)*p1c(it).cov(3,6)
            vp(1,4) = vp(1,4) + a(3)*p1c(it).cov(4,6)
            vp(2,2) = vp(2,2) - 2.*a(3)*p1c(it).cov(2,5)
     *                        + azz * p1c(it).cov(5,5)
            vp(2,3) = vp(2,3) - a(3)*p1c(it).cov(3,5)
            vp(2,4) = vp(2,4) - a(3)*p1c(it).cov(4,5)
          else
            axx = a(1)**2
            axy = a(1)*a(2)
            axz = a(1)*a(3)
            ayy = a(2)**2
            ayz = a(2)*a(3)
            azz = a(3)**2
            vp(1,1) = vp(1,1)
     *              + 2.*a(3)*p1c(it).cov(1,6)
     *              - 2.*a(2)*p1c(it).cov(1,7)
     *              - 2.*ayz*p1c(it).cov(6,7)
     *              + azz*p1c(it).cov(6,6)
     *              + ayy*p1c(it).cov(7,7)
            vp(1,2) = vp(1,2)
     *              + a(1)*p1c(it).cov(1,7)
     *              - a(3)*p1c(it).cov(1,5)
     *              + a(3)*p1c(it).cov(2,6)
     *              + axz*p1c(it).cov(6,7)
     *              - azz*p1c(it).cov(5,6)
     *              - a(2)*p1c(it).cov(2,7)
     *              - axy*p1c(it).cov(7,7)
     *              + ayz*p1c(it).cov(5,7)
            vp(1,3) = vp(1,3)
     *              + a(2)*p1c(it).cov(1,5)
     *              - a(1)*p1c(it).cov(1,6)
     *              + a(3)*p1c(it).cov(3,6)
     *              + ayz*p1c(it).cov(5,6)
     *              - axz*p1c(it).cov(6,6)
     *              - a(2)*p1c(it).cov(3,7)
     *              - ayy*p1c(it).cov(5,7)
     *              + axy*p1c(it).cov(6,7)
            vp(1,4) = vp(1,4)
     *              + a(3)*p1c(it).cov(4,6)
     *              - a(2)*p1c(it).cov(4,7)
            vp(2,2) = vp(2,2)
     *              + 2.*a(1)*p1c(it).cov(2,7)
     *              - 2.*a(3)*p1c(it).cov(2,5)
     *              + axx*p1c(it).cov(7,7)
     *              - 2.*axz*p1c(it).cov(5,7)
     *              + azz*p1c(it).cov(5,5)
            vp(2,3) = vp(2,3)
     *              + a(2)*p1c(it).cov(2,5)
     *              - a(1)*p1c(it).cov(2,6)
     *              + a(1)*p1c(it).cov(2,7)
     *              + axy* p1c(it).cov(5,7)
     *              - axx* p1c(it).cov(6,7)
     *              - a(3)*p1c(it).cov(3,5)
     *              - ayz* p1c(it).cov(5,5)
     *              + axz* p1c(it).cov(5,6)
            vp(2,4) = vp(2,4)
     *              + a(1)*p1c(it).cov(4,7)
     *              - a(3)*p1c(it).cov(4,5)
            vp(3,3) = vp(3,3)
     *              + 2.*a(2)*p1c(it).cov(3,5)
     *              - 2.*a(1)*p1c(it).cov(3,6)
     *              + ayy*    p1c(it).cov(5,5)
     *              - 2.*axy* p1c(it).cov(5,6)
     *              + axx*    p1c(it).cov(6,6)
            vp(3,4) = vp(3,4)
     *              + a(2)*p1c(it).cov(4,5)
     *              - a(1)*p1c(it).cov(4,6)
          endif
        endif
        do 360 i=1,2
          s1(1,i) = vtx_cnst.trk_cnst(it).dvx(i,1)
     *            + a(3)*vtx_cnst.trk_cnst(it).dvx(i,6)
     *            - a(2)*vtx_cnst.trk_cnst(it).dvx(i,7)
          s1(2,i) = vtx_cnst.trk_cnst(it).dvx(i,2)
     *            + a(1)*vtx_cnst.trk_cnst(it).dvx(i,7)
     *            - a(3)*vtx_cnst.trk_cnst(it).dvx(i,5)
          s1(3,i) = vtx_cnst.trk_cnst(it).dvx(i,3)
     *            + a(2)*vtx_cnst.trk_cnst(it).dvx(i,5)
     *            - a(1)*vtx_cnst.trk_cnst(it).dvx(i,6)
          s1(4,i) = vtx_cnst.trk_cnst(it).dvx(i,4)
360     continue
        do 370 i=1,2
          do 365 j=1,4
            s2(j,i) = s1(j,1)*vtx_cnst.trk_cnst(it).vd(1,i)
     *              + s1(j,2)*vtx_cnst.trk_cnst(it).vd(2,i)
365       continue
370     continue
        do 390 i=1,4
          do 385 j=1,i
            vp(j,i) = vp(j,i) - s2(j,1)*s1(i,1) - s2(j,2)*s1(i,2)
385       continue
390     continue
        if(.not.lvertx) goto 400
        do 380 i=1,3
          do 375 j=1,4
            s3(j,i) = s2(j,1)*vtx_cnst.trk_cnst(it).e(i,1)
     *              + s2(j,2)*vtx_cnst.trk_cnst(it).e(i,2)
            t(j,i) = t(j,i) + s3(j,i)
375       continue
380     continue
400   continue

C     Forget about vertex part if fixed vertex
      if(.not.lvertx .or. mvp.lt.7) then
        do 407 i=2,4
          do 405 j=1,i-1
            vp(i,j) = vp(j,i)
405       continue
407     continue
        goto 1000
      endif

      t(1,2) = t(1,2) + sumz
      t(2,1) = t(2,1) - sumz
      t(1,3) = t(1,3) - sumy
      t(3,1) = t(3,1) + sumy
      t(2,3) = t(2,3) + sumx
      t(3,2) = t(3,2) - sumx

c     compute t * vz
      do 420 i=1,3
        do 410 j=1,4
          tvz(j,i) = t(j,1)*vz(1,i) + t(j,2)*vz(2,i) + t(j,3)*vz(3,i)
410     continue
420   continue

C          | G + T*Vz*T(t)  -T*Vz |
C     Vw = |                      |
C          | -Vz*T(t)         Vz  |

C     Calculate rest of P-P part due to T*Vz*T(t)
      do 430 i=1,4
        do 425 j=1,i
          vp(j,i) = vp(j,i) + t(j,1)*tvz(i,1) + t(j,2)*tvz(i,2)
     *                      + t(j,3)*tvz(i,3)
425     continue
430   continue

c     calculate p-vertex part = -t*vz
      do 450 i=1,3
        do 440 j=1,4
          vp(j,i+4) = -tvz(j,i)
440     continue
450   continue

c     now do the vertex-vertex part
      do 470 i=1,3
        do 460 j=1,i
          vp(4+j,4+i) = vz(j,i)
460     continue
470   continue

c     fill in the other side of the matrix
      do 520 i=2,7
        do 510 j=1,i-1
          vp(i,j) = vp(j,i)
510     continue
520   continue

c     normal exit
1000  kfit_build_do = 0
      return

c     error exit
9999  chisq = -1.
      kfit_build_do = 1
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:47  eugenio
c Initial revision
c
c Revision 1.8  1998/05/14 00:10:19  kutschke
c Compute vertex charge.
c
c Revision 1.7  1998/03/04  00:03:48  kutschke
c Fix check of status after call to kvtx_3d_fix
c
c Revision 1.6  1997/04/04  20:32:06  garren
c add rcs log line
c

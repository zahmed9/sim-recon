      integer function kfit_mass(ik, mass, update, chisq)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Constrain the mass of a particle to the value "mass" and replace
c   the resulting 4-vector and its covariance matrix in the kinematic
c   track list.
c
c   The mass constraint is imposed by the method of lagrange multipliers
c
c   chisq = (x-x0)(t) * vx0(inv) * (x-x0) + 2*lam(t)*(d*x + d1)
c
c   where x0 are the unconstrained parameters, x are the final parameters and
c   d*x + d1 = 0 is the linearized constraint equation. the solution is
c
c         x = x0 - Vx0*D(t)*lam
c       lam = VD * (D*x0 + d1)
c        VD = [D * Vx0 * D(t)](inv)
c        Vx = Vx0 - Vx0*D(t)*VD*D*Vx0
c
c   The mass constraint has the form
c
c         E**2 - Px**2 - Py**2 - Pz**2 - Mc**2 = 0
c
c   This equation can be linearized by expanding around an approximate
c   solution x1 = (px1, py1, pz1, E1):
c
c      E1*dE1 - Px1*dpx1 - Py1*dpy1 - Pz1*dpz1 + (M1**2 - Mc**2)/2 = 0
c
c   where M1 is the mass obtained with the vector (px1, py1, pz1, E1).
c   This means that D can be written
c
c       D = (-Px1, -Py1, -Pz1, E1)
c       d1= (M1**2 - Mc**2) / 2
c
c   The covariance matrix of the resulting track can be computed as
c
c       Vp = Vx0 - Vx0*D(t)*VD*D*Vx0
c
c  ik        integer variable (read)
c            ik = position in track_kine track list
c
C  mass      DFLOAT variable (read)
C            Mass to constrain to
C
C  update    integer variable (read)
C            0 ==> do not update track (calculate chisq only)
C            1 ==> update track
C
C *chisq     DFLOAT variable (write)
C            Chisq of fit.
C
c created  5/16/97 Paul Avery
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "track_kine.inc"
#include "kine_chi.inc"
#include "kine_cnst.inc"
#include "wtrack_struct.inc"

c     calling arguments
      integer ik, update
      DFLOAT mass, chisq

c     local variables
      integer i, j
      DFLOAT tmp, m1sq, p4(4)
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Check track legality
      if(ik.le.0 .or. ik.gt.max_trk) goto 9999

c     Iteration loop
      p4(1) = trk_kine(ik).w0.px
      p4(2) = trk_kine(ik).w0.py
      p4(3) = trk_kine(ik).w0.pz
      p4(4) = trk_kine(ik).w0.E

      iterf = 0
      choldf = 1.e20
500   iterf = iterf + 1

c     Compute vd = [d*vx0*d(t)](inv) and dx0 + d1
      kine_cnst(1).dc(1) = -p4(1)
      kine_cnst(1).dc(2) = -p4(2)
      kine_cnst(1).dc(3) = -p4(3)
      kine_cnst(1).dc(4) =  p4(4)
      vdc(1,1) = 0.
      do i=1,7
        kine_cnst(1).dcvx(i) = trk_kine(ik).cov(1,i)*kine_cnst(1).dc(1)
     *                       + trk_kine(ik).cov(2,i)*kine_cnst(1).dc(2)
     *                       + trk_kine(ik).cov(3,i)*kine_cnst(1).dc(3)
     *                       + trk_kine(ik).cov(4,i)*kine_cnst(1).dc(4)
        vdc(1,1) = vdc(1,1) + kine_cnst(1).dc(i)*kine_cnst(1).dcvx(i)
      enddo

      m1sq = p4(4)**2 - p4(1)**2 - p4(2)**2 - p4(3)**2
      kine_cnst(1).d1c = 0.5 * (m1sq - mass**2)
     *       + kine_cnst(1).dc(1)*(trk_kine(ik).w0.px - p4(1))
     *       + kine_cnst(1).dc(2)*(trk_kine(ik).w0.py - p4(2))
     *       + kine_cnst(1).dc(3)*(trk_kine(ik).w0.pz - p4(3))
     *       + kine_cnst(1).dc(4)*(trk_kine(ik).w0.E  - p4(4))

c     find the lagrange multiplier lam
      if(vdc(1,1) .eq. 0.) goto 9999
      vdc(1,1) = 1. / vdc(1,1)
      kine_cnst(1).lamc = vdc(1,1) * kine_cnst(1).d1c

c     Compute the chisquare = lam(t)*vd(inv)*lam = lam(t) * (d*x0 + d1)
      chisq = kine_cnst(1).lamc * kine_cnst(1).d1c

      p4(1) = trk_kine(ik).w0.px
     *         - kine_cnst(1).dcvx(1)*kine_cnst(1).lamc
      p4(2) = trk_kine(ik).w0.py
     *         - kine_cnst(1).dcvx(2)*kine_cnst(1).lamc
      p4(3) = trk_kine(ik).w0.pz
     *         - kine_cnst(1).dcvx(3)*kine_cnst(1).lamc
      p4(4) = trk_kine(ik).w0.E
     *         - kine_cnst(1).dcvx(4)*kine_cnst(1).lamc

      if(choldf-chisq.gt.max_del_chisq ) then
         if( iterf.lt.max_iter) then
            choldf = chisq
            goto 500
         endif
         goto 9999
      endif

c     Calculate updated track
      if(update .eq. 0) goto 1000

      trk_kine(ik).w0.px = p4(1)
      trk_kine(ik).w0.py = p4(2)
      trk_kine(ik).w0.pz = p4(3)
      trk_kine(ik).w0.E  = p4(4)
      trk_kine(ik).w0.x = trk_kine(ik).w0.x
     *                    - kine_cnst(1).dcvx(5)*kine_cnst(1).lamc
      trk_kine(ik).w0.y = trk_kine(ik).w0.y
     *                    - kine_cnst(1).dcvx(6)*kine_cnst(1).lamc
      trk_kine(ik).w0.z = trk_kine(ik).w0.z
     *                    - kine_cnst(1).dcvx(7)*kine_cnst(1).lamc
      trk_kine(ik).w0.p = sqrt(p4(1)**2 + p4(2)**2 + p4(3)**2)
      trk_kine(ik).w0.pt = sqrt(p4(1)**2 + p4(2)**2)

      call ucopy(trk_kine(ik).w0, trk_kine(ik).w, WTRACK_WORD)

c     Calculate its covariance matrix
c         vp = vx0 - vx0*d(t)*vd*d*vx0

      do i=1,7
        tmp = vdc(1,1) * kine_cnst(1).dcvx(i)
        do j=1,i
          trk_kine(ik).cov(i,j) = trk_kine(ik).cov(i,j)
     *                          - tmp*kine_cnst(1).dcvx(j)
          trk_kine(ik).cov(j,i) = trk_kine(ik).cov(i,j)
        enddo
      enddo

c     Normal exit
1000  chif = chisq
      nconf = 1
      ndegf = 1
      kfit_mass = 0
      return

c     error exit
9999  chisq = -1.
      chif = chisq
      nconf = 0
      ndegf = 0
      kfit_mass = 1
      return
      end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:47  eugenio
c Initial revision
c
c Revision 1.2  1998/04/27 02:26:32  kutschke
c New file.
c
c

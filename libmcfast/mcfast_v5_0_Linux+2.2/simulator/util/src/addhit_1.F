      integer function addhit_1 ( dc1, ccov, derv, dcalc0, 
     +                            dmeas, sigma2, dc2, fwt, chisq )
c
c A Kalman filter service routine.
c Add a one dimensional hit to the linearized track parameters.
c This will work both in the ftk and ctk parameterizations.
c

      implicit none

#include "const.inc"

      ! Number of track parameters.
      integer NPAR
      parameter ( NPAR = 5 )

c Input Arguments.

      ! Input linearized correction.
      DFLOAT dc1(NPAR)

      ! Covariance matrix of updated track parameters.
      DFLOAT ccov(NPAR,NPAR)

      ! Derivative vector.
      DFLOAT derv(NPAR)

      ! Measured distance.
      DFLOAT dmeas

      ! The distance calculated using the present value of the seed
      ! parameters ( those about which we do the linearization ).
      DFLOAT dcalc0

      ! Error**2 on the measured distance.
      DFLOAT sigma2

      ! Weight matrix of the track parameters, before update.
      DFLOAT fwt(NPAR,NPAR)

c Output Arguments.
      ! New value of linearized correction.
      DFLOAT dc2(NPAR)

      ! Chi-squared contribution of this hit.
      DFLOAT chisq

c Local variables.

      ! The update the to linearized track parameters.
      DFLOAT deta(NPAR)

      ! The full computed drift distance ( base+correction ) before
      ! and after the update.
      DFLOAT dcalc, dcalca

      ! Indexology.
      integer i

      ! Temporary so that dc1 and dc2 may share storage.
      DFLOAT dctmp(NPAR)


c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      dcalc = dcalc0 +
     *        derv(1)*dc1(1) + derv(2)*dc1(2) +
     *        derv(3)*dc1(3) + derv(4)*dc1(4) +
     *        derv(5)*dc1(5)

      ! Update the corrections.
      do i = 1, NPAR
         deta(i) = ( ccov(i,1)*derv(1) + ccov(i,2)*derv(2) +
     +               ccov(i,3)*derv(3) + ccov(i,4)*derv(4) +
     +               ccov(i,5)*derv(5) ) * 
     +             ( dmeas - dcalc ) / sigma2
         dctmp(i) = dc1(i) + deta(i)
      enddo
      call ucopy ( dctmp, dc2, NPAR*FLOAT_WORD )

      ! Compute the chi2.
      dcalca = dcalc0 + derv(1)*dc2(1) + derv(2)*dc2(2) +
     +                  derv(3)*dc2(3) + derv(4)*dc2(4) + 
     +                  derv(5)*dc2(5)

      chisq = deta(1)**2*fwt(1,1) +
     +        deta(2)**2*fwt(2,2) + deta(3)**2*fwt(3,3) +
     +        deta(4)**2*fwt(4,4) + deta(5)**2*fwt(5,5) +
     +        2.0*( deta(1)*(deta(2)*fwt(1,2) + deta(3)*fwt(1,3)  +
     +                       deta(4)*fwt(1,4) + deta(5)*fwt(1,5)) +
     +              deta(2)*(deta(3)*fwt(2,3) + deta(4)*fwt(2,4)  +
     +                       deta(5)*fwt(2,5) ) +
     +              deta(3)*(deta(4)*fwt(3,4) + deta(5)*fwt(3,5)) +
     +              deta(4)* deta(5)*fwt(4,5)
     +            ) +
     +      ((dcalca-dmeas)**2)/sigma2

      ! Normal return.
      addhit_1 = 0

      end
c
c$Id$
c
c$Log$
cRevision 1.1  2000/06/19 19:59:42  eugenio
cInitial revision
c
cRevision 1.1  1998/02/13 23:08:25  kutschke
cNew routine.
c
c

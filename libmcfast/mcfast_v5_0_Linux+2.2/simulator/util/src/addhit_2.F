      integer function addhit_2 ( dc1, ccov, derv, dcalc0, 
     +                            dmeas, mcov, dc2, fwt, chisq )
c
c A Kalman filter service routine.
c Add a two dimensional hit to the linearized track parameters.
c This will work both in the ftk and ctk parameterizations.
c

      implicit none

#include "const.inc"

      ! Number of track parameters.
      integer NPAR
      parameter ( NPAR = 5 )

      ! Dimension of measurement vector.
      integer NMEAS
      parameter ( NMEAS = 2 )

c Input Arguments.

      ! Input linearized correction.
      DFLOAT dc1(NPAR)

      ! Covariance matrix of track parameters.
      DFLOAT ccov(NPAR,NPAR)

      ! Derivative matrix.  
      DFLOAT derv(NPAR,NMEAS)

      ! Measured distance. 
      DFLOAT dmeas(NMEAS)

            ! The distance calculated using the present value of the seed
      ! parameters ( those about which we do the linearization ).
      DFLOAT dcalc0(NMEAS)

      ! Covariance matrix of the measurements.
      DFLOAT mcov(NMEAS,NMEAS)

      ! Weight matrix of the track parameters, before update.
      DFLOAT fwt(NPAR,NPAR)

c Output Arguments.
      ! New value of linearized correction.
      DFLOAT dc2(NPAR)

      ! Chi-squared contribution of this hit.
      DFLOAT chisq

c Local variables.

      ! Indexology.
      integer i

      ! Inverse of mcov.
      DFLOAT minv(NMEAS,NMEAS)

      ! Discriminant for calculation of minv.
      DFLOAT disc

      ! Temporaries in computation of the updated parameters.
      DFLOAT vd(NMEAS), dvd(NPAR)

      ! The full computed distances, with all corrections, before
      ! and after the update.
      DFLOAT dcalc(NMEAS), dcalca(NMEAS)

      ! The update to the track parameters.
      DFLOAT deta(NPAR)


c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      ! Invert the measurement covariance matrix.
      disc = mcov(1,1)*mcov(2,2)-mcov(1,2)*mcov(2,1)
      if ( disc .eq. 0. ) goto 9999
      minv(1,1) =  mcov(2,2)/disc
      minv(2,2) =  mcov(1,1)/disc
      minv(1,2) = -mcov(1,2)/disc
      minv(2,1) =  minv(1,2)

      ! Compute the full distance using the input parameters.
      dcalc(1) = dcalc0(1) +
     *           derv(1,1)*dc1(1) + derv(2,1)*dc1(2) +
     *           derv(3,1)*dc1(3) + derv(4,1)*dc1(4) +
     *           derv(5,1)*dc1(5)
      dcalc(2) = dcalc0(2) +
     *           derv(1,2)*dc1(1) + derv(2,2)*dc1(2) +
     *           derv(3,2)*dc1(3) + derv(4,2)*dc1(4) +
     *           derv(5,2)*dc1(5)

      ! Compute:  (V_m)^{-1}( d(meas) - d(calc) )
      vd(1) =  minv(1,1)*( dmeas(1) - dcalc(1) )
     +       + minv(1,2)*( dmeas(2) - dcalc(2) )
      vd(2) =  minv(2,1)*( dmeas(1) - dcalc(1) )
     +       + minv(2,2)*( dmeas(2) - dcalc(2) )

      ! Compute: D (V_m)^{-1}( d(meas) - d(calc) )
      dvd(1) = derv(1,1)*vd(1) + derv(1,2)*vd(2)
      dvd(2) = derv(2,1)*vd(1) + derv(2,2)*vd(2)
      dvd(3) = derv(3,1)*vd(1) + derv(3,2)*vd(2)
      dvd(4) = derv(4,1)*vd(1) + derv(4,2)*vd(2)
      dvd(5) = derv(5,1)*vd(1) + derv(5,2)*vd(2)

      ! Compute: update to track parameters =
      !      V^{\prime} D (V_m)^{-1}( d(meas) - d(calc) )
      do i = 1, NPAR
         deta(i) = ccov(i,1)*dvd(1) + ccov(i,2)*dvd(2) +
     +             ccov(i,3)*dvd(3) + ccov(i,4)*dvd(4) +
     +             ccov(i,5)*dvd(5)
         dc2(i) = dc1(i) + deta(i)
      enddo

      ! Compute the full distance using the updated parameters.
      dcalca(1) = dcalc0(1) +
     *            derv(1,1)*dc2(1) + derv(2,1)*dc2(2) +
     *            derv(3,1)*dc2(3) + derv(4,1)*dc2(4) +
     *            derv(5,1)*dc2(5)
      dcalca(2) = dcalc0(2) +
     *            derv(1,2)*dc2(1) + derv(2,2)*dc2(2) +
     *            derv(3,2)*dc2(3) + derv(4,2)*dc2(4) +
     *            derv(5,2)*dc2(5)

      ! This code also needs modifying if mcov is not diagonal.
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
     +        ((dcalca(1)-dmeas(1))**2)/mcov(1,1)  +
     +        ((dcalca(2)-dmeas(2))**2)/mcov(2,2)

      ! Normal return
      addhit_2 = 0
      return

c     Error return.
 9999 addhit_2 = 1

      end
c
c$Id$
c
c$Log$
cRevision 1.1  2000/06/19 19:59:42  eugenio
cInitial revision
c
cRevision 1.2  1998/11/11 05:01:46  kutschke
cProper treatment of non-diagonal measurement errors.
c
c Revision 1.1  1998/02/13  23:08:28  kutschke
c New routine.
c
c

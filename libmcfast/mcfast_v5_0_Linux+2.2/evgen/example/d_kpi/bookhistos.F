      SUBROUTINE bookhistos
C
C  book histograms
C
      IMPLICIT NONE

#include "qq_flag.inc"

      ! HBOOK common
      INTEGER HBKMAX 
      PARAMETER ( HBKMAX = 50000 )
      REAL HMEMOR
      COMMON/PAWC/HMEMOR(HBKMAX)

      ! Setup the HBOOK memory limit.
      call hlimit(hbkmax)

      !Book histograms.
      call hbook1(1,'no. of b particles in event',20,0.0,20.0,0.0)
      call hbook1(2,'no. of particles in event',100,0.0,500.0,0.0)
      if(lqq)then
        call hbook1(3,'no. of particles before QQ',100,0.0,500.0,0.0)
        call hbook1(4,'no. of particles added by QQ',
     1              100,0.0,500.0,0.0)
      endif

      ! charge and 4-momentum conservation at end of event.
      call hbook1 ( 10, 'total charge of stable particles', 
     +     10, -5., 5., 0. )
      call hbook1 ( 11, '4-momentum conservation px (GeV)', 
     +     100,  -20.,   20., 0. )
      call hbook1 ( 12, '4-momentum conservation py (GeV)', 
     +     100,  -20.,   20., 0. )
      call hbook1 ( 13, '4-momentum conservation pz (GeV)', 
     +     100,  -20.,   20., 0. )
      call hbook1 ( 14, '4-momentum conservation E (GeV)', 
     +     100,  -20.,   20., 0. )

      ! Multiplicities.
      call hbook1 ( 15, 
     +     'Number of e,mu,pi,k,p per event',
     +     250, 0., 250., 0.)
      call hbook1 ( 16, 'Number of neutrinos per event',
     +     100, 0., 100., 0.)
      call hbook1 ( 17, 'Number of photons per event',
     +     200, 0., 200., 0.)
      call hbook1 ( 18, 'Number of K0L and n0 per event',
     +     50, 0., 50., 0.)
      call hbook1 ( 19, 'Number of hyperons and K0 per event',
     +     50, 0., 50., 0.)

      ! Should not get any of these.
      call hbook1 ( 20, 'Number of unknown stable  particles event',
     +     25, 0., 25, 0.)


      RETURN
      END

      SUBROUTINE bookhistos
C--- book histograms
C
      IMPLICIT NONE

#include "qq_flag.inc"

C---   The HBOOK common
      REAL HMEMOR
      COMMON/PAWC/HMEMOR(50000)

C---   Setup the HBOOK memory limit.
      CALL HLIMIT(50000)

C...   Book histograms.
      CALL HBOOK1(1,'no. of b particles in event',20,0.0,20.0,0.0)
      CALL HBOOK1(2,'no. of particles in event',100,0.0,500.0,0.0)
      if(lqq)then
        CALL HBOOK1(3,'no. of particles before QQ',100,0.0,500.0,0.0)
        CALL HBOOK1(4,'no. of particles added by QQ',
     1              100,0.0,500.0,0.0)
      endif
      RETURN
      END

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:35  eugenio
c Initial revision
c
c Revision 1.2  1998/06/25 15:48:58  bphyslib
c add all necessary changes from v3_3
c

*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:50  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:32  zfiles
* first version of qqlib in CVS
*
*
*CMZ :  1.03/68 30/08/93  13.39.49  by  Peter C Kim
*-- Author :
* 15/10/96 Lynn Garren: Add double precision conditionals.
#if defined(CLEO_CDGDOC)
C*******************************************************
C  ---------------------------------------------------------------------
C     C$INC:HEPEVT.INC
C  ---------------------------------------------------------------------
C This is the "official" event common of the HEP community for MC events.
C  NEVHEP      = event number
C  NHEP        = number of particles ("lines")
C  ISTHEP(N)   = stability code; 0 if stable, 1 if decays.
C  IDHEP(I)    = particle ID code; see PDG '92, III.73
C  JMOHEP(1,I) = line number of mother particle
C  JMOHEP(2,I) = line number of last mother particle, if formed by string
C  JDAHEP(1,I) = line number of 1st daughter particle
C  JDAHEP(2,I) = line number of last daughter particle - MUST BE CONSECUTIVE!
C  PHEP(5,I)   = px,py,pz,E,m of particle
C  VHEP(4,I)   = x,y,z,L of production vertex
#endif
      INTEGER NMXHEP,NEVHEP,NHEP,ISTHEP,IDHEP,JMOHEP,JDAHEP
#if defined(NONCLEO_DOUBLE)
      double precision PHEP,VHEP
      PARAMETER (NMXHEP=4000)
#else
      REAL    PHEP,VHEP
      PARAMETER (NMXHEP=2000)
#endif
      COMMON/HEPEVT/NEVHEP,NHEP,ISTHEP(NMXHEP),IDHEP(NMXHEP),
     *JMOHEP(2,NMXHEP),JDAHEP(2,NMXHEP),PHEP(5,NMXHEP),VHEP(4,NMXHEP)
      SAVE /HEPEVT/

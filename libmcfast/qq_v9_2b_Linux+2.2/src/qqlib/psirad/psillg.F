*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:40  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:37  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 04/10/94  22.12.48  by  Paul Avery
*CMZ :  1.03/60 16/03/93  11.57.27  by  Peter C Kim
*CMZ :  1.03/57 15/02/93  17.04.29  by  Peter C Kim
*-- Author :    D. Coffman   15/02/93
* 16/10/96 Lynn Garren: Add double precision conditionals.
* 18/11/96 Rob Kutschke: Don't truncate to single precision.
      SUBROUTINE PSILLG(NP,NQ,KID,XM,KQ,ID,CMAS,T,IT,ND,PQ,MATRX,IER)
C.......................................................................
C.
C. PSILLG - Simulate the decay J/psi --> l+ l- (photon)
C.
C. Inputs    :
C.      NP     No. of daughter particles including quarks (Input and Output)
C.      KID    Particle ID of daughters                   (Input and Output)
C.      XM     Mass of daughters                          (Input and Output)
C.      ID      Particle ID of parents
C.      CMAS   Mass of parent
C.      T      Four momentum of parent
C.      IT     SU(5) specification of parent               (Not used)
C.      ND     No. of dauthter particles, excluding quarks (Input and output)
C.      MATRX  Specification of polarization
C.
C... The polarization is specified through the value of MATRX:

C...   MATRX = 41 ==> No polarization
C...   MATRX = 42 ==> Transverse polarization   (helicity = +/- 1)
C...   MATRX = 43 ==> Longitudinal polarization (helicity = 0)

C. Outputs   :
C.      NQ   No. of quark type daughters                   (Set to zero)
C.      KQ   Storage for quarks                            (Not used)
C.      PQ   Lab frame four momenta of the daughters
C.
C. Calls     : PSIGEN
C. Called    : DECAY
C...
C... This is the driver routine --- QQ interface --- for the J/psi
C... decay package.
C... Note that the number and type of daughter particles will be
C... modified if an additional photon is generated.
C...
C...        D. Coffman 1/29/93
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
C
C Declare the arguments
C
      INTEGER   KID(30),KQ(2,5)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION      T(4),XM(30),PQ(4,30)
      INTEGER   NP, NQ, ID, IT, ND, MATRX, IER
      DOUBLE PRECISION      CMAS
#else
      REAL      T(4),XM(30),PQ(4,30)
      INTEGER   NP, NQ, ID, IT, ND, MATRX, IER
      REAL      CMAS
#endif
C
C Local declarations
C
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'PSILLG' )
C
C Declare the 4-momenta
C
      DOUBLE PRECISION P4PSI(4)
      DOUBLE PRECISION P4LP(4), P4LM(4), P4G(4)
      DOUBLE PRECISION MPSI, ML
C
C This is the low-energy cut-off parameter.

      DOUBLE PRECISION KLOW
      PARAMETER(KLOW = 0.001D0)
C
C This variable flags the type of leptons to be produced:
C     lmode = 1 ==> electron
C     lmode = 2 ==> muons
C
      INTEGER LMODE
C
C Sundry variables
C
      INTEGER J

C-------------------------------------------------------------------
C Executable code starts here
C-------------------------------------------------------------------

C
C First check the arguments to make sure that they are correct
C   Particle type  1 ==> photon
C   Particle type  7 ==> e-
C   Particle type  8 ==> e+
C   Particle type 11 ==> mu-
C   Particle type 12 ==> mu+
C   Particle type 94 ==> J/psi
C
C Make sure the parent is a J/psi or Psi'
C Require two and only two non-quark daughters
C

      IER = 1
      IF (ID .NE. 94. AND. ID.NE.219)   RETURN
      IF (NP .NE. 2 .OR. NQ .NE. 0)     RETURN

C
C Require the daughters to be a lepton pair
C

      IF    (KID(1) .EQ.  7 .AND. KID(2) .EQ.  8) THEN
        LMODE = 1
      ELSEIF(KID(1) .EQ.  8 .AND. KID(2) .EQ.  7) THEN
        LMODE = 1
      ELSEIF(KID(1) .EQ. 11 .AND. KID(2) .EQ. 12) THEN
        LMODE = 2
      ELSEIF(KID(1) .EQ. 12 .AND. KID(2) .EQ. 11) THEN
        LMODE = 2
      ELSE
        RETURN
      ENDIF

C
C Look up the J/psi and daughter momenta
C

      MPSI = DBLE(CMAS)
      ML   = DBLE(XM(1))
      DO 10, J = 1,4
        P4PSI(J) = DBLE(T(J))
 10   CONTINUE

C
C Generate the daughter momenta
C

      CALL PSIGEN(P4PSI, MPSI, MATRX,
     *            KLOW,  ML,   P4LP,
     *            P4LM,  P4G,  ND, LMODE)


C
C Store the 4-momenta
C     First lepton:
C

      IF(KID(1) .EQ. 8 .OR. KID(1) .EQ. 12) THEN
        DO 20 J = 1,4
#if defined(NONCLEO_DOUBLE)
          PQ(J, 1) = P4LP(J)
#else
          PQ(J, 1) = SNGL(P4LP(J))
#endif
 20     CONTINUE
      ELSE
        DO 30 J = 1,4
#if defined(NONCLEO_DOUBLE)
          PQ(J, 1) = P4LM(J)
#else
          PQ(J, 1) = SNGL(P4LM(J))
#endif
 30     CONTINUE
      ENDIF

C
C     Second lepton:
C

      IF(KID(2) .EQ. 8 .OR. KID(2) .EQ. 12) THEN
        DO 40 J = 1,4
#if defined(NONCLEO_DOUBLE)
          PQ(J, 2) = P4LP(J)
#else
          PQ(J, 2) = SNGL(P4LP(J))
#endif
 40     CONTINUE
      ELSE
        DO 50 J = 1,4
#if defined(NONCLEO_DOUBLE)
          PQ(J, 2) = P4LM(J)
#else
          PQ(J, 2) = SNGL(P4LM(J))
#endif
 50     CONTINUE
      ENDIF

C
C     Photon (if one was generated)
C

      IF(ND .EQ. 3) THEN
        NP     = 3
        KID(3) = 1
        XM(3)  = 0.0

        DO 60 J = 1,4
#if defined(NONCLEO_DOUBLE)
          PQ(J, 3) = P4G(J)
#else
          PQ(J, 3) = SNGL(P4G(J))
#endif
 60     CONTINUE
      ENDIF

C
C Reset the error flag and return
C

      IER = 0

      RETURN
      END

*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:36  eugenio
* Initial revision
*
* Revision 1.2  1996/04/29 22:19:14  zfiles
* Decay.dec version number is saved in qqinfo.inc as IVRSDD.
*
* Revision 1.1.1.1  1994/10/08  02:21:31  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 05/10/94  02.45.46  by  Peter C Kim
*CMZ :  1.03/70 15/10/93  11.30.18  by  Paul Avery
*CMZ :  1.03/35 06/12/91  15.06.11  by  Peter C Kim
*CMZ :  1.03/31 11/11/91  20.48.00  by  Unknown
*CMZ :  1.03/12 02/07/91  12.18.05  by  Peter C Kim
*CMZ :  1.02/00 19/11/90  17.58.25  by  Paul Avery
*CMZ :  1.01/01 06/11/90  17.54.22  by  Paul Avery
*CMZ :  1.01/00 05/11/90  22.17.18  by  Paul Avery
*CMZ :          29/10/90  15.00.54  by  Paul Avery
*>> Author :
      SUBROUTINE QQRFIL(FILE, LERR)

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Read in particle types and decay modes for all particles used in the QQ
C   Monte Carlo. This program enables the user to specify the final state
C   from a data file.
C
C  FILE        character variable (read)
C              Name of file to read
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#include "seq/clinc/qqinfo.inc"
#include "seq/clinc/qqpars.inc"
#include "qqlib/seq/qqbrat.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/readinp.inc"
#include "qqlib/seq/qqluns.inc"
#include "seq/clinc/qqfile.inc"
#include "qqlib/seq/qqmisc.inc"

C     Calling arguments
      CHARACTER*(*) FILE
      LOGICAL LERR
*
C     Local variables
      INTEGER LENG, IPART, ITMP, IP1, IP2, IHEL
      INTEGER MATRX, NDAU, I, J, NUM
      INTEGER NDMTRX, IDMTRX(7)
      INTEGER NDANGH, IDANGH(8), NDHEL, IDHEL(20), NDMIX, IDMIX(3)
      INTEGER NDCPMX, IDCPMX(3), NDPAR, IDPAR(2), NDCPAR, IDCPAR(2)
      INTEGER NPDG,IPDG(2)
      CHARACTER*20 CPRIM(22)

C     External declarations
      INTEGER LENOCC, ISTRNG, ICMTYP, QQRINP, QQRINQ
      EXTERNAL LENOCC, ISTRNG, ICMTYP, QQRINP, QQRINQ
      DATA NDMTRX, IDMTRX/7,  7*2/
      DATA NDANGH, IDANGH/8,  8*2/
      DATA NDHEL,  IDHEL /20, 20*2/
      DATA NDMIX,  IDMIX /3,  3, 3, 2/
      DATA NDCPMX, IDCPMX/3,  3, 3, 2/
      DATA NDPAR,  IDPAR /2,  3, 1/
      DATA NPDG,   IPDG /2,  3, 1/
      DATA NDCPAR, IDCPAR/2,  3, 1/

      DATA CPRIM/'INCLUDE', 'USERFILE', 'STOP', 'EXIT', 'STABLE',
     *           'PARTICLE', 'DECAY', 'ENDDECAY', 'CHANNEL',
     *           'MATRIX', 'ANGULAR_HELICITY', 'QQBAR',
     *           'MIXING', 'CPTAG', 'PARITY', 'CPARITY',
     *           'CPEIGENSTATE', 'HELICITY', 'PDG', 'HIDE',
     *           'VERSION', ' '/
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C     Min, max particles to be defined
      NPMNQQ =  1000
      NPMXQQ = -1000

      NUM = MCNUM + 20 + 1
      CALL VZERO(CHARGE, NUM)
#if defined(NONCLEO_DOUBLE)
      DO I=-20,MCNUM
        CTAU(I) = 0.D0
        AMASS(I) = 0.D0
        RWIDTH(I) = 0.D0
        RMASMN(I) = 0.D0
        RMASMX(I) = 0.D0
      ENDDO
      CALL VZERO(SPIN, NUM)
#else
      CALL VZERO(CTAU, NUM)
      CALL VZERO(SPIN, NUM)
      CALL VZERO(AMASS, NUM)
      CALL VZERO(RWIDTH, NUM)
      CALL VZERO(RMASMN, NUM)
      CALL VZERO(RMASMX, NUM)
#endif
      CALL VZERO(LPARTY, NUM)
      CALL VZERO(CPARTY, NUM)
      CALL VZERO(IMIXPP, NUM)
      CALL VFILL(HIDEQQ, NUM, .FALSE.)
#if defined(NONCLEO_DOUBLE)
      DO I=-20,MCNUM
        RMIXPP(I) = 0.D0
        RCPMIX(I) = 0.D0
      ENDDO
      CALL VZERO(ICPMIX, NUM)
#else
      CALL VZERO(RMIXPP, NUM)
      CALL VZERO(ICPMIX, NUM)
      CALL VZERO(RCPMIX, NUM)
#endif
      CALL VZERO(IDMC, NUM)
      CALL VZERO(IDPDGQ, NUM)
      CALL VZERO(INVMC, MCSTBL+1)
      DO 10 I=-20,MCNUM
        PNAME(I) = ' '
10    CONTINUE
      DO 11 I=1,37
        QNAME(I) = ' '
11    CONTINUE

      NBRLST = 0
      NDGHTR = 0
      NUM = MCNUM + 20 + 1
      CALL VZERO(BRLIST, MCHANS)
      CALL VZERO(AGLIST, MCHANS*7)
      CALL VZERO(MLLIST, MCHANS*9)
      CALL VFILL(LCPTAG, MCHANS, .FALSE.)
      CALL VZERO(IPLIST, NUM*4)
      CALL VZERO(IDLIST, MCDTRS)

      NHLPRB = 0
      NHLLST = 0
      NHLANG = 0
      CALL VZERO(IHLPRB, MHLPRB)
      CALL VZERO(HELPRB, MHLPRB)
      CALL VZERO(HELLST, MHLLST)
      CALL VZERO(HELANG, MHLANG)
      CALL VZERO(COFANG, MHLANG*7)

      NCPLST = 0
      CALL VZERO(CPLIST, MCPLST)
      CALL VZERO(CPSNPH, MCPLST)

      IVRSDD = 0

      DO 40 I=1,MFDECA
        CFDECA(I) = ' '
40    CONTINUE

      NCHAN = 0
      NCHNCP = 0

      NDECAY = 0
      IDECAY = -100
      CALL QQRINI

      CFILE = FILE
      CALL QQROPN

      CALL TYPINI
      CALL UNITYP(0, LTTOQQ)

C     Set terminator set (blank, comma are only terminators)
      CALL SDLSCN(', ')

C     Allow @ _ $ : ; . [ ] / * - + ' to be embedded in commands
      CALL ICMSYM('@_$:;.[]/*-+''')


100   READ(LUN, 5000, END=1000, ERR=9998) STRING
5000  FORMAT(A)

C     Skip comments( blank line or ";", "!", "*" in first column)
      IF(STRING .EQ. ' ') GOTO 100
      CHR = STRING(1:1)
      IF(CHR.EQ.'!' .OR. CHR.EQ.';' .OR. CHR.EQ.'*') GOTO 100

C     Get command
      CALL QUOTYP(STRING)
      ICMD = ICMTYP(.FALSE., DELIM, CPRIM)
      IF(ICMD .LE. 0) GOTO 9997

      CMD = CPRIM(ICMD)

C     EXIT or STOP encountered: quit reading the file
      IF(CMD.EQ.'EXIT' .OR. CMD.EQ.'STOP') THEN
        GOTO 1000

C     DECAY.DEC version number
      ELSE IF(CMD .EQ. 'VERSION') THEN
        CALL QQRGLN(1, 1, NREAD, LIST, CLIST, LERROR)
        IVRSDD = LIST(1)
        IF(LERROR) GOTO 9999

C     INCLUDE filename
C     Read from a new file now
      ELSE IF(CMD .EQ. 'INCLUDE') THEN
        ITMP = ISTRNG(.FALSE., CFILE, LENG)
        CALL QQROPN
        IF(LERROR) GOTO 9999

C     USERFILE

C     Ask user for new file
      ELSE IF(CMD .EQ. 'USERFILE') THEN

        IF(NEWDEC .EQ. ' ') GOTO 100
        CALL QUOTYP(NEWDEC)
        ITMP = ISTRNG(.FALSE., CFILE, LENG)
        CALL QQROPN
        IF(LERROR) GOTO 100

C     DECAY  name
C     Decay a particle
      ELSE IF(CMD .EQ. 'DECAY') THEN
        IF(IDECAY .GE. NPMNQQ) CALL QQRBRA

C     Get particle number
        ITMP = ISTRNG(.FALSE., CNAME, LENG)
        IDECAY = QQRINP(CNAME)
        IF(IDECAY .LT. NPMNQQ) GOTO 9981

        NDECAY = NDECAY + 1
        NCHAN = 0
        NCHNCP = 0
        IF(IPLIST(1,IDECAY) .NE. 0) THEN
          WRITE(LTTOQQ, 4034) IDECAY, PNAME(IDECAY)
4034      FORMAT(/,' QQRFIL: ',5('*'),' Particle',
     *          I4,' (',A5,') redefined',5('*'))
        ENDIF

        IPLIST(1,IDECAY) = NBRLST + 1
        IPLIST(2,IDECAY) = 0
        IPLIST(3,IDECAY) = NCPLST + 1
        IPLIST(4,IDECAY) = 0

C     ENDDECAY
C     Finish decaying a particle
      ELSE IF(CMD .EQ. 'ENDDECAY') THEN
        CALL QQRBRA
        CALL QQRINI
        IDECAY = -100

C     STABLE name
C     Make a particle stable (even if previously used in a DECAY statement)
      ELSE IF(CMD .EQ. 'STABLE') THEN
        IF(IDECAY .GE. NPMNQQ) CALL QQRBRA

C     Get particle number
        ITMP = ISTRNG(.FALSE., CNAME, LENG)
        IDECAY = QQRINP(CNAME)
        IF(IDECAY .LT. NPMNQQ) GOTO 9981
        IF(IPLIST(1,IDECAY) .NE. 0) WRITE(LTTOQQ, 5040) CNAME(:LENG)
5040    FORMAT(' QQRFIL: ***** Particle ',A,' redefined as stable',
     *         '*****')
        IPLIST(1,IDECAY) = 0
        IPLIST(2,IDECAY) = 0
        IPLIST(3,IDECAY) = 0
        IPLIST(4,IDECAY) = 0
        CALL QQRINI
        IDECAY = -100

C     PARTICLE  name ityp1 ityp2 mass charge spin ctau width mass_min mass_max
C     Define a new particle
      ELSE IF(CMD .EQ. 'PARTICLE') THEN
        CALL QQRPAR
        IF(LERROR) GOTO 9998

C     PDG       name idpdgq
C     Set the PDG identification number for particle "name"
      ELSE IF(CMD .EQ. 'PDG') THEN
        CALL QQRGLN(NPDG, IPDG, NREAD, LIST, CLIST, LERROR)
        IF(LERROR) GOTO 9997
        IP1 = QQRINP(CLIST(1))
        IF(IP1 .LT. NPMNQQ) GOTO 9998
        IDPDGQ(IP1) = LIST(2)

C     HIDE       name
C     Set this particle to "hidden". When produced, it will be decayed
C     immediately so that it never appears in the decay history list.
      ELSE IF(CMD .EQ. 'HIDE') THEN
        CALL QQRGLN(1, 3, NREAD, LIST, CLIST, LERROR)
        IF(LERROR) GOTO 9997
        IP1 = QQRINP(CLIST(1))
        IF(IP1 .LT. NPMNQQ) GOTO 9998
        HIDEQQ(IP1) = .TRUE.

C     QQBAR name ityp
C     Define a new qqbar combination
      ELSE IF(CMD .EQ. 'QQBAR') THEN
        CALL QQRQQB
        IF(LERROR) GOTO 9998

C     PARITY  name  ip
C     Set parity of particle "name"
      ELSE IF(CMD .EQ. 'PARITY') THEN
        CALL QQRGLN(NDPAR, IDPAR, NREAD, LIST, CLIST, LERROR)
        IF(LERROR) GOTO 9997
        IP1 = QQRINP(CLIST(1))
        IF(IP1 .LT. NPMNQQ) GOTO 9998
        LPARTY(IP1) = LIST(2)

C     CPARITY  name  ip
C     Set C parity of particle "name"
      ELSE IF(CMD .EQ. 'CPARITY') THEN
        CALL QQRGLN(NDCPAR, IDCPAR, NREAD, LIST, CLIST, LERROR)
        IF(LERROR) GOTO 9997
        IP1 = QQRINP(CLIST(1))
        IF(IP1 .LT. NPMNQQ) GOTO 9998
        CPARTY(IP1) = LIST(2)

C     CPEIGENSTATE  sinphi
C     Identifies the next decay channel as being a CP eigenstate decay
C     sinphi = CP violating parameter
      ELSE IF(CMD .EQ. 'CPEIGENSTATE') THEN
        CALL QQRGLN(1, 2, NREAD, LIST, CLIST, LERROR)
        IF(LERROR) GOTO 9997
        SINPHI = XLIST(1)
        LCPEIG = .TRUE.

C     CHANNEL matrix_id  br  name1  name2 ...
C     Define a new decay channel
      ELSE IF(CMD .EQ. 'CHANNEL') THEN
        CALL QQRCHN
        IF(LERROR) GOTO 9998

C     MATRIX  A1  A2 ... A7
C     Sets parameters for matrix element for next channel
C     If next decay is 2 body the coefficients are used to define the
C     angular distribution
C
C        dN/dcos = A1 + A2*cos(theta) + ... + A7*cos(theta)**2

      ELSE IF(CMD .EQ. 'MATRIX') THEN
        CALL QQRGLN(NDMTRX, IDMTRX, NREAD, LIST, CLIST, LERROR)
        IF(LERROR) GOTO 9993
        CALL UCOPY(XLIST, ANGS, 7)

C     ANGULAR_HELICITY  hel  A1 A2 ... A7
C     Set angular distribution for a given helicity for the next channel
C     Defined by dN/dcos = A1 + A2*cos(theta) + ... + A7*cos(theta)**6
      ELSE IF(CMD .EQ. 'ANGULAR_HELICITY') THEN
        CALL QQRGLN(NDANGH, IDANGH, NREAD, LIST, CLIST, LERROR)
        IF(LERROR) GOTO 9993
        IF(NHEL .GE. MHEL) GOTO 9998
        NHEL = NHEL + 1
        ANGH(1,NHEL) = XLIST(1)
        ANGH(2,NHEL) = XLIST(2)
        ANGH(3,NHEL) = XLIST(3)
        ANGH(4,NHEL) = XLIST(4)
        ANGH(5,NHEL) = XLIST(5)
        ANGH(6,NHEL) = XLIST(6)
        ANGH(7,NHEL) = XLIST(7)
        ANGH(8,NHEL) = XLIST(8)

C     HELICITY  prob  ihel1  ihel2  ihep3 ...
C     Set probability of a given helicity state for next decay channel
C     prob = probability of this helicity state
C     iheln = helicity of each particle in next decay (-100 if not set)
      ELSE IF(CMD .EQ. 'HELICITY') THEN
        CALL QQRGLN(NDHEL, IDHEL, NREAD, LIST, CLIST, LERROR)
        IF(LERROR) GOTO 9988
        IF(NREAD .LT. 3) GOTO 9989
        NDAU = NREAD - 1
        IF(NPRB .GE. MPRB) GOTO 9998
        NPRB = NPRB + 1
        DO 180 I=1,NDAU
          PROBH(NPRB) = XLIST(1)
          HEL(I,NPRB) = XLIST(1+I)
180     CONTINUE

C     MIXING  name1  name2  x
C     Set mixing of particles "name1" and "name2" into each other.
C     x = dM / Gamma
      ELSE IF(CMD .EQ. 'MIXING') THEN
        CALL QQRGLN(NDMIX, IDMIX, NREAD, LIST, CLIST, LERROR)
        IF(LERROR) GOTO 9997
        IF(NREAD .LT. NDMIX) GOTO 9998
        IP1 = QQRINP(CLIST(1))
        IP2 = QQRINP(CLIST(2))
        IF(IP1.LE.0 .OR. IP2.LE.0) GOTO 9998
        IMIXPP(IP1) = IP2
        IMIXPP(IP2) = IP1
        RMIXPP(IP1) = XLIST(3)
        RMIXPP(IP2) = XLIST(3)

C     CPTAG
C     Sets a flag so that when the daughter decays are carried out later, the
C     decays should have one of the following two forms
C       (1)    1 ==> CP eigenstate   2 ==> tag decay
C       (2)    2 ==> CP eigenstate   1 ==> tag decay
C     CP eigenstate decays are flagged by the CPEIGENSTATE command
C     Tag decays are all other decays.
C
C     If CPTAG is not called and there are two daughters that mix into each
C     other, and the CPEIGENSTATE command has been invoked to flag CP violating
C     decays for both daughters, then the final state will be generated as one
C     of the following
C       (1)    1 ==> CP eigenstate   2 ==> any decay
C       (2)    2 ==> CP eigenstate   1 ==> any decay
C
      ELSE IF(CMD .EQ. 'CPTAG') THEN
        LCPTG = .TRUE.

      ENDIF
      GOTO 100

C     Come here after either (1) end of file, (2) STOP, (3) EXIT
C     Read more if other files still open
1000  CALL QQRCLS
      IF(ILUN .GT. 0) GOTO 100
      LERROR = .FALSE.
      GOTO 8000

C     Come here when done. Check for hanging DECAY sequence
8000  CALL QQRBRA
      CALL QQRINI
      LERR = .FALSE.
      GOTO 9999

9981  CALL ZERTYP('.TRUE.')
      LERR = .TRUE.
      GOTO 9999

C9982  CALL ZERTYP('.TRUE.')
C      LERR = .TRUE.
C      GOTO 9999

C9983  CALL ZERTYP('.TRUE.')
C      LERR = .TRUE.
C      GOTO 9999

C9984  CALL ZERTYP('.TRUE.')
C      LERR = .TRUE.
C      GOTO 9999

9985  CALL ZERTYP('.TRUE.')
      LERR = .TRUE.
      GOTO 9999

C9986  CALL ZERTYP('.TRUE.')
C      LERR = .TRUE.
C      GOTO 9999

C9987  CALL ZERTYP('.TRUE.')
C      LERR = .TRUE.
C      GOTO 9999

9988  CALL ZERTYP('.TRUE.')
      LERR = .TRUE.
      GOTO 9999

9989  CALL ZERTYP('.TRUE.')
      LERR = .TRUE.
      GOTO 9999

C9990  CALL ZERTYP('.TRUE.')
C      LERR = .TRUE.
C      GOTO 9999

C9991  CALL ZERTYP('.TRUE.')
C      LERR = .TRUE.
C      GOTO 9999

C9992  CALL ZERTYP('.TRUE.')
C      LERR = .TRUE.
C      GOTO 9999

9993  CALL ZERTYP('.TRUE.')
      LERR = .TRUE.
      GOTO 9999

9994  CALL ZERTYP('.TRUE.')
      LERR = .TRUE.
      GOTO 9999

9995  CALL ZERTYP('.TRUE.')
      LERR = .TRUE.
      GOTO 9999

C9996  CALL ZERTYP('.TRUE.')
C      LERR = .TRUE.
C      GOTO 9999

9997  CALL ZERTYP('.TRUE.')
      LERR = .TRUE.
      GOTO 9999

9998  CALL ZERTYP('.TRUE.')
      LERR = .TRUE.
      GOTO 9999

9999  CALL UNITYP(LTTIQQ, LTTOQQ)
      RETURN

      END

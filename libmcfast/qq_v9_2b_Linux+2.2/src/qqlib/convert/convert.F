*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:35  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:32  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 07/11/90  13.52.31  by  Paul Avery
*CMZ :  1.01/00 02/11/90  00.24.57  by  Paul Avery
*CMZ :          30/10/90  17.38.34  by  Paul Avery
*>> Author :
      PROGRAM CONVERT

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"

C ---------------------------------------------------------------------------
C   Converts old style *.inp file and converts it to the new format
C ---------------------------------------------------------------------------

C     Local variables
      INTEGER IPOLD, LENG
      INTEGER LUNIT, IOERR, IPNEW, NPART, IHL1,IHL2,IHL3, ITMP, J
      INTEGER MATRX, NDAU, I, NUM, LENN, KTP
      INTEGER ITEMP(20), ihel(3), ih, luntti, luntto
      logical lerror
      REAL RAT, X2, CHRG, CT, WID, XL, XH, spinn
      LOGICAL LDECAY
      CHARACTER*5 GNAME(10),CNAME(20),NAME
      CHARACTER STRING*100, filei*80, fileo*80
*
C     External declarations

      DATA GNAME/'GG','GGG','QQ','QQG',6*' '/
C ---------------------------------------------------------------------------

      luntti = 5
      luntto = 6
      lunit = 21

      write(luntto, 6550)
6550  format('  Input file: ',$)
      read(luntti, '(a)') filei

      write(luntto, 6551)
6551  format(' Output file: ',$)
      read(luntti, '(a)') fileo

      open(unit=lunit, file=filei, status='old', readonly, shared)

      open(unit=22, file=fileo, status='new',
     *     carriagecontrol='list')

C     Read in NAMES.DEC
      write(luntti, 5070)
5070  format(/,' Reading UD:[BFACMC.SOFTWARE]NAMES.DEC to get names',
     *         ' of particles',/)
      call qqrfil('ud:[bfacmc.software]names.dec', lerror)
      if(lerror) stop 'NAMES.DEC not found'

C     last unstable particle
      IPOLD = -1

C     not yet reading in decay cards
      LDECAY = .FALSE.

200   READ(LUNIT,3090,END=4000)STRING
3090  FORMAT(A)

C   See what's been read in
C      ";" ==> comment line

      IF(STRING(1:1) .EQ. ';')THEN
        CONTINUE
        leng = len(string)
        do 33 i=leng, 1, -1
          if(string(i:i) .ne. ' ') then
            leng = i
            goto 34
          ENDIF
33      CONTINUE
        leng = 1

34      write(22, '(a)') string(:leng)

      ELSEIF(STRING(1:) .EQ. ' ')THEN
        CONTINUE
        write(22, '(1x)')

C   "TTY" card ...  get name of additional file and open it
      ELSEIF(STRING(1:3) .EQ. 'TTY')THEN
        write(22, 6501)
6501    format('ENDDECAY',//,'USERFILE')

C   "DECAY" card
      ELSEIF(STRING(1:5) .EQ. 'DECAY')THEN
        if(ipold .ge. 0) write(22, 6536)
6536    format('ENDDECAY',/)

        READ(STRING,3003)IPNEW
3003    FORMAT(5X,10I)
        write(22, 6502) pname(ipnew)
6502    format('DECAY  ', a)
        IPOLD = IPNEW
        LDECAY = .TRUE.

C   "END" card .... quit reading file

      ELSEIF(STRING(1:3) .EQ. 'END')THEN
        write(22, 6504)
6504    format('EXIT')

        GO TO 4000

C      "STABLE" card .... turn off br's for particle

      ELSEIF(STRING(1:6) .EQ. 'STABLE')THEN
        READ(STRING,3055)NPART
3055    FORMAT(6X,I)
        write(22, 6505) pname(npart)
6505    format('STABLE  ', a)

C     "ANGULAR" card .... set angular distribution for helicities
      ELSEIF(STRING(1:7) .EQ. 'ANGULAR')THEN
        READ(STRING,3016)IHL1,IHL2,IHL3
3016    FORMAT(7X,3I)
        ihel(1) = ihl1
        ihel(2) = ihl2
        ihel(3) = ihl3
        do 1234 i=1,3
          ih = -2 + i
          if(ihel(i) .eq. 0) then
            write(22, 6506) ih
6506        format('ANGULAR_HELICITY', i4,'   0.  0.  0.')
          else if(ihel(i) .eq. 1) then
            write(22, 6507) ih
6507        format('ANGULAR_HELICITY', i4,'   1.  0.  1.')
          else if(ihel(i) .eq. 2) then
            write(22, 6508) ih
6508        format('ANGULAR_HELICITY', i4,'   1.  0. -1.')
          else if(ihel(i) .eq. 3) then
            write(22, 6509) ih
6509        format('ANGULAR_HELICITY', i4,'   1.  0.  0.5')
          else if(ihel(i) .eq. 4) then
            write(22, 6510) ih
6510        format('ANGULAR_HELICITY', i4,'   1.  0.  -0.5')
          else if(ihel(i) .eq. 5) then
            write(22, 6511) ih
6511        format('ANGULAR_HELICITY', i4,'   3.  0.  1.')
          else if(ihel(i) .eq. 6) then
            write(22, 6512) ih
6512        format('ANGULAR_HELICITY', i4,'   3.  0. -1.')
          else if(ihel(i) .eq. 7) then
            write(22, 6513) ih
6513        format('ANGULAR_HELICITY', i4,'   1.  2.  1.')
          else if(ihel(i) .eq. 8) then
            write(22, 6514) ih
6514        format('ANGULAR_HELICITY', i4,'   1. -2.  1.')
          else if(ihel(i) .eq. 9) then
            write(22, 6515) ih
6515        format('ANGULAR_HELICITY', i4,'   0.  0.  1.')
          ENDIF
1234    CONTINUE

C  "HELICITY" CARD .... set polarizations for daughter particles
      ELSEIF(STRING(1:8) .EQ. 'HELICITY')THEN

        read(string,3015)(itemp(j),j=1,5)
3015    FORMAT(8X,10I)
        write(22, 6516) (itemp(j), j=1,2)
6516    format('HELICITY   1.0', 3i5)


C  Read in branching decay parameters for particle
      ELSE
        IF(LDECAY)THEN

C  Get BR, matrix element type, and number and list of daughters
          READ(STRING,3004)RAT,MATRX,NDAU
3004      FORMAT(G,20I)
          LENN = NDAU

C   for matrx < 0, clear daughter list
          IF(MATRX .LT. 0)ITEMP(1) = 0
          READ(STRING,3004)RAT,MATRX,NDAU,(ITEMP(I),I=1,LENN)

C   matrx < 0, get special name of process ("ggg" etc.)
C   matrx = -1 to -4 ==> 'gg', 'ggg', 'qq', 'qqg'
          IF(MATRX .LT. 0)THEN
            lenn = 0
            cname(1) = ' '

C    MATRX > 0, get names of particles ( .GE.0 ) or qq pairs ( .LT.0 )

          ELSE
            DO 1010 I=1,LENN
              IF(ITEMP(I).GE.0)THEN
                CNAME(I) =  PNAME(ITEMP(I))
              ELSE
                CNAME(I) = QNAME(-ITEMP(I))
              ENDIF
1010        CONTINUE

          ENDIF

          if(lenn.eq.2 .and. (matrx.eq.1 .or. matrx.eq.2)) then
            if(matrx .eq. 1) then
              write(22, 6557)
6557          format('MATRIX     1.  0.  1.')
            else if(matrx .eq. 2) then
              write(22, 6558)
6558          format('MATRIX     1.  0. -1.')
            ENDIF
            matrx = 0
          ENDIF

          write(22, 6520) matrx, rat, (cname(i),i=1,lenn)
6520      format('CHANNEL', i3, f7.4, 15a6)

C  read in particle definitions (mass, name, etc.)
        ELSE
          READ(STRING,3005)NUM,NAME,X2,KTP,CHRG,CT,WID,XL,XH
3005      FORMAT(I,A5,G,I,5G)
          if(name .eq. ' ') name = '*****'

          if(num .eq. 5) name = 'QQ'
          pname(num) = name

          if(num .eq. -13) then
            spinn = 1.
          else if(num.ge.-12 .and. num.le.-1) then
            spinn = 0.5
          else if(num.ge.0 .and. num.le.1) then
            spinn = 1.
          else if(num.ge.2 .and. num.le.6) then
            spinn = 0.
          else if(num.ge.7 .and. num.le.20) then
            spinn = 0.5
          else if(num.ge.21 .and. num.le.60) then
            spinn = 0.
          else if(num.ge.61 .and. num.le.99) then
            spinn = 1.
          else if(num.ge.121 .and. num.le.160) then
            spinn = 0.5
          else if(num.ge.161 .and. num.le.200) then
            spinn = 1.5
          else if(num.ge.201 .and. num.le.206) then
            spinn = 1.
          else if(num.ge.207 .and. num.le.210) then
            spinn = 1.
          ELSE
            spinn = 0.
          ENDIF

          if(wid .eq. 0) then
            write(22, 6521) pname(num), num, ktp, x2, chrg, spinn, ct
          ELSE
            write(22, 6521) pname(num), num, ktp, x2, chrg, spinn, ct,
     *                      wid, xl, xh
          ENDIF
6521      format('DEFINE ',a8, 2i5, f10.6, f5.1, f5.1, f11.6,
     *           3f7.3)

        ENDIF

      ENDIF
      GOTO 200

C   eof encountered
4000  CLOSE(UNIT=LUNIT)
      close(unit=22)

      END


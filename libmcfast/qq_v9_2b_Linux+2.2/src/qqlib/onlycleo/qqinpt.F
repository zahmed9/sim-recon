*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:39  eugenio
* Initial revision
*
* Revision 1.8  1996/07/31 09:50:50  clib
* Include qqinfo.inc.
*
* Revision 1.7  1996/06/05 07:50:28  clib
* FFKEY for beam dispersion sigmas.
*
* Revision 1.6  1996/05/01 06:55:42  zfiles
* New FFREAD card, ITRMTV, for variation of tracking efficiency used in trksim.
* New FFREAD card, BDISPX, BDISPY for CESR beam dispersion.
*
* Revision 1.4  1995/02/03  16:44:48  zfiles
* Fixed another typo (PCK)
*
* Revision 1.3  1995/02/03  16:36:38  zfiles
* Fixed a typo (PCK)
*
* Revision 1.1.1.1  1994/10/08  02:21:37  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 05/10/94  02.44.55  by  Peter C Kim
*CMZ :          07/01/94  13.32.21  by  Brian Heltsley
* add new variable BHEMIN
*CMZ :          20/12/93  16.32.33  by  Paul Avery
*CMZ :  1.03/68 30/08/93  10.58.43  by  Peter C Kim
*CMZ :  1.03/57 15/02/93  14.57.44  by  Peter C Kim
*CMZ :  1.03/54 24/11/92  11.33.58  by  Peter C Kim
*CMZ :  1.03/52 17/11/92  13.18.09  by  Peter C Kim
*CMZ :  1.03/49 21/09/92  15.25.08  by  Peter C Kim
*CMZ :  1.03/36 16/12/91  19.46.10  by  Peter C Kim
*CMZ :  1.03/35 06/12/91  15.54.59  by  Peter C Kim
*CMZ :  1.03/31 11/11/91  20.47.59  by  Unknown
*CMZ :  1.03/25 01/10/91  10.02.27  by  Peter C Kim
*CMZ :  1.03/17 25/07/91  10.14.28  by  Peter C Kim
*CMZ :  1.03/15 22/07/91  21.32.12  by  Peter C Kim
*CMZ :  1.03/13 02/07/91  19.17.05  by  Peter C Kim
*CMZ :  1.03/12 02/07/91  12.15.33  by  Peter C Kim
*CMZ :  1.03/06 01/05/91  13.31.23  by  Peter C Kim
*CMZ :  1.03/00 02/04/91  11.19.43  by  Peter C Kim
*CMZ :  1.02/00 06/02/91  11.40.42  by  Peter C Kim
*-- Author :
      SUBROUTINE QQINPT(LERROR)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Read in control variables for QQ via FFREAD
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqbmst.inc"
#include "qqlib/seq/qqcntl.inc"
#include "seq/clinc/qqevnt.inc"
#include "seq/clinc/qqbfld.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/mcjet.inc"
#include "qqlib/seq/qqsngl.inc"
#include "qqlib/seq/qqluns.inc"
#include "qqlib/seq/qqbuffer.inc"
#include "seq/clinc/qqfile.inc"
#include "qqlib/seq/qqmisc.inc"
#include "qqlib/seq/jetscl.inc"
#include "qqlib/seq/korbcm.inc"
#include "qqlib/seq/ggginp.inc"
#include "seq/clinc/qqinfo.inc"

      CHARACTER*(*) CRNAME
      PARAMETER ( CRNAME = 'QQINPT')


C-- Calling arguments
      LOGICAL LERROR

C-- Local variables
      INTEGER   I
      REAL      CTOT
      INTEGER LUNDTB(20),UDECAY(20),DEFDEC(20),TAPOUT(20)
      INTEGER LSINGL(5),LRESON(5)

      REAL UUPS,DDPS,SSPS,UUV,DDV,SSV
      COMMON /QQTEMP/UUPS(3),DDPS(3),SSPS(3),UUV(3),DDV(3),SSV(3)

      CHARACTER*80  TDECQQ, LUTTAB, NEWDET

C-- +1,-1,0 sigma variation of TRKSIM track recon. efficiency
      INTEGER ITRMTV 
      DATA ITRMTV /0/

C-- Conversion for UNIX system

#if defined(CLEO_UNIX)
* EQNAME - Logically equivalent name to FCTLQQ
      CHARACTER*80 EQNAME
#endif

C-- Increase the size of common for FFREAD

      REAL SPACE
      COMMON /CFREAD/SPACE(9000)
      CALL FFINIT(9000)

C-- Define Keys for FFREAD

      CALL FFSET ('SIZE',6)

C                                                   QQEVNT
      CALL FFKEY ('ECM   ', ECM   , 1, 'REAL')
C                                                   QQBMST

      CALL FFKEY ('BFLDQQ', BFLDQQ, 1, 'REAL')
      CALL FFKEY ('BMPSQQ', BMPSQQ, 1, 'REAL')
      CALL FFKEY ('BMNGQQ', BMNGQQ, 1, 'REAL')
      CALL FFKEY ('BWPSQQ', BWPSQQ, 1, 'REAL')
      CALL FFKEY ('BWNGQQ', BWNGQQ, 1, 'REAL')
      CALL FFKEY ('BPOSQQ', BPOSQQ, 3, 'REAL')
      CALL FFKEY ('BSIZQQ', BSIZQQ, 3, 'REAL')

C                                                   QQFILE
      CALL FFKEY ('TAPOUT', TAPOUT,20, 'HOLL')
      CALL FFKEY ('UDECAY', UDECAY,20, 'HOLL')
      CALL FFKEY ('DEFDEC', DEFDEC,20, 'HOLL')

C                                                   QQCNTL
      CALL FFKEY ('NDO   ', NDO   , 1, 'INTEGER')
      CALL FFKEY ('NDUMP ', NDUMP , 1, 'INTEGER')
      CALL FFKEY ('IRAN  ', IRAN  , 1, 'INTEGER')
C                                                   QQCNTL
      CALL FFKEY ('MODEL' , MODEL , 1, 'INTEGER')
      CALL FFKEY ('IFL  ' , IFL   , 1, 'INTEGER')
      CALL FFKEY ('IMODE' , IMODE , 1, 'INTEGER')
      CALL FFKEY ('SPREAD', SPREAD, 1, 'REAL')
      CALL FFKEY ('ENRGMX', ENRGMX, 1, 'REAL')
      CALL FFKEY ('ENRGMN', ENRGMN, 1, 'REAL')
      CALL FFKEY ('KEMIN ', KEMIN , 1, 'REAL')
      CALL FFKEY ('KEMAX ', KEMAX , 1, 'REAL')
      CALL FFKEY ('BHEMIN', BHEMIN , 1, 'REAL')
      CALL FFKEY ('CRSANG', CRSANG , 1, 'REAL')
      CALL FFKEY ('BDSIGX', BDSIGX , 1, 'REAL')
      CALL FFKEY ('BDSIGY', BDSIGY , 1, 'REAL')
C                                                   QQCNTL
      CALL FFKEY ('TRACE ', TRACE  , 1, 'LOGICAL')
      CALL FFKEY ('LPHASE', LPHASE , 1, 'LOGICAL')
      CALL FFKEY ('LPRDEC', LPRDEC , 1, 'LOGICAL')
      CALL FFKEY ('LRESPR', LRESPR , 1, 'LOGICAL')
      CALL FFKEY ('LSELCT', LSELCT , 1, 'LOGICAL')
      CALL FFKEY ('LTAPE ', LTAPE  , 1, 'LOGICAL')
      CALL FFKEY ('LSHAPE', LSHAPE , 1, 'LOGICAL')
      CALL FFKEY ('BMRAD ', BMRAD  , 1, 'LOGICAL')
      CALL FFKEY ('LWIDE ', LWIDE  , 1, 'LOGICAL')
      CALL FFKEY ('LONGLF', LONGLF , 1, 'LOGICAL')
      CALL FFKEY ('LTRKSM', LTRKSM , 1, 'LOGICAL')
      CALL FFKEY ('LTSMP0', LTSMP0 , 1, 'LOGICAL')
      CALL FFKEY ('LTSMVF', LTSMVF , 1, 'LOGICAL')
      CALL FFKEY ('LTSMEI', LTSMEI , 1, 'LOGICAL')
      CALL FFKEY ('ADDPQQ', ADDPQQ , 1, 'LOGICAL')
      CALL FFKEY ('LPROMP', LPROMP , 1, 'LOGICAL')

      CALL FFKEY ('ITRMTV', ITRMTV , 1, 'INTEGER')

C                                                   QQCNTL
      CALL FFKEY ('ANGMIN', ANGMIN, 1, 'REAL')
      CALL FFKEY ('ANGMAX', ANGMAX, 1, 'REAL')
      CALL FFKEY ('CEN   ', CEN   , 2, 'REAL')
      CALL FFKEY ('FWID  ', FWID  , 2, 'REAL')
      CALL FFKEY ('C1B   ', C1B   , 3, 'REAL')
      CALL FFKEY ('C2B   ', C2B   , 3, 'REAL')
C                                                   QQSNGL
      CALL FFKEY ('LSINGL', LSINGL , 3, 'HOLL')
      CALL FFKEY ('PSINGL', PSINGL , 2, 'REAL')
      CALL FFKEY ('STHET ', STHET  , 2, 'REAL')
      CALL FFKEY ('SPHI  ', SPHI   , 2, 'REAL')

C                                                   MCGEN /DATA1/
      CALL FFKEY ('IFR   ', IFR   , 1, 'INTEGER')
      CALL FFKEY ('PUD   ', PUD   , 1, 'REAL')
      CALL FFKEY ('SIGMA ', SIGMA , 1, 'REAL')
      CALL FFKEY ('PAR   ', PAR   ,25, 'REAL')
C                                                   MCGEN /DATA5/
      CALL FFKEY ('BSPIN ', BSPIN , 5, 'REAL')
      CALL FFKEY ('BSYMM ', BSYMM , 3, 'REAL')

C                                                   MCGEN /BARYON/
      CALL FFKEY ('PBFL  ', PBFL  , 6, 'REAL')
      CALL FFKEY ('FLIP  ', FLIP  , 1, 'REAL')
      CALL FFKEY ('WBAR  ', WBAR  , 1, 'REAL')
C                                                   MCJET  /JET3PA/
      CALL FFKEY ('PSPIN ', PSPIN ,10, 'REAL')

      CALL FFKEY ('UUPS  ', UUPS, 3, 'REAL')
      CALL FFKEY ('DDPS  ', DDPS, 3, 'REAL')
      CALL FFKEY ('SSPS  ', SSPS, 3, 'REAL')
      CALL FFKEY ('UUV   ', UUV , 3, 'REAL')
      CALL FFKEY ('DDV   ', DDV , 3, 'REAL')
      CALL FFKEY ('SSV   ', SSV , 3, 'REAL')

      CALL FFKEY ('CMLT1 ', CMLT1  , 5, 'REAL')
      CALL FFKEY ('CMLT2 ', CMLT2  , 5, 'REAL')

C                                                     JETSCL /CTLUND/
      CALL FFKEY ('MCMODE', MCMODE , 1, 'INTEGER')
      CALL FFKEY ('NFLAV ', NFLAV  , 1, 'INTEGER')
      CALL FFKEY ('IQTYPE', IQTYPE , 1, 'INTEGER')
      CALL FFKEY ('QCDCOR', QCDCOR , 1, 'INTEGER')
      CALL FFKEY ('LFRAG ', LFRAG  , 1, 'INTEGER')
      CALL FFKEY ('LUNDEC', LUNDEC , 1, 'INTEGER')
      CALL FFKEY ('ISTRAD', ISTRAD , 1, 'INTEGER')
      CALL FFKEY ('LXEDIT', LXEDIT , 1, 'INTEGER')
      CALL FFKEY ('LNDDMP', LNDDMP , 1, 'INTEGER')

      CALL FFKEY ('LRESON', LRESON , 3, 'HOLL')
      CALL FFKEY ('LUNDAA', LUNDAA , 1, 'REAL')
      CALL FFKEY ('LUNDBB', LUNDBB , 1, 'REAL')
      CALL FFKEY ('EPSC  ', EPSC   , 1, 'REAL')
      CALL FFKEY ('EPSB  ', EPSB   , 1, 'REAL')
      CALL FFKEY ('MSPIN ', MSPIN  , 7, 'REAL')
      CALL FFKEY ('BSTECM', BSTECM , 6, 'REAL')
      CALL FFKEY ('EMINFX', EMINFX , 1, 'REAL')
      CALL FFKEY ('LUNDTB', LUNDTB ,20, 'HOLL')

C                                                     KORBCM /KORPAR/
      CALL FFKEY ('KSPIN ', KSPIN  , 1, 'INTEGER')
      CALL FFKEY ('ITFIN ', ITFIN  , 1, 'INTEGER')
      CALL FFKEY ('KEYGSW', KEYGSW , 1, 'INTEGER')
      CALL FFKEY ('KEYRAD', KEYRAD , 1, 'INTEGER')
      CALL FFKEY ('ITDKRC', ITDKRC , 1, 'INTEGER')
      CALL FFKEY ('KORBE1', KORBE1 , 3, 'REAL')
      CALL FFKEY ('KORBE2', KORBE2 , 3, 'REAL')
      CALL FFKEY ('SINW2 ', SINW2  , 1, 'REAL')
      CALL FFKEY ('KORBGV', KORBGV , 1, 'REAL')
      CALL FFKEY ('KORBGA', KORBGA , 1, 'REAL')
      CALL FFKEY ('KORXK0', KORXK0 , 1, 'REAL')

C                                                     2-PHOTON MC
C                                                     GGGINP /GGGINP/
      CALL FFKEY ('MODLGG', MODLGG , 1, 'INTEGER')
      CALL FFKEY ('NTAGGG', NTAGGG , 1, 'INTEGER')
      CALL FFKEY ('KRESGG', KRESGG , 1, 'INTEGER')
      CALL FFKEY ('JRESGG', JRESGG , 1, 'INTEGER')
      CALL FFKEY ('JPARGG', JPARGG , 1, 'INTEGER')
      CALL FFKEY ('LHRSGG', LHRSGG , 1, 'INTEGER')
      CALL FFKEY ('F2TPGG', F2TPGG , 1, 'INTEGER')
      CALL FFKEY ('NQRKGG', NQRKGG , 1, 'INTEGER')
      CALL FFKEY ('IQRKGG', IQRKGG , 1, 'INTEGER')
      CALL FFKEY ('EPAGG ', EPAGG  , 1, 'REAL')
      CALL FFKEY ('WMINGG', WMINGG , 1, 'REAL')
      CALL FFKEY ('WMAXGG', WMAXGG , 1, 'REAL')
      CALL FFKEY ('TG1LGG', TG1LGG , 1, 'REAL')
      CALL FFKEY ('TG1HGG', TG1HGG , 1, 'REAL')
      CALL FFKEY ('TG2LGG', TG2LGG , 1, 'REAL')
      CALL FFKEY ('TG2HGG', TG2HGG , 1, 'REAL')
      CALL FFKEY ('ANGUGG', ANGUGG , 1, 'REAL')
      CALL FFKEY ('EXPSGG', EXPSGG , 1, 'REAL')
      CALL FFKEY ('PTBRGG', PTBRGG , 1, 'REAL')
      CALL FFKEY ('SIG0GG', SIG0GG , 1, 'REAL')
      CALL FFKEY ('GVDMGG', GVDMGG , 1, 'LOGICAL')
      CALL FFKEY ('RHOPGG', RHOPGG , 1, 'LOGICAL')
      CALL FFKEY ('TRGMGG', TRGMGG , 1, 'LOGICAL')
      CALL FFKEY ('LMTLGG', LMTLGG , 1, 'LOGICAL')
      CALL FFKEY ('ELONLY', ELONLY , 1, 'LOGICAL')

C--- Initialize some variables

      UUPS(1) = -999.
      DDPS(1) = -999.
      SSPS(1) = -999.
      UUV (1) = -999.
      DDV (1) = -999.
      SSV (1) = -999.

C-- Default decay tables

      TDECQQ = 'DECAY.DEC'
      LUTTAB = 'LDECAY.TAB'

C==  Convert logical names.

      CALL GFUFNM( TDECQQ, FDECQQ, CRNAME)
      CALL GFUFNM( LUTTAB, LUDTAB, CRNAME)


      NEWDET = ' '
      NEWDEC = ' '
      FTAPQQ = ' '


      CALL VBLANK(DEFDEC,20)
      CALL VBLANK(UDECAY,20)
      CALL VBLANK(LUNDTB,20)
      CALL VBLANK(TAPOUT,20)
      CALL VBLANK(LSINGL,3)
      CALL VBLANK(LRESON,3)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C     Get unit numbers -- Eliminate 10-9-93 (PA)
CPA      CALL DVLUNS(LTTIQQ, LTTOQQ, LOUTQQ, LTMPQQ, LTINQQ, LTOUQQ)

C-- Read in any changes to the control variables via FFREAD

C-- Get name of input file
5090  WRITE(LTTOQQ,5003)

#if defined(CLEO_VAX)||defined(CLEO_SGI)||defined(CLEO_DECS)
5003  FORMAT(' Enter name of QQ control file: ',$)
#endif
#if defined(CLEO_IBM)||defined(CLEO_RS6000)||defined(CLEO_HPUX)
5003  FORMAT(' Enter name of QQ control file: ')
#endif

      READ(LTTIQQ,4003) FCTLQQ
4003  FORMAT(A)

#if defined(CLEO_VAX)
      OPEN(UNIT=LTMPQQ, FILE=FCTLQQ,STATUS='OLD',READONLY,SHARED)
#endif
#if defined(CLEO_UNIX)
      CALL TRNFNM(FCTLQQ, EQNAME)
      OPEN(UNIT=LTMPQQ, FILE=EQNAME, STATUS='OLD')
#endif
#if defined(CLEO_IBM)
      OPEN(UNIT=LTMPQQ, FILE=FCTLQQ, STATUS='OLD')
#endif

C                                    Read in the parameters
      CALL FFSET('LINP',LTMPQQ)
      CALL FFGO

C------------------------- Version number is read from CMZ via QQLBVR
C      WRITE(LTTOQQ,5048)
C5048  FORMAT(' QQ',T11,'Vers-8.08',T21,'25-Jun-91',T31,'Avery',
C     *  T41,'MC Event generator')
C
      CALL QQLBVR
C-------------------------------------------------------------------
      WRITE(LTTOQQ,5004)
      WRITE(LTTOQQ,5004)FCTLQQ
5004  FORMAT(:,' Input file ',A)


      CALL UHTOC(DEFDEC,4,TDECQQ,80)
      IF(TDECQQ.NE.' ') THEN
#if defined(CLEO_VAX)||defined(CLEO_IBM)
         FDECQQ = TDECQQ
#endif
#if defined(CLEO_UNIX)
         CALL TRNFNM(TDECQQ, FDECQQ)
#endif
      ENDIF

      CALL UHTOC(LUNDTB,4,LUTTAB,80)
      IF(LUTTAB.NE.' ') THEN
#if defined(CLEO_VAX)||defined(CLEO_IBM)
         LUDTAB = LUTTAB
#endif
#if defined(CLEO_UNIX)
         CALL TRNFNM(LUTTAB, LUDTAB)
#endif
      ENDIF

C---  IF LPROMP=.TRUE., the user wanted to type in UDECAY=NEWDET.

      IF(LPROMP) THEN
        WRITE(LTTOQQ,5005)
#if defined(CLEO_VAX)||defined(CLEO_SGI)||defined(CLEO_DECS)
5005    FORMAT(' Enter name of UDECAY file: ',$)
#endif
#if defined(CLEO_IBM)||defined(CLEO_RS6000)||defined(CLEO_HPUX)
5005    FORMAT(' Enter name of UDECAY file: ')
#endif
        READ(LTTIQQ,5006) NEWDET
5006    FORMAT(A)
      ELSE
        CALL UHTOC(UDECAY,4,NEWDET,80)
      ENDIF

      IF(NEWDET.NE.' ') THEN
#if defined(CLEO_VAX)||defined(CLEO_IBM)
         NEWDEC = NEWDET
#endif
#if defined(CLEO_UNIX)
         CALL TRNFNM(NEWDET, NEWDEC)
#endif
      ENDIF

      CALL UHTOC(TAPOUT,4,FTAPQQ,80)
      CALL UHTOC(LSINGL,4,CSINGL,10)
      CALL UHTOC(LRESON,4,CRESON,10)

      IF(UUPS(1).NE.-999.) THEN
        DO 200 I=1,3
 200    CMIX1(I,1) = UUPS(I)
      ENDIF

      IF(DDPS(1).NE.-999.) THEN
        DO 201 I=1,3
 201    CMIX1(I,2) = DDPS(I)
      ENDIF

      IF(SSPS(1).NE.-999.) THEN
        DO 202 I=1,3
 202    CMIX1(I,3) = SSPS(I)
      ENDIF

      IF(UUV(1).NE.-999.) THEN
        DO 203 I=1,3
 203    CMIX1(I,4) = UUV(I)
      ENDIF

      IF(DDV(1).NE.-999.) THEN
        DO 204 I=1,3
 204    CMIX1(I,5) = DDV(I)
      ENDIF

      IF(SSV(1).NE.-999.) THEN
        DO 205 I=1,3
 205    CMIX1(I,6) = SSV(I)
      ENDIF

C-- Convert angles for single particle generation

      STHET(1) = STHET(1)*3.141592/180.0
      STHET(2) = STHET(2)*3.141592/180.0
      SPHI(1)  = SPHI(1) *3.141592/180.0
      SPHI(2)  = SPHI(2) *3.141592/180.0


C-- If LTRKSM is set and the user forgot LONGLF, Turn it on.

      IF(LTRKSM) THEN
        WRITE(LTTOQQ,9001)
        IF(LTSMP0) THEN
          WRITE(LTTOQQ,9011)
        ELSE
          WRITE(LTTOQQ,9012)
        ENDIF
        IF(LTSMVF) THEN
          WRITE(LTTOQQ,9021)
        ELSE
          WRITE(LTTOQQ,9022)
        ENDIF
        IF(LTSMEI) THEN
          WRITE(LTTOQQ,9031)
        ELSE
          WRITE(LTTOQQ,9032)
        ENDIF
        IF(.NOT.LONGLF) THEN
         WRITE(LTTOQQ,9002)
         WRITE(LTTOQQ,9003)
         LONGLF = .TRUE.
        ENDIF

C variation of track recon efficiency by +1,-1,0 sigmas.
        IF(ITRMTV.NE.0) CALL TRMTRV(ITRMTV)

      ENDIF

9001    FORMAT(2X, ' TRKSIM/GLBFIL is being called. ')
9011    FORMAT(2X, '    GTPIR  is on  (pi0 bank) ')
9012    FORMAT(2X, '    GTPIR  is off (pi0 bank) ')
9021    FORMAT(2X, '    VFINDR is on  (secondary vertices) ')
 9022   FORMAT(2X, '    VFINDR is off (secondary vertices) ')
9031    FORMAT(2X, '    GETEID is on  (electron id.) ')
9032    FORMAT(2X, '    GETEID is off  (electron id.) ')

9002    FORMAT(2X,' But you forgot to decay long-lived particles')
9003    FORMAT(2X,'   QQ/TRKSIM is doing it for you... '         )

C     Normal exit
      LERROR = .FALSE.
      RETURN

C     Error exit
CCC9999  RETURN
      END

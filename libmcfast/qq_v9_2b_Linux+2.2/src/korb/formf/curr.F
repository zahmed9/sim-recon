*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:27  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:05  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/06 30/01/94  16.22.55  by  Alan J. Weinstein
*AJWMOD add complex AMPL's from Vasia.
*CMZ :  2.00/00 21/01/93  15.42.59  by  Alan Weinstein
*AJWMOD Major mods for rho-pi-pi
*CMZ :  2.00/00 21/01/93  15.42.59  by  Alan Weinstein
*-- Author :
      SUBROUTINE CURR(MNUM,PIM1,PIM2,PIM3,PIM4,HADCUR)
C     ==================================================================
C     hadronic current for 4 pi final state
C     R. Fisher, J. Wess and F. Wagner Z. Phys C3 (1980) 313
C     R. Decker Z. Phys C36 (1987) 487.
C     M. Gell-Mann, D. Sharp, W. Wagner Phys. Rev. Lett 8 (1962) 261.
C     ==================================================================
 
      COMMON / PARMAS / AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      REAL*4            AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
      COMMON / DECPAR / GFERMI,GV,GA,CCABIB,SCABIB,GAMEL
      REAL*4            GFERMI,GV,GA,CCABIB,SCABIB,GAMEL
      COMMON / ADDMAS / PMAS(18),PWID(18),PPRB(2,20)                    AJWMOD
      REAL              PMAS,    PWID,    PPRB                          AJWMOD
C ARBITRARY FIXING OF THE FOUR PI X-SECTION NORMALIZATION
      COMMON /ARBIT/ ARFLAT,AROMEG
      REAL  PIM1(4),PIM2(4),PIM3(4),PIM4(4),PAA(4)
      COMPLEX HADCUR(4),FORM1,FORM2,FORM3,WIGFOR,FPIKM,FPIKMD
      COMPLEX AMPL(7)
      COMPLEX BWIGN
      REAL PA(4),PB(4)
      REAL AA(4,4),PP(4,4)
      DATA PI /3.141592653589793238462643/
      DATA  FPI /93.3E-3/
      BWIGN(A,XM,XG)=1.0/CMPLX(A-XM**2,XM*XG)
C
C --- masses and constants
      IF (G1.EQ.12.924) GOTO 1
      G1=12.924
      G2=1475.98
      G =G1*G2
      ELPHA=-.1
      AMROP=1.7
      GAMROP=0.26
      AMOM=.782
      GAMOM=0.0085
      ARFLAT=1.0
      AROMEG=1.0
C
      FRO=0.266*AMRO**2
      COEF1=2.0*SQRT(3.0)/FPI**2*ARFLAT
      COEF2=FRO*G*AROMEG
C
      ELPHA = -.145                                                     AJWMOD
      AMROP = PMAS(11)                                                  AJWMOD
      GAMROP= PWID(11)                                                  AJWMOD
      AMOM  = PMAS(18)                                                  AJWMOD
      GAMOM = PWID(18)                                                  AJWMOD
C
C Amplitudes for (pi-pi-pi0pi+) -> PS, rho0, rho-, rho+, omega.
C From vasia, 1/94.
      AMPL(1) = CMPLX(PPRB(1,1)*COEF1)
      AMPL(2) = CMPLX(PPRB(1,2)*COEF1*0.7071)
     $         *CMPLX(SQRT(0.1281/0.3315),0.0)*CEXP(CMPLX(0.0,-0.4385))
      AMPL(3) = CMPLX(PPRB(1,3)*COEF1*0.7071)
     $         *CMPLX(SQRT(0.25/0.328),0.0)*CEXP(CMPLX(0.0,0.0))
      AMPL(4) = -CMPLX(PPRB(1,4)*COEF1)
     $         *CMPLX(SQRT(0.23/0.0929),0.0)*CEXP(CMPLX(0.0,-1.130))
      AMPL(5) = CMPLX(PPRB(1,5)*COEF2)
     $         *CMPLX(SQRT(0.1721/0.165),0.0)*CEXP(CMPLX(0.0,-2.279))
C Amplitudes for (pi0pi0pi0pi-) -> PS, rho-.
      AMPL(6) = CMPLX(PPRB(1,6)*COEF1)
      AMPL(7) = CMPLX(PPRB(1,7)*COEF1)
 1    CONTINUE
C
C --- initialization of four vectors
      DO 7 K=1,4
      DO 8 L=1,4
 8    AA(K,L)=0.0
      HADCUR(K)=CMPLX(0.0)
      PAA(K)=PIM1(K)+PIM2(K)+PIM3(K)+PIM4(K)
      PP(1,K)=PIM1(K)
      PP(2,K)=PIM2(K)
      PP(3,K)=PIM3(K)
 7    PP(4,K)=PIM4(K)
C
      IF (MNUM.EQ.1) THEN
C ===================================================================
C pi- pi- p0 pi+ case                                            ====
C ===================================================================
       QQ=PAA(4)**2-PAA(3)**2-PAA(2)**2-PAA(1)**2
CAJWMOD begin modified section:
C --- loop over five contribution of the rho-pi-pi
       DO 201 K1=1,3
       DO 201 K2=3,4
C
         IF (K2.EQ.K1) THEN
           GOTO 201
         ELSEIF (K2.EQ.3) THEN
C rho-
           IRO = 3
         ELSEIF (K1.EQ.3) THEN
C rho+
           IRO = 4
         ELSE
C rho0
           IRO = 2
         END IF
C
         SK=(PP(K1,4)+PP(K2,4))**2-(PP(K1,3)+PP(K2,3))**2
     $     -(PP(K1,2)+PP(K2,2))**2-(PP(K1,1)+PP(K2,1))**2
C -- definition of AA matrix
C -- cronecker delta
        DO 202 I=1,4
         DO 203 J=1,4
 203     AA(I,J)=0.0
 202    AA(I,I)=1.0
C ... and the rest ...
        DO 204 L=1,4
         IF (L.NE.K1.AND.L.NE.K2) THEN
          DENOM=(PAA(4)-PP(L,4))**2-(PAA(3)-PP(L,3))**2
     $         -(PAA(2)-PP(L,2))**2-(PAA(1)-PP(L,1))**2
          DO 205 I=1,4
          DO 205 J=1,4
                      SIG= 1.0
           IF(J.NE.4) SIG=-SIG
           AA(I,J)=AA(I,J)
     $            -SIG*(PAA(I)-2.0*PP(L,I))*(PAA(J)-PP(L,J))/DENOM
 205      CONTINUE
         ENDIF
 204    CONTINUE
C
C --- let's add something to HADCURR
C        FORM1= FPIKM(SQRT(SK),AMPI,AMPI) *FPIKM(SQRT(QQ),AMPI,AMPI)
         FORM1= AMPL(1)+AMPL(IRO)*FPIKM(SQRT(SK),AMPI,AMPI)
C
       DO 206 I=1,4
       DO 206 J=1,4
        HADCUR(I)=HADCUR(I)+FORM1*AA(I,J)*(PP(K1,J)-PP(K2,J))
 206   CONTINUE
C --- end of the rho-pi-pi current (5 possibilities)
 201   CONTINUE
C
C Now modify the coefficient for the omega-pi current:
       IF (AMPL(5).EQ.CMPLX(0.,0.)) GOTO 311
       FORM2=AMPL(5)*(BWIGN(QQ,AMRO,GAMRO)+ELPHA*BWIGN(QQ,AMROP,GAMROP))
C
CAJWMOD don't compile old version of section:
#if defined(CLEO_OLDCODE)
C
C --- loop over thre contribution of the non-omega current
       DO 201 K=1,3
        SK=(PP(K,4)+PIM4(4))**2-(PP(K,3)+PIM4(3))**2
     $    -(PP(K,2)+PIM4(2))**2-(PP(K,1)+PIM4(1))**2
C -- definition of AA matrix
C -- cronecker delta
        DO 202 I=1,4
         DO 203 J=1,4
 203     AA(I,J)=0.0
 202    AA(I,I)=1.0
C ... and the rest ...
        DO 204 L=1,3
         IF (L.NE.K) THEN
          DENOM=(PAA(4)-PP(L,4))**2-(PAA(3)-PP(L,3))**2
     $         -(PAA(2)-PP(L,2))**2-(PAA(1)-PP(L,1))**2
          DO 205 I=1,4
          DO 205 J=1,4
                      SIG= 1.0
           IF(J.NE.4) SIG=-SIG
           AA(I,J)=AA(I,J)
     $            -SIG*(PAA(I)-2.0*PP(L,I))*(PAA(J)-PP(L,J))/DENOM
 205      CONTINUE
         ENDIF
 204    CONTINUE
C --- let's add something to HADCURR
       FORM1= FPIKM(SQRT(SK),AMPI,AMPI) *FPIKM(SQRT(QQ),AMPI,AMPI)
C       FORM1= FPIKM(SQRT(SK),AMPI,AMPI) *FPIKMD(SQRT(QQ),AMPI,AMPI)
CCCCCCCCCCCCCCCCC       FORM1=WIGFOR(SK,AMRO,GAMRO)      (tests)
C
       FIX=1.0
       IF (K.EQ.3) FIX=-2.0
       DO 206 I=1,4
       DO 206 J=1,4
        HADCUR(I)=
     $  HADCUR(I)+CMPLX(FIX*COEF1)*FORM1*AA(I,J)*(PP(K,J)-PP(4,J))
 206   CONTINUE
C --- end of the non omega current (3 possibilities)
 201   CONTINUE
C
CAJWMOD resume compiling
#endif
CAJWMOD end modified section.
C
C --- there are two possibilities for omega current
C --- PA PB are corresponding first and second pi-'s
       DO 301 KK=1,2
        DO 302 I=1,4
         PA(I)=PP(KK,I)
         PB(I)=PP(3-KK,I)
 302    CONTINUE
C --- lorentz invariants
         QQA=0.0
         SS23=0.0
         SS24=0.0
         SS34=0.0
         QP1P2=0.0
         QP1P3=0.0
         QP1P4=0.0
         P1P2 =0.0
         P1P3 =0.0
         P1P4 =0.0
        DO 303 K=1,4
                     SIGN=-1.0
         IF (K.EQ.4) SIGN= 1.0
         QQA=QQA+SIGN*(PAA(K)-PA(K))**2
         SS23=SS23+SIGN*(PB(K)  +PIM3(K))**2
         SS24=SS24+SIGN*(PB(K)  +PIM4(K))**2
         SS34=SS34+SIGN*(PIM3(K)+PIM4(K))**2
         QP1P2=QP1P2+SIGN*(PAA(K)-PA(K))*PB(K)
         QP1P3=QP1P3+SIGN*(PAA(K)-PA(K))*PIM3(K)
         QP1P4=QP1P4+SIGN*(PAA(K)-PA(K))*PIM4(K)
         P1P2=P1P2+SIGN*PA(K)*PB(K)
         P1P3=P1P3+SIGN*PA(K)*PIM3(K)
         P1P4=P1P4+SIGN*PA(K)*PIM4(K)
 303    CONTINUE
C
CAJWMOD       FORM2=COEF2*(BWIGN(QQ,AMRO,GAMRO)+ELPHA*BWIGN(QQ,AMROP,GAMROP))
C        FORM3=BWIGN(QQA,AMOM,GAMOM)*(BWIGN(SS23,AMRO,GAMRO)+
C     $        BWIGN(SS24,AMRO,GAMRO)+BWIGN(SS34,AMRO,GAMRO))
        FORM3=BWIGN(QQA,AMOM,GAMOM)
C
        DO 304 K=1,4
         HADCUR(K)=HADCUR(K)+FORM2*FORM3*(
     $             PB  (K)*(QP1P3*P1P4-QP1P4*P1P3)
     $            +PIM3(K)*(QP1P4*P1P2-QP1P2*P1P4)
     $            +PIM4(K)*(QP1P2*P1P3-QP1P3*P1P2) )
 304    CONTINUE
 301   CONTINUE
 311   CONTINUE
C
      ELSE
C ===================================================================
C pi0 pi0 p0 pi- case                                            ====
C ===================================================================
       QQ=PAA(4)**2-PAA(3)**2-PAA(2)**2-PAA(1)**2
       DO 101 K=1,3
C --- loop over thre contribution of the non-omega current
        SK=(PP(K,4)+PIM4(4))**2-(PP(K,3)+PIM4(3))**2
     $    -(PP(K,2)+PIM4(2))**2-(PP(K,1)+PIM4(1))**2
C -- definition of AA matrix
C -- cronecker delta
        DO 102 I=1,4
         DO 103 J=1,4
 103     AA(I,J)=0.0
 102    AA(I,I)=1.0
C
C ... and the rest ...
        DO 104 L=1,3
         IF (L.NE.K) THEN
          DENOM=(PAA(4)-PP(L,4))**2-(PAA(3)-PP(L,3))**2
     $         -(PAA(2)-PP(L,2))**2-(PAA(1)-PP(L,1))**2
          DO 105 I=1,4
          DO 105 J=1,4
                      SIG=1.0
           IF(J.NE.4) SIG=-SIG
           AA(I,J)=AA(I,J)
     $            -SIG*(PAA(I)-2.0*PP(L,I))*(PAA(J)-PP(L,J))/DENOM
 105      CONTINUE
         ENDIF
 104    CONTINUE
C --- let's add something to HADCURR
C       FORM1= FPIKM(SQRT(SK),AMPI,AMPI) *FPIKMD(SQRT(QQ),AMPI,AMPI)
CCCCCCCCCCCCC       FORM1=WIGFOR(SK,AMRO,GAMRO)        (tests)
C       FORM1= FPIKM(SQRT(SK),AMPI,AMPI) *FPIKM(SQRT(QQ),AMPI,AMPI)
C AJWMOD:
       FORM1 = AMPL(6)+AMPL(7)*FPIKM(SQRT(SK),AMPI,AMPI)
C End AJWMOD
        DO 106 I=1,4
        DO 106 J=1,4
         HADCUR(I)=HADCUR(I)+FORM1*AA(I,J)*(PP(K,J)-PP(4,J))
 106    CONTINUE
C --- end of the non omega current (3 possibilities)
 101   CONTINUE
      ENDIF
      END
 

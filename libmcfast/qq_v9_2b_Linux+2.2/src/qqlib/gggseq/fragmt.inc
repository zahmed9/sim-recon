*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:37  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:35  zfiles
* first version of qqlib in CVS
*
*
*CMZ :  1.03/16 25/04/91  18.23.44  by  R.A.FULTON
*-- Author :    R.A.FULTON   04/12/90
#if defined(CLEO_CDGDOC)
C********************************************************
C          DOFRAG = DO EVENT FRAGMENTATION (I.E. LET LUND DO DECAY
C      REMAINING PARAMETERS REFER TO MODE2G=5
C          F2TYPE     = F2=ALPHA,= ALPHA*Q, = ALPHA*Q**2, = QPM
C          NORAMP    = TURN OFF RAMPING OF LUND PARAMETERS
C*********************************************************
#endif
      INTEGER   F2TYPE
      REAL      EXPSL, SIG0, PTBRK, PTSLPE, X2G0, X2G1
      LOGICAL   DOFRAG, NORAMP, TARGMS, LUMTL, GVDM, RHOPOL

      COMMON/FRAGMT/DOFRAG,F2TYPE,NORAMP,
     +               TARGMS,LUMTL, GVDM, RHOPOL,
     +               EXPSL, SIG0, PTBRK, PTSLPE,X2G0, X2G1

       SAVE /FRAGMT/

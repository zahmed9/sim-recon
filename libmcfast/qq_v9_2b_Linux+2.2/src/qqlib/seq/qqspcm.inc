*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:50  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:33  zfiles
* first version of qqlib in CVS
*
*
*CMZ :  1.04/00 21/09/94  22.58.11  by  Paul Avery
*-- Author :    Lynn Garren   06/12/93
* 16/10/96 Lynn Garren:  Add double precision conditionals.
*
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*                       QQSPCM.INC
*
*      LOCAL VARIABLES THAT ARE USED IN  SUBROUTINE  SPECTR
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION P2QRK, EMB, EMBQ, EMNU, EMCL, EMCQ, PBAR, EBEAM
#else
      REAL P2QRK, EMB, EMBQ, EMNU, EMCL, EMCQ, PBAR, EBEAM
#endif
      COMMON /SPECOM/P2QRK(4,4),EMB,EMBQ,EMNU,EMCL,EMCQ,PBAR,EBEAM

C---------------------------------------------------------------------

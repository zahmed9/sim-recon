*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:22  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/04/05  21:38:30  lkg
* Beta version of GEANT using CLEO CVS system
*
*
*
* cgcaan.inc
*
#if !defined(CLEO_SINGLE)
      DOUBLE PRECISION RAD,COSI,SINI,COSDA(2),SINDA(2),XYHA(4,2)
      INTEGER          NASTP(2)
      COMMON /CGCAAN/  RAD,COSI,SINI,COSDA,SINDA,XYHA,NASTP
     +                ,IFULL,ATREDG
#endif
#if defined(CLEO_SINGLE)
      REAL             COSDA(2),SINDA(2),XYHA(4,2)
      INTEGER          NASTP(2)
      COMMON /CGCAAN/  RAD,COSI,SINI,COSDA,SINDA,XYHA,NASTP
     +                ,IFULL,ATREDG
#endif

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
*
* lujetx.inc
*

      INTEGER   NJS, KJS
#if defined(NONCLEO_DOUBLE)
      double precision PJS, VJS
#else
      REAL      PJS, VJS
#endif
      COMMON/LUJETX/PJS(4000,5),VJS(4000,5),NJS,KJS(4000,5)
      SAVE /LUJETX/



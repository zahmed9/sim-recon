*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:10  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  17:59:30  nk
* Consolidation
*
* Revision 1.1.1.1  1994/10/04 21:54:49  zfiles
* first version of clutil in CVS
*
*
*
* meslun.inc
*
*
* MESLIN - LUN for standard input
* MESLOU - LUN for standard output
* MESLER - LUN for standard error
* MESLEC - LUN for echo
* MESLPT - LUN for driver printer output
*
      INTEGER         MESLIN, MESLOU, MESLER, MESLEC, MESLPT
      COMMON /MESLUN/ MESLIN, MESLOU, MESLER, MESLEC, MESLPT
*

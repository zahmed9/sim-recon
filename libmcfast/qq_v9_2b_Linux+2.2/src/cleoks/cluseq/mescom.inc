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
* mescom.inc
*
*
* MSINIT - Set to MSFLAG if initialization completes successfully
* MSCLOG - Set to .TRUE. if messages can be logged (header bank exists)
* MSFLAG - A flag value
*
      INTEGER    MSFLAG, MSINIT
      PARAMETER( MSFLAG = 12344321 )
*
      LOGICAL    MSCLOG
*
      COMMON /MESCOM/ MSINIT, MSCLOG

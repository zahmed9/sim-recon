*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:52  eugenio
* Initial revision
*
* Revision 1.2  1994/10/07  23:58:36  zfiles
* Include qqxxxx.inc
*
*
*CMZ :  1.02/61 05/10/94  02.20.51  by  Peter Kim
*CMZ :  1.02/48 28/02/94  16.13.40  by  Karen Lingel, Physicist
*CMZ :  1.02/40 27/09/93  14.52.40  by  Karen Lingel, Physicist
*CMZ :  1.02/31 27/01/93  17.50.06  by  Karen Lingel
*CMZ :  1.02/29 01/12/92  21.48.58  by  Nobu Katayama
*CMZ :  1.02/23 03/08/92  16.52.46  by  Karen Lingel
*CMZ :  1.02/20 25/05/92  22.06.01  by  Karen Lingel
*CMZ :  1.02/19 18/05/92  15.23.32  by  Karen Lingel
*CMZ :  1.02/00 25/07/91  13.51.44  by  Peter C Kim
*CMZ :  1.01/98 11/06/91  15.18.06  by  Karen Lingel, Physicist
*CMZ :  1.01/86 28/02/91  17.46.37  by  Karen Lingel, Physicist
*CMZ :  1.01/85 26/02/91  12.55.27  by  Paul Avery
*CMZ :  1.01/62 16/09/90  16.12.50  by  Paul Avery
*CMZ :          19/05/90  13.53.08  by  Jorge L. Rodriguez
*>> Author :
*
*  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*                         MCCOMS.INC
*
*   Contains track, vertex and event information about QQ. This file is
*   essentially the same as before except that the variables have been
*   reorganized into different files. User code should not change except
*   for a recompile.
*
*   Rearranged and split into many QQ* sequencses   9/94  PRA
*
*        MCCOMS  <==  //seq/clinc/qq*
*  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*
#include "seq/clinc/qqevnt.inc"
#include "seq/clinc/qqtrak.inc"
#include "seq/clinc/qqvrtx.inc"
#include "seq/clinc/qqbfld.inc"
#include "seq/clinc/qqipcd.inc"
#include "seq/clinc/qqipft.inc"
#include "seq/clinc/qqbmst.inc"
#include "seq/clinc/qqinfo.inc"
#include "seq/clinc/qqfile.inc"

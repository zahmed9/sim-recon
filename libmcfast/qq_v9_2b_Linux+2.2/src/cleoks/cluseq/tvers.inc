*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:10  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  17:59:32  nk
* Consolidation
*
* Revision 1.1.1.1  1994/10/04 21:54:49  zfiles
* first version of clutil in CVS
*
*
*
* tvers.inc
*
#if defined(CLEO_VAX)
C.          This is the VAX(VMS) version.
#endif
#if defined(CLEO_VMCMS)
C.          This is the IBM(VM/CMS) version.
#endif
#if defined(CLEO_APOLLO)
C.          This is the APOLLO/DOMAIN version.
#endif
#if defined(CLEO_UNIX)
C.          This is the UNIX/BSD 4.3 version
#endif

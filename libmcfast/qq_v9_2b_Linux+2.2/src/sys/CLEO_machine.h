* Urheim - modify for ibm rs6000.
*
* CLEO_machine.h for ultrix.
* (Fortran style comments)
*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:52  eugenio
* Initial revision
*
* Revision 1.5  1995/11/29 18:26:55  zfiles
* Define CLEO_HUGM and CLEO_BIGM for AXP
*
* Revision 1.4  1994/12/10  03:18:18  zfiles
* Remove double quotes around CLEO_DEFS for makedepend
*
* Revision 1.3  1994/06/08  18:48:46  nk
* Added CLEO_VMS flag
*
* Revision 1.2  1994/06/08  18:33:45  nk
* Changed comment leader. Added Id and Log
*
*
#if defined(vax)
#define CLEO_VAX
#define CLEO_VMS
#endif

#if !defined(CLEO_VAX)

#if defined(unix) || defined(__unix__)
#define CLEO_UNIX
#endif

#if defined(ultrix)
#define CLEO_ULTRIX
#define CLEO_DECS
#define CLEO_DEC
#endif

#if defined(mips)
#define CLEO_MIPS
#endif

#if defined(__osf__) && defined(__alpha)
#define CLEO_AXPOSF
#define CLEO_DECS
#define CLEO_DEC
#endif

#if defined(__sgi)
#define CLEO_SGI
#define CLEO_BIGENDIAN
#endif

#if defined(_AIX) || defined (AIX)
#ifndef unix
#define unix
#endif
#ifndef CLEO_UNIX
#define CLEO_UNIX
#endif
#ifndef CLEO_RS6000
#define CLEO_RS6000
#endif
#ifndef CLEO_IBMRT
#define CLEO_IBMRT
#endif
#ifndef CLEO_BIGENDIAN
#define CLEO_BIGENDIAN
#endif
#endif

#if defined(sun)
#define CLEO_SunOS
#define CLEO_BIGENDIAN
#define CLEO_BIGM
#endif

#if defined(hpux)
#define CLEO_HPUX
#define CLEO_BIGENDIAN
#define CLEO_BIGM
#endif

#if defined(__linux)
#ifndef CLEO_UNIX
#define CLEO_UNIX
#endif
#define CLEO_LINUX
#define CLEO_BIGM
#endif

#if defined(CLEO_SGI) || defined(CLEO_DECS) 
#define CLEO_BIGM
#endif

#if defined(__osf__) && defined(__alpha)
#define CLEO_BIGM
#define CLEO_HUGM
#endif
#endif /* CLEO_VAX */

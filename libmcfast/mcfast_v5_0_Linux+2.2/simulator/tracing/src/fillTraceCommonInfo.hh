#ifndef TRACING_FILLTRACECOMMONINFO_H
#define TRACING_FILLTRACECOMMONINFO_H

#include "MCParticle.hh"

// forward declarations

// prototype
MCFBool fillTraceCommonInfo( const MCParticle& particle );


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:34  eugenio
// Initial revision
//
// Revision 1.5  1998/11/20 23:48:12  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.4  1998/11/03  17:43:40  mkl
// changes to compile under egcs
//
// Revision 1.3  1998/07/07  16:30:36  yarba_j
// updated so that integrated tracing routine can be called from fortran usr_before_trigger, with loop over particles be in usr_before_trigger
//
// Revision 1.2  1997/08/01  20:56:35  mkl
// forward declare stl containers
//
// Revision 1.1.1.1  1997/03/14  22:52:34  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//


#endif

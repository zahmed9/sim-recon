// -*- C++ -*-
//
// Package:     Tracing
// Module:      Report
// 
// Description: Report facility
//
// Implimentation:
//
// Author:      Martin Lohner
// Created:     

// system include files
#include <iostream.h>
#include <fstream.h>
#include <string.h>

// user include files
#include "cc_fortran_types.hh"
#include "report.hh"

//
// constants, enums and typedefs
//
// set the debug level for the "report" message facility
// make it global variable to allow setting at run-time in gdb!
// static const Severity kDebugLevel=DEBUG; 
Severity kDebugLevel=DEBUG; 


ostream& report( Severity severity ,
		 const char* kFacility,
		 ostream& out )
{
   if ( severity > kDebugLevel ) {
      static ofstream dev_null;
      static MCFBool first=true;
      if( true == first ) {
	 dev_null.open( "/dev/null", ios::out );
	 first=false;
      }
      return dev_null;
   }

   if ( severity < WARNING ) {
      if( 0 != strcmp( kFacility, "" ) ) cerr << kFacility << ": " ;
      return cerr;
   }

   if( 0 != strcmp( kFacility, "" ) ) out << kFacility << ": " ;
   return out ;
}


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:34  eugenio
// Initial revision
//
// Revision 1.4  1998/11/20 23:48:13  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.3  1997/11/12  07:49:13  mkl
// major bug fixes (mostly reverse_iterator specific) -- now good agreement with fortran tracing found number of tracks
//
// Revision 1.2  1997/11/11  01:17:51  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.1  1997/07/03  03:34:02  mkl
// new approach: surfaces vs volumes; box tracing
//
//



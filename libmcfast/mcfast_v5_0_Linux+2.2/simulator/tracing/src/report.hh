#if !defined(TRACING_REPORT_H)
#define TRACING_REPORT_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      Report
// 
// Description: report facility
//
// Usage:
//
// Author:      Martin Lohner
// Created:     

// system include files
#include <iostream.h>

// user include files

// forward declarations

//
// constants, enums and typedefs
//
enum Severity {
   EMERGENCY,		// fatal
   ALERT,		// requires immediate action
   CRITICAL,		// serious
   ERROR,
   WARNING,
   NOTICE,		// "normal but significant"
   INFO,		// informational
   DEBUG		// debug
};

// function declaration
ostream& report( Severity severity, 
		 const char* kFacility = "", 
		 ostream& out = cout ) ;

// inline function definitions



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:34  eugenio
// Initial revision
//
// Revision 1.2  1997/11/11 01:17:52  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.1  1997/07/03  03:34:03  mkl
// new approach: surfaces vs volumes; box tracing
//
//


#endif /* TRACING_REPORT_H */

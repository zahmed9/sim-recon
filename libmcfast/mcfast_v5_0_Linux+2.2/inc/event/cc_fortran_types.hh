#if !defined(CC_FORTRAN_TYPES_HH)
#define CC_FORTRAN_TYPES_HH

// -*- C++ -*-
//
// Package:     TRACING
// Module:      cc_fortran_types
// 
// Description: 1.) Types needed for machine independent 
//                  Fortran-C-C++ Interfacing
//              2.) Various other types
// Usage:
//
// Author:      Martin Lohner
// Created:     Jan 14, 1997
// RCS(Id)
//
// Revision history
//
// RCS(Log)

// system include files

// user include files


// make sure the following are machine-independent (for Fortran implementation)
typedef int Integer;
typedef int integer;
//typedef unsigned int Logical; 
//typedef unsigned int logical; 
typedef int Logical; 
typedef int logical; 
typedef float Real;
typedef float real;
typedef double DFLOAT;

// other types
typedef bool MCFBool;



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:58:36  eugenio
// Initial revision
//
// Revision 1.2  1998/11/20 23:40:13  mkl
// changed Boolean to MCFBool to avoid clashes with other typedef-ed bool types (e.g. Inventor)
//
// Revision 1.1  1997/03/15  19:06:59  mkl
// moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
// fixed rcs comment headers from # to c.
// used cvs admin -c to change default rcs comment headers for .inc files.
//
//


#endif /* CC_FORTRAN_TYPES_HH */

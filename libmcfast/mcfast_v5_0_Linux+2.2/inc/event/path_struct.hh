#ifndef TRACING_PATH_STRUCT_HH
#define TRACING_PATH_STRUCT_HH

//   Path information for a particle

// AUTHOR: Martin Lohner
// PURPOSE: translation of path_struct.inc
// DATE: Mar 14, 1997

// -------------------------------------------------------------
// WARNING: if you change this file, also make sure you change 
//            path_struct.inc!
// -------------------------------------------------------------

#include "const.hh"
#include "cc_fortran_types.hh"

const Integer PATH_WORD = 3*FLOAT_WORD;

struct PathStruct {
      DFLOAT arc;     //!3-D arc length
      DFLOAT time;    //!Time since nominal crossing time
      DFLOAT tau;     //!Proper flight time
};



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:58:38  eugenio
// Initial revision
//
// Revision 1.4  1998/07/16 18:49:55  bphyslib
// sigh, it really is const.hh
//
// Revision 1.3  1998/07/15  16:44:10  garren
// rename const.hh to const.h
//
// Revision 1.2  1997/03/15  19:06:59  mkl
// moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
// fixed rcs comment headers from # to c.
// used cvs admin -c to change default rcs comment headers for .inc files.
//
// Revision 1.1  1997/03/14  22:50:37  mkl
// imported .hh files for equivalent .inc files for Martin Lohner's c++ tracing code
//


#endif /* TRACING_PATH_STRUCT_HH */

#ifndef TRACING_PLANE_STRUCT_HH
#define TRACING_PLANE_STRUCT_HH

//  Representation of plane using a point and a normal

// AUTHOR: Martin Lohner
// PURPOSE: translation of plane_struct.inc
// DATE: May 8, 1997

// -------------------------------------------------------------
// WARNING: if you change this file, also make sure you change 
//            path_struct.inc!
// -------------------------------------------------------------

#include "const.hh"
#include "cc_fortran_types.hh"

const int PLANE_WORD = 6*FLOAT_WORD;

struct PlaneStruct {
      DFLOAT xp[3];     //!Point on plane
      DFLOAT eta[3];    //!Direction cosines of normal
};

// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:58:39  eugenio
// Initial revision
//
// Revision 1.4  1998/11/01 04:25:33  mkl
// added 'const int' instead of just 'const'
//
// Revision 1.3  1998/07/16  18:49:56  bphyslib
// sigh, it really is const.hh
//
// Revision 1.2  1998/07/15  16:44:11  garren
// rename const.hh to const.h
//
// Revision 1.1  1997/05/09  06:35:25  mkl
// added plane_struct.hh to be used by plane tracing.
//
//

#endif /* TRACING_PLANE_STRUCT_HH */



#ifndef TRACING_WTRACK_STRUCT_HH
#define TRACING_WTRACK_STRUCT_HH

// Track parametrization in W form (4-momentum + position)

// AUTHOR: Martin Lohner
// PURPOSE: translation of wtrack_struct.inc
// DATE: Mar 14, 1997

// -------------------------------------------------------------
// WARNING: if you change this file, also make sure you change 
//            wtrack_struct.inc and wtrack_struct.h!
// -------------------------------------------------------------

#include "const.hh"
#include "cc_fortran_types.hh"

const integer WTRACK_WORD = 10*FLOAT_WORD;

struct WTrackStruct {

      // Constants to identify locations in W track covariance matrix
      enum { jwpx=1,
	     jwpy=2,
	     jwpz=3,
	     jwe=4,
	     jwx=5,
	     jwy=6,
	     jwz=7
      };


      DFLOAT px;      //!Px
      DFLOAT py;      //!Py
      DFLOAT pz;      //!Pz
      DFLOAT E;       //!E
      DFLOAT x;       //!x
      DFLOAT y;       //!y
      DFLOAT z;       //!z
      DFLOAT pt;      //!Pt = sqrt(px**2 + py**2)
      DFLOAT p;       //!Momentum
      DFLOAT q;       //!Charge
};

#if 0 // not needed
inline
Boolean 
operator!=( const WTrackStruct& lhs, const WTrackStruct& rhs ) 
{
   if( lhs.px != rhs.px ) return false;
   if( lhs.py != rhs.py ) return false;
   if( lhs.pz != rhs.pz ) return false;
   if( lhs.E  != rhs.E )  return false;
   if( lhs.x  != rhs.x )  return false;
   if( lhs.y  != rhs.y )  return false;
   if( lhs.z  != rhs.z )  return false;
   if( lhs.pt != rhs.pt ) return false;
   if( lhs.p  != rhs.p )  return false;
   if( lhs.q  != rhs.q )  return false;

   return true;
}
#endif




// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:58:38  eugenio
// Initial revision
//
// Revision 1.5  1998/09/15 04:30:51  kutschke
// Update comments.
//
// Revision 1.4  1998/07/16  18:49:55  bphyslib
// sigh, it really is const.hh
//
// Revision 1.3  1998/07/15  16:44:10  garren
// rename const.hh to const.h
//
// Revision 1.2  1997/03/15  19:07:01  mkl
// moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
// fixed rcs comment headers from # to c.
// used cvs admin -c to change default rcs comment headers for .inc files.
//
// Revision 1.1  1997/03/14  22:50:39  mkl
// imported .hh files for equivalent .inc files for Martin Lohner's c++ tracing code
//

#endif /* TRACING_WTRACK_STRUCT_HH */


#if !defined(TRACING_TRACETYPE_H)
#define TRACING_TRACETYPE_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      TraceType
// 
// Description: TraceType class
//
// Usage:
//
// Author:      Martin Lohner
// Created:     Jan 23, 1997
// RCS(Id)
//
// Revision history
//
// RCS(Log)

// system include files
#include <map>

// user include files
#include "cc_fortran_types.hh"
#include "mkl_trace_struct.hh"

// forward declarations
#if !defined(_TraceType_TraceTypeMap_)
#  define _TraceType_TraceTypeMap_ map< TraceType::Type, char*, less<TraceType::Type> >
#endif /* _TraceType_TraceTypeMap_ */

class TraceType
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // this definitiones come from "trace_types.inc"
      enum Type { kRPlane    =  1,  //!Radial plane
		  kZPlane    =  2,  //!Z plane
		  kCone      =  3,  //!Cone
		  kProd      =  4,  //!Production
		  kDecay     =  5,  //!Decay in flight
		  kPair      =  6,  //!Pair production
		  kAbsorb    =  7,  //!Absorption
		  kCalor     =  8,  //!Calorimeter face
		  kShower    =  9,  //!shower conversion point
		  kDummy     = 10,  //!Dummy point
		  // NOTE: up to here trace types are same as in old fortran code
		  //       beyond here I added my own
		  kFinal     = 11,  //!Dummy final point 
		                    // (different from decay etc.)
		  kMSEloss,         // material effects MS and Eloss at plane
		  kMSElossNOT,      // material effects, but not applied!
		  kBFieldBoundary   // bfield boundary recorded!
      };


      // Constructors and destructor
      TraceType( Type iType=kDummy );
//      TraceType( const TraceType& );      // need copy constructor for STL vector!
      ~TraceType();                   // non-virtual destructor!

      // assignment operators
//      const TraceType& operator=( const TraceType& ); // need = operator for STL vector!

      // member functions

      // const member functions

      Type type() const { return m_type; }

      // static member functions
      static const _TraceType_TraceTypeMap_* typeMap();
      static const char* type2Char( const int which );
      static const char* type2Char( const Type type );

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor

      // assignment operator(s)

      // private member functions
      void createTypeMap();

      // private const member functions

      // data members

      Type m_type;                    // trace type

      // static data members
      static _TraceType_TraceTypeMap_* m_typeMap;

};

// inline function definitions

inline
const _TraceType_TraceTypeMap_*
TraceType::typeMap()
{
   return m_typeMap;
}


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:33  eugenio
// Initial revision
//
// Revision 1.3  1998/11/03 17:43:34  mkl
// changes to compile under egcs
//
// Revision 1.2  1998/05/15  03:37:07  mkl
// inlined often-used functions to improve speed
//
// Revision 1.1  1998/02/16  21:30:09  mkl
// added new TraceType class that deals with trace types exclusively
//
//


#endif /* TRACING_TRACETYPE_H */

// -*- C++ -*-
//
// Package:     Tracing
// Module:      TraceType
// 
// Description: TraceType class containing trace info and more
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     Jan 23, 1997
// RCS(Id)
//
// Revision history
//
// RCS(Log)

// system include files
#include <assert.h>
#include <map>
#include <string.h>

// user include files
#include "report.hh"

#include "TraceType.hh"
#include "mkl_trace_struct.hh"

//#include "HitStruct.hh"

//
// constants, enums and typedefs
//
typedef _TraceType_TraceTypeMap_ TraceTypeMap;

static const char* const kFacilityString = "Tracing.Trace";

//
// static data member definitions
//
TraceTypeMap* TraceType::m_typeMap = 0;

//
// constructors and destructor
//
TraceType::TraceType( TraceType::Type iType )
   : m_type(iType)
{
   // only needs to be done once since static
   if ( 0 == m_typeMap ) {
      createTypeMap();
   }
}

//TraceType::TraceType( const TraceType& iTraceType )
//{
//}

TraceType::~TraceType()
{
}

//
// assignment operators
//
//const TraceType&
//TraceType::operator=( const TraceType& iTraceType )
//{
//   if( this != &iTraceType ) {
//   }
//   
//   return *this;
//}
//
// member functions
//
//
// const member functions
//
//
// static member functions
//
void 
TraceType::createTypeMap()
{
   m_typeMap = new map< Type, char*, less<Type> > ;

   (*m_typeMap).insert( pair< const Type, char* >
			  ( TraceType::kRPlane, "R-plane" ) ) ;
   (*m_typeMap).insert( pair< const Type, char* >
			  ( TraceType::kZPlane, "Z-plane" ) ) ;
   (*m_typeMap).insert( pair< const Type, char* >
			  ( TraceType::kCone,   "Cone" ) ) ;
   (*m_typeMap).insert( pair< const Type, char* >
			  ( TraceType::kProd, "Production" ) ) ;
   (*m_typeMap).insert( pair< const Type, char* >
			  ( TraceType::kDecay, "Decay-in-flight" ) ) ;
   (*m_typeMap).insert( pair< const Type, char* >
			  ( TraceType::kPair, "Pair-production" ) ) ;
   (*m_typeMap).insert( pair< const Type, char* >
			  ( TraceType::kAbsorb, "Absorption" ) ) ;
   (*m_typeMap).insert( pair< const Type, char* >
			  ( TraceType::kCalor, "Calorimeter-face" ) ) ;
   (*m_typeMap).insert( pair< const Type, char* >
			  ( TraceType::kShower, "shower-conversion-point" ) ) ;
   (*m_typeMap).insert( pair< const Type, char* >
			  ( TraceType::kDummy, "Dummy-point" ) ) ;
   (*m_typeMap).insert( pair< const Type, char* >
			  ( TraceType::kFinal, "Dummy-final-point" ) ) ;
   (*m_typeMap).insert( pair< const Type, char* >
			  ( TraceType::kMSEloss, "MS/Eloss" ) ) ;
   (*m_typeMap).insert( pair< const Type, char* >
			  ( TraceType::kMSElossNOT, "MS/Eloss-NOT" ) ) ;
   (*m_typeMap).insert( pair< const Type, char* >
			  ( TraceType::kBFieldBoundary, "Bfield-boundary" ) ) ;
}

const char* 
TraceType::type2Char( const TraceType::Type which )
{
   static char* dummyString = "ERROR";

   if( 0 ==  TraceType::typeMap() ) {
      report( ERROR, kFacilityString ) 
	 << "No TraceTypeMap!" << endl;
      return dummyString;
   }
   
   return (*(TraceTypeMap*)TraceType::typeMap())[which];
}

const char* 
TraceType::type2Char( const int which )
{
   static char* dummyString = "ERROR";

   if( which > TraceType::typeMap()->size() ) {
      report( ERROR, kFacilityString ) 
	 << "Trace-type index out of range=" << which << "!" << endl;
      return dummyString;
   }

   Type type = Type( which );
   return (*(TraceTypeMap*)TraceType::typeMap())[type];
}

// ----------------------------------------------------------------------
// global function to be fortran-callable: first argument is return type:
//   character*32 name, c_trace_type
//   print *, c_trace_type( index )
extern "C" void c_trace_type_( char* name, int length, const int& which )
{
   // create TraceType object for use from Fortran
   static TraceType traceType;

   // initialize with spaces
   memset( name, '\040', length );

   // copy name over into (fortran) array
   const char* nameOfType = TraceType::type2Char( which );
   strncpy( name, nameOfType, strlen( nameOfType ) );
}

// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:33  eugenio
// Initial revision
//
// Revision 1.5  1998/05/15 03:37:06  mkl
// inlined often-used functions to improve speed
//
// Revision 1.4  1998/02/16  22:30:30  mkl
// name: only print up to strlen(typeName) into (fortran) string
//
// Revision 1.3  1998/02/16  22:27:22  mkl
// pad witname h spaces for better (fortran) printout
//
// Revision 1.2  1998/02/16  21:49:05  mkl
// create static TraceType object for Fortran calls
//
// Revision 1.1  1998/02/16  21:30:08  mkl
// added new TraceType class that deals with trace types exclusively
//
//



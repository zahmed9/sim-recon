// -*- C++ -*-
//
// Package:     Tracing
// Module:      ProxyMedium
// 
// Description: Please see ProxyMedium.cc for a description
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     Sat Aug  2 14:48:43 CDT 1997
//

// system include files
#include <float.h>

// user include files
#include "report.hh"
#include "ProxyMedium.hh"
#include "DenseMedium.hh"
#include "Surface.hh"
#include "Detector.hh"
#include "Material.hh"

// STL classes

//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Tracing.ProxyMedium";

//
// static data member definitions
//

//
// constructors and destructor
//
ProxyMedium::ProxyMedium( Medium& medium, const Surface& surface )
   : m_realMedium( medium )
{
   Medium::setName( Medium::kProxy, medium.fortranName() );

   // need to clone, since Medium owns it and will delete it!
   setSurface( surface.clone() );

   const Detector* detector = medium.pDetector();
   if( 0 != detector ) setDetector( detector->clone() );

   const Material* material = medium.pMaterial();
   if( 0 != material ) setMaterial( material->clone() );
}

//ProxyMedium::ProxyMedium( const ProxyMedium& proxyMedium )
//   : m_realMedium( proxyMedium.m_realMedium )
//{
//   *this = proxyMedium;
//}

ProxyMedium::~ProxyMedium()
{
}

//
// assignment operators
//
//const ProxyMedium& ProxyMedium::operator=( const ProxyMedium& proxyMedium )
//{
//   if( this != &proxyMedium ) {
//      Medium::operator=( proxyMedium );
//   }
//
//   return *this;   
//}

//
// comparison operators
//
bool 
ProxyMedium::operator==( const Medium& medium ) const 
{
#if defined(MKLDEBUG)
   report( INFO, kFacilityString ) << "Proxy==medium" << endl;
#endif
   return medium.operator==( *this );
}

bool 
ProxyMedium::operator==( const DenseMedium& denseMedium ) const 
{
#if defined(MKLDEBUG)
   report( INFO, kFacilityString ) << "Proxy==denseMedium" << endl;
#endif
   return ( &m_realMedium == (Medium*)&denseMedium ) ? true : false;
}

bool 
ProxyMedium::operator==( const ProxyMedium& proxyMedium ) const 
{
#if defined(MKLDEBUG)
   report( INFO, kFacilityString ) << "Proxy==proxy" << endl;
#endif
   return ( &m_realMedium == &proxyMedium.m_realMedium ) ? true : false;
}

//
// member functions
//

// Collection of neighbouring DenseMedia
void
ProxyMedium::collectRNeighbours( vector<Medium*>& mediaList, 
                                 vector<Medium*>::iterator& iIndex ) 
{
   m_realMedium.collectRNeighbours( mediaList, iIndex ) ;
}
void
ProxyMedium::collectZNeighbours( vector<Medium*>& mediaList, 
                                 vector<Medium*>::iterator& iIndex ) 
{
   m_realMedium.collectZNeighbours( mediaList, iIndex ) ;
}

void
ProxyMedium::addNeighbour( Medium* medium ) 
{
   m_realMedium.addNeighbour( medium ) ;
}

//
// const member functions
//
// geometrical functionality
DFLOAT 
ProxyMedium::maxStep( const MCParticle& particle, int& howMany ) const
{
   DFLOAT distance = FLT_MAX;

   distance = surface().maxStep( particle, howMany );

   return distance;
}

DFLOAT 
ProxyMedium::distanceTo( const MCParticle& particle, 
			 DFLOAT iDistanceToBeat,
			 MCFBool& oWithinSides ) const
{
   DFLOAT distance = FLT_MAX;

   distance = surface().distanceTo( particle, iDistanceToBeat, oWithinSides );

   return distance;
}

MCFBool 
ProxyMedium::contains( const WTrackStruct& iWTrack ) const
{
   MCFBool returnValue = false;

   returnValue = surface().contains( iWTrack );

   return returnValue;
}


// ProxyMedium response
MCFBool
ProxyMedium::reactTo( MCParticle& particle ) const
{
   MCFBool returnValue = true;

   // forward request to real Medium
   returnValue = m_realMedium.reactTo( particle );
   
   return returnValue;
}

// I/O
void 
ProxyMedium::printOn( ostream& os ) const
{
   os << name() << ": " 
      << m_realMedium.name() << ": " << m_realMedium.fortranName() 
      << " { ";
   surface().printOn( os );
   os << "}" << flush;
}

//
// static member functions
//



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:33  eugenio
// Initial revision
//
// Revision 1.12  1999/04/22 01:28:54  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.11  1998/11/20  23:47:56  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.10  1998/05/18  16:42:51  yarba_j
// updated to account for showers spread over multiple volumes
//
// Revision 1.9  1998/05/04  22:08:31  mkl
// equality operator properly working for Medium pointers
//
// Revision 1.8  1998/04/28  18:01:33  mkl
// unconst ProxyMedium association with real medium
//
// Revision 1.7  1998/01/14  20:01:18  mkl
// beautifications of printouts
//
// Revision 1.6  1997/11/22  20:26:33  mkl
// keep track of fortran name of planes
//
// Revision 1.5  1997/11/11  06:43:58  mkl
// beautification of debug print-out
//
// Revision 1.4  1997/11/11  01:17:37  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.3  1997/08/27  03:31:40  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.2  1997/08/23  01:10:13  mkl
// toward volume-based tracing
//
// Revision 1.1  1997/08/03  04:19:44  mkl
// moved Box to AlignedBox
//



// -*- C++ -*-
//
// Package:     Tracing
// Module:      Tube
// 
// Description: Please see Tube.cc for a description
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     Sat Aug  2 14:48:43 CDT 1997
//

// system include files
#include <iostream.h>
#include <stdlib.h>
#include <assert.h>

// user include files
#include "report.hh"
#include "Tube.hh"
#include "RSurface.hh"
#include "ZCircularSurface.hh"
#include "MCParticle.hh"
#include "VolumeVisitor.hh"
#include "changeWTrack.hh"

// STL classes

//
// constants, enums and typedefs
//

//
// static data member definitions
//

//
// constructors and destructor
//
Tube::Tube( const float rmin, const float rmax, 
	    const float zmin, const float zmax )
   : m_innerCylinder( 0 ),
     m_outerCylinder( 0 ),
     m_zminRing( 0 ),
     m_zmaxRing( 0 ),

     m_rmin( rmin )
{
   // -1 signifies: dummy inner cylinder
   assert( 0 <= m_rmin || -1 == m_rmin );  
   assert( 0 <= rmax );

   // create surfaces
   if( -1 == rmin ) { // for everything else rmin --> 0
      m_rmin = 0; 
      m_innerCylinder = 0;
   }
   else if( 0 <= m_rmin ) {
      m_innerCylinder = new RSurface( m_rmin, zmin, zmax );
   }
   m_outerCylinder = new RSurface( rmax, zmin, zmax );
   m_zminRing      = new ZCircularSurface( zmin, m_rmin, rmax );
   m_zmaxRing      = new ZCircularSurface( zmax, m_rmin, rmax );

   if(  ( 0 < m_rmin && 0 == m_innerCylinder )
       || 0 == m_outerCylinder 
       || 0 == m_zminRing
       || 0 == m_zmaxRing
      )
   {
      report( EMERGENCY ) << "Tube::ctor: out of memory!\n";
      assert( false );
      ::exit(-1);
   }

   // now pass them on to Volume
   if( 0 != m_innerCylinder ) {
      insert( m_innerCylinder );
   }
   insert( m_outerCylinder );
   insert( m_zminRing );
   insert( m_zmaxRing );
}

Tube::Tube( const Tube& Tube )
{
   // rely on equality operator to implemented correctly
   *this = Tube;
}

Tube::~Tube()
{
   // don't delete surfaces here, since Volume will delete them!
}

//
// assignment operators
//
const Tube& Tube::operator=( const Tube& iTube )
{
   if( this != &iTube ) 
   {
      m_rmin = iTube.m_rmin;

      delete m_innerCylinder; // safe to delete 0 pointer!
      delete m_outerCylinder;
      delete m_zminRing;
      delete m_zmaxRing;
      if( 0 != iTube.m_innerCylinder ) {
	 m_innerCylinder = new RSurface( *iTube.m_innerCylinder );
      }
      else {
	 m_innerCylinder = 0;
      }
      m_outerCylinder = new RSurface( *iTube.m_outerCylinder );
      m_zminRing      = new ZCircularSurface( *iTube.m_zminRing );
      m_zmaxRing      = new ZCircularSurface( *iTube.m_zmaxRing );
     
      if( ( 0 < m_rmin && 0 == m_innerCylinder )
	  || 0 == m_outerCylinder 
          || 0 == m_zminRing
          || 0 == m_zmaxRing
	 )
      {
	 report( EMERGENCY ) << "Tube::ctor: out of memory!\n";
	 assert( false );
	 ::exit(-1);
      }

      // insert them in Volume; don't call Voluem::operator=!!!
      //Volume::operator=( iTube );
      if( 0 != m_innerCylinder ) {
	 insert( m_innerCylinder );
      }
      insert( m_outerCylinder );
      insert( m_zminRing );
      insert( m_zmaxRing );
      
   }

   return *this;   
}

//
// member functions
//
void
Tube::accept( VolumeVisitor& visitor )
{
   visitor.visitTube( *this );
}

//
// const member functions
//
Tube*
Tube::clone() const
{
   return new Tube(*this);
}                                   

DFLOAT 
Tube::distanceTo( const MCParticle& particle, 
		  DFLOAT iDistanceToBeat,
		  MCFBool& oWithinSides ) const
{
   // this routine is only here to implement the Volume interface!
   // this method should not be called; it's an error to get here!

   DFLOAT distance = FLT_MAX;

   report( ERROR ) << "Tube::distanceTo: I should not be called!\n";
   assert( false );
   ::exit(-1);

   return distance;
}

MCFBool 
Tube::contains( const WTrackStruct& wtrack ) const
{
   MCFBool returnValue = false;

   // check that particle coordinates are within rmin, rmax, zmin, zmax
   float r2 = wtrack.x*wtrack.x + wtrack.y*wtrack.y;
   float z  = wtrack.z;

   if(   r2 <= rmax()*rmax()
      && r2 >= rmin()*rmin()
      && z  <= zmax()
      && z  >= zmin()
      )
   {
      returnValue = true;
   }

   return returnValue;
}

const float
Tube::rmin() const
{
//   return m_innerCylinder->radius();
   return m_rmin;
}

const float
Tube::rmax() const
{
   return m_outerCylinder->radius();
}

const float
Tube::zmin() const
{
   return m_outerCylinder->zmin();
}

const float
Tube::zmax() const
{
   return m_outerCylinder->zmax();
}

// I/O
void 
Tube::printOn( ostream& os ) const
{
   os << "\nVolume of type( " << nameOf() << " )\n";

   os << "rmin=" << rmin() << ", rmax=" << rmax() << "\n";
   os << "zmin=" << zmin() << ", zmax=" << zmax() << "\n";

   Volume::printOn( os );

   os << "\n";
}

//
// static member functions
//



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:31  eugenio
// Initial revision
//
// Revision 1.8  1999/04/22 01:28:57  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.7  1998/11/20  23:48:02  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.6  1998/02/15  01:55:37  mkl
// for DenseMedia, need base reactTo figure out if entering or leaving volume, and call implementReactTo if entering
//
// Revision 1.5  1998/01/08  22:20:40  mkl
// added small distance along direction of flight to figure out if entering or exiting volume
//
// Revision 1.4  1997/11/11  01:17:43  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.3  1997/08/27  03:31:44  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.2  1997/08/25  19:23:04  mkl
// new Visitor classes to keep from cluttering volume class
//
// Revision 1.1  1997/08/23  01:10:15  mkl
// toward volume-based tracing
//
//



// -*- C++ -*-
//
// Package:     Tracing
// Module:      RectPlane
// 
// Description: R-type Volume
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     June 26, 1997
//

// system include files
#include <math.h>
#include <float.h>
#include <assert.h>

// user include files
#include "UserSettings.hh"
#include "externFortran.hh"
#include "report.hh"

#include "RectPlane.hh"
#include "MCParticle.hh"
#include "Point.hh"
#include "Direction.hh"

#include "functions.hh"
#include "bfield_struct.hh"
#include "wtrack_struct.hh"

//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Traceing.RectPlane";

//
// static data member definitions
//

//
// constructors and destructor
//
RectPlane::RectPlane( const Point& point, const Direction& normal, 
		      DFLOAT xmin, DFLOAT xmax, 
		      DFLOAT ymin, DFLOAT ymax, 
		      DFLOAT zmin, DFLOAT zmax  
   )
   : Plane( point, normal ),
     m_xmin( xmin ), m_xmax( xmax ),
     m_ymin( ymin ), m_ymax( ymax ),
     m_zmin( zmin ), m_zmax( zmax )
{
}

RectPlane::RectPlane( const RectPlane& rectPlane )
   : Plane( rectPlane.point(), rectPlane.normal() )
{
   *this = rectPlane;
}

RectPlane::~RectPlane()
{
}

//
// assignment operators
//
const RectPlane& RectPlane::operator=( const RectPlane& rectPlane )
{
   if( this != &rectPlane ) {
      m_xmin   = rectPlane.m_xmin;
      m_xmax   = rectPlane.m_xmax; 
      m_ymin   = rectPlane.m_ymin;
      m_ymax   = rectPlane.m_ymax; 
      m_zmin   = rectPlane.m_zmin;
      m_zmax   = rectPlane.m_zmax; 
      Plane::operator=( rectPlane );
   }

   return *this;
}

//
// member functions
//

//
// const member functions
//

// clone operation
RectPlane*
RectPlane::clone() const 
{
   return new RectPlane(*this);
}

// are within side boundaries?
MCFBool 
RectPlane::withinSides( const WTrackStruct& wtrack ) const
{
   MCFBool within 
      =  (wtrack.x >= xmin() && wtrack.x <= xmax() )
      && (wtrack.y >= ymin() && wtrack.y <= ymax() )
      && (wtrack.z >= zmin() && wtrack.z <= zmax() )
      ? true : false ;

#ifdef MKLDEBUG
   if( false == within )
   {
      report( INFO, kFacilityString )
	 << "not within sides: more info:\n"
	 << "xmin, xmax, ymin, ymax, zmin, zmax: \n"
	 << xmin() << " " << xmax() << " "
	 << ymin() << " " << ymax() << " "
	 << zmin() << " " << zmax() << "\n"
	 << "wtrack.x, .y, .z: " 
	 << wtrack.x << " " << wtrack.y << " " << wtrack.z 
	 << endl;
   }
#endif

   return within;
}

// is the point inside the surface?
MCFBool
RectPlane::contains( const WTrackStruct& iWTrack ) const 
{
   report( ERROR ) << "RectPlane::contains(): not fully implemented yet!\n";
   assert( false );

   return( withinSides( iWTrack ) ? true:false ) ;
}

// I/O
void
RectPlane::printOn( ostream& str ) const
{
   str << "\nVolume of type( " << nameOf() << " )\n";

   Plane::printOn( str );
   str << "xmin( "   << xmin()   << " )\n";
   str << "xmax( "   << xmax()   << " )\n";
   str << "ymin( "   << ymin()   << " )\n";
   str << "ymax( "   << ymax()   << " )\n";
   str << "zmin( "   << zmin()   << " )\n";
   str << "zmax( "   << zmax()   << " )\n";

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
// Revision 1.4  1998/11/20 23:47:59  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.3  1997/11/11  01:17:40  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.2  1997/08/27  03:31:43  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.1  1997/07/03  03:33:53  mkl
// new approach: surfaces vs volumes; box tracing
//
//



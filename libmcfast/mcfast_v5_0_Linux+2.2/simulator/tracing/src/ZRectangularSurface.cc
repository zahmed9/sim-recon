// -*- C++ -*-
//
// Package:     Tracing
// Module:      ZRectangularSurface
// 
// Description: Z-type box-shaped surface
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     Jan 23, 1997

// system include files
#include <float.h>

// user include files
#include "report.hh"
#include "UserSettings.hh"

#include "ZRectangularSurface.hh"
#include "RectPlane.hh"
#include "MCParticle.hh"
#include "functions.hh"
#include "bfield_struct.hh"
#include "wtrack_struct.hh"
#include "changeWTrack.hh"

//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Tracing.ZRectangularSurface";

//
// static data member definitions
//

//
// constructors and destructor
//
ZRectangularSurface::ZRectangularSurface( float z, 
					  float xmin, float xmax,
					  float ymin, float ymax )
   : ZSurface( z ), 
     m_xmin( xmin ), m_xmax( xmax ), 
     m_ymin( ymin ), m_ymax( ymax )
{
}

ZRectangularSurface::ZRectangularSurface( 
   const RectPlane& rectPlane ) 
   : ZSurface( rectPlane.zmin() ),
     m_xmin( rectPlane.xmin() ), m_xmax( rectPlane.xmax() ),
     m_ymin( rectPlane.ymin() ), m_ymax( rectPlane.ymax() )
{
}

ZRectangularSurface::ZRectangularSurface( 
   const ZRectangularSurface& zRectangularV )
{
   *this = zRectangularV;
}

ZRectangularSurface::~ZRectangularSurface()
{
}

//
// assignment operators
//
const ZRectangularSurface& 
ZRectangularSurface::operator=( const ZRectangularSurface& surface )
{
   if( this != &surface ) {
      m_xmin = surface.m_xmin;
      m_xmax = surface.m_xmax;
      m_ymin = surface.m_ymin;
      m_ymax = surface.m_ymax;
      ZSurface::operator=( surface );
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
ZRectangularSurface*
ZRectangularSurface::clone() const
{
   return new ZRectangularSurface(*this);
}

// are within side walls?
MCFBool 
ZRectangularSurface::withinSides( const WTrackStruct& wtrack ) const
{
   return ( (    wtrack.x > xmin() && wtrack.x < xmax() 
	      && wtrack.y > ymin() && wtrack.y < ymax()  
      ) ? true:false );
}

// is the point inside this surface?
MCFBool
ZRectangularSurface::contains( const WTrackStruct& iWTrack ) const 
{
   // make sure we're within rounding error
   static const DFLOAT deltaStep = SMALLDISTANCE;   //particle.stepLength()/2;

   // cheating: particle has to be within half of last step
   return ( (    iWTrack.z >= (z()-deltaStep)
	      && iWTrack.z <= (z()+deltaStep)
	      && withinSides( iWTrack ) 
      ) ? true : false );
}

// I/O
void
ZRectangularSurface::printOn( ostream& str ) const
{
   str << nameOf() << ": "
       << "z( "    << z()    << " ), "
       << "xmin( " << xmin() << " ), "
       << "xmax( " << xmax() << " ), "
       << "ymin( " << ymin() << " ), "
       << "ymax( " << ymax() << " )";
}                           

//
// static member functions
//


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:34  eugenio
// Initial revision
//
// Revision 1.5  1998/11/20 23:48:10  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.4  1997/11/11  06:44:01  mkl
// beautification of debug print-out
//
// Revision 1.3  1997/11/11  01:17:49  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.2  1997/08/27  03:31:48  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.1  1997/07/03  03:33:57  mkl
// new approach: surfaces vs volumes; box tracing
//
//



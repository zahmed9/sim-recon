// -*- C++ -*-
//
// Package:     Tracing
// Module:      Plane
// 
// Description: Planar Surface
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     Jun 26, 1997

// system include files
#include <math.h>
#include <float.h>
#include <assert.h>

// user include files
#include "UserSettings.hh"
#include "externFortran.hh"
#include "report.hh"

#include "Plane.hh"
#include "MCParticle.hh"
#include "functions.hh"
#include "bfield_struct.hh"
#include "wtrack_struct.hh"
#include "plane_struct.hh"

#include "changeWTrack.hh"

//
// constants, enums and typedefs
//

//
// static data member definitions
//

//
// constructors and destructor
//
Plane::Plane( const Point& point, const Direction& normal )
   : m_point( point ), m_normal( normal )
{
}

Plane::Plane( const Plane& Plane )
{
   *this = Plane;
}

Plane::~Plane()
{
}

//
// assignment operators
//
const Plane& Plane::operator=( const Plane& plane )
{
   if( this != &plane ) {
      m_point  = plane.m_point;
      m_normal = plane.m_normal;
      Surface::operator=( plane );
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
Plane*
Plane::clone() const 
{
   return new Plane(*this);
}

DFLOAT 
Plane::distanceTo( const MCParticle& particle, 
		   DFLOAT iDistanceToBeat,
		   MCFBool& oWithinSides ) const
{
   // set to "infinity"
   DFLOAT arcLength = FLT_MAX;
   oWithinSides = false;

   // add small distance to be beyond first solution!
   WTrackStruct wtrackAt = addSmallDistance( particle.wtrack() );
   //const WTrackStruct& wtrackAt = particle.wtrack();
   WTrackStruct wtrackNew = particle.wtrack();
   const BFieldStruct& bfield = particle.bfield();
   int status = move_wtk_plane_direct_( wtrackAt,
					planeStruct(),
					bfield,
					iDistanceToBeat,
					wtrackNew,
					arcLength );
   // add that small distance to correct argLength
   arcLength = addSmallDistance( arcLength );

   if( status != 0 ) {
#ifdef MKLDEBUG
      report( DEBUG ) << "Plane::distanceTo: move_wtk_plane error; " 
		      << "resetting to kMAX_FLIGHT" << "\n";
#endif
      arcLength = FLT_MAX;
   }
   else {

   // if fake move didn't hit the medium within side limits
      oWithinSides = withinSides( wtrackNew );

#ifdef MKLDEBUG
      report( DEBUG ) << "Plane.cc::distanceTo: "
		      << ", arcLength=" << arcLength
		      << ", withinSides=" << oWithinSides
		      << "\n";
#endif
      
   } // if status != 0

   // cache distance
   setDistanceTo( arcLength );
   setWTrackTo  ( wtrackNew );
   
   return arcLength;
}

// are within side walls?
MCFBool 
Plane::withinSides( const WTrackStruct& wtrack ) const
{
   // always true, since Plane is infinite
   return true;
}

// is the point inside the volume?
MCFBool
Plane::contains( const WTrackStruct& ) const 
{
   report( ERROR ) << "Plane::contains(): Not Implemented!" << endl;
   assert( false );

   return false;
}

// return Fortran-ready structure
const PlaneStruct 
Plane::planeStruct() const
{
   PlaneStruct plane = { { m_point.x(),  m_point.y(),  m_point.z()  },
			 { m_normal.x(), m_normal.y(), m_normal.z() } };

   return plane;
}

const DFLOAT*
Plane::eta( const WTrackStruct& ) const 
{
   static DFLOAT eta[3] = { m_normal.x(), m_normal.y(), m_normal.z() };
   return eta;
}

// I/O
void
Plane::printOn( ostream& str ) const
{
   str << "\nVolume of type( " << nameOf() << " )\n";

   str << "Point ( " << point()  << " )\n";
   str << "Normal( " << normal() << " )\n";

}                           

//
// static member functions
//


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:32  eugenio
// Initial revision
//
// Revision 1.7  1999/04/22 01:28:53  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.6  1998/11/20  23:47:55  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.5  1998/10/21  19:59:35  mkl
// implement eta correctly
//
// Revision 1.4  1998/05/15  03:50:56  mkl
// first attempt at taking one step to new wtrack without using move_wtk_arc routine
//
// Revision 1.3  1997/08/27  03:31:39  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.2  1997/07/31  14:53:05  bphyslib
// minor changes
//
// Revision 1.1  1997/07/03  03:33:52  mkl
// new approach: surfaces vs volumes; box tracing
//
//



// -*- C++ -*-
//
// Package:     Tracing
// Module:      YSurface
// 
// Description: X-type surface -- base implementation for all x-type surfaces
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     Nov 6, 1997
//

// system include files
#include <float.h>

// user include files
#include "report.hh"
#include "UserSettings.hh"
#include "externFortran.hh"
#include "functions.hh"

#include "YSurface.hh"
#include "MCParticle.hh"
#include "bfield_struct.hh"
#include "wtrack_struct.hh"
#include "plane_struct.hh"

#include "changeWTrack.hh"

//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Tracing.YSurface";

//
// static data member definitions
//

//
// constructors and destructor
//
YSurface::YSurface( float y, float xmin, float xmax, float zmin, float zmax  )
   : RectPlane( Point( (xmin+xmax)/2.0, y, (zmin+zmax)/2.0 ),
		Direction( 0, 1, 0 ), 
		xmin, xmax, y, y, zmin, zmax )
{
}

YSurface::YSurface( const RectPlane& rectPlane )
   : RectPlane( rectPlane )
{
}

YSurface::YSurface( const YSurface& surface )
   : RectPlane( surface )
{
   *this = surface;
}

YSurface::~YSurface()
{
}

//
// assignment operators
//
const YSurface& YSurface::operator=( const YSurface& surface )
{
   if( this != &surface ) {
      RectPlane::operator=( surface );
   }
   
   return *this;
}

//
// member functions
//

//
// const member functions
//

DFLOAT 
YSurface::distanceTo( const MCParticle& particle,
		      DFLOAT iDistanceToBeat,
		      MCFBool& oWithinSides ) const
{
   // set to "infinity"
   DFLOAT arcLength = FLT_MAX;
   oWithinSides = false;

   // fake move track in bfield to boundary

   // add small distance to be beyond first solution!
   WTrackStruct wtrackAt = addSmallDistance( particle.wtrack() );
   //const WTrackStruct&  wtrackAt = particle.wtrack();
   WTrackStruct wtrackNew;
   const BFieldStruct& bfield = particle.bfield();
//   int status = move_wtk_zplane_( wtrackAt,
//                                z(),
//                                bfield,
//                                wtrackNew,
//                                arcLength );
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
      report( DEBUG, kFacilityString ) 
	 << "distanceTo: move_wtk_(z)plane error; "
	 << "resetting to kMAX_FLIGHT" << endl;
#endif
      arcLength = FLT_MAX;
      wtrackNew = particle.wtrack();
   }
   else {

      // if fake move didn't hit the medium within side limits
      oWithinSides = withinSides( wtrackNew );
      
#ifdef MKLDEBUG
      report( DEBUG, kFacilityString ) 
	 << "distanceTo: "
	 << "particle_atY=" << particle.wtrack().y
	 << ", y=" << y()
	 << ", arcLength=" << arcLength
	 << ", withinSides=" << oWithinSides
	 << endl;
#endif

   } // if status != 0

   // cache distance
   setDistanceTo( arcLength );
   setWTrackTo  ( wtrackNew );

   return arcLength;
}

// clone operation
YSurface*
YSurface::clone() const
{
   return new YSurface(*this);
}

// are within side walls?
MCFBool 
YSurface::withinSides( const WTrackStruct& wtrack ) const
{
   return ( (    wtrack.x > xmin() && wtrack.x < xmax() 
	      && wtrack.z > zmin() && wtrack.z < zmax()  
      ) ? true:false );
}

// is the point inside this surface?
MCFBool
YSurface::contains( const WTrackStruct& iWTrack ) const 
{
   // make sure we're within rounding error
   static const DFLOAT deltaStep = SMALLDISTANCE;   //particle.stepLength()/2;

   // cheating: particle has to be within half of last step
   return ( (    iWTrack.y >= (y()-deltaStep)
	      && iWTrack.y <= (y()+deltaStep)
	      && withinSides( iWTrack ) 
      ) ? true : false );
}

// I/O
void
YSurface::printOn( ostream& str ) const
{
   str << nameOf() << ": "
       << "y( "    << y()    << " ), "
       << "xmin( " << xmin() << " ), "
       << "xmax( " << xmax() << " ), "
       << "zmin( " << zmin() << " ), "
       << "zmax( " << zmax() << " )";
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
// Revision 1.5  1999/04/22 01:29:01  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.4  1998/11/20  23:48:07  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.3  1998/05/15  03:50:59  mkl
// first attempt at taking one step to new wtrack without using move_wtk_arc routine
//
// Revision 1.2  1997/11/11  06:44:00  mkl
// beautification of debug print-out
//
// Revision 1.1  1997/11/11  01:17:47  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
//



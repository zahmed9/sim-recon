// -*- C++ -*-
//
// Package:     Tracing
// Module:      XSurface
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

#include "XSurface.hh"
#include "MCParticle.hh"
#include "bfield_struct.hh"
#include "wtrack_struct.hh"
#include "plane_struct.hh"

#include "changeWTrack.hh"

//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Tracing.XSurface";

//
// static data member definitions
//

//
// constructors and destructor
//
XSurface::XSurface( float x, float ymin, float ymax, float zmin, float zmax  )
   : RectPlane( Point( x, (ymin+ymax)/2.0, (zmin+zmax)/2.0 ),
		Direction( 1, 0, 0 ), 
		x, x, ymin, ymax, zmin, zmax )
{
}

XSurface::XSurface( const XSurface& surface )
   : RectPlane( surface )
{
   *this = surface;
}

XSurface::XSurface( const RectPlane& rectPlane )
   : RectPlane( rectPlane )
{
}

XSurface::~XSurface()
{
}

//
// assignment operators
//
const XSurface& XSurface::operator=( const XSurface& surface )
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
XSurface::distanceTo( const MCParticle& particle,
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
	 << "particle_atX=" << particle.wtrack().x
	 << ", x=" << x()
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
XSurface*
XSurface::clone() const
{
   return new XSurface(*this);
}

// are within side walls?
MCFBool 
XSurface::withinSides( const WTrackStruct& wtrack ) const
{
   return ( (    wtrack.y > ymin() && wtrack.y < ymax() 
	      && wtrack.z > zmin() && wtrack.z < zmax()  
      ) ? true:false );
}

// is the point inside this surface?
MCFBool
XSurface::contains( const WTrackStruct& iWTrack ) const 
{
   // make sure we're within rounding error
   static const DFLOAT deltaStep = SMALLDISTANCE;   //particle.stepLength()/2;

   // cheating: particle has to be within half of last step
   return ( (    iWTrack.x >= (x()-deltaStep)
	      && iWTrack.x <= (x()+deltaStep)
	      && withinSides( iWTrack ) 
      ) ? true : false );
}

// I/O
void
XSurface::printOn( ostream& str ) const
{
   str << nameOf() << ": "
       << "x( "    << x()    << " ), "
       << "ymin( " << ymin() << " ), "
       << "ymax( " << ymax() << " ), "
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
// Revision 1.5  1999/04/22 01:28:59  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.4  1998/11/20  23:48:05  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.3  1998/05/15  03:50:58  mkl
// first attempt at taking one step to new wtrack without using move_wtk_arc routine
//
// Revision 1.2  1997/11/11  06:43:59  mkl
// beautification of debug print-out
//
// Revision 1.1  1997/11/11  01:17:46  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
//



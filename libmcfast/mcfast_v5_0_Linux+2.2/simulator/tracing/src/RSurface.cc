// -*- C++ -*-
//
// Package:     Tracing
// Module:      RSurface
// 
// Description: R-type Surface
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     Jan 23, 1997

// system include files
#include <math.h>
#include <float.h>
#include <assert.h>

// user include files
#include "UserSettings.hh"
#include "externFortran.hh"
#include "report.hh"

#include "RSurface.hh"
#include "MCParticle.hh"
#include "functions.hh"
#include "bfield_struct.hh"
#include "wtrack_struct.hh"

#include "changeWTrack.hh"

//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Tracing.RSurface";

//
// static data member definitions
//

//
// constructors and destructor
//
RSurface::RSurface( float radius, float zmin, float zmax )
   : m_radius( radius ), m_zmin( zmin ), m_zmax( zmax )
{
}

RSurface::RSurface( const RSurface& rSurface )
{
   *this = rSurface;
}

RSurface::~RSurface()
{
}

//
// assignment operators
//
const RSurface& RSurface::operator=( const RSurface& surface )
{
   if( this != &surface ) {
      m_radius = surface.m_radius;
      m_zmin   = surface.m_zmin;
      m_zmax   = surface.m_zmax; 
      Surface::operator=( surface );
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
RSurface*
RSurface::clone() const 
{
   return new RSurface(*this);
}

DFLOAT 
RSurface::distanceTo( const MCParticle& particle, 
		      DFLOAT iDistanceToBeat,
		      MCFBool& oWithinSides ) const
{
   // set to "infinity"
   DFLOAT arcLength = FLT_MAX;
   oWithinSides = false;

   // --- to make curlers possible, always set "direct=1 ==> forward" -----
   Integer direct = 1;

   // fake move track in bfield to boundary

   // add small distance to be beyond first solution!
   WTrackStruct wtrackAt = addSmallDistance( particle.wtrack() );
   //const WTrackStruct& wtrackAt = particle.wtrack();
   WTrackStruct wtrackNew;
   const BFieldStruct& bfield = particle.bfield();
   int status = move_wtk_radius_( wtrackAt, 
				  radius(), 
				  direct, 
				  bfield,
				  wtrackNew, 
				  arcLength );
   // add that small distance to correct argLength
   arcLength = addSmallDistance( arcLength );

   if( status != 0 ) {
#ifdef MKLDEBUG
      report( DEBUG, kFacilityString ) 
	 << "distanceTo: move_wtk_radius error; " 
	 << "resetting to kMAX_FLIGHT" << endl;
#endif
      arcLength = FLT_MAX;
      wtrackNew = particle.wtrack();
   }
   else {

   // if fake move didn't hit the medium within side limits
      oWithinSides = withinSides( wtrackNew );

#ifdef MKLDEBUG
      DFLOAT wx=particle.wtrack().x, wy=particle.wtrack().y;
      DFLOAT particle_atRadius2 = wx*wx + wy*wy;
      report( DEBUG, kFacilityString ) 
	 << "distanceTo: "
	 << "particle_atRadius="	<< sqrt(particle_atRadius2) 
	 << ", radius=" << radius()
	 << ", direct=" << direct
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

// are within side walls?
MCFBool 
RSurface::withinSides( const WTrackStruct& wtrack ) const
{
   return ( (wtrack.z >= zmin() && wtrack.z <= zmax() ) ? true:false );
}

// is the point inside the surface?
MCFBool
RSurface::contains( const WTrackStruct& iWTrack ) const 
{
   // make sure it's within round-off error
   static const DFLOAT deltaStep = SMALLDISTANCE;   //particle.stepLength()/2;

   DFLOAT trackAtRadius = sqrt( iWTrack.x * iWTrack.x + iWTrack.y * iWTrack.y );

   // cheating: particle has to be within half of last step
   return ( (    trackAtRadius >= radius()-deltaStep
	      && trackAtRadius <= radius()+deltaStep
	      && withinSides( iWTrack )
      ) ? true:false );
}

const DFLOAT* 
RSurface::eta( const WTrackStruct& iWTrack ) const
{
   static DFLOAT eta[3] = {0};

   DFLOAT radius = sqrt( iWTrack.x*iWTrack.x + iWTrack.y*iWTrack.y );
   eta[0] = iWTrack.x/radius;
   eta[1] = iWTrack.y/radius;
   eta[2] = 0;

   return eta;
}

// I/O
void
RSurface::printOn( ostream& str ) const
{
   str << nameOf() << ": "
       << "radius( " << radius() << " ), "
       << "zmin( "   << zmin()   << " ), "
       << "zmax( "   << zmax()   << " )";
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
// Revision 1.10  1999/04/22 01:28:55  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.9  1998/11/20  23:47:58  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.8  1998/10/21  19:59:36  mkl
// implement eta correctly
//
// Revision 1.7  1998/05/15  03:50:57  mkl
// first attempt at taking one step to new wtrack without using move_wtk_arc routine
//
// Revision 1.6  1997/11/11  06:43:58  mkl
// beautification of debug print-out
//
// Revision 1.5  1997/11/11  01:17:39  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.4  1997/08/27  03:31:42  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.3  1997/08/03  06:01:47  mkl
// small fixes
//
// Revision 1.2  1997/07/31  14:53:05  bphyslib
// minor changes
//
// Revision 1.1  1997/07/03  03:33:53  mkl
// new approach: surfaces vs volumes; box tracing
//
//



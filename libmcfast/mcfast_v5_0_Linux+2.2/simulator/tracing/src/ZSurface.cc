// -*- C++ -*-
//
// Package:     Tracing
// Module:      ZSurface
// 
// Description: Z-type surface -- base implementation for all z-type surfaces
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
#include <float.h>

// user include files
#include "report.hh"
#include "UserSettings.hh"
#include "externFortran.hh"
#include "functions.hh"

#include "ZSurface.hh"
#include "MCParticle.hh"
#include "bfield_struct.hh"
#include "wtrack_struct.hh"
#include "plane_struct.hh"

#include "changeWTrack.hh"

//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Tracing.ZSurface";

//
// static data member definitions
//

//
// constructors and destructor
//
ZSurface::ZSurface( float z )
   : m_z( z )
{
}

ZSurface::ZSurface( const ZSurface& surface )
{
   *this = surface;
}

ZSurface::~ZSurface()
{
}

//
// assignment operators
//
const ZSurface& ZSurface::operator=( const ZSurface& surface )
{
   if( this != &surface ) {
      m_z = surface.m_z;
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

DFLOAT 
ZSurface::distanceTo( const MCParticle& particle,
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
   PlaneStruct plane = { { 0, 0, z() }, { 0, 0, 1 } };
   int status = move_wtk_plane_direct_( wtrackAt,
					plane,
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
	 << "particle_atZ=" << particle.wtrack().z
	 << ", z=" << z()
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

const DFLOAT* 
ZSurface::eta( const WTrackStruct& ) const
{
   static DFLOAT eta[3] = {0,0,1};
   return eta;
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
// Revision 1.8  1999/04/22 01:29:02  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.7  1998/11/20  23:48:11  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.6  1998/10/21  19:59:39  mkl
// implement eta correctly
//
// Revision 1.5  1998/05/15  03:50:59  mkl
// first attempt at taking one step to new wtrack without using move_wtk_arc routine
//
// Revision 1.4  1997/11/11  06:44:02  mkl
// beautification of debug print-out
//
// Revision 1.3  1997/08/03  06:01:49  mkl
// small fixes
//
// Revision 1.2  1997/07/31  14:53:06  bphyslib
// minor changes
//
// Revision 1.1  1997/07/03  03:33:57  mkl
// new approach: surfaces vs volumes; box tracing
//
//



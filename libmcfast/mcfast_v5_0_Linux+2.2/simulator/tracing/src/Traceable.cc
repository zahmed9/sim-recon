// -*- C++ -*-
//
// Package:     Tracing
// Module:      Traceable
// 
// Description: <one line class summary>
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     Fri Nov 7 15:21:36 EDT 1997

// system include files
#include <iostream.h>
#include <float.h>
#include <stdlib.h>
#include <assert.h>

// user include files
#include "Traceable.hh"
#include "MCParticle.hh"
#include "UserSettings.hh"

#include "report.hh"

#include "externFortran.hh"
#include "wtrack_struct.hh"
#include "bfield_struct.hh"

// STL classes

//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Tracing.Traceable";

static WTrackStruct NullWTrack;

//
// static data member definitions
//

//
// constructors and destructor
//
Traceable::Traceable()
   : m_distanceTo( FLT_MAX ),
     m_wtrackTo( NullWTrack )
{
}

Traceable::Traceable( const Traceable& traceable )
{
   *this = traceable;
}

Traceable::~Traceable()
{
}

//
// assignment operators
//
const Traceable& Traceable::operator=( const Traceable& traceable ) 
{
   if( this != &traceable )
   {
      m_distanceTo = traceable.m_distanceTo;
      m_wtrackTo   = traceable.m_wtrackTo;
   }

   return *this;
}

//
// member functions
//

//
// const member functions
//

// maximum step towards boundary
DFLOAT 
Traceable::maxStep( const MCParticle& particle, int& howMany ) const
{
   // (use cached version)
   DFLOAT arcLength = Traceable::distanceTo();

   const WTrackStruct& wtrack = particle.wtrack();
   const BFieldStruct& bfield = particle.bfield();
   DFLOAT rcurve = wtk_radius_curvature_( wtrack, bfield );
   
   DFLOAT angle = arcLength * ( wtrack.pt/wtrack.p ) / rcurve;

   // figure out max step
   int nstep1 = int( arcLength / UserSettings::kSTEP_MAX_DISTANCE ) + 1;
   int nstep2 = int( angle / UserSettings::kSTEP_MAX_ANGLE ) + 1;
   howMany = max( nstep1, nstep2 );

   // just do one big step if either the particle is not charged 
   // or we don't have a B-field
   if( wtrack.q * bfield.bmag == 0. ) {
      howMany = 1;
   }

   // limit number of steps to something reasonable
   if( howMany > UserSettings::kMAX_INTER_STEPS ) {
#ifdef MKLDEBUG
      report( WARNING ) << "Traceable::maxStep: large number of steps" << "\n";
#endif
      howMany = UserSettings::kMAX_INTER_STEPS;
   }

   return arcLength / howMany;

}

MCFBool 
Traceable::withinSides( const WTrackStruct& wtrack ) const
{
   report( EMERGENCY, kFacilityString )
      << "withinSides: I shouldn't be called!" << endl;
   assert( false );
   ::exit(1);
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
// Revision 1.6  1998/11/20 23:48:01  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.5  1998/08/05  16:13:52  mkl
// change some UserSettings defaults and now by default print when max # of steps or turns is reached
//
// Revision 1.4  1998/08/05  16:12:08  mkl
// change some UserSettings defaults and now by default print when max # of steps or turns is reached
//
// Revision 1.3  1998/05/15  03:50:57  mkl
// first attempt at taking one step to new wtrack without using move_wtk_arc routine
//
// Revision 1.2  1997/11/22  20:26:34  mkl
// keep track of fortran name of planes
//
// Revision 1.1  1997/11/11  01:17:42  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
//
//               

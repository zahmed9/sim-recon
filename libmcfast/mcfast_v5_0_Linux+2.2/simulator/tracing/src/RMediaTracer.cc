// -*- C++ -*-
//
// Package:     <Tracing>
// Module:      RMediaTracer
// 
// Description: <one line class summary>
//
// Implementation:
//     <Notes on implementation>
//
// Author:      Martin Lohner
// Created:     Tue Oct 21 12:13:35 EDT 1997
// $Id$
//
// Revision history
//
// $Log$
// Revision 1.1  2000/06/19 19:59:33  eugenio
// Initial revision
//
// Revision 1.9  1998/11/20 23:47:57  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.8  1998/11/20  05:32:15  mkl
// more verbose findFirstMedium with nicer return type; update index after volume exit
//
// Revision 1.7  1998/11/03  17:43:34  mkl
// changes to compile under egcs
//
// Revision 1.6  1998/02/17  05:10:08  mkl
// more verbose printout for PASSEDPARTICLE
//
// Revision 1.5  1998/02/15  01:54:27  mkl
// for innermost r-plane, always set directory to PLUS
//
// Revision 1.4  1998/01/08  22:20:05  mkl
// fixed problem with divide by zero for particle at origin
//
// Revision 1.3  1997/11/12  07:49:10  mkl
// major bug fixes (mostly reverse_iterator specific) -- now good agreement with fortran tracing found number of tracks
//
// Revision 1.2  1997/11/11  06:43:58  mkl
// beautification of debug print-out
//
// Revision 1.1  1997/11/11  01:17:38  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//

//#include "Experiment/Experiment.h"

// system include files
#include <fstream.h>
#include <math.h>
#include <vector>
#include <algorithm>

// user include files
#include "report.hh"
#include "RMediaTracer.hh"
#include "Medium.hh"
#include "MCParticle.hh"
#include "RSurface.hh"

//
// constants, enums and typedefs
//

static const char* const kFacilityString = "Tracing.RMediaTracer" ;

typedef _mediatracer_medialist_ MediaList;

//
// static data member definitions
//

//
// constructors and destructor
//
RMediaTracer::RMediaTracer( MediaList& iMediaList )
   : MediaTracer( iMediaList )
{
}

// RMediaTracer::RMediaTracer( const RMediaTracer& )
// {
// }

RMediaTracer::~RMediaTracer()
{
}

//
// assignment operators
//
// const RMediaTracer& RMediaTracer::operator=( const RMediaTracer& )
// {
// }

//
// member functions
//
   // local class for functional object
   class comp_rmedia { // Function Object
      public: 
	 MCFBool operator()( const Medium* x, const Medium* y ) {
	    // sort based on r
	    return( (   ((const RSurface*)x->pSurface())->radius() 
			< ((const RSurface*)y->pSurface())->radius() ) 
		    ? true : false );
	 }
   };
   
void
RMediaTracer::sortMedia()
{
   stable_sort( mediaList().begin(), mediaList().end(), comp_rmedia() ); 
}

MediaList::const_iterator
RMediaTracer::findFirstMedium( const MCParticle& iParticle )
{
   MediaList::const_iterator returnValue = mediaList().end();

   // can't assume that mediaList we're given is sorted
   if( false == isSorted() ) {
      sortMedia();
      setSorted( true );
   }

   // loop through all media for first medium.
   // To make things easy, as a first medium only consider 
   // radially outgoing

   // current particle radius
   const WTrackStruct& wtrack = iParticle.wtrack();
   DFLOAT radiusOfParticle = sqrt(wtrack.x*wtrack.x+wtrack.y*wtrack.y);

   // need to figure out direction (outward or inward)
   DFLOAT cosineAngle = wtrack.x*wtrack.px + wtrack.y*wtrack.py;
   Direction direction = ( cosineAngle >= 0 ) ? PLUS : MINUS;

   // set initial direction
   setDirection( direction );

   // loop through all media for first medium.
   // find first medium depending on flight direction
   if( PLUS == direction ) {  // moving in positive r direction
      
      MediaList::const_iterator itEnd = mediaList().end();
      for( MediaList::const_iterator it = mediaList().begin();
	   it != itEnd;
	   ++it )
      {
	 RSurface* pRSurface = ((RSurface* )(*it)->pSurface()); 
	 DFLOAT radius = (*pRSurface).radius(); 
	 if( radius > radiusOfParticle ) 
	 {
	    currentMedium()  = it;
	    previousMedium() = it;
	    returnValue = currentMedium();
	    
#ifdef MKLDEBUG
	    report( INFO, kFacilityString )
	       << "potential first medium (positive r): " 
	       << *currentMedium() << endl;
#endif
	    // found our first potential surface
	    break;
	 }
      }
   }
   else // moving in negative r direction
   {
      
      MediaList::const_iterator itEnd = mediaList().end();
      for( MediaList::const_iterator it = mediaList().begin();
	   it != itEnd;
	   ++it )
      {
	 RSurface* pRSurface = ((RSurface* )(*it)->pSurface()); 
	 DFLOAT radius = (*pRSurface).radius(); 

	 // look for layer just beyond; then we'll try to step back
	 if( radius > radiusOfParticle ) 
	 {
	    // if it's the first layer, then the first layer it is!
	    if( mediaList().begin() == it ) {
	       currentMedium()  = it;
	       previousMedium() = it;
	       returnValue = currentMedium();
	       setDirection( PLUS );  // always out-going!
	    }
	    else { // otherwise we take the previous layer!
	       --it;
	       currentMedium()  = it;
	       previousMedium() = it;
	       returnValue = currentMedium();
	    }	    
#ifdef MKLDEBUG
	    report( INFO, kFacilityString )
	       << "potential first medium (negative r): " 
	       << *currentMedium() << endl;
#endif
	    // found our first potential surface
	    break;
	 }
      }
   }

   return returnValue;
}

//
// const member functions
//
MCFBool 
RMediaTracer::equidistantMedium( 
   const vector<Medium*>::const_iterator& iIndex
   ) const
{
   MCFBool returnValue = false;

   // radius of current and new Medium
   DFLOAT radiusOfCurrentMedium 
      = (*(RSurface*)((*currentMedium())->pSurface())).radius(); 

   DFLOAT radiusOfNewMedium 
      = (*(RSurface*)(*iIndex          )->pSurface()).radius();
   
   // if current medium is at same distance or beyond
   if( radiusOfCurrentMedium == radiusOfNewMedium ) 
   {
      returnValue = true;
   }
   
   return returnValue;
}
 
MCFBool 
RMediaTracer::particleSurpassedPlus( 
   const vector<Medium*>::const_iterator& iIndex,
   const MCParticle& iParticle 
   ) const
{
   MCFBool returnValue = false;

   // radius of new Medium
   DFLOAT radiusOfNewMedium = (*(RSurface*)(*iIndex)->pSurface()).radius();
   
   // current particle radius
   const WTrackStruct& wtrack = iParticle.wtrack();
   DFLOAT radiusOfParticle = sqrt(wtrack.x*wtrack.x+wtrack.y*wtrack.y);

   // if radius of particle is larger than of medium
   if( radiusOfParticle > radiusOfNewMedium ) 
   {
#ifdef MKLDEBUG
      report( DEBUG, kFacilityString ) 
	 << "particleSurpassedPlus: skipping\n" 
	 << "radiusP=" << radiusOfParticle << ", "
	 << "radiusM=" << radiusOfNewMedium << endl;
#endif

      returnValue = true;
   }
   
   return returnValue;
}

MCFBool 
RMediaTracer::particleSurpassedMinus( 
   const vector<Medium*>::const_iterator& iIndex,
   const MCParticle& iParticle
   ) const
{
   MCFBool returnValue = false;

   // radius of new Medium
   DFLOAT radiusOfNewMedium = (*(RSurface*)(*iIndex)->pSurface()).radius();
   
   // current particle radius
   const WTrackStruct& wtrack = iParticle.wtrack();
   DFLOAT radiusOfParticle = sqrt(wtrack.x*wtrack.x+wtrack.y*wtrack.y);

   // if radius of particle is larger than of medium
   if( radiusOfParticle < radiusOfNewMedium ) 
   {
#ifdef MKLDEBUG
      report( DEBUG, kFacilityString ) 
	 << "particleSurpassedPlus: skipping\n"
	 << "radiusP=" << radiusOfParticle << ", "
	 << "radiusM=" << radiusOfNewMedium << endl;
#endif

      returnValue = true;
   }
   
   return returnValue;
}


// Printable interface
void
RMediaTracer::printOn( ostream& str ) const
{
   str << "RMediaTracer: I am not implemented yet!" << endl;
}

//
// static member functions
//

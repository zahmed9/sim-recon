// -*- C++ -*-
//
// Package:     <Tracing>
// Module:      ZMediaTracer
// 
// Description: <one line class summary>
//
// Implementation:
//     <Notes on implementation>
//
// Author:      Martin Lohner
// Created:     Tue Oct 21 12:13:37 EDT 1997
//

//#include "Experiment/Experiment.h"

// system include files
#include <vector>
#include <algorithm>

// user include files
#include "report.hh"
#include "ZMediaTracer.hh"
#include "Medium.hh"
#include "MCParticle.hh"
#include "ZSurface.hh"


//
// constants, enums and typedefs
//

static const char* const kFacilityString = "Tracing.ZMediaTracer" ;

typedef _mediatracer_medialist_ MediaList;

//
// static data member definitions
//

//
// constructors and destructor
//
ZMediaTracer::ZMediaTracer( MediaList& iMediaList )
   : MediaTracer( iMediaList )
{
}

// ZMediaTracer::ZMediaTracer( const ZMediaTracer& )
// {
// }

ZMediaTracer::~ZMediaTracer()
{
}

//
// assignment operators
//
// const ZMediaTracer& ZMediaTracer::operator=( const ZMediaTracer& )
// {
// }

//
// member functions
//
// local class for functional object
   class comp_zmedia {
      public: 
	 MCFBool operator()( const Medium* x, const Medium* y ) const {
	    // sort based on z
	    return( (   ((const ZSurface*)x->pSurface())->z() 
		      < ((const ZSurface*)y->pSurface())->z() ) 
		    ? true : false );
	 }
   };
   
void
ZMediaTracer::sortMedia()
{
   stable_sort( mediaList().begin(), mediaList().end(), comp_zmedia() ); 
}

MediaList::const_iterator
ZMediaTracer::findFirstMedium( const MCParticle& iParticle )
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

   // find direction of particle
   Direction direction = ( iParticle.wtrack().pz >= 0 ) ? PLUS : MINUS;
   setDirection( direction );

   // loop through all media for first medium.
   // find first medium depending on flight direction
   if( PLUS == direction ) {  // moving in positive z
      
      MediaList::const_iterator itEnd = mediaList().end();
      for( MediaList::const_iterator it = mediaList().begin();
	   it != itEnd;
	   ++it )
      {
	 ZSurface* pZSurface = (ZSurface* )(*it)->pSurface(); 
	 DFLOAT z = (*pZSurface).z();
	 if( z > iParticle.wtrack().z ) 
	 {
	    currentMedium()  = it;
	    previousMedium() = it;
	    returnValue = currentMedium();
#ifdef MKLDEBUG
	    report( INFO, kFacilityString )
	       << "potential first medium (positive z): " 
	       << *currentMedium() << endl;
#endif
	    // found our first potential surface
	    break;
	 }
      }
   }
   else // moving in negative z
   { 
      // have to cast to (const MediaList&) before requesting 
      // const_reverse_iterator because of g++ problem
      MediaList::const_reverse_iterator itEnd      
	 = ((const MediaList&)mediaList()).rend(); 

      for( MediaList::const_reverse_iterator it 
	      = ((const MediaList&)mediaList()).rbegin();
	   it != itEnd;
	   ++it )
      {
	 ZSurface* pZSurface = (ZSurface* )(*it)->pSurface(); 
	 DFLOAT z = (*pZSurface).z();
	 if( z < iParticle.wtrack().z ) 
	 {
	    currentMedium()  = it.base()-1 ;
	    previousMedium() = it.base()-1 ;
	    returnValue = currentMedium();
	    
#ifdef MKLDEBUG 
	    report( INFO, kFacilityString )
	       << "potential first medium (negative z): " 
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
ZMediaTracer::equidistantMedium( 
   const vector<Medium*>::const_iterator& iIndex
   ) const
{
   MCFBool returnValue = false;
   
   // z of current and new Medium
   DFLOAT zOfCurrentMedium 
      = (*((ZSurface*)(*currentMedium())->pSurface())).z();

   DFLOAT zOfNewMedium 
      = (*((ZSurface*)(*iIndex         )->pSurface())).z();
   
   // if current medium is at same distance or beyond
   if( zOfCurrentMedium == zOfNewMedium ) 
   {
      returnValue = true;
   }
   
   return returnValue;
}
 
MCFBool 
ZMediaTracer::particleSurpassedPlus( 
   const vector<Medium*>::const_iterator& iIndex,
   const MCParticle& iParticle 
   ) const
{
   MCFBool returnValue = false;

   // new Medium
   DFLOAT zOfNewMedium = (*((ZSurface*)(*iIndex)->pSurface())).z();
   
   // particle
   const WTrackStruct& wtrack = iParticle.wtrack();
   DFLOAT zOfParticle = iParticle.wtrack().z;

   // if z of particle is larger than of medium
   if( zOfParticle > zOfNewMedium ) 
   {
#ifdef MKLDEBUG
      report( DEBUG, kFacilityString ) 
	 << "particleSurpassedPlus: skipping\n" 
	 << "zOfParticle=" << zOfParticle << ", "
	 << "zOfNewMedium=" << zOfNewMedium << endl;
#endif

      returnValue = true;
   }
   
   return returnValue;
}

MCFBool 
ZMediaTracer::particleSurpassedMinus( 
   const vector<Medium*>::const_iterator& iIndex,
   const MCParticle& iParticle
   ) const
{
   MCFBool returnValue = false;

   // new Medium
   DFLOAT zOfNewMedium = (*((ZSurface*)(*iIndex)->pSurface())).z();
   
   // particle
   const WTrackStruct& wtrack = iParticle.wtrack();
   DFLOAT zOfParticle = iParticle.wtrack().z;

   // if z of particle is larger than of medium
   if( zOfParticle < zOfNewMedium ) 
   {
#ifdef MKLDEBUG
      report( DEBUG, kFacilityString ) 
	 << "particleSurpassedPlus: skipping\n" 
	 << "zOfParticle=" << zOfParticle << ", "
	 << "zOfNewMedium=" << zOfNewMedium << endl;
#endif

      returnValue = true;
   }
   
   return returnValue;
}


// Printable interface
void
ZMediaTracer::printOn( ostream& str ) const
{
   str << "ZMediaTracer: I am not implemented yet!" << endl;
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
// Revision 1.8  1998/11/20 23:48:09  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.7  1998/11/20  05:32:17  mkl
// more verbose findFirstMedium with nicer return type; update index after volume exit
//
// Revision 1.6  1998/11/03  17:43:38  mkl
// changes to compile under egcs
//
// Revision 1.5  1998/05/29  21:06:24  yarba_j
// findFirstMedium(...) - fixed search in -z-direction
//
// Revision 1.4  1998/02/17  05:22:35  mkl
// more verbose printing for PASSEDPARTICLE
//
// Revision 1.3  1997/11/12  07:49:12  mkl
// major bug fixes (mostly reverse_iterator specific) -- now good agreement with fortran tracing found number of tracks
//
// Revision 1.2  1997/11/11  06:44:01  mkl
// beautification of debug print-out
//
// Revision 1.1  1997/11/11  01:17:48  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
//
//


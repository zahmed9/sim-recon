// -*- C++ -*-
//
// Package:     <Tracing>
// Module:      YMediaTracer
// 
// Description: <one line class summary>
//
// Implementation:
//     <Notes on implementation>
//
// Author:      Martin Lohner
// Created:     Thu Nov 6 12:13:37 EDT 1997
//

//#include "Experiment/Experiment.h"

// system include files
#include <vector>
#include <algorithm>

// user include files
#include "report.hh"
#include "YMediaTracer.hh"
#include "Medium.hh"
#include "MCParticle.hh"
#include "YSurface.hh"

//
// constants, enums and typedefs
//

static const char* const kFacilityString = "Tracing.YMediaTracer" ;

typedef _mediatracer_medialist_ MediaList;

//
// static data member definitions
//

//
// constructors and destructor
//
YMediaTracer::YMediaTracer( MediaList& iMediaList )
   : MediaTracer( iMediaList )
{
}

// YMediaTracer::YMediaTracer( const YMediaTracer& )
// {
// }

YMediaTracer::~YMediaTracer()
{
}

//
// assignment operators
//
// const YMediaTracer& YMediaTracer::operator=( const YMediaTracer& )
// {
// }

//
// member functions
//
// local class for functional object
   class comp_ymedia {
      public: 
	 MCFBool operator()( const Medium* x, const Medium* y ) const {
	    // sort based on y
	    return( (   ((const YSurface*)x->pSurface())->y() 
		      < ((const YSurface*)y->pSurface())->y() ) 
		    ? true : false );
	 }
   };
   
void
YMediaTracer::sortMedia()
{
   stable_sort( mediaList().begin(), mediaList().end(), comp_ymedia() ); 
}

MediaList::const_iterator
YMediaTracer::findFirstMedium( const MCParticle& iParticle )
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
   Direction direction = ( iParticle.wtrack().py >= 0 ) ? PLUS : MINUS;
   setDirection( direction );

   // loop through all media for first medium.
   // find first medium depending on flight direction
   if( PLUS == direction ) {  // moving in positive direction
      
      MediaList::const_iterator itEnd = mediaList().end();
      for( MediaList::const_iterator it = mediaList().begin();
	   it != itEnd;
	   ++it )
      {
	 YSurface* pYSurface = (YSurface* )(*it)->pSurface(); 
	 DFLOAT y = (*pYSurface).y();
	 if( y > iParticle.wtrack().y ) 
	 {
	    currentMedium()  = it;
	    previousMedium() = it;
	    returnValue = currentMedium();
	    
#ifdef MKLDEBUG
	    report( INFO, kFacilityString )
	       << "potential first medium (positive y): " 
	       << *currentMedium() << endl;
#endif
	    // found our first potential surface
	    break;
	 }
      }
   }
   else // moving in negative y
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
	 YSurface* pYSurface = (YSurface* )(*it)->pSurface(); 
	 DFLOAT y = (*pYSurface).y();
	 if( y < iParticle.wtrack().y ) 
	 {
	    currentMedium()  = it.base() - 1;
	    previousMedium() = it.base() -1 ;
	    returnValue = currentMedium();
	    
#ifdef MKLDEBUG
	    report( INFO, kFacilityString )
	       << "potential first medium (negative y): " 
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
YMediaTracer::equidistantMedium( 
   const vector<Medium*>::const_iterator& iIndex
   ) const
{
   MCFBool returnValue = false;

   // y of current and new Medium
   DFLOAT yOfCurrentMedium 
      = (*((YSurface*)(*currentMedium())->pSurface())).y();

   DFLOAT yOfNewMedium 
      = (*((YSurface*)(*iIndex         )->pSurface())).y();
   
   // if current medium is at same distance or beyond
   if( yOfCurrentMedium == yOfNewMedium ) 
   {
      returnValue = true;
   }
   
   return returnValue;
}
 
MCFBool 
YMediaTracer::particleSurpassedPlus( 
   const vector<Medium*>::const_iterator& iIndex,
   const MCParticle& iParticle 
   ) const
{
   MCFBool returnValue = false;

   // new Medium
   DFLOAT yOfNewMedium = (*((YSurface*)(*iIndex)->pSurface())).y();
   
   // particle
   const WTrackStruct& wtrack = iParticle.wtrack();
   DFLOAT yOfParticle = iParticle.wtrack().y;

   // if y of particle is larger than of medium
   if( yOfParticle > yOfNewMedium ) 
   {
#ifdef MKLDEBUG
      report( DEBUG, kFacilityString ) 
	 << "particleSurpassedPlus: skipping\n" 
	 << "yOfParticle=" << yOfParticle << ", "
	 << "yOfNewMedium=" << yOfNewMedium << endl;
#endif

      returnValue = true;
   }
   
   return returnValue;
}

MCFBool 
YMediaTracer::particleSurpassedMinus( 
   const vector<Medium*>::const_iterator& iIndex,
   const MCParticle& iParticle
   ) const
{
   MCFBool returnValue = false;

   // new Medium
   DFLOAT yOfNewMedium = (*((YSurface*)(*iIndex)->pSurface())).y();
   
   // particle
   const WTrackStruct& wtrack = iParticle.wtrack();
   DFLOAT yOfParticle = iParticle.wtrack().y;

   // if y of particle is larger than of medium
   if( yOfParticle < yOfNewMedium ) 
   {
#ifdef MKLDEBUG
      report( DEBUG, kFacilityString ) 
	 << "particleSurpassedPlus: skipping\n" 
	 << "yOfParticle=" << yOfParticle << ", "
	 << "yOfNewMedium=" << yOfNewMedium << endl;
#endif

      returnValue = true;
   }
   
   return returnValue;
}


// Printable interface
void
YMediaTracer::printOn( ostream& str ) const
{
   str << "YMediaTracer: I am not implemented yet!" << endl;
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
// Revision 1.8  1999/11/17 01:54:53  kutschke
// From Julia:  Offset of -1 when switching direction of iterator.
//
// Revision 1.7  1998/11/20  23:48:06  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.6  1998/11/20  05:32:16  mkl
// more verbose findFirstMedium with nicer return type; update index after volume exit
//
// Revision 1.5  1998/11/03  17:43:38  mkl
// changes to compile under egcs
//
// Revision 1.4  1998/02/17  05:22:35  mkl
// more verbose printing for PASSEDPARTICLE
//
// Revision 1.3  1997/11/12  07:49:11  mkl
// major bug fixes (mostly reverse_iterator specific) -- now good agreement with fortran tracing found number of tracks
//
// Revision 1.2  1997/11/11  06:44:00  mkl
// beautification of debug print-out
//
// Revision 1.1  1997/11/11  01:17:47  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
//
//


// -*- C++ -*-
//
// Package:     <Tracing>
// Module:      XMediaTracer
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
#include "XMediaTracer.hh"
#include "Medium.hh"
#include "MCParticle.hh"
#include "XSurface.hh"

//
// constants, enums and typedefs
//

static const char* const kFacilityString = "Tracing.XMediaTracer" ;

typedef _mediatracer_medialist_ MediaList;

//
// static data member definitions
//

//
// constructors and destructor
//
XMediaTracer::XMediaTracer( MediaList& iMediaList )
   : MediaTracer( iMediaList )
{
}

// XMediaTracer::XMediaTracer( const XMediaTracer& )
// {
// }

XMediaTracer::~XMediaTracer()
{
}

//
// assignment operators
//
// const XMediaTracer& XMediaTracer::operator=( const XMediaTracer& )
// {
// }

//
// member functions
//
// local class for functional object
   class comp_xmedia {
      public: 
	 MCFBool operator()( const Medium* x, const Medium* y ) const {
	    // sort based on x
	    return( (   ((const XSurface*)x->pSurface())->x() 
		      < ((const XSurface*)y->pSurface())->x() ) 
		    ? true : false );
	 }
   };
   
void
XMediaTracer::sortMedia()
{
   stable_sort( mediaList().begin(), mediaList().end(), comp_xmedia() ); 
}

MediaList::const_iterator
XMediaTracer::findFirstMedium( const MCParticle& iParticle )
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
   Direction direction = ( iParticle.wtrack().px >= 0 ) ? PLUS : MINUS;
   setDirection( direction );

   // loop through all media for first medium.
   // find first medium depending on flight direction
   if( PLUS == direction ) {  // moving in positive direction
      
      MediaList::const_iterator itEnd = mediaList().end();
      for( MediaList::const_iterator it = mediaList().begin();
	   it != itEnd;
	   ++it )
      {
	 XSurface* pXSurface = (XSurface* )(*it)->pSurface(); 
	 DFLOAT x = (*pXSurface).x();
	 if( x > iParticle.wtrack().x ) 
	 {
	    currentMedium()  = it;
	    previousMedium() = it;
	    returnValue = currentMedium();
	    
#ifdef MKLDEBUG
	    report( INFO, kFacilityString )
	       << "potential first medium (positive x): "
	       << *currentMedium() << endl;
#endif
	    // found our first potential surface
	    break;
	 }
      }
   }
   else // moving in negative x
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
	 XSurface* pXSurface = (XSurface* )(*it)->pSurface(); 
	 DFLOAT x = (*pXSurface).x();
	 if( x < iParticle.wtrack().x ) 
	 {
	    currentMedium()  = it.base() -1 ;
	    previousMedium() = it.base() -1 ;
	    returnValue = currentMedium();
	    
#ifdef MKLDEBUG
	    report( INFO, kFacilityString )
	       << "potential first medium (negative x): " 
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
XMediaTracer::equidistantMedium( 
   const vector<Medium*>::const_iterator& iIndex
   ) const
{
   MCFBool returnValue = false;

   // x of current and new Medium
   DFLOAT xOfCurrentMedium 
      = (*((XSurface*)(*currentMedium())->pSurface())).x();

   DFLOAT xOfNewMedium 
      = (*((XSurface*)(*iIndex         )->pSurface())).x();
   
   // if current medium is at same distance or bexond
   if( xOfCurrentMedium == xOfNewMedium ) 
   {
      returnValue = true;
   }
   
   return returnValue;
}
 
MCFBool 
XMediaTracer::particleSurpassedPlus( 
   const vector<Medium*>::const_iterator& iIndex,
   const MCParticle& iParticle 
   ) const
{
   MCFBool returnValue = false;

   // new Medium
   DFLOAT xOfNewMedium = (*((XSurface*)(*iIndex)->pSurface())).x();
   
   // particle
   const WTrackStruct& wtrack = iParticle.wtrack();
   DFLOAT xOfParticle = iParticle.wtrack().x;

   // if x of particle is larger than of medium
   if( xOfParticle > xOfNewMedium ) 
   {
#ifdef MKLDEBUG
      report( DEBUG, kFacilityString ) 
	 << "particleSurpassedPlus: skipping\n" 
	 << "xOfParticle=" << xOfParticle << ", "
	 << "xOfNewMedium=" << xOfNewMedium << endl;
#endif

      returnValue = true;
   }
   
   return returnValue;
}

MCFBool 
XMediaTracer::particleSurpassedMinus( 
   const vector<Medium*>::const_iterator& iIndex,
   const MCParticle& iParticle
   ) const
{
   MCFBool returnValue = false;

   // new Medium
   DFLOAT xOfNewMedium = (*((XSurface*)(*iIndex)->pSurface())).x();
   
   // particle
   const WTrackStruct& wtrack = iParticle.wtrack();
   DFLOAT xOfParticle = iParticle.wtrack().x;

   // if x of particle is larger than of medium
   if( xOfParticle < xOfNewMedium ) 
   {
#ifdef MKLDEBUG
      report( DEBUG, kFacilityString ) 
	 << "particleSurpassedPlus: skipping\n" 
	 << "xOfParticle=" << xOfParticle << ", "
	 << "xOfNewMedium=" << xOfNewMedium << endl;
#endif

      returnValue = true;
   }
   
   return returnValue;
}


// Printable interface
void
XMediaTracer::printOn( ostream& str ) const
{
   str << "XMediaTracer: I am not implemented yet!" << endl;
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
// Revision 1.8  1999/11/17 01:54:52  kutschke
// From Julia:  Offset of -1 when switching direction of iterator.
//
// Revision 1.7  1998/11/20  23:48:04  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.6  1998/11/20  05:32:16  mkl
// more verbose findFirstMedium with nicer return type; update index after volume exit
//
// Revision 1.5  1998/11/03  17:43:37  mkl
// changes to compile under egcs
//
// Revision 1.4  1998/02/17  05:22:35  mkl
// more verbose printing for PASSEDPARTICLE
//
// Revision 1.3  1997/11/12  07:49:10  mkl
// major bug fixes (mostly reverse_iterator specific) -- now good agreement with fortran tracing found number of tracks
//
// Revision 1.2  1997/11/11  06:43:59  mkl
// beautification of debug print-out
//
// Revision 1.1  1997/11/11  01:17:46  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
//
//


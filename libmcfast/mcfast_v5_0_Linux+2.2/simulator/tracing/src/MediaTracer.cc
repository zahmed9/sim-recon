// -*- C++ -*-
//
// Package:     <Tracing>
// Module:      MediaTracer
// 
// Description: <one line class summary>
//
// Implementation:
//     <Notes on implementation>
//
// Author:      Martin Lohner
// Created:     Tue Oct 21 12:13:17 EDT 1997
//

//#include "Experiment/Experiment.h"

// system include files
#include <assert.h>
#include <stdlib.h>

#if defined(STL_TEMPLATE_DEFAULT_PARAMS_FIRST_BUG)
#include <vector>
#endif /* STL_TEMPLATE_DEFAULT_PARAMS_FIRST_BUG */

// user include files
#include "report.hh"
#include "functions.hh"
#include "MediaTracer.hh"
#include "Medium.hh"
#include "MCParticle.hh"
#include "UserSettings.hh"

// STL classes
#include <vector>

//
// constants, enums and typedefs
//

static const char* const kFacilityString = "Tracing.MediaTracer" ;

typedef _mediatracer_medialist_ MediaList;

//
// static data member definitions
//

//
// constructors and destructor
//
MediaTracer::MediaTracer( MediaList& iMediaList )
   : m_mediaList( iMediaList ),
     m_currentMedium( m_mediaList.end() ),
     m_previousMedium( m_mediaList.end() ),
     m_direction( PLUS ),
     m_isSorted( false ),
     m_rookieParticle( true )
{
}

// MediaTracer::MediaTracer( const MediaTracer& )
// {
// }

MediaTracer::~MediaTracer()
{
}

//
// assignment operators
//
// const MediaTracer& MediaTracer::operator=( const MediaTracer& )
// {
// }

//
// member functions
//
const Medium* 
MediaTracer::findNextMedium( const MCParticle& particle,
			     DFLOAT& minArcLength,
			     DFLOAT& arcLengthToBeat )
{
   // if we can't find medium, return null pointer
   const Medium* nextMedium=0;

   // initialize to ridiculously large value
   minArcLength=FLT_MAX;

   // if we don't have any media, take easy route out
   if( true == m_mediaList.empty() ) return nextMedium=0;

   // figure out which is next medium to go to
   MediaList::const_iterator nextIndex;

   if( true == needsInitialization() )
   {
      m_rookieParticle = true;

      // find first potential medium
      findFirstMedium( particle );

      // if we couldn't initialize properly, better get out
      if( m_mediaList.end() == m_currentMedium ) {
	 return nextMedium=0;
      }

      nextIndex  = m_currentMedium;
   }
   else // ---------- not first time ---------------------
   {
      m_rookieParticle = false;

      nextIndex  
	 = ( PLUS == m_direction ) ? m_currentMedium + 1 : m_currentMedium - 1;
   }

   // ---------- not first time ---------------------

   // find distance to nearest surface; and make it efficient by
   // looking first along the flight direction
   // and then using that information to speed up the backwards search
   // first try outward, then inward
   // beware that reverse iterators have a setoff of -1 from iterators
   MediaList::const_iterator         plusIndex ( nextIndex );
   MediaList::const_reverse_iterator minusIndex( plusIndex+1 );

   DFLOAT plusLength  = FLT_MAX; 
   DFLOAT minusLength = FLT_MAX;

   if( PLUS == m_direction ) // to speed things up
   {
      arcLengthToBeat = min( arcLengthToBeat, abs( minusLength ) );

      plusIndex = findNextPlusMedium( plusIndex,      // start index
				      particle,
				      plusLength,
				      arcLengthToBeat  // for speed
	 );
      arcLengthToBeat = min( arcLengthToBeat, abs( plusLength ) );
      
      if( true == UserSettings::kAllowCurlers  // only when asked for
	  && plusLength == FLT_MAX )            // and no "forward" 
      {                                        // solution
	 
	 ++minusIndex;
	 minusIndex = findNextMinusMedium( minusIndex,        // start index
					   particle,
					   minusLength,
					   arcLengthToBeat // for speed
	    );
      }
   }
   else // minus direction
   {
      arcLengthToBeat = min( arcLengthToBeat, abs( plusLength ) );

      minusIndex  = findNextMinusMedium( minusIndex,      // start index
					 particle,
					 minusLength,
					 arcLengthToBeat // for speed
	 );
      arcLengthToBeat = min( arcLengthToBeat, abs( minusLength ) );
      
      if( true == UserSettings::kAllowCurlers  // only when asked for
	  && minusLength == FLT_MAX )             // and no "forward" 
      {                                        // solution
	 ++plusIndex;
	 plusIndex = findNextPlusMedium( plusIndex,       // start index
					 particle,
					 plusLength,
					 arcLengthToBeat // for speed
	    );
      }
   }
   
   // ===================================================================
   // if the distance is negative, we don't want to go there!(backwards!)
   // shouldn't happen! that's why we use assert here
   assert( plusLength  >= 0 );
   assert( minusLength >= 0 );

   // take the smaller of the two: plusLength vs minusLength
   if( plusLength <= minusLength && plusLength < FLT_MAX ) 
   {
      m_direction     = PLUS;          // for efficiency reasons only
      m_currentMedium = plusIndex;
      nextMedium      = *plusIndex;
      minArcLength    = plusLength;
   } 
   else if( plusLength > minusLength ) 
   {
      m_direction     = MINUS;         // for efficiency reasons only
      m_currentMedium = minusIndex.base()-1;
      nextMedium      = *minusIndex;
      minArcLength    = minusLength;
   } 
   else 
   {
      // otherwise the defaults are used (nextMedium=0, 
      //                                  minArcLength=maximum)
#ifdef MKLDEBUG
      report( WARNING )
	 << nameOf() << ": no good nextMedium" << endl;
#endif
      nextMedium = 0;
      minArcLength = FLT_MAX;
   }


   return nextMedium;
}

void 
MediaTracer::resetIndex()
{
   // to speed up finding of new Medium
   int offset = 0;
   if( m_currentMedium > m_previousMedium ) 
   {
      offset = -1;
   } 
   else if( m_currentMedium < m_previousMedium )
   {
      offset = +1;
   }
   m_currentMedium += offset;
}

void 
MediaTracer::updateIndex()
{
   m_previousMedium = m_currentMedium;
}

MediaList::const_iterator& 
MediaTracer::findNextPlusMedium( MediaList::const_iterator& iIndex,
				 const MCParticle& iParticle,
				 DFLOAT& oLength, 
				 const DFLOAT iLengthToBeat )
{
   // (for efficiency) if the distance in the forward direction is 
   // farther than in the backward direction, we better get out fast;
   // That's the reason why arcLengthToBeat is passed in as a parameter

   // start with infinity
   oLength = FLT_MAX;

   // ===================================================================
   // PLUS loop starting with "startingIndex"
   // 
   MediaList::const_iterator indexEnd = m_mediaList.end();
   for( ;     // iIndex is starting point 
	iIndex != indexEnd;
	++iIndex )
   {
      MCFBool withinSides;

#ifdef MKLDEBUG
      report( DEBUG ) 
	 << nameOf() << ":findNextPlusMedium: " << *iIndex << endl;
#endif

      // don't do efficient stuff for first-timers
      if( false == m_rookieParticle ) {

	 // skip if we have medium at same "distance"
	 Equidistantness status 
	    = isEquidistantMedium( iIndex, iParticle, oLength );
	 if( HIT == status ) {
	    break;
	 } 
	 else if( MISS == status ) {
	    continue;
	 }

	 // break if particle is already passed 
	 // (else infinite loops, because of precision problems!)
	 if( true == particleSurpassedPlus( iIndex, iParticle ) ) {

	    // refind next potential medium
	    MediaList::const_iterator temp = findFirstMedium( iParticle );
	    // if we couldn't initialize properly, better get out
	    if( m_mediaList.end() == temp ) {
	       oLength = FLT_MAX;
	       break;
	    }
	    iIndex = temp;
	 }
      }

      // now figure out distance to next medium
      oLength = (*iIndex)->distanceTo( iParticle, iLengthToBeat, withinSides );


      // -------- different cases to break out of loop -----------
      
      // if we can't find good next Medium, break (the next one will be
      // just as bad)
      if( oLength == FLT_MAX ) break;

      // if distance is "negative", don't go there; break
      if( oLength < 0 ) 
      { 
	 oLength = FLT_MAX;
	 break;
      }

      // (for efficiency) if the distance in the forward direction is 
      // farther than in the backward direction, we better get out
      if( oLength > iLengthToBeat ) break;

      // if distance is "positive" and within side limits, 
      // we found our candidate
      if( oLength >= 0 
	  && oLength < FLT_MAX 
	  && withinSides == true ) break;
      
      // if outside sides, do the right thing!
      if( false == withinSides ) continue;
      
   }
   // if we didn't find a good medium
   if( m_mediaList.end() == iIndex ) oLength = FLT_MAX;
   
   return iIndex;
}

MediaList::const_reverse_iterator& 
MediaTracer::findNextMinusMedium( MediaList::const_reverse_iterator& iIndex,
				  const MCParticle& iParticle,
				  DFLOAT& oLength, 
				  const DFLOAT iLengthToBeat )
{
   // (for efficiency) if the distance in the forward direction is 
   // farther than in the backward direction, we better get out fast;
   // That's the reason why arcLengthToBeat is passed in as a parameter

   // start with infinity
   oLength = FLT_MAX;

   // ===================================================================
   // MINUS loop starting with "startingIndex"
   //
   // have to cast to (const MediaList&) before requesting 
   // const_reverse_iterator because of g++ problem
   MediaList::const_reverse_iterator itEnd      
      = ((const MediaList&)m_mediaList).rend(); 
   for( ;     // iIndex is starting point 
	iIndex != itEnd;
	++iIndex )
   {
      MCFBool withinSides;

#ifdef MKLDEBUG
      report( DEBUG ) 
	 << nameOf() << ":findNextMinusMedium: " << *iIndex << endl;
#endif

      // don't do efficient stuff for first-timers
      if( false == m_rookieParticle ) {

	 // skip if we have medium at same "distance"
	 Equidistantness status 
	    = isEquidistantMedium( iIndex.base()-1, iParticle, oLength );
	 if( HIT == status ) {
	    break;
	 }
	 else if( MISS == status ) {
	    continue;
	 }
	 
	 // break if particle is already passed 
	 // (else infinite loops, because of precision problems!)
	 if( true == particleSurpassedMinus( iIndex.base()-1, iParticle ) ) {

	    // refind next potential medium
	    MediaList::const_iterator temp = findFirstMedium( iParticle );
	    // if we couldn't initialize properly, better get out
	    if( m_mediaList.end() == temp ) {
	       oLength = FLT_MAX;
	       break;
	    }
	    MediaList::const_reverse_iterator revIndex( temp+1 );
	    iIndex = revIndex;
	 }
      }

      // now figure out distance to next medium
      oLength = (*iIndex)->distanceTo( iParticle, iLengthToBeat, withinSides );
      
      // -------- different cases to break out of loop -----------
      
      // if we can't find good next Medium, break (the next one will be
      // just as bad)
      if( oLength == FLT_MAX ) break;
      
      // if distance is "negative", don't go there; break
      if( oLength < 0 )
      { 
	 oLength = FLT_MAX;
	 break;
      }

      // (for efficiency) if the distance in the forward direction is 
      // farther than in the backward direction, we better get out
      if( oLength > iLengthToBeat ) break;

      // if distance is "positive" and within side limits, 
      // we found our candidate
      if( oLength >= 0 
	  && oLength < FLT_MAX 
	  && withinSides == true ) break;
      
      // if outside sides, do the right thing!
      if( false == withinSides ) continue;
      
   } 
   // if we didn't find a good medium
   if( ((const MediaList&)m_mediaList).rend() == iIndex ) oLength = FLT_MAX;

   return iIndex;
}

//
// const member functions
//
MediaTracer::Equidistantness
MediaTracer::isEquidistantMedium( const MediaList::const_iterator& iIndex,
				  const MCParticle& iParticle,
				  DFLOAT& oLength ) const
{
// --------------------------------------------------------------
// Algorithm: have to handle equidistant media:
//
// 1.) If (for just initialized media) the current Medium is the same
//     as the one the index is pointing to, don't bother.
// 2.) If there is an equidistant Medium:
//    a.) If the particle would hit it (withinSides == true),
//        then we should set the distance to zero and return true;
//    b.) If it wouldn't hit, return false;
// ---------------------------------------------------------------

   Equidistantness returnValue = MediaTracer::NOTEQUID;
   oLength = FLT_MAX;

   // if currentMedium and iIndex are the same medium, don't bother
   //if( *currentMedium() == *iIndex ) 
   if( currentMedium() == iIndex ) 
   {
      returnValue = MediaTracer::NOTEQUID;

   } else
   if( true == equidistantMedium( iIndex ) ) 
   {
      if( true == (*iIndex)->contains( iParticle.wtrack() ) )
      {
	 oLength = 0;
	 // cache distance (have to cast away const)
	 Medium* medium = (Medium*)(*iIndex);
	 medium->setDistanceTo( oLength );
	 medium->setWTrackTo( iParticle.wtrack() );
#ifdef MKLDEBUG
	 report( DEBUG )
	    << nameOf() << ":isEquiDistantMedium; will HIT " << endl;
#endif
	 returnValue = MediaTracer::HIT;
      }
      else
      {
#ifdef MKLDEBUG
      report( DEBUG ) 
	 << nameOf() << ":isEquiDistantMedium; will MISS " << *iIndex << endl;
#endif
	 returnValue = MediaTracer::MISS;
      }
   }
   else
   {
      returnValue = MediaTracer::NOTEQUID;
   }
   
   return returnValue;
}


// Printable interface
void
MediaTracer::printOn( ostream& str ) const
{
   str << "MediaTracer: I am not implemented yet!" << endl;
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
// Revision 1.19  1999/04/22 01:28:51  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.18  1998/11/21  00:14:49  mkl
// undo changes only for testing, inadvertantly submitted with previous Boolean --> MCFBool submission
//
// Revision 1.17  1998/11/20  23:47:54  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.16  1998/11/20  05:32:14  mkl
// more verbose findFirstMedium with nicer return type; update index after volume exit
//
// Revision 1.15  1998/11/03  17:43:32  mkl
// changes to compile under egcs
//
// Revision 1.14  1998/08/08  20:33:21  mkl
// speed improvements for curler handling
//
// Revision 1.13  1998/08/08  19:45:13  mkl
// rookie needs to be on a direction basis
//
// Revision 1.12  1998/08/04  19:43:43  mkl
// handle initialization properly in equidistant media handling
//
// Revision 1.11  1998/05/15  03:50:55  mkl
// first attempt at taking one step to new wtrack without using move_wtk_arc routine
//
// Revision 1.9  1998/03/18  15:28:44  mkl
// fix to isEquidistantMedium: compare indices, not media (though shouldn't matter)
//
// Revision 1.8  1998/02/18  05:11:55  mkl
// new improvement to handle all cases of equidistant media
//
// Revision 1.7  1998/02/17  22:58:29  mkl
// now handle equidistant media correctly for the first time; have to handle distance=0 correctly!
//
// Revision 1.6  1998/02/17  05:13:42  mkl
// always handle equal-distant media
//
// Revision 1.5  1998/02/15  01:55:37  mkl
// for DenseMedia, need base reactTo figure out if entering or leaving volume, and call implementReactTo if entering
//
// Revision 1.4  1997/11/22  20:25:58  mkl
// don't skip planes at same location
//
// Revision 1.3  1997/11/12  07:49:09  mkl
// major bug fixes (mostly reverse_iterator specific) -- now good agreement with fortran tracing found number of tracks
//
// Revision 1.2  1997/11/11  06:43:57  mkl
// beautification of debug print-out
//
// Revision 1.1  1997/11/11  01:17:35  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
//
//


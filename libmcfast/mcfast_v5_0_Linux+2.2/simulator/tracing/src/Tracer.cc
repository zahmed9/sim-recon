// -*- C++ -*-
//
// Package:     <Tracing>
// Module:      Tracer
// 
// Description: Tracing Algorithm for CompositeMedia
//
// Implementation:
//     <Notes on implementation>
//
// Author:      Martin Lohner
// Created:     Mon Oct 20 10:50:24 EDT 1997
//

//#include "Experiment/Experiment.h"

// system include files
#include <assert.h>
#include <float.h>
#include <math.h>
#include <vector>
#include <algorithm>

// user include files
#include "report.hh"
#include "functions.hh"
#include "Tracer.hh"
#include "Medium.hh"
#include "MCParticle.hh"
#include "CompositeMedium.hh"
#include "UserSettings.hh"
 
#include "RSurface.hh"
#include "ZSurface.hh"

//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Tracing.Tracer" ;

typedef vector<Medium*> MediumList;

//
// static data member definitions
//

//
// constructors and destructor
//
Tracer::Tracer( CompositeMedium& theMedium )
   : m_medium( theMedium ),
     m_rMediaTracer( *new RMediaTracer( theMedium.m_rMedia ) ),
     m_zMediaTracer( *new ZMediaTracer( theMedium.m_zMedia ) ),
     m_xMediaTracer( *new XMediaTracer( theMedium.m_xMedia ) ),
     m_yMediaTracer( *new YMediaTracer( theMedium.m_yMedia ) )
{
   if(    0 == &m_rMediaTracer
       || 0 == &m_zMediaTracer
       || 0 == &m_xMediaTracer
       || 0 == &m_yMediaTracer
      )
   {
      report( EMERGENCY, kFacilityString )
	 << "can't allocate  memory." << endl;
      assert( false );
      ::exit( 1 );
   }


   reset();
}

// Tracer::Tracer( const Tracer& )
// {
// }

Tracer::~Tracer()
{
   delete &m_rMediaTracer;
   delete &m_zMediaTracer;
   delete &m_xMediaTracer;
   delete &m_yMediaTracer;
}

//
// assignment operators
//
// const Tracer& Tracer::operator=( const Tracer& )
// {
// }

//
// member functions
//
// reset
void
Tracer::reset()
{
   m_rMediaTracer.reset();
   m_zMediaTracer.reset();
   m_xMediaTracer.reset();
   m_yMediaTracer.reset();
}


   // local class for functional object
   class Stuff 
   { 
      public:
	 Stuff( const char* const iName = "", 
		MediaTracer* iMediaTracer = 0 ) 
	    : m_name( iName ), 
	      m_arcLength( FLT_MAX ),
	      m_medium( 0 ),
              m_mediaTracer( iMediaTracer ) {}

	 const Stuff& operator=( const Stuff& iStuff ) {
	    if( this != &iStuff ) {
	       m_name = iStuff.m_name;
	       m_arcLength = iStuff.m_arcLength;
	       m_medium = iStuff.m_medium;
	       m_mediaTracer = iStuff.m_mediaTracer;
	    }
	 }

	 const char* m_name;
	 DFLOAT m_arcLength; 
	 const Medium* m_medium; 
	 MediaTracer* m_mediaTracer;
   };

   class comp_arcLength {
      public:
	 MCFBool operator()( const Stuff& x, const Stuff& y ) const {
	    // sort based on arcLength
	    return( ( x.m_arcLength < y.m_arcLength ) ? true: false );
	 }
   };


// Methods used in Tracking
const Medium*
Tracer::nextMediumTo( const MCParticle& particle )
{
   // find whichever we're going to hit first
   // whichever we're going to hit first
   const Medium* returnMedium=0;
   DFLOAT minArcLength = FLT_MAX;

   static vector< Stuff > stuff;
   static MCFBool first = true;
   if( true == first )
   {
      first = false;
      stuff.push_back( Stuff( "r", &m_rMediaTracer ) );
      stuff.push_back( Stuff( "z", &m_zMediaTracer ) );
      stuff.push_back( Stuff( "x", &m_xMediaTracer ) );
      stuff.push_back( Stuff( "y", &m_yMediaTracer ) );
   }

   // if the particle was going in one direction before, 
   // chances are it's still going in the same direction

   vector< Stuff >::iterator itEnd = stuff.end();
   for( vector< Stuff >::iterator it = stuff.begin();
	it != itEnd;
	++it )
   {
      (*it).m_medium
	 = (*it).m_mediaTracer->findNextMedium( particle, 
						(*it).m_arcLength,
						minArcLength // for speed
	    );

      // speed-up for planes at same location:
      // we KNOW this is the one!
      // the other loops will still contain the previous closest media,
      // which is fine!
      if( 0 == (*it).m_arcLength ) break; 
   }
					    

   // ------ now find medium for minimal distance ----------

   // sort so that the smallest arcLength Medium occupies the first location
   stable_sort( stuff.begin(), stuff.end(), comp_arcLength() );


   // update our "returnValues" with closest Medium
   if( !stuff.empty() )
   {
      vector< Stuff >::const_iterator first = stuff.begin();
      minArcLength = (*first).m_arcLength;

      // if the distance is still "infinity", we didn't find good next medium
      if( minArcLength == FLT_MAX ) 
      {
#ifdef MKLDEBUG
	 report( INFO, kFacilityString ) 
	    << "Tracer::nextMedium: no good next medium\n";
#endif
	 returnMedium = 0;
      }
      else
      {
	 returnMedium = (*first).m_medium;
      }
   }

   // update the first location index, and reset the rest;
   if( !stuff.empty() ) (*stuff.begin()).m_mediaTracer->updateIndex();

   vector< Stuff >::iterator itNewEnd = stuff.end();
   for( vector< Stuff >::iterator it = stuff.begin()+1;
	it != itNewEnd;
	++it )
   {
      // try for speed and safety! (instead of just resetting the index!)
      (*it).m_mediaTracer->reset();
      //(*it).m_mediaTracer->resetIndex();
   }

   
   return returnMedium;
}

//
// const member functions
//

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
// Revision 1.6  1998/11/20 23:48:02  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.5  1998/11/03  17:43:35  mkl
// changes to compile under egcs
//
// Revision 1.4  1998/02/18  05:12:27  mkl
// better comment about resetting all vs just index
//
// Revision 1.3  1998/02/17  05:12:25  mkl
// now do complete reset of media in non-progressing loops
//
// Revision 1.2  1997/11/22  20:26:07  mkl
// don't skip planes at same location
//
// Revision 1.1  1997/11/11  01:17:43  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//



#if !defined(TRACING_MEDIATRACER_H)
#define TRACING_MEDIATRACER_H
// -*- C++ -*-
//
// Package:     <Tracing>
// Module:      MediaTracer
// 
// Description: Base class for all Media tracers encapsulating the algorithm
//              to find the next medium.
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     Tue Oct 21 12:13:14 EDT 1997
//

// system include files
#include <float.h>
#include <vector>

// user include files
#include "cc_fortran_types.hh"

#include "Printable.hh"

// forward declarations
class Medium;
class MCParticle;

#if !defined(_mediatracer_medialist_)
#define _mediatracer_medialist_ vector<Medium*>
#endif

class MediaTracer : public Printable
{
      // friend classes and functions

   public:
      // constants, enums and typedefs

      // only used to speed things up!!!
      // when a particle has been going PLUS in the past, 
      // chances are, it is still going PLUS!
      enum Direction { PLUS=0, MINUS=1 };

      // Constructors and destructor
      MediaTracer( _mediatracer_medialist_& iMediaList );
      virtual ~MediaTracer();

      // member functions
      void reset();         // overall reset of indices etc.

      // order our entries (planes, volumes whatever)
      virtual void sortMedia() = 0; 

      virtual const Medium* findNextMedium( const MCParticle& particle,
					    DFLOAT& minArcLength,
					    DFLOAT& arcLengthToBeat );

      // accessor methods
      _mediatracer_medialist_& mediaList();
      _mediatracer_medialist_::const_iterator& currentMedium();
      _mediatracer_medialist_::const_iterator& previousMedium();

      void updateIndex();
      void resetIndex();

      // const member functions

      // accessor methods
      const _mediatracer_medialist_& mediaList() const;
      const _mediatracer_medialist_::const_iterator& currentMedium() const;
      const _mediatracer_medialist_::const_iterator& previousMedium() const;

      MCFBool needsInitialization() const;

      // Printable interface
      virtual const char* nameOf() const { return "MediaTracer"; }
      virtual void printOn( ostream& out=cout ) const;

      // static member functions

   protected:
      // protected member functions
      virtual _mediatracer_medialist_::const_iterator 
      findFirstMedium( const MCParticle& iParticle ) = 0;

      // allow derived classes to set 
      void setSorted( MCFBool flag );
      void setDirection( Direction );

      // protected const member functions
      MCFBool isSorted() const;

   private:
      // Constructors and destructor
      MediaTracer();                                      // stop default
      MediaTracer( const MediaTracer& );                  // stop default

      // assignment operator(s)
      const MediaTracer& operator=( const MediaTracer& ); // stop default

      // private member functions
      virtual _mediatracer_medialist_::const_iterator& 
      findNextPlusMedium( _mediatracer_medialist_::const_iterator&,
			  const MCParticle& iParticle,
			  DFLOAT& oLength, 
			  const DFLOAT iLengthToBeat=FLT_MAX );
      virtual _mediatracer_medialist_::const_reverse_iterator& 
      findNextMinusMedium( _mediatracer_medialist_::const_reverse_iterator&,
			   const MCParticle& iParticle,
			   DFLOAT& oLength, 
			   const DFLOAT iLengthToBeat=FLT_MAX );

      // private const member functions

      // need three conditions: either NOT equidistant, or if is
      // particle will hit it or now (because outside of frame!)
      enum Equidistantness { NOTEQUID=0, MISS, HIT };

      virtual Equidistantness
      isEquidistantMedium( 
	 const _mediatracer_medialist_::const_iterator& iIndex,
	 const MCParticle& iParticle,
	 DFLOAT& oLength ) const;

      virtual MCFBool equidistantMedium( 
	 const _mediatracer_medialist_::const_iterator& ) const = 0;
      virtual MCFBool particleSurpassedPlus( 
	 const _mediatracer_medialist_::const_iterator&,
	 const MCParticle& ) const = 0;
      virtual MCFBool particleSurpassedMinus( 
	 const _mediatracer_medialist_::const_iterator&,
	 const MCParticle& ) const = 0;

      // data members
      _mediatracer_medialist_& m_mediaList;
      _mediatracer_medialist_::const_iterator m_currentMedium;
      _mediatracer_medialist_::const_iterator m_previousMedium;

      Direction m_direction;

      MCFBool m_isSorted;

      MCFBool m_rookieParticle;

      // static data members

};

// inline function definitions

inline
ostream&
operator<<( ostream& os, const MediaTracer& m )
{
   m.printOn(os);
   return os;
}

inline
ostream&
operator<<( ostream& os, const MediaTracer* m )
{
   m->printOn(os);
   return os;
}

inline
void 
MediaTracer::reset()
{
   m_currentMedium = m_mediaList.end();
   m_previousMedium = m_mediaList.end();
}

inline
_mediatracer_medialist_& 
MediaTracer::mediaList()
{
   return m_mediaList;
}

inline
_mediatracer_medialist_::const_iterator& 
MediaTracer::currentMedium()
{
   return m_currentMedium;
}

inline
_mediatracer_medialist_::const_iterator& 
MediaTracer::previousMedium()
{
   return m_previousMedium;
}

inline
const _mediatracer_medialist_& 
MediaTracer::mediaList() const
{
   return m_mediaList;
}

inline
const _mediatracer_medialist_::const_iterator& 
MediaTracer::currentMedium() const
{
   return m_currentMedium;
}

inline
const _mediatracer_medialist_::const_iterator& 
MediaTracer::previousMedium() const
{
   return m_previousMedium;
}

inline
void 
MediaTracer::setSorted( MCFBool flag )
{
   m_isSorted = flag;
}

inline
void 
MediaTracer::setDirection( Direction direction )
{
   m_direction = direction;
}

inline
MCFBool
MediaTracer::isSorted() const
{
   return m_isSorted;
}

inline
MCFBool
MediaTracer::needsInitialization() const
{
   return( ( m_mediaList.end() == m_currentMedium ) ? true : false );
}

//#if defined(INCLUDE_TEMPLATE_DEFINITIONS)
// templated member function definitions
//# include "Tracing/Template/MediaTracer.cc"
//#endif


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:32  eugenio
// Initial revision
//
// Revision 1.11  1998/11/20 23:47:54  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.10  1998/11/20  05:32:15  mkl
// more verbose findFirstMedium with nicer return type; update index after volume exit
//
// Revision 1.9  1998/11/03  17:43:32  mkl
// changes to compile under egcs
//
// Revision 1.8  1998/08/08  19:45:13  mkl
// rookie needs to be on a direction basis
//
// Revision 1.7  1998/08/04  19:43:01  mkl
// use cpp macro to avoid typedef to localize member definition to one place
//
// Revision 1.6  1998/05/15  03:28:33  mkl
// inlined often-used functions to improve speed
//
// Revision 1.5  1998/02/18  05:11:55  mkl
// new improvement to handle all cases of equidistant media
//
// Revision 1.4  1998/02/17  22:58:30  mkl
// now handle equidistant media correctly for the first time; have to handle distance=0 correctly!
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

#endif /* TRACING_MEDIATRACER_H */

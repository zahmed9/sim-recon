#if !defined(TRACING_TRACEABLE_H)
#define TRACING_TRACEABLE_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      Traceable
//
// Description: Defines interface (and default implementations) 
//              for all Traceable "Things" (Surface, Volumes, etc.)
//
// Usage:
//
// Author:      Martin Lohner
// Created:     Nov 6, 1997

// system include files

// user include files
#include "cc_fortran_types.hh"

// forward declarations
class MCParticle;
#include "wtrack_struct.hh"


class Traceable
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      virtual ~Traceable();

      // member functions

      // for caching
      void setDistanceTo( const DFLOAT iDistance ) const;
      void setWTrackTo( const WTrackStruct& iWTrack ) const;

      // const member functions

      // return the distance along the track path
      virtual DFLOAT distanceTo( const MCParticle& iParticle,
				 DFLOAT iDistanceToBeat,
        			 MCFBool& oWithinSides ) const = 0;
      // cached version
      const DFLOAT distanceTo() const;
      const WTrackStruct& wtrackTo() const;

      // maximum step towards boundary; howMany if more than one
      virtual DFLOAT maxStep( const MCParticle& particle, 
			      int& howMany ) const;

      // is the point inside the Traceable?
      virtual MCFBool contains( const WTrackStruct& iWtrack ) const = 0;
      
      // within side walls?
      virtual MCFBool withinSides( const WTrackStruct& wtrack ) const;

      // static member functions

   protected:
      // protected member functions

      // Constructor
      Traceable();

      // assignment operator(s)
      const Traceable& operator=( const Traceable& iTraceable );

      // protected const member functions

   private:
      // Constructors and destructor
      Traceable( const Traceable& );

      // private member functions

      // private const member functions

      // data members
      // cached distance (should be "mutable"!)
      DFLOAT m_distanceTo;
      WTrackStruct m_wtrackTo;

      // static data members

};

// inline function definitions
inline
const DFLOAT 
Traceable::distanceTo() const 
{ 
   return m_distanceTo; 
}

inline
const WTrackStruct&
Traceable::wtrackTo() const 
{ 
   return m_wtrackTo;
}

// for caching (notice the funny implementation to get around lack 
// of the "mutable" keyword)
inline
void 
Traceable::setDistanceTo( const DFLOAT distance ) const 
{ 
   Traceable* const fakeThis = (Traceable* ) this;
   (*fakeThis).m_distanceTo = distance; 
}

inline
void 
Traceable::setWTrackTo( const WTrackStruct& wtrack ) const 
{ 
   Traceable* const fakeThis = (Traceable* ) this;
   (*fakeThis).m_wtrackTo = wtrack;
}

// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:33  eugenio
// Initial revision
//
// Revision 1.5  1999/04/22 01:28:57  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.4  1998/11/20  23:48:01  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.3  1998/05/15  03:50:58  mkl
// first attempt at taking one step to new wtrack without using move_wtk_arc routine
//
// Revision 1.2  1997/11/22  20:26:35  mkl
// keep track of fortran name of planes
//
// Revision 1.1  1997/11/11  01:17:42  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
//
//


#endif /* TRACING_TRACEABLE_H */

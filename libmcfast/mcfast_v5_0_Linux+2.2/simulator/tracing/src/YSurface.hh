#if !defined(TRACING_YSURFACE_H)
#define TRACING_YSURFACE_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      YSurface
//
// Description: Abstract BaseClass YSurface implements y behavior for Surfaces
//
// Usage:
//
// Author:      Martin Lohner
// Created:     Nov 6, 1997

// system include files

// user include files
#include "RectPlane.hh"

// forward declarations
class MCParticle;
class WTrackStruct;

class YSurface : public RectPlane
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      YSurface( float y=0,
		float xmin=0, float xmax=0, 
		float zmin=0, float zmax=0 );
      YSurface( const RectPlane& );
      YSurface( const YSurface& );
      virtual ~YSurface();

      // assignment operator(s)
      const YSurface& operator=( const YSurface& );

      // member functions

      // const member functions

      // clone operation
      virtual YSurface* clone() const;

      const float y() const { return ymin(); }

      // return the distance along the track path
      virtual DFLOAT distanceTo( const MCParticle& iParticle,
				 DFLOAT iDistanceToBeat,
				 MCFBool& oWithinSides ) const;

      // is the point inside the YSurface?
      virtual MCFBool contains( const WTrackStruct& iWTrack ) const;
      
      // within side boundaries?
      virtual MCFBool withinSides( const WTrackStruct& wtrack ) const;

      virtual void printOn( ostream& os = cout ) const;
      virtual const char* nameOf() const { return "YSurface"; }

      // fix for fortran routines
      virtual int type() const { return 3; }

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor

      // private member functions

      // private const member functions

      // data members

      // static data members

};

// inline function definitions

inline 
ostream& 
operator<<( ostream& os, const YSurface& v )
{
   v.printOn(os); 
   return os; 
}

inline 
ostream& 
operator<<( ostream& os, const YSurface* v )
{
   v->printOn(os); 
   return os;
}



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:33  eugenio
// Initial revision
//
// Revision 1.4  1999/04/22 01:29:01  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.3  1998/11/20  23:48:07  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.2  1997/11/22  20:26:36  mkl
// keep track of fortran name of planes
//
// Revision 1.1  1997/11/11  01:17:48  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
//


#endif /* TRACING_ZSURFACE_H */

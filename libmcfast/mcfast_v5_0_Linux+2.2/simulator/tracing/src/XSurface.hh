#if !defined(TRACING_XSURFACE_H)
#define TRACING_XSURFACE_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      XSurface
//
// Description: Abstract BaseClass XSurface implements x behavior for Surfaces
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

class XSurface : public RectPlane
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      XSurface( float x=0, 
		float ymin=0, float ymax=0, 
		float zmin=0, float zmax=0 );
      XSurface( const RectPlane& );
      XSurface( const XSurface& );
      virtual ~XSurface();

      // assignment operator(s)
      const XSurface& operator=( const XSurface& );

      // member functions

      // const member functions

      // clone operation
      virtual XSurface* clone() const;

      const float x() const { return xmin(); }

      // return the distance along the track path
      virtual DFLOAT distanceTo( const MCParticle& iParticle,
				 DFLOAT iDistanceToBeat,
				 MCFBool& oWithinSides ) const;

      // is the point inside the XSurface?
      virtual MCFBool contains( const WTrackStruct& iWTrack ) const;
      
      // within side boundaries?
      virtual MCFBool withinSides( const WTrackStruct& wtrack ) const;

      virtual void printOn( ostream& os = cout ) const;
      virtual const char* nameOf() const { return "XSurface"; }

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
operator<<( ostream& os, const XSurface& v )
{
   v.printOn(os); 
   return os; 
}

inline 
ostream& 
operator<<( ostream& os, const XSurface* v )
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
// Revision 1.4  1999/04/22 01:29:00  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.3  1998/11/20  23:48:05  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.2  1997/11/22  20:26:35  mkl
// keep track of fortran name of planes
//
// Revision 1.1  1997/11/11  01:17:47  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
//


#endif /* TRACING_ZSURFACE_H */

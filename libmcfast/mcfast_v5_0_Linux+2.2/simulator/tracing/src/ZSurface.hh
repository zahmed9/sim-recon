#if !defined(TRACING_ZSURFACE_H)
#define TRACING_ZSURFACE_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      ZSurface
//
// Description: Abstract BaseClass ZSurface implements z behavior for Surfaces
//
// Usage:
//
// Author:      Martin Lohner
// Created:     Jan 23, 1997

// system include files

// user include files
#include "Surface.hh"

// forward declarations
class MCParticle;
class WTrackStruct;

class ZSurface : public Surface
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      ZSurface( float z=0 );
      ZSurface( const ZSurface& );
      virtual ~ZSurface() = 0;

      // assignment operator(s)
      const ZSurface& operator=( const ZSurface& );

      // member functions

      // const member functions

      // eta of surface for given particle's wtrack parms
      virtual const DFLOAT* eta( const WTrackStruct& ) const;

      // clone operation
      virtual ZSurface* clone() const = 0;

      const float z() const { return m_z; }

      // return the distance along the track path
      virtual DFLOAT distanceTo( const MCParticle& iParticle,
				 DFLOAT iDistanceToBeat,
				 MCFBool& oWithinSides ) const;

      // is the point inside the ZSurface?
      virtual MCFBool contains( const WTrackStruct& iWTrack ) const = 0;
      
      // within side boundaries?
      virtual MCFBool withinSides( const WTrackStruct& wtrack ) const = 0;

      virtual void printOn( ostream& os = cout ) const = 0;
      virtual const char* nameOf() const { return "ZSurface"; }

      // fix for fortran routines
      virtual int type() const { return 2; }

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor

      // private member functions

      // private const member functions

      // data members
      float m_z;

      // static data members

};

// inline function definitions

inline 
ostream& 
operator<<( ostream& os, const ZSurface& v )
{
   v.printOn(os); 
   return os; 
}

inline 
ostream& 
operator<<( ostream& os, const ZSurface* v )
{
   v->printOn(os); 
   return os;
}



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:34  eugenio
// Initial revision
//
// Revision 1.7  1999/04/22 01:29:02  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.6  1998/11/20  23:48:11  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.5  1998/10/21  19:59:39  mkl
// implement eta correctly
//
// Revision 1.4  1997/11/22  20:26:37  mkl
// keep track of fortran name of planes
//
// Revision 1.3  1997/11/11  01:17:50  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.2  1997/08/27  03:31:49  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.1  1997/07/03  03:33:58  mkl
// new approach: surfaces vs volumes; box tracing
//
//


#endif /* TRACING_ZSURFACE_H */

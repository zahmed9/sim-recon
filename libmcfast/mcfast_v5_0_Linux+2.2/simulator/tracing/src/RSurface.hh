#if !defined(TRACING_RSURFACE_H)
#define TRACING_RSURFACE_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      RSurface
//
// Description: RSurface implements radial behavior for Surfaces.
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

class RSurface : public Surface
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      RSurface( float radius=0, float zmin=0, float zmax=0 );
      RSurface( const RSurface& );
      virtual ~RSurface();

      // assignment operator(s)
      const RSurface& operator=( const RSurface& );

      // member functions

      // const member functions

      // eta of surface for given particle's wtrack parms
      virtual const DFLOAT* eta( const WTrackStruct& ) const;

      // clone operation
      virtual RSurface* clone() const;

      const float radius() const { return m_radius; }
      const float zmin()   const { return m_zmin; }
      const float zmax()   const { return m_zmax; }

      // return the distance along the track path
      virtual DFLOAT distanceTo( const MCParticle& particle,
				 DFLOAT iDistanceToBeat,
				 MCFBool& oWithinSides ) const;

      // is the point inside the RSurface?
      virtual MCFBool contains( const WTrackStruct& iWTrack ) const;
      
      // within side walls?
      virtual MCFBool withinSides( const WTrackStruct& wtrack ) const;

      virtual void printOn( ostream& os = cout ) const;
      virtual const char* nameOf() const { return "RSurface"; }

      // fix for fortran routines
      virtual int type() const { return 1; }

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor

      // private member functions

      // private const member functions

      // data members
      float m_radius;
      float m_zmin, m_zmax;

      // static data members

};

// inline function definitions

inline 
ostream& 
operator<<( ostream& os, const RSurface& v )
{
   v.printOn(os); 
   return os; 
}

inline 
ostream& 
operator<<( ostream& os, const RSurface* v )
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
// Revision 1.6  1999/04/22 01:28:56  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.5  1998/11/20  23:47:58  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.4  1998/10/21  19:59:36  mkl
// implement eta correctly
//
// Revision 1.3  1997/11/22  20:26:34  mkl
// keep track of fortran name of planes
//
// Revision 1.2  1997/08/27  03:31:42  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.1  1997/07/03  03:33:53  mkl
// new approach: surfaces vs volumes; box tracing
//
//


#endif /* TRACING_RSURFACE_H */

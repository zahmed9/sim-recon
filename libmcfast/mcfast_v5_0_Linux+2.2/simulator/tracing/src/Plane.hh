#if !defined(TRACING_PLANE_H)
#define TRACING_PLANE_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      Plane
//
// Description: Plane Surface
//
// Usage:
//
// Author:      Martin Lohner
// Created:     June 25, 1997
//
// system include files

// user include files
#include "Surface.hh"
#include "Point.hh"
#include "Direction.hh"

// forward declarations
class MCParticle;
struct PlaneStruct;
struct WTrackStruct;


class Plane : public Surface
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      Plane( const Point& point, const Direction& normal );
      Plane( const Plane& );
      virtual ~Plane();

      // assignment operator(s)
      const Plane& operator=( const Plane& );

      // member functions

      // const member functions

      // clone operation
      virtual Plane* clone() const;

      const Point&     point()  const { return m_point; }
      const Direction& normal() const { return m_normal; }

      // eta of surface for given particle's wtrack parms
      virtual const DFLOAT* eta( const WTrackStruct& ) const;

      // return the distance along the track path
      virtual DFLOAT distanceTo( const MCParticle& particle,
				 DFLOAT iDistanceToBeat,
				 MCFBool& oWithinSides ) const;

      // is the point inside the Plane?
      virtual MCFBool contains( const WTrackStruct& iWTrack ) const;

      // within side walls?
      virtual MCFBool withinSides( const WTrackStruct& wtrack ) const;

      // return Fortran-ready structure (make sure to copy!)
      const PlaneStruct planeStruct() const;
      
      virtual void printOn( ostream& os = cout ) const;
      virtual const char* nameOf() const { return "Plane"; }

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor

      // private member functions

      // private const member functions

      // data members
      Point m_point;
      Direction m_normal;

      // static data members

};

// inline function definitions

inline 
ostream& 
operator<<( ostream& os, const Plane& v )
{
   v.printOn(os); 
   return os; 
}

inline 
ostream& 
operator<<( ostream& os, const Plane* v )
{
   v->printOn(os); 
   return os;
}



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:32  eugenio
// Initial revision
//
// Revision 1.6  1999/04/22 01:28:54  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.5  1998/11/20  23:47:56  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.4  1998/10/21  19:59:36  mkl
// implement eta correctly
//
// Revision 1.3  1997/11/22  20:26:32  mkl
// keep track of fortran name of planes
//
// Revision 1.2  1997/08/27  03:31:40  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.1  1997/07/03  03:33:52  mkl
// new approach: surfaces vs volumes; box tracing
//
//


#endif /* TRACING_PLANE_H */

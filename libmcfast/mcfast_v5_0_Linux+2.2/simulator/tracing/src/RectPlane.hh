#if !defined(TRACING_RECTPLANE_H)
#define TRACING_RECTPLANE_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      RectPlane
//
// Description: RectPlane Surface
//
//              The assumption made here is that a RectPlane is aligned with
//              one of the main axes (x, y, z).
//
// Usage:
//
// Author:      Martin Lohner
// Created:     June 25, 1997
//
// system include files

// user include files
#include "Plane.hh"

// forward declarations
class MCParticle;
class Point;
class Direction;
struct WTrackStruct;


class RectPlane : public Plane
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      RectPlane( const Point& point, const Direction& normal, 
		 DFLOAT xmin, DFLOAT xmax, 
		 DFLOAT ymin, DFLOAT ymax, 
		 DFLOAT zmin, DFLOAT zmax );
      RectPlane( const RectPlane& );
      virtual ~RectPlane();

      // assignment operator(s)
      const RectPlane& operator=( const RectPlane& );

      // member functions

      // const member functions

      // clone operation
      virtual RectPlane* clone() const;

      // is the point inside the RectPlane?
      virtual MCFBool contains( const WTrackStruct& iWTrack ) const;

      // within side walls?
      virtual MCFBool withinSides( const WTrackStruct& iWTrack ) const;

      const DFLOAT xmin() const { return m_xmin; }
      const DFLOAT xmax() const { return m_xmax; }
      const DFLOAT ymin() const { return m_ymin; }
      const DFLOAT ymax() const { return m_ymax; }
      const DFLOAT zmin() const { return m_zmin; }
      const DFLOAT zmax() const { return m_zmax; }

      virtual void printOn( ostream& os = cout ) const;
      virtual const char* nameOf() const { return "RectPlane"; }

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor

      // private member functions

      // private const member functions

      // data members
      // dimensions
      DFLOAT m_xmin, m_xmax, m_ymin, m_ymax, m_zmin, m_zmax;

      // static data members

};

// inline function definitions

inline 
ostream& 
operator<<( ostream& os, const RectPlane& v )
{
   v.printOn(os); 
   return os; 
}

inline 
ostream& 
operator<<( ostream& os, const RectPlane* v )
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
// Revision 1.6  1998/11/20 23:48:00  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.5  1998/10/21  19:59:37  mkl
// implement eta correctly
//
// Revision 1.4  1997/11/22  20:26:34  mkl
// keep track of fortran name of planes
//
// Revision 1.3  1997/11/11  01:17:40  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.2  1997/08/27  03:31:43  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.1  1997/07/03  03:33:53  mkl
// new approach: surfaces vs volumes; box tracing
//
//


#endif /* TRACING_RECTPLANE_H */

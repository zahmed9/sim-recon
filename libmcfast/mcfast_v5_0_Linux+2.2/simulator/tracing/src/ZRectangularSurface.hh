#if !defined(TRACING_ZRECTANGULARSURFACE_H)
#define TRACING_ZRECTANGULARSURFACE_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      ZRectangularSurface
//
// Description: ZRectangularSurface implements behavior for 
//              xy-shaped Z Surfaces.
//
// Usage:
//
// Author:      Martin Lohner
// Created:     Jan 23, 1997

// system include files

// user include files
#include "ZSurface.hh"

// forward declarations
class MCParticle;
class WTrackStruct;
class RectPlane;

class ZRectangularSurface : public ZSurface
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      ZRectangularSurface( float z=0, 
			   float xmin=0, float xmax=0,
			   float ymin=0, float ymax=0 );

      ZRectangularSurface( const RectPlane& );
      ZRectangularSurface( const ZRectangularSurface& );
      virtual ~ZRectangularSurface();

      // assignment operator(s)
      const ZRectangularSurface& operator=( const ZRectangularSurface& );

      // member functions

      // const member functions
      
      // clone operation
      virtual ZRectangularSurface* clone() const; 

      const float xmin() const { return m_xmin; }
      const float xmax() const { return m_xmax; }
      const float ymin() const { return m_ymin; }
      const float ymax() const { return m_ymax; }

      // is the point inside the ZRectangularSurface?
      virtual MCFBool contains( const WTrackStruct& iWTrack ) const;
      
      // within side walls?
      virtual MCFBool withinSides( const WTrackStruct& wtrack2 ) const;

      virtual void printOn( ostream& os = cout ) const;
      virtual const char* nameOf() const { return "ZRectangularSurface"; }

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor

      // private member functions

      // private const member functions

      // data members
      // m_z is member of ZSurface
      float m_xmin, m_xmax;
      float m_ymin, m_ymax;

      // static data members

};

// inline function definitions

inline 
ostream& 
operator<<( ostream& os, const ZRectangularSurface& v )
{
   v.printOn(os); 
   return os; 
}

inline 
ostream& 
operator<<( ostream& os, const ZRectangularSurface* v )
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
// Revision 1.5  1998/11/20 23:48:10  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.4  1997/11/22  20:26:37  mkl
// keep track of fortran name of planes
//
// Revision 1.3  1997/11/11  01:17:49  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.2  1997/08/27  03:31:49  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.1  1997/07/03  03:33:57  mkl
// new approach: surfaces vs volumes; box tracing
//
//


#endif /* TRACING_ZRECTANGULARSURFACE_H */

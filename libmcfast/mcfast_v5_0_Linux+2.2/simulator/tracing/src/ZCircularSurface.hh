#if !defined(TRACING_ZCIRCULARSURFACE_H)
#define TRACING_ZCIRCULARSURFACE_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      ZCircularSurface
//
// Description: ZCircularSurface implements behavior for 
//              circular-shape Z Surfaces.
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


class ZCircularSurface : public ZSurface
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      ZCircularSurface( float z=0, float rmin=0, float rmax=0 );
      ZCircularSurface( const ZCircularSurface& );
      virtual ~ZCircularSurface();

      // assignment operator(s)
      const ZCircularSurface& operator=( const ZCircularSurface& );

      // member functions

      // const member functions

      // clone operation
      virtual ZCircularSurface* clone() const;
      
      const float rmin() const { return m_rmin; }
      const float rmax() const { return m_rmax; }
 
      // is the point inside this surface?
      virtual MCFBool contains( const WTrackStruct& iWTrack ) const;
 
      // within side walls?
      virtual MCFBool withinSides( const WTrackStruct& wtrack ) const;

      virtual void printOn( ostream& os = cout ) const;
      virtual const char* nameOf() const { return "ZCircularSurface"; }

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor

      // private member functions

      // private const member functions

      // data members

      // z variable lives in ZSurface
      float m_rmin, m_rmax;

      // static data members

};

// inline function definitions

inline 
ostream& 
operator<<( ostream& os, const ZCircularSurface& v )
{
   v.printOn(os); 
   return os; 
}

inline 
ostream& 
operator<<( ostream& os, const ZCircularSurface* v )
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
// Revision 1.4  1998/11/20 23:48:08  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.3  1997/11/22  20:26:36  mkl
// keep track of fortran name of planes
//
// Revision 1.2  1997/08/27  03:31:47  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.1  1997/07/03  03:33:57  mkl
// new approach: surfaces vs volumes; box tracing
//
//


#endif /* TRACING_ZCIRCULARSURFACE_H */

#if !defined(TRACING_TUBE_H)
#define TRACING_TUBE_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      Tube
// 
// Description: Tube = 2 z-axis-aligned Cylinders with z boundaries
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     Sat Aug 20 22:48:41 CDT 1997
//

// system include files

// user include files
#include "Volume.hh"

// forward declarations
class RSurface;
class ZCircularSurface;
class MCParticle;
class VolumeVisitor;


class Tube : public Volume
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      Tube( const float rmin=0, const float rmax=0, 
	    const float zmin=0, const float zmax=0 );
      Tube( const Tube& );
      virtual ~Tube();

      // assignment operator(s)
      const Tube& operator=( const Tube& );

      // member functions
      void accept( VolumeVisitor& visitor );

      // const member functions

      virtual Tube* clone() const;

      // return the distance along the track path
      virtual DFLOAT distanceTo( const MCParticle& iParticle, 
				 DFLOAT iDistanceToBeat,
				 MCFBool& oWithinSides ) const;

      // is the point inside the volume?
      virtual MCFBool contains( const WTrackStruct& iWTrack ) const;
      
      virtual void printOn( ostream& os = cout ) const;
      virtual const char* nameOf() const { return "Tube"; }

      // simple accessor functions
      const int fortranIndex() const;
      const float rmin() const;
      const float rmax() const;
      const float zmin() const;
      const float zmax() const;

      const RSurface& innerCylinder() const;
      const RSurface& outerCylinder() const;
      const ZCircularSurface& zminRing() const;
      const ZCircularSurface& zmaxRing() const;

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor

      // private member functions

      // private const member functions

      // data members
      RSurface* m_innerCylinder;
      RSurface* m_outerCylinder;
      ZCircularSurface* m_zminRing;
      ZCircularSurface* m_zmaxRing;

      float m_rmin; // needed for special case rmin==-1

      // static data members

};

// inline function definitions

inline
ostream&
operator<<( ostream& os, const Tube& v )
{
   v.printOn(os);
   return os;
}

inline
ostream&
operator<<( ostream& os, const Tube* v )
{
   v->printOn(os);
   return os;
}                                    

inline
const RSurface&
Tube::innerCylinder() const
{
   return *m_innerCylinder;
}

inline
const RSurface&
Tube::outerCylinder() const
{
   return *m_outerCylinder;
}

inline
const ZCircularSurface&
Tube::zminRing() const
{
   return *m_zminRing;
}

inline
const ZCircularSurface&
Tube::zmaxRing() const
{
   return *m_zmaxRing;
}



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:33  eugenio
// Initial revision
//
// Revision 1.6  1999/04/22 01:28:58  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.5  1998/11/20  23:48:02  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.4  1997/11/11  01:17:44  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.3  1997/08/27  03:31:45  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.2  1997/08/25  19:23:05  mkl
// new Visitor classes to keep from cluttering volume class
//
// Revision 1.1  1997/08/23  01:10:15  mkl
// toward volume-based tracing
//
//


#endif /* TRACING_TUBE_H */

#if !defined(TRACING_VOLUME_H)
#define TRACING_VOLUME_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      Volume
//
// Description: abstract base class for all volumes;
//              defined in terms of surfaces; 
//              has the notion of inside and outside
//
//              It derives from "Surface" to enable us to use the 
//              Composite Pattern (see the "Design Patterns" book):
//                one should be able to ask a generic surface how far
//                the distance is from our current location.
//
// Usage:
//
// Author:      Martin Lohner
// Created:     June 25, 1997

// system include files
#include <vector>

// user include files
#include "cc_fortran_types.hh"
#include "Surface.hh"

// forward declarations
//class Point;
class MCParticle;
struct WTrackStruct;
class VolumeVisitor; 


class Volume : public Surface
{
      // friend classses and functions

   public:
      // constants, enums and typedefs
      // ugly, but necessary: for error checking with fortran!
      enum ShapeType { kNone=0, kBox, kCylinder, kCone };

      // Constructors and destructor
      virtual ~Volume();

      // member functions
      virtual void accept( VolumeVisitor& ) = 0;

      // const member functions

      // eta of surface for given particle's wtrack parms
      // should be pure!
      // virtual const DFLOAT* eta( const WTrackStruct& ) const = 0;
      virtual const DFLOAT* eta( const WTrackStruct& ) const;

      // clone operation
      virtual Volume* clone() const = 0;

      // return the distance along the track path
      virtual DFLOAT distanceTo( const MCParticle& iParticle, 
				 DFLOAT iDistanceToBeat,
				 MCFBool& oWithinSides ) const;

      // is the point inside the volume?
      virtual MCFBool contains( const WTrackStruct& iWtrack ) const = 0;
      
      // how far to exit (assuming point is inside)
      virtual DFLOAT distanceToExit( const MCParticle& iParticle ) const;

      // I/O
      virtual void printOn( ostream& os = cout ) const;
      virtual const char* nameOf() const { return "Volume"; }

      // static member functions

   protected:
      // protected member functions
      void insert( Surface* );
      vector<Surface*>& surfaces() { return m_surfaces; }

      // Constructor
      Volume();

      // assignment operator
      const Volume& operator=( const Volume& volume );

      // protected const member functions
      const vector<Surface*>& surfaces() const { return m_surfaces; }

   private:
      // Constructors and destructor
      Volume( const Volume& );

      // private member functions
      void deleteSurfaceList();

      // private const member functions

      // data members
      vector<Surface*> m_surfaces;

      // static data members

};

// inline function definitions

inline 
ostream& 
operator<<( ostream& os, const Volume& v )
{
   v.printOn(os); 
   return os; 
}

inline 
ostream& 
operator<<( ostream& os, const Volume* v )
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
// Revision 1.12  1999/04/22 01:28:59  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.11  1998/11/20  23:48:04  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.10  1998/11/03  17:43:36  mkl
// changes to compile under egcs
//
// Revision 1.9  1998/10/21  19:59:38  mkl
// implement eta correctly
//
// Revision 1.8  1997/11/11  01:17:44  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.7  1997/08/27  03:31:46  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.6  1997/08/25  19:23:05  mkl
// new Visitor classes to keep from cluttering volume class
//
// Revision 1.5  1997/08/23  01:10:16  mkl
// toward volume-based tracing
//
// Revision 1.4  1997/08/01  20:56:34  mkl
// forward declare stl containers
//
// Revision 1.3  1997/07/03  03:33:56  mkl
// new approach: surfaces vs volumes; box tracing
//
//


#endif /* TRACING_VOLUME_H */

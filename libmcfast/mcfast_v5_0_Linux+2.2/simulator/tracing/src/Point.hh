#if !defined(TRACING_POINT_H)
#define TRACING_POINT_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      Point
//
// Description: Point is a 3-DIM space Point
//
// Usage:
//
// Author:      Martin Lohner
// Created:     June 25, 1997

// system include files

// user include files
#include "Vector.hh"

// forward declarations
class WTrackStruct;      // only for convenience

class Point : public Vector
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      Point( const DFLOAT x=0, const DFLOAT y=0, const DFLOAT z=0 );
      Point( const WTrackStruct& wtrack );  // only for convenience
      //Point( const Point& );
      virtual ~Point();

      // assignment operator(s)
      //const Point& operator=( const Point& );

      // member functions

      // const member functions

      virtual void printOn( ostream& os = cout ) const;
      virtual const char* nameOf() const { return "Point"; }

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
operator<<( ostream& os, const Point& v )
{
   v.printOn(os); 
   return os; 
}

inline 
ostream& 
operator<<( ostream& os, const Point* v )
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
// Revision 1.1  1997/07/03 03:33:52  mkl
// new approach: surfaces vs volumes; box tracing
//
//


#endif /* TRACING_POINT_H */

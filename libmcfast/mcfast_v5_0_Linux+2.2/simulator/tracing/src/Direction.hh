#if !defined(TRACING_DIRECTION_H)
#define TRACING_DIRECTION_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      Direction
//
// Description: Direction is a 3-DIM space Direction with cosx, cosy, cosz
//              It is the same as what Paul calls "eta[1..3]".
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

class Direction : public Vector
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      Direction( const DFLOAT cosx=0, const DFLOAT cosy=0, const DFLOAT cosz=0 );
      Direction( const WTrackStruct& wtrack );  // only for convenience
      //Direction( const Direction& );
      virtual ~Direction();

      // assignment operator(s)
      //const Direction& operator=( const Direction& );

      // member functions

      // const member functions

      virtual void printOn( ostream& os = cout ) const;
      virtual const char* nameOf() const { return "Direction"; }

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
operator<<( ostream& os, const Direction& v )
{
   v.printOn(os); 
   return os; 
}

inline 
ostream& 
operator<<( ostream& os, const Direction* v )
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
// Revision 1.1  1997/07/03 03:33:48  mkl
// new approach: surfaces vs volumes; box tracing
//
//


#endif /* TRACING_DIRECTION_H */

#if !defined(TRACING_VECTOR_H)
#define TRACING_VECTOR_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      Vector
//
// Description: Vector is a 3-DIM Vector with 3 components
//
// Usage:
//
// Author:      Martin Lohner
// Created:     June 25, 1997

// system include files

// user include files
#include "cc_fortran_types.hh"
#include "Printable.hh"

// forward declarations

class Vector : public Printable
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      Vector( DFLOAT x=0, DFLOAT y=0, DFLOAT z=0 );
      //Vector( const Vector& );
      virtual ~Vector();

      // assignment operator(s)
      //const Vector& operator=( const Vector& );

      // member functions

      // const member functions

      const float x() const { return m_x; }
      const float y() const { return m_y; }
      const float z() const { return m_z; }

      virtual void printOn( ostream& os = cout ) const;
      virtual const char* nameOf() const { return "Vector"; }

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor

      // private member functions

      // private const member functions

      // data members
      DFLOAT m_x, m_y, m_z;

      // static data members

};

// inline function definitions

inline 
ostream& 
operator<<( ostream& os, const Vector& v )
{
   v.printOn(os); 
   return os; 
}

inline 
ostream& 
operator<<( ostream& os, const Vector* v )
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
// Revision 1.3  1997/11/11 01:17:44  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.2  1997/08/01  20:56:34  mkl
// forward declare stl containers
//
// Revision 1.1  1997/07/03  03:33:55  mkl
// new approach: surfaces vs volumes; box tracing
//
//


#endif /* TRACING_VECTOR_H */

#if !defined(TRACING_PRINTABLE_H)
#define TRACING_PRINTABLE_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      Printable
// 
// Description: 
//              Interface class for simple I/O
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     Jan 23, 1997
// RCS(Id)
//
// Revision history
//
// RCS(Log)

// system include files
#include <iostream.h>

// user include files

// forward declarations


class Printable
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      Printable();
      virtual ~Printable() = 0;

      // member functions

      // const member functions
      virtual const char* nameOf() const=0;
      virtual void printOn( ostream& out=cout ) const=0;

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor
      //Printable( const Printable& );

      // assignment operator(s)
      //const Printable& operator=( const Printable& );

      // private member functions

      // private const member functions

      // data members

      // static data members

};

// inline function definitions
inline 
ostream& 
operator<<( ostream& os, const Printable& g )
{
   g.printOn( os ); 
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
// Revision 1.1  1997/11/11 01:17:37  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
//


#endif /* TRACING_GEOMOBJECT_H */

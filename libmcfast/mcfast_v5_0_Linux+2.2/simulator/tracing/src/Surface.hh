#if !defined(TRACING_SURFACE_H)
#define TRACING_SURFACE_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      Surface
//
// Description: Defines abstract base class for all Surfaces
//
// Usage:
//
// Author:      Martin Lohner
// Created:     Jan 23, 1997
// RCS(Id)
//
// Revision history
//
// RCS(Log)

// system include files

// user include files
#include "cc_fortran_types.hh"
#include "Traceable.hh"
#include "Printable.hh"

// forward declarations
struct WTrackStruct;


class Surface : public Traceable, public Printable
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      virtual ~Surface();

      // member functions

      // const member functions

      // eta of surface for given particle's wtrack parms
      virtual const DFLOAT* eta( const WTrackStruct& ) const = 0;

      // clone operation
      virtual Surface* clone( void ) const = 0;

      // return the distance along the track path
      virtual void printOn( ostream& os = cout ) const {}
      virtual const char* nameOf() const { return "Surface"; }

      // fix for fortran routines
      virtual int type() const;

      // static member functions

   protected:
      // protected member functions

      // Constructor
      Surface();

      // assignment operator(s)
      const Surface& operator=( const Surface& iSurface );

      // protected const member functions

   private:
      // Constructors and destructor
      Surface( const Surface& );

      // private member functions

      // private const member functions

      // data members

      // static data members

};

// inline function definitions

inline 
ostream& 
operator<<( ostream& os, const Surface& v )
{
   v.printOn(os); 
   return os; 
}

inline 
ostream& 
operator<<( ostream& os, const Surface* v )
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
// Revision 1.5  1998/10/21 19:59:37  mkl
// implement eta correctly
//
// Revision 1.4  1997/11/11  01:17:41  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.3  1997/08/27  03:31:44  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.2  1997/08/01  20:56:33  mkl
// forward declare stl containers
//
// Revision 1.1  1997/07/03  03:33:54  mkl
// new approach: surfaces vs volumes; box tracing
//
//


#endif /* TRACING_SURFACE_H */

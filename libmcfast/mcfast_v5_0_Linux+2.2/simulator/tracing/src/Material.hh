#if !defined(TRACING_MATERIAL_H)
#define TRACING_MATERIAL_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      Material
//
// Description: Base class (abstract). Not much here, just a space holder!
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

// user include files
#include "cc_fortran_types.hh"
#include "Printable.hh"

// forward declarations
class MCParticle;


class Material : public Printable
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      Material();
      //Material( const Material& );
      virtual ~Material() = 0;

      // member functions

      // const member functions
      
      virtual Material* clone() const = 0;

      virtual MCFBool interactWith( MCParticle& particle ) const = 0;
      
      virtual float radLength()  const = 0;
      virtual float dedx()       const = 0;
      virtual float collLength() const = 0;
      virtual float absLength()  const = 0;

      virtual void printOn( ostream& os = cout ) const;
      virtual const char* nameOf() const { return "Material"; }

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor

      // assignment operator(s)
      //const Material& operator=( const Material& );

      // private member functions

      // private const member functions

      // data members

      // static data members

};

// inline function definitions
// inline function definitions

inline
ostream&
operator<<( ostream& os, const Material& m )
{
   m.printOn(os);
   return os;
}

inline
ostream&
operator<<( ostream& os, const Material* m )
{
   m->printOn(os);
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
// Revision 1.8  1998/11/20 23:47:54  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.7  1998/02/16  04:33:42  mkl
// first version of 2ndary interactions
//
// Revision 1.6  1997/11/11  20:14:32  mkl
// doCorrections --> interactWith
//
// Revision 1.5  1997/11/11  01:17:34  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.4  1997/08/02  02:59:42  mkl
// RealMaterial and AssociatedMaterial derive from placeholder Material
//
// Revision 1.3  1997/08/01  20:56:32  mkl
// forward declare stl containers
//
// Revision 1.2  1997/03/15  19:02:21  mkl
// moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
// fixed commend headers for .inc files from # to c.
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//


#endif /* TRACING_MATERIAL_H */


#if !defined(TRACING_MATERIALLOOKUPTABLE_H)
#define TRACING_MATERIALLOOKUPTABLE_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      MaterialLookupTable
//
// Description: is Container of Materials.
//              A material can be found by name. 
//              Implemented as Singleton.
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner, Julia Yarba
// Created:     Aug 1, 1997
// RCS(Id)
//
// Revision history
//
// RCS(Log)

// system include files
#include <string>
#include <map>

// user include files
#include "cc_fortran_types.hh"
#include "Printable.hh"

// forward declarations
class Material ;

class MaterialLookupTable : public Printable
{
      // friend classses and functions
      friend class Dummy {};  // to get around compiler warning

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      virtual ~MaterialLookupTable();

      // member functions

      // const member functions
      const Material* get( const string& name ) const;

      // implemented for Printable
      virtual void printOn( ostream& os = cout ) const;
      virtual const char* nameOf() const { return "MaterialLookupTable"; }

      // static member functions
      static MaterialLookupTable* instance( void );
      static void destroy( void );

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor
      MaterialLookupTable();
      MaterialLookupTable( const MaterialLookupTable& );

      // assignment operator(s)
      const MaterialLookupTable& operator=( const MaterialLookupTable& );
      
      // private member functions

      // private const member functions

      // data members

      map< string, Material*, less<string> > m_mapOfMaterials;

      // static data members
      static MaterialLookupTable* m_instance;

};

// inline function definitions
// inline function definitions

inline
ostream&
operator<<( ostream& os, const MaterialLookupTable& m )
{
   m.printOn(os);
   return os;
}

inline
ostream&
operator<<( ostream& os, const MaterialLookupTable* m )
{
   m->printOn(os);
   return os;
}



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:29  eugenio
// Initial revision
//
// Revision 1.6  1998/11/03 17:44:01  mkl
// changes to compile under egcs
//
// Revision 1.5  1998/06/29  21:52:59  yarba_j
// derives from Printable, not PrintableObject
//
// Revision 1.4  1997/11/12  22:04:25  yarba_j
// updated use of real materials for volume based tracing
//
// Revision 1.2  1997/08/02  19:38:39  mkl
// minor
//
// Revision 1.1  1997/08/01  20:48:05  mkl
// Map of Materials
//
//


#endif /* TRACING_MATERIALLOOKUPTABLE_H */


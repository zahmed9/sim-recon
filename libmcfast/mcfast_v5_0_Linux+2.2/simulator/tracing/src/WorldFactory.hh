#if !defined(TRACING_WORLDFACTORY_H)
#define TRACING_WORLDFACTORY_H
// -*- C++ -*-
//
// Package:     <Tracing>
// Module:      WorldFactory
// 
// Description: static factory: creates the detector = world
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     Mon Oct 20 10:40:36 EDT 1997
// $Id$
//
// Revision history
//
// $Log$
// Revision 1.1  2000/06/19 19:59:33  eugenio
// Initial revision
//
// Revision 1.1  1997/11/11 01:17:46  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//

// system include files

// user include files

// forward declarations
class CompositeMedium;
class Dummy; // only here to get rid of stupid g++ warning messages

class WorldFactory
{
      // friend classes and functions
      friend Dummy; // only here to get rid of stupid g++ warning messages

   public:
      // constants, enums and typedefs

      // Constructors and destructor

      // member functions

      // const member functions

      // static member functions
      static CompositeMedium* createWorld();

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor
      WorldFactory();                                      // stop default
      virtual ~WorldFactory();                             // stop default

      WorldFactory( const WorldFactory& );                 // stop default

      // assignment operator(s)
      const WorldFactory& operator=( const WorldFactory& );// stop default

      // private member functions

      // private const member functions

      // data members

      // static data members
      static CompositeMedium* s_worldInstance;

};

// inline function definitions

//#if defined(INCLUDE_TEMPLATE_DEFINITIONS)
// templated member function definitions
//# include "Tracing/Template/WorldFactory.cc"
//#endif


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:33  eugenio
// Initial revision
//
// Revision 1.1  1997/11/11 01:17:46  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
//
//

#endif /* TRACING_WORLDFACTORY_H */

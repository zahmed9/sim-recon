#if !defined(TRACING_TRACER_H)
#define TRACING_TRACER_H
// -*- C++ -*-
//
// Package:     <Tracing>
// Module:      Tracer
// 
// Description: Tracing Algorithm in CompositeMedia
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     Mon Oct 20 10:50:23 EDT 1997
//

// system include files

// user include files
#include "cc_fortran_types.hh"
#include "RMediaTracer.hh"
#include "ZMediaTracer.hh"
#include "XMediaTracer.hh"
#include "YMediaTracer.hh"

// forward declarations
class MCParticle;
class Medium;
class CompositeMedium;

class Tracer
{
      // friend classes and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      Tracer( CompositeMedium& theMedium );
      virtual ~Tracer();

      // member functions
      const Medium* nextMediumTo( const MCParticle& particle );

      //const Medium* nextBoxMedium( const MCParticle& particle,
      //			   DFLOAT& distance,
      //			   DFLOAT& distanceToBeat );

      void reset(); // reset state

      // const member functions

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor
      Tracer( const Tracer& );

      // assignment operator(s)
      const Tracer& operator=( const Tracer& );

      // private member functions

      // private const member functions

      // data members

      // target
      const CompositeMedium& m_medium;

      // individual tracers
      RMediaTracer& m_rMediaTracer;
      ZMediaTracer& m_zMediaTracer;
      XMediaTracer& m_xMediaTracer;
      YMediaTracer& m_yMediaTracer;

      // static data members

};

// inline function definitions


//#if defined(INCLUDE_TEMPLATE_DEFINITIONS)
// templated member function definitions
//# include "Tracing/Template/Tracer.cc"
//#endif

// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:33  eugenio
// Initial revision
//
// Revision 1.2  1998/11/03 17:43:35  mkl
// changes to compile under egcs
//
// Revision 1.1  1997/11/11  01:17:43  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//

#endif /* TRACING_TRACER_H */

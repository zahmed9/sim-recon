#if !defined(TRACING_ZMEDIATRACER_H)
#define TRACING_ZMEDIATRACER_H
// -*- C++ -*-
//
// Package:     <Tracing>
// Module:      ZMediaTracer
// 
// Description: <one line class summary>
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     Tue Oct 21 12:13:28 EDT 1997

// system include files

// user include files
#include "MediaTracer.hh"

// forward declarations

class ZMediaTracer : public MediaTracer
{
      // friend classes and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      ZMediaTracer( _mediatracer_medialist_& iMediaList );
      virtual ~ZMediaTracer();

      // member functions
      virtual void sortMedia();

      // const member functions

      // Printable interface
      virtual const char* nameOf() const { return "ZMediaTracer"; }
      virtual void printOn( ostream& out=cout ) const;

      // static member functions

   protected:
      // protected member functions
      virtual _mediatracer_medialist_::const_iterator 
      findFirstMedium( const MCParticle& iParticle );

      // protected const member functions

   private:
      // Constructors and destructor
      ZMediaTracer();                                      // stop default
      ZMediaTracer( const ZMediaTracer& );                 // stop default

      // assignment operator(s)
      const ZMediaTracer& operator=( const ZMediaTracer& );// stop default

      // private member functions

      // private const member functions
      virtual MCFBool equidistantMedium( 
	 const vector<Medium*>::const_iterator& ) const;
      virtual MCFBool particleSurpassedPlus( 
	 const vector<Medium*>::const_iterator&,
	 const MCParticle& ) const;
      virtual MCFBool particleSurpassedMinus( 
	 const vector<Medium*>::const_iterator&,
	 const MCParticle& ) const;

      // data members

      // static data members

};

// inline function definitions

inline
ostream&
operator<<( ostream& os, const ZMediaTracer& m )
{
   m.printOn(os);
   return os;
}

inline
ostream&
operator<<( ostream& os, const ZMediaTracer* m )
{
   m->printOn(os);
   return os;
}

//#if defined(INCLUDE_TEMPLATE_DEFINITIONS)
// templated member function definitions
//# include "Tracing/Template/ZMediaTracer.cc"
//#endif


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:34  eugenio
// Initial revision
//
// Revision 1.5  1998/11/20 23:48:09  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.4  1998/11/20  05:32:18  mkl
// more verbose findFirstMedium with nicer return type; update index after volume exit
//
// Revision 1.3  1998/11/03  17:43:39  mkl
// changes to compile under egcs
//
// Revision 1.2  1997/11/12  07:49:12  mkl
// major bug fixes (mostly reverse_iterator specific) -- now good agreement with fortran tracing found number of tracks
//
// Revision 1.1  1997/11/11  01:17:49  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
//
//

#endif /* TRACING_ZMEDIATRACER_H */

#if !defined(TRACING_ABSORBER_H)
#define TRACING_ABSORBER_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      Absorber
// 
// Description: derived class of Detector:
//              It's ONLY purpose is to STOP a particle.
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     June 25, 1997

// system include files

// user include files
#include "Detector.hh"

// forward declarations
class MCParticle;
class ostream;


class Absorber : public Detector
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      Absorber();
      Absorber( const Absorber& );
      virtual ~Absorber();

      // assignment operator(s)
      const Absorber& operator=( const Absorber& );

      // member functions

      // const member functions

      // clone operation
      virtual Absorber* clone() const;

      virtual const char* nameOf() const { return "Absorber"; }

      // display 
      virtual void printOn( ostream& ) const {}

      // All detectors must specify what they will do 
      // when traversed by a particle
      virtual MCFBool generateResponse( MCParticle&, 
					MCFBool& oHitActiveArea,
					DFLOAT = 0 ) const;

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
operator<<( ostream& os, const Absorber& d )
{
   d.printOn(os);
   return os;
}

inline 
ostream& 
operator<<( ostream& os, const Absorber* d )
{
   d->printOn(os);
   return os;
}



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:31  eugenio
// Initial revision
//
// Revision 1.5  1998/11/20 23:47:46  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.4  1998/08/04  22:58:33  mkl
// implemented Detector::generateResponse with extra output argument: oHitActiveArea; only if true, do material effects
//
// Revision 1.3  1997/12/09  00:33:33  yarba_j
// generateResponse( MCParticle& ) -> generateResponse( MCParticle&, DFLOAT (signal) = 0 )
//
// Revision 1.2  1997/11/20  21:20:31  mkl
// make virtual member function nameOf() explicit
//
// Revision 1.1  1997/07/03  03:33:44  mkl
// new approach: surfaces vs volumes; box tracing
//
//


#endif /* TRACING_ABSORBER_H */

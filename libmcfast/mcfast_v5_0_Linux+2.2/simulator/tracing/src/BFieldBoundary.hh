#if !defined(TRACING_BFIELDBOUNDARY_H)
#define TRACING_BFIELDBOUNDARY_H
// -*- C++ -*-
//
// Package:     <Tracing>
// Module:      BFieldBoundary
// 
// Description: BFieldBoundary "Detector" to record trace at 
//              boundary between bfields
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     Thu Nov 20 11:14:08 CST 1997
//

// system include files

// user include files
#include "Detector.hh"

// forward declarations

class BFieldBoundary : public Detector
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      BFieldBoundary();
      BFieldBoundary( const BFieldBoundary& );
      virtual ~BFieldBoundary();

      // assignment operator(s)
      const BFieldBoundary& operator=( const BFieldBoundary& );

      // member functions

      // const member functions
      virtual MCFBool generateResponse( MCParticle&, 
					MCFBool& oHitActiveArea,
					DFLOAT = 0 ) const;

      virtual void printOn( ostream& ) const;

      virtual Detector* clone() const;

      virtual const char* nameOf() const { return "BFieldBoundary"; }

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
operator<<( ostream& os, const BFieldBoundary& d )
{
   d.printOn(os);
   return os;
}

inline 
ostream& 
operator<<( ostream& os, const BFieldBoundary* d )
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
// Revision 1.4  1998/11/20 23:47:44  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.3  1998/08/04  22:58:31  mkl
// implemented Detector::generateResponse with extra output argument: oHitActiveArea; only if true, do material effects
//
// Revision 1.2  1997/12/09  00:33:32  yarba_j
// generateResponse( MCParticle& ) -> generateResponse( MCParticle&, DFLOAT (signal) = 0 )
//
// Revision 1.1  1997/11/20  21:18:39  mkl
// new BFieldBoundary Detector to record traces on field boundaries
//


#endif /* TRACING_BFIELDBOUNDARY_H */

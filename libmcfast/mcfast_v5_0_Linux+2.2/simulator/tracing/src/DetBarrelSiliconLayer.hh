#if !defined(TRACING_BARRELSILICONLAYER_H)
#define TRACING_BARRELSILICONLAYER_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      BarrelSiliconLayer
// 
// Description: derived class of Detector
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
#include "Detector.hh"

// forward declarations
class MCParticle;
//struct HitStruct;
class ostream;


class BarrelSiliconLayer : public Detector
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      BarrelSiliconLayer();
      BarrelSiliconLayer( const BarrelSiliconLayer& );
      virtual ~BarrelSiliconLayer();

      // assignment operator(s)
      const BarrelSiliconLayer& operator=( const BarrelSiliconLayer& );

      // member functions

      // const member functions

      // clone operation
      virtual BarrelSiliconLayer* clone() const;

      virtual const char* nameOf() const { return "BarrelSiliconLayer"; }

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

      void findPlaneCoordinates( int plane, DFLOAT position[3] ) const;
      MCFBool scoreHit( int plane, MCParticle& particle, 
			int& hitIndexF ) const;
      //MCFBool scoreHit( int plane, MCParticle& particle, 
      //                  const HitStruct*& pHit, int& hitIndexF ) const;

      // data members

      // static data members

};

// inline function definitions

inline 
ostream& 
operator<<( ostream& os, const BarrelSiliconLayer& d )
{
   d.printOn(os);
   return os;
}

inline 
ostream& 
operator<<( ostream& os, const BarrelSiliconLayer* d )
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
// Revision 1.5  1998/11/20 23:47:47  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.4  1998/08/04  22:58:33  mkl
// implemented Detector::generateResponse with extra output argument: oHitActiveArea; only if true, do material effects
//
// Revision 1.3  1997/12/09  00:33:34  yarba_j
// generateResponse( MCParticle& ) -> generateResponse( MCParticle&, DFLOAT (signal) = 0 )
//
// Revision 1.2  1997/11/20  21:20:41  mkl
// make virtual member function nameOf() explicit
//
// Revision 1.1.1.1  1997/03/14  22:52:34  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//


#endif /* TRACING_BARRELSILICONLAYER_H */

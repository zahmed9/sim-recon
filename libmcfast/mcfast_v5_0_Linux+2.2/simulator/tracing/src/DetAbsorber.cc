// -*- C++ -*-
//
// Package:     Tracing
// Module:      Absorber
// 
// Description: Absorber absorbs (stops) particle.
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     June 25, 1997

// system include files

// user include files
#include "cc_fortran_types.hh"
#include "report.hh"
#include "DetAbsorber.hh"
#include "MCParticle.hh"

//
// constants, enums and typedefs
//

//
// static data member definitions
//

//
// constructors and destructor
//
Absorber::Absorber()
{
}

Absorber::Absorber( const Absorber& detector )
{
   *this = detector;
}

Absorber::~Absorber()
{
}

//
// assignment operators
//
const Absorber& 
Absorber::operator=( const Absorber& detector )
{
   if( this != &detector ) 
   {
      Detector::operator=( detector );
   }

   return *this;
}

//
// member functions
//
//
// const member functions
//

// clone operation
Absorber*
Absorber::clone() const
{
   return new Absorber(*this);
}

MCFBool
Absorber::generateResponse( MCParticle& particle, 
			    MCFBool& oHitActiveArea,
			    DFLOAT signal ) const
{
   // Absorber: stop particle

   MCFBool returnValue = true;
   oHitActiveArea = true;

   // plan: stop all particles, except muons

   if( !particle.isMuon() ) {

      // add an absorption trace
      particle.addTrace( TraceType::kAbsorb );

      // absorb particle
      particle.setStatus( MCParticle::ABSORBED );

   }
   else { // is muon

      particle.addTrace( TraceType::kDummy );
   }


   return returnValue;
}

//
// static member functions
//


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:31  eugenio
// Initial revision
//
// Revision 1.7  1998/11/20 23:47:46  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.6  1998/08/04  22:58:32  mkl
// implemented Detector::generateResponse with extra output argument: oHitActiveArea; only if true, do material effects
//
// Revision 1.5  1998/02/17  22:56:02  mkl
// handle ala Fortran: absorb everything but muons
//
// Revision 1.4  1998/02/16  21:30:04  mkl
// added new TraceType class that deals with trace types exclusively
//
// Revision 1.3  1997/12/09  17:58:01  yarba_j
// minor cleaup
//
// Revision 1.2  1997/12/09  00:33:33  yarba_j
// generateResponse( MCParticle& ) -> generateResponse( MCParticle&, DFLOAT (signal) = 0 )
//
// Revision 1.1  1997/07/03  03:33:44  mkl
// new approach: surfaces vs volumes; box tracing
//
//



// -*- C++ -*-
//
// Package:     <Tracing>
// Module:      BFieldBoundary
// 
// Description: <one line class summary>
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     Thu Nov 20 11:14:12 CST 1997
//

// system include files

// user include files
#include "report.hh"
#include "BFieldBoundary.hh"
#include "MCParticle.hh"

// STL classes

//
// constants, enums and typedefs
//

//
// static data member definitions
//

//
// constructors and destructor
//
BFieldBoundary::BFieldBoundary()
{
}

BFieldBoundary::BFieldBoundary( const BFieldBoundary& bfieldBoundary )
{
   *this = bfieldBoundary;
}

BFieldBoundary::~BFieldBoundary()
{
}

//
// assignment operators
//
const BFieldBoundary& BFieldBoundary::operator=( 
   const BFieldBoundary& bfieldBoundary )
{
   if( this != &bfieldBoundary )
   {
      Detector::operator=( bfieldBoundary );
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
Detector* 
BFieldBoundary::clone() const
{
   return new BFieldBoundary( *this );
}

MCFBool 
BFieldBoundary::generateResponse( MCParticle& particle, 
				  MCFBool& oHitActiveArea,
				  DFLOAT signal ) const
{
   // only need to record trace at this point

   MCFBool returnValue = true;
   oHitActiveArea = false;

   // record dummy trace here
   particle.addTrace( TraceType::kBFieldBoundary );

   return returnValue;
}

void 
BFieldBoundary::printOn( ostream& ) const
{
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
// Revision 1.6  1998/11/20 23:47:44  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.5  1998/08/04  22:58:31  mkl
// implemented Detector::generateResponse with extra output argument: oHitActiveArea; only if true, do material effects
//
// Revision 1.4  1998/02/16  21:30:03  mkl
// added new TraceType class that deals with trace types exclusively
//
// Revision 1.3  1997/12/09  17:58:01  yarba_j
// minor cleaup
//
// Revision 1.2  1997/12/09  00:33:32  yarba_j
// generateResponse( MCParticle& ) -> generateResponse( MCParticle&, DFLOAT (signal) = 0 )
//
// Revision 1.1  1997/11/20  21:18:36  mkl
// new BFieldBoundary Detector to record traces on field boundaries
//



// -*- C++ -*-
//
// Package:     Tracing
// Module:      DriftChamberCathode
// 
// Description: Detector-based class implementing DriftChamber Cathodes.
//
// Implimentation:
//     <Notes on implimentation>
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
#include "DetDriftChamberCathode.hh"
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
DriftChamberCathode::DriftChamberCathode()
{
}

DriftChamberCathode::DriftChamberCathode( const DriftChamberCathode& detector )
{
   *this = detector;
}

DriftChamberCathode::~DriftChamberCathode()
{
}

//
// assignment operators
//
const DriftChamberCathode& 
DriftChamberCathode::operator=( const DriftChamberCathode& detector )
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
DriftChamberCathode*
DriftChamberCathode::clone() const
{
   return new DriftChamberCathode(*this);
}

MCFBool
DriftChamberCathode::generateResponse( MCParticle& particle,
				       MCFBool& oHitActiveArea,
                                       DFLOAT signal ) const
{
   int returnValue = 0;
   oHitActiveArea = false;

   return returnValue;
}

MCFBool
DriftChamberCathode::scoreHit( int plane, 
			       MCParticle& particle ) const
{
   MCFBool returnValue = true;
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
// Revision 1.7  1998/11/20 23:47:48  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.6  1998/08/04  22:58:35  mkl
// implemented Detector::generateResponse with extra output argument: oHitActiveArea; only if true, do material effects
//
// Revision 1.5  1997/12/09  17:58:03  yarba_j
// minor cleaup
//
// Revision 1.4  1997/12/09  00:33:36  yarba_j
// generateResponse( MCParticle& ) -> generateResponse( MCParticle&, DFLOAT (signal) = 0 )
//
// Revision 1.3  1997/11/21  04:16:29  mkl
// comment fix
//
// Revision 1.2  1997/03/15  19:02:18  mkl
// moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
// fixed commend headers for .inc files from # to c.
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//



// -*- C++ -*-
//
// Package:     Tracing
// Module:      DriftChamberAnode
// 
// Description: Detector-based class implementing DriftChamber Anodes.
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
#include <assert.h>

// user include files
#include "cc_fortran_types.hh"
#include "DetDriftChamberAnode.hh"
#include "MCParticle.hh"
#include "report.hh"

extern "C" {
   void trk_make_drift_hit_( const integer& hep,
			     const integer& traceIndex,
			     const WTrackStruct& w, 
			     const integer& dev, 
			     const integer& lyr, 
			     const BFieldStruct& bf,
			     integer& hitIndex,
			     integer& error );
}

//
// constants, enums and typedefs
//

//
// static data member definitions
//

//
// constructors and destructor
//
DriftChamberAnode::DriftChamberAnode()
{
}

DriftChamberAnode::DriftChamberAnode( const DriftChamberAnode& detector )
{
   *this = detector;
}

DriftChamberAnode::~DriftChamberAnode()
{
}

//
// assignment operators
//
const DriftChamberAnode& 
DriftChamberAnode::operator=( const DriftChamberAnode& detector )
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
DriftChamberAnode*
DriftChamberAnode::clone() const
{
   return new DriftChamberAnode(*this);
}

MCFBool
DriftChamberAnode::generateResponse( MCParticle& particle, 
				     MCFBool& oHitActiveArea,
                                     DFLOAT signal ) const
{
   //
   //     Drift Chamber Anode ... we're at the Layer, just make hit
   //

   MCFBool returnValue = true;
   oHitActiveArea = false;

   // now see if we can score a hit
   int hitIndexF=0;
   
   // if the Particle is charged
   if( particle.isCharged() ) 
   {
      // create hit
      MCFBool status = scoreHit( particle, hitIndexF );
      if( false == status ) {
	 return returnValue = false;
      }
      if( hitIndexF > 0 ) {
	 oHitActiveArea = true;
      }
   }
   
   // now adding trace with attached hit (if there was a hit, hitIndex>0)
   particle.addTrace( TraceType::kRPlane, hitIndexF );


   return returnValue;
}

MCFBool
DriftChamberAnode::scoreHit( MCParticle& particle, 
			     int& oHitIndexF ) const
{
   MCFBool returnValue = true;
   oHitIndexF=0; 

   assert( particle.hepIndexF() > 0 );

   integer error=0;
   //fake traceIndex; used to be: trace_cent_num+1;
   integer centralTraceIndex=0; 
   trk_make_drift_hit_( particle.hepIndexF(), 
			centralTraceIndex,
			particle.wtrack(),
			deviceIndexF(),
			layerIndexF(), 
			particle.bfield(), 
			oHitIndexF, 
			error );
   
   if( error != 0 ) {
      report( ERROR ) << "error in trk_make_bsil_hit" << "\n";
      if( 1 ==  error ) {
	 report( ERROR ) << "too many hits" << "\n";
      }
      particle.setStatus( MCParticle::STOPPED );
      returnValue = false;
   }
   else if( oHitIndexF <= 0 ) { // no hit made because didn't hit wire
#ifdef MKLDEBUG
      report( WARNING ) << "DetDriftChamberAnode::scoreHit: hitIndexF=" 
			<< oHitIndexF << "\n";
#endif
      ;
   }
   else {
      particle.addHit( oHitIndexF );
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
// Revision 1.9  1998/11/20 23:47:47  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.8  1998/08/04  22:58:34  mkl
// implemented Detector::generateResponse with extra output argument: oHitActiveArea; only if true, do material effects
//
// Revision 1.7  1998/02/16  21:30:05  mkl
// added new TraceType class that deals with trace types exclusively
//
// Revision 1.6  1997/12/09  17:58:03  yarba_j
// minor cleaup
//
// Revision 1.5  1997/12/09  00:33:35  yarba_j
// generateResponse( MCParticle& ) -> generateResponse( MCParticle&, DFLOAT (signal) = 0 )
//
// Revision 1.4  1997/11/21  18:55:34  mkl
// replace TraceType::kDummy with TraceType::kRZPlane
//
// Revision 1.3  1997/07/03  03:33:45  mkl
// new approach: surfaces vs volumes; box tracing
//
// Revision 1.2  1997/03/15  19:02:17  mkl
// moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
// fixed commend headers for .inc files from # to c.
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//



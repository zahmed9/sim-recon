// -*- C++ -*-
//
// Package:     Tracing
// Module:      SiliconDiskLayer
// 
// Description: Detector-based class implementing SiliconDisk Layers.
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
#include "DetSiliconDiskLayer.hh"
#include "MCParticle.hh"
#include "report.hh"

extern "C" {
   void trk_find_sidisk_plane_( const WTrackStruct& w,
				const integer& deviceIndexF, 
				const integer& layerIndexF, 
				const integer& firstWedgeIndexF, 
				integer& hitWedgeIndexF, 
				logical& struckPlane,
				DFLOAT eta[3] );

   void trk_make_sidisk_hit_( const integer& hep, 
			      const integer& traceIndex, 
			      const WTrackStruct& w,  
			      const integer& dev,  
			      const integer& lyr, 
			      const integer& jwedge, 
			      const logical& struckPlane,
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
SiliconDiskLayer::SiliconDiskLayer()
{
}

SiliconDiskLayer::SiliconDiskLayer( const SiliconDiskLayer& detector )
{
   *this = detector;
}

SiliconDiskLayer::~SiliconDiskLayer()
{
}

//
// assignment operators
//
const SiliconDiskLayer& 
SiliconDiskLayer::operator=( const SiliconDiskLayer& detector )
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
SiliconDiskLayer*
SiliconDiskLayer::clone() const
{
   return new SiliconDiskLayer(*this);
}

MCFBool
SiliconDiskLayer::generateResponse( MCParticle& particle, 
				    MCFBool& oHitActiveArea,
                                    DFLOAT signal ) const
{
   //
   //     Silicon Disk Layer ... find which plane was hit
   //
   MCFBool returnValue = true;
   oHitActiveArea = false;

   logical struckPlane=0;
   DFLOAT eta[3]={0};
   integer hitWedgeIndexF=0;

   trk_find_sidisk_plane_( particle.wtrack(), 
			   deviceIndexF(), 
			   layerIndexF(), 
			   wedgeIndexF(), 
			   hitWedgeIndexF, 
			   struckPlane, 
			   eta );

   // if plane struck
   if( struckPlane != 0 ) {

      // now see if we can score a hit
      int hitIndexF=0;
 
      // if the Particle is charged
      if( particle.isCharged() ) {

	 // create hit
	 MCFBool status = scoreHit( struckPlane, 
				    hitWedgeIndexF, 
				    particle, 
				    hitIndexF );
	 if( false == status ) {
	    return returnValue = false;
	 }
	 if( hitIndexF > 0 ) {
	    oHitActiveArea = true;
	 }
      }

      // now adding trace with attached hit
      particle.addTrace( TraceType::kZPlane, hitIndexF );
   }
   else { // didn't find any struck plane
      // add  dummy trace
      particle.addTrace( TraceType::kZPlane );
   }      

   return returnValue;
}

MCFBool
SiliconDiskLayer::scoreHit( logical struckPlane, integer hitWedgeIndexF, 
			    MCParticle& particle, 
			    int& oHitIndexF ) const
{
   MCFBool returnValue = true;
   oHitIndexF=0; 

   assert( particle.hepIndexF() > 0 );

   integer error=0;
   //fake traceIndex; used to be: trace_cent_num+1;
   integer centralTraceIndex=0; 
   trk_make_sidisk_hit_( particle.hepIndexF(), 
			 centralTraceIndex,
			 particle.wtrack(),
			 deviceIndexF(),
			 layerIndexF(), 
			 hitWedgeIndexF,
			 struckPlane, 
			 particle.bfield(), 
			 oHitIndexF, 
			 error );
   
   if( error != 0 ) {
      report( ERROR ) << "trk_make_sidisk_hit: Too Many Hits" << "\n";
      if( 1 == error ) {
	 report( ERROR ) << "too many hits" << "\n";
      }
      particle.setStatus( MCParticle::STOPPED );
      returnValue = false;
   }
   else if( oHitIndexF <= 0 ) { // no hit made because outside waver
#ifdef MKLDEBUG
      report( WARNING ) << "DetSiliconDiskLayer::scoreHit: hitIndexF=" 
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
// Revision 1.1  2000/06/19 19:59:32  eugenio
// Initial revision
//
// Revision 1.9  1998/11/20 23:47:49  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.8  1998/08/04  22:58:36  mkl
// implemented Detector::generateResponse with extra output argument: oHitActiveArea; only if true, do material effects
//
// Revision 1.7  1998/02/16  21:30:06  mkl
// added new TraceType class that deals with trace types exclusively
//
// Revision 1.6  1997/12/09  17:58:04  yarba_j
// minor cleaup
//
// Revision 1.5  1997/12/09  00:33:37  yarba_j
// generateResponse( MCParticle& ) -> generateResponse( MCParticle&, DFLOAT (signal) = 0 )
//
// Revision 1.4  1997/11/21  18:55:35  mkl
// replace TraceType::kDummy with TraceType::kRZPlane
//
// Revision 1.3  1997/07/03  03:33:46  mkl
// new approach: surfaces vs volumes; box tracing
//
// Revision 1.2  1997/03/15  19:02:18  mkl
// moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
// fixed commend headers for .inc files from # to c.
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//



// -*- C++ -*-
//
// Package:     Tracing
// Module:      XYPixelPlane
// 
// Description: Detector-based class implementing XY Pixel Detectors.
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
#include "tracingCPPFlags.inc"

#include "cc_fortran_types.hh"
#include "DetXYPixelPlane.hh"
#include "MCParticle.hh"
#include "report.hh"

extern "C" {

   void trk_find_siz_rect_( const WTrackStruct& w,
			    const integer& deviceIndexF,
			    const integer& layerIndexF,
			    integer& wafer,
			    logical& struckPlane,
			    DFLOAT eta[3] );

   void trk_make_siz_rect_hit_( const integer& hep, 
				const integer& traceIndex, 
				const WTrackStruct& w,  
				const integer& dev,  
				const integer& lyr, 
				const integer& wafer,
				const logical& struckPlane,
				integer& hitIndex,
				integer& error );

}

//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Tracing.DetXYPixelPlane";

//
// static data member definitions
//

//
// constructors and destructor
//
XYPixelPlane::XYPixelPlane()
{
}

XYPixelPlane::XYPixelPlane( const XYPixelPlane& detector )
{
   *this = detector;
}

XYPixelPlane::~XYPixelPlane()
{
}

//
// assignment operators
//
const XYPixelPlane& 
XYPixelPlane::operator=( const XYPixelPlane& detector )
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
XYPixelPlane*
XYPixelPlane::clone() const
{
   return new XYPixelPlane(*this);
}

MCFBool
XYPixelPlane::generateResponse( MCParticle& particle, 
				MCFBool& oHitActiveArea,
				DFLOAT signal ) const
{
   //
   //     XY Pixel Plane Layer ... find which plane was hit
   //
   MCFBool returnValue = true;
   oHitActiveArea = false;

   logical struckPlane=0;
   integer waferNumber=0;
   DFLOAT eta[3]={0};

   trk_find_siz_rect_( particle.wtrack(), 
		       deviceIndexF(), 
		       layerIndexF(), 
		       waferNumber,
		       struckPlane, 
		       eta );

   // if plane struck
   if( struckPlane != 0 
       && waferNumber > 0 
      ) 
   {

      oHitActiveArea = true;

      // now see if we can score a hit
      int hitIndexF=0;
 
      // if the Particle is charged
      if( particle.isCharged() ) {

	 // create hit
	 MCFBool status = scoreHit( struckPlane, 
				    waferNumber, 
				    particle, 
				    hitIndexF );

	 if( false == status ) {
	    return returnValue = false;
	 }

      }

      // now adding trace with attached hit
      particle.addTrace( TraceType::kZPlane, hitIndexF );
   }
   else { // didn't find any struck plane
      // add  dummy trace
      // commented out because fortran does too 
     //   particle.addTrace( TraceType::kZPlane );
   }      

   return returnValue;
}

MCFBool
XYPixelPlane::scoreHit( const logical iStruckPlane, 
			const integer iWaferNumber,
			MCParticle& particle, 
			int& oHitIndexF ) const
{
   MCFBool returnValue = true;
   oHitIndexF=0;

   assert( particle.hepIndexF() > 0 );

   integer error=0;
   // fake traceIndex; used to be: trace_cent_num+1;
   integer centralTraceIndex=0; 

   trk_make_siz_rect_hit_( particle.hepIndexF(), 
                           centralTraceIndex,
			   particle.wtrack(),
			   deviceIndexF(),
			   layerIndexF(), 
			   iWaferNumber,
			   iStruckPlane, 
			   oHitIndexF, 
			   error );

   if( error != 0 ) {
      report( ERROR ) << "error in trk_make_siz_rect_hit" << "\n";
      if( 1 == error ) {
	 report( ERROR ) << "too many hits" << endl;
      }
      particle.setStatus( MCParticle::STOPPED );
      returnValue = false;
   }
   else if( oHitIndexF <= 0 ) { // no hit made because outside waver
#ifdef MKLDEBUG
      report( WARNING, kFacilityString ) 
	 << "DetXYPixelPlane::scoreHit: hitIndexF=" 
	 << oHitIndexF 
	 << endl;
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
// Revision 1.14  2000/02/07 21:01:50  kutschke
// oHitActiveArea now means did it hit any material at all.
//
// Revision 1.13  1998/11/20  23:47:50  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.12  1998/08/14  02:04:15  kutschke
// Do not add unneeded trace points.
//
// Revision 1.11  1998/08/11  17:06:37  mkl
// cleaned out OLD_ZSIXY handling
//
// Revision 1.10  1998/08/04  22:58:37  mkl
// implemented Detector::generateResponse with extra output argument: oHitActiveArea; only if true, do material effects
//
// Revision 1.9  1998/02/18  00:37:39  mkl
// had mixed-up args for (fortran) call to trk_make_siz_rect_hit and trk_find_siz_rect
//
// Revision 1.8  1998/02/16  21:30:06  mkl
// added new TraceType class that deals with trace types exclusively
//
// Revision 1.7  1997/12/09  17:58:04  yarba_j
// minor cleaup
//
// Revision 1.6  1997/12/09  00:33:38  yarba_j
// generateResponse( MCParticle& ) -> generateResponse( MCParticle&, DFLOAT (signal) = 0 )
//
// Revision 1.5  1997/11/21  18:55:36  mkl
// replace TraceType::kDummy with TraceType::kRZPlane
//
// Revision 1.4  1997/11/13  03:59:24  mkl
// switch from zsixy to siz_rect silicon pixel detectors
//
// Revision 1.3  1997/07/03  03:33:46  mkl
// new approach: surfaces vs volumes; box tracing
//
// Revision 1.2  1997/03/15  19:02:19  mkl
// moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
// fixed commend headers for .inc files from # to c.
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//



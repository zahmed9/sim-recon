// -*- C++ -*-
//
// Package:     Tracing
// Module:      BarrelSiliconLayer
// 
// Description: Detector-based class implementing Barrel Silicon wafers.
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
#include "report.hh"
#include "UserSettings.hh"

#include "DetBarrelSiliconLayer.hh"
#include "MCParticle.hh"

#include "externFortran.hh"

extern "C" {
   void trk_find_bsil_plane_( const WTrackStruct& w,
			      const DFLOAT& arc,
			      const BFieldStruct& bf,
			      const integer& deviceIndexF, 
			      const integer& layerIndexF, 
			      integer planes[2], 
			      logical struckPlane[2], 
			      DFLOAT etas[2][3] );

   void trk_make_bsil_hit_( const integer& hep, 
			    const integer& traceIndex, 
			    const WTrackStruct& w, 
			    const integer& dev, 
			    const integer& lyr, 
			    const integer& pln,
			    const BFieldStruct& bf,
			    integer& hitIndex,
			    integer& error );

   void find_bsil_plane_pos_( integer& dev, 
			      integer& lyr, 
			      integer& plane, 
			      DFLOAT position[3] );

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
BarrelSiliconLayer::BarrelSiliconLayer()
{
}

BarrelSiliconLayer::BarrelSiliconLayer( const BarrelSiliconLayer& detector )
{
   *this = detector;
}

BarrelSiliconLayer::~BarrelSiliconLayer()
{
}

//
// assignment operators
//
const BarrelSiliconLayer& 
BarrelSiliconLayer::operator=( const BarrelSiliconLayer& detector )
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
BarrelSiliconLayer*
BarrelSiliconLayer::clone() const
{
   return new BarrelSiliconLayer(*this);
}

MCFBool
BarrelSiliconLayer::generateResponse( MCParticle& particle, 
				      MCFBool& oHitActiveArea,
                                      DFLOAT signal ) const
{
//     Barrel silicon layer ... find which plane was hit
//     This portion of the code allows overlapping strips, so it finds
//     2 planes.
//        if(type .eq. jrpl_sibarrel) then

   MCFBool returnValue = true;
   oHitActiveArea = false;

   // IMPORTANT: the current geometry setup places the "other"
   // side of the wafer on a second "plane"; but since this routine
   // traces the particle to the actual wafer location away from
   // the "ideal" cylindrical location, the second side will never
   // get considered, unless we do something special here.
   // I consider this a short-coming of the geometry setup,
   // not a short-coming of the c++ tracing code.
   // So: before moving away from "ideal" location, save and reset later
   WTrackStruct wtrackIdeal = particle.wtrack();

   // find struck wafers
   integer planes[2]={-1, -1};
   logical struckPlane[2]={0};
   DFLOAT etas[2][3]={0};
   trk_find_bsil_plane_( particle.wtrack(),
			 particle.path().arc,
			 particle.bfield(), 
			 deviceIndexF(), 
			 layerIndexF(), 
			 planes, 
			 struckPlane, 
			 etas );

   // there are two possible planes struck
   for( int i=0; i<2; ++i ) {

      // if plane struck
      if( struckPlane[i] != 0 ) {

	 // Move the track to the plane
	 DFLOAT position[3];
	 findPlaneCoordinates( planes[i], position );

	 DFLOAT arcLength;
	 int status = move_wtk_xyplane_( particle.wtrack(), 
					 position, 
					 &etas[i][0], 
					 particle.bfield(), 
					 particle.wtrack(), 
					 arcLength );

	 if( status != 0 ) {
	    report( ERROR ) << "DetBarrelSiliconLayer::generateResponse:"
			    << " can't move to particle to detector!"
			    << " will simply return" << "\n";
	    return returnValue=false;
	 }

	 //Update path info
	 particle.updatePath( arcLength );

	 // now see if we can score a hit
	 int hitIndexF=0;
 
	 // if the Particle is charged
	 if( particle.isCharged() ) {
	    // create hit
	    MCFBool status = scoreHit( planes[i], particle, hitIndexF );
	    if( false == status ) {
	       return returnValue = false;
	    }
// oHitActiveArea=true always if hit plane since hitIndex maybe 0 because of efficiency
//	    if( hitIndexF > 0 ) {
	       oHitActiveArea = true;
//	    }
	 }

	 // now adding trace with attached hit
	 particle.addTrace( TraceType::kRPlane, hitIndexF );
	 // reset eta on trace so that it reflects eta of wafer
	 TraceStruct* tr = (TraceStruct*)&(particle.traceList().back().traceInfo()) ;
	 for ( int itr=0; itr<3; itr++)
	    tr->eta[itr] = etas[i][itr] ;
      }
      else {
	 particle.addTrace( TraceType::kRPlane );
      }
   }

   // reset wtrack of particle to "ideal" location; see explanation above
   particle.wtrack() = wtrackIdeal;


   return returnValue;
}

void 
BarrelSiliconLayer::findPlaneCoordinates( int plane, DFLOAT position[3] ) const
{
   int device = deviceIndexF();
   int layer = layerIndexF();

   find_bsil_plane_pos_( device, layer, plane, position );
}      


MCFBool
BarrelSiliconLayer::scoreHit( int plane, 
			      MCParticle& particle, 
			      int& oHitIndexF ) const
{
   MCFBool returnValue = true;
   oHitIndexF=0; 

   integer error=0;

   //fake traceIndex; used to be: trace_cent_num+1;
   integer centralTraceIndex=0; 

   assert( particle.hepIndexF() > 0 ); // this should never happen

   trk_make_bsil_hit_( particle.hepIndexF(), 
		       centralTraceIndex,
		       particle.wtrack(),
		       deviceIndexF(),
		       layerIndexF(), 
		       plane, 
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
   else if( oHitIndexF <= 0 ) { // no hit made because outside waver
#ifdef MKLDEBUG
      report( WARNING ) << "DetBarrelSiliconLayer::scoreHit: hitIndexF=" 
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
// Revision 1.11  1999/06/16 22:42:53  yarba_j
// use correct normal to a given bsvx wafer when do hit generation and/or mscat/dedx
//
// Revision 1.10  1998/11/20  23:47:46  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.9  1998/08/04  22:58:33  mkl
// implemented Detector::generateResponse with extra output argument: oHitActiveArea; only if true, do material effects
//
// Revision 1.8  1998/08/04  19:45:25  mkl
// preserve ideal wtrack and reset particle to that after making hits and saving traces
//
// Revision 1.7  1998/02/16  21:30:04  mkl
// added new TraceType class that deals with trace types exclusively
//
// Revision 1.6  1997/12/09  17:58:02  yarba_j
// minor cleaup
//
// Revision 1.5  1997/12/09  00:33:34  yarba_j
// generateResponse( MCParticle& ) -> generateResponse( MCParticle&, DFLOAT (signal) = 0 )
//
// Revision 1.4  1997/11/21  18:55:34  mkl
// replace TraceType::kDummy with TraceType::kRZPlane
//
// Revision 1.3  1997/07/03  03:33:44  mkl
// new approach: surfaces vs volumes; box tracing
//
// Revision 1.2  1997/03/15  19:02:16  mkl
// moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
// fixed commend headers for .inc files from # to c.
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//



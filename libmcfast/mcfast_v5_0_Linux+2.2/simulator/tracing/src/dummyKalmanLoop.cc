// -*- C++ -*-
//
// Package:     Tracing
// Module:      dummyKalmanLoop
// 
// Description:
//
//   example for Rob's Kalman fitter of how to access tracing and hit info
//
// Implimentation:
//
// Author:      Martin Lohner
// Created:     Jan 31, 1997
// RCS(Id)
//
// Revision history
//
// RCS(Log)

// system include files
#include <fstream.h>
#include <vector>

// user include files
#include "cc_fortran_types.hh"
#include "report.hh"
#include "fortranAccess.hh"

#include "dummyKalmanLoop.hh"

#include "MCParticle.hh"
#include "Trace.hh"

// forward declarations

//
// constants, enums and typedefs
//

//
// static data member definitions
//
#include "dummyVectorInstantiator.hh"


//-------------------------------------------------------
// as an example for Rob, do a dummy Kalman loop
//-------------------------------------------------------
void
dummyKalmanLoop( const MCParticle& particle )
{

   const vector<Trace>& traceList=particle.traceList();

   int nFirstHit=0;
   MCFBool firstHit = true;
//      for( vector<Trace>::const_iterator trace=traceList.begin(); 
//           trace != traceList.end(); 
//           trace++ ) {
   for( int j=0; j<traceList.size(); ++j )
   {
	 // get structures and pass them to Fortran access routines

	 const TraceStruct& traceInfo = traceList[j].traceInfo();
	 rob_traceinfo_( traceInfo );

	 // for hits, either check on hit pointer (!=0)
	 //const HitStruct* hit = traceList[j].hit();
	 //if( hit != 0 ) {  
	 //   rob_tracehit_( hit );
	 //}
	 // or check fortran index into common block
	 int hitIndexF = traceList[j].hitIndexF();
	 if( hitIndexF > 0 ) {
	    //rob_tracehit_( hit );
	    rob_tracehitindex_( hitIndexF );
   }
	 
   const BFieldStruct& bfield = traceList[j].bfield();
   rob_tracebfield_( bfield );

   //const GeomStruct* geometry = traceList[j].geom();
   //rob_tracegeometry_( geometry );

   const WTrackStruct& wtrack = traceList[j].wtrack();
   rob_tracewtrack_( wtrack );

   }

}

// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:34  eugenio
// Initial revision
//
// Revision 1.5  1998/11/20 23:48:11  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.4  1998/07/07  16:31:03  yarba_j
// updated so that integrated tracing routine can be called from fortran usr_before_trigger, with loop over particles be in usr_before_trigger
//
// Revision 1.3  1997/07/03  03:33:58  mkl
// new approach: surfaces vs volumes; box tracing
//
// Revision 1.2  1997/03/15  19:02:23  mkl
// moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
// fixed commend headers for .inc files from # to c.
//
// Revision 1.1.1.1  1997/03/14  22:52:34  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//



// -*- C++ -*-
//
// Package:     Tracing
// Module:      fillTraceCommonInfo
// 
// Description:
//
//   After tracing code is done and has filled a internal dynamic traceList,
//   trace common blocks need to be filled for old-style (pre-Rob) tracing
//   and visualization via Iris Explorer
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

#include "fillTraceCommonInfo.hh"

#include "MCParticle.hh"
#include "Trace.hh"

//
// constants, enums and typedefs
//

static const char* const kFacilityString = "Tracing.fillTraceCommonInfo";

//
// static data member definitions
//
#include "dummyVectorInstantiator.hh"

//-------------------------------------------------------------------------
// fill common block info for old-style (pre-Rob) tracking and 
//                                         visualization with Iris Explorer
// (this is very ugly code; only look at it if somebody points a gun at you
//-------------------------------------------------------------------------
MCFBool
fillTraceCommonInfo( const MCParticle& particle )
{
#ifdef MKLDEBUG
   static ofstream of( "trace.txt" );
   static eventCounter=0;
   report( DEBUG, kFacilityString, of ) 
      << "\nEvent " << ++eventCounter << " {\n";
#endif

   MCFBool returnValue = true ;

   // counters into trace and hit common block lists (needed for mcfio)
   int countTraces = 1; 
   int nFirstTrace = 1;

   // write out MCParticle info
#ifdef MKLDEBUG
      report( DEBUG, kFacilityString, of ) << particle;
#endif

   const vector<Trace>& traceList=particle.traceList();

//      for( vector<Trace>::const_iterator trace=traceList.begin(); 
//           trace != traceList.end(); 
//           trace++ ) {

   int status_tracefilling=0;
   for( int j=0; j< traceList.size(); ++j )
   {
	 const TraceStruct& traceInfo = traceList[j].traceInfo();
	 const WTrackStruct& wtrack = traceList[j].wtrack();
	 int hitIndexF = traceList[j].hitIndexF();

	 // for debugging through Iris Explorer
	 status_tracefilling = 
	    fill_trace_commons_( countTraces, traceInfo, wtrack, hitIndexF );
	 if( status_tracefilling != 0 ) break ; // overflowed common block array

   }

   // have to update info in hep_trace commons (eg. for display with IE)
   // if we exceeded common block info, only report max size!
      
   int nOfTraces = ( status_tracefilling == 0 ) ? traceList.size() : 0;
   int nFirstHit = ( particle.hitIndexList().size() > 0 )
	 ? particle.hitIndexList().front() : 0;
   int nOfHits   = ( status_tracefilling == 0 ) 
	 ? particle.hitIndexList().size() : 0;
#ifdef MKLDEBUG
      report( DEBUG, kFacilityString ) 
	 << "usr_before_trigger:: # of particle=" << particle.hepIndexF()
	 << "; found nTraces=" << nOfTraces 
	 << " with firstTrace=" << nFirstTrace 
	 << " and nHits=" << nOfHits 
	 << " with firstHit=" << nFirstHit << "\n";
#endif
   int status_hepfilling = 
      fill_hep_trace_commons_( particle.hepIndexF(), 
			       nOfTraces, nFirstTrace, 
			       nOfHits, nFirstHit );
   if ( status_hepfilling != 0 ) returnValue = false ;
   if ( status_tracefilling !=0 ) returnValue = false ;

#ifdef MKLDEBUG
   report( DEBUG, kFacilityString, of ) << "}" << "\n";
#endif

   return returnValue ;

}

// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:34  eugenio
// Initial revision
//
// Revision 1.8  1998/11/20 23:48:12  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.7  1998/08/05  16:11:11  mkl
// fixed particle number printout only visible in debug mode
//
// Revision 1.6  1998/07/07  16:30:35  yarba_j
// updated so that integrated tracing routine can be called from fortran usr_before_trigger, with loop over particles be in usr_before_trigger
//
// Revision 1.5  1997/11/11  01:17:51  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.4  1997/07/03  03:33:59  mkl
// new approach: surfaces vs volumes; box tracing
//
// Revision 1.3  1997/04/22  20:01:09  bphyslib
// fixes for decay-in-flights
//
// Revision 1.2  1997/03/15  19:02:24  mkl
// moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
// fixed commend headers for .inc files from # to c.
//
// Revision 1.1.1.1  1997/03/14  22:52:34  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//



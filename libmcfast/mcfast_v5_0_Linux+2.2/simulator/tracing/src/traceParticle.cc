// -*- C++ -*-
//
// Package:     Tracing
// Module:      trace_particle
// 
// Description:
//
//   Traces a given particle 
//   Does a bunch of definitions if called the first time
//
//   THIS VERSION CALLS NEW TRACING ROUTINES 
//     which trace thru r and z and cones at the same time! 
//                
//       - interface routine from Fortran program to C++ Tracing
//       - contains main loop over tracks to do tracing on each
//
// Implimentation:
//      Use "extern \"C\"" construct to be callable by Fortran
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
#include "stdhep.h"

#include "cc_fortran_types.hh"
#include "functions.hh"
#include "report.hh"
#include "fortranAccess.hh"
#include "UserSettings.hh"

#include "traceParticle.hh"
#include "fillTraceCommonInfo.hh"
#include "dummyKalmanLoop.hh"

#include "MCParticle.hh"
#include "CompositeMedium.hh"
#include "WorldFactory.hh"


extern vector<MCParticle> g_particleList ;

// forward declarations

//
// constants, enums and typedefs
//

//
// static data member definitions
//
#include "dummyVectorInstantiator.hh"

// global variables

int trace_particle_( int& ihep ) 
{
   static MCFBool first=true;
   if( first ) {
      first=false;
      cout << "trace_particle: calling trace routine for each track" << "\n";
   }

   // read UserSettings (only once!)
   UserSettings* userSettings = UserSettings::instance();
   
   // create the World from r and z planes and cones and xy planes
   // (only once per job!)
   CompositeMedium* world = WorldFactory::createWorld();
   
   // check if particle is in the list; if not - secondary, put it in   
   if ( ihep >= g_particleList.size() )
   {
      int NPARTS = hepevt_.nhep ;
      int NPARTS_IN_gLIST = g_particleList.size() ;
      int ihepCount ;
      for ( ihepCount=NPARTS_IN_gLIST; ihepCount<NPARTS; ihepCount++ )
      {
         g_particleList.push_back( MCParticle(ihepCount) ) ;
      }
   }
   
   // get particle with hep index from the particle list
   MCParticle& particleRef = g_particleList[ihep] ;

   // Trace all stable tracks except neutrinos

   // is stable?
   if( ! particleRef.isStable() ) return 0 ;

   // is neutrino? 
   if( ! particleRef.isTraceable() ) return 0 ;


   // trace particles through detectors
   MCFBool statusOK;
   if( ( statusOK = particleRef.propagate( *world ) ) != true ) {
      report( ERROR ) << "Unsuccessful tracing of particle " 
		      	 << ihep+1 << "\n";
   }
   
   // WE'RE DONE WITH TRACING
   // everything below is extra
   // ===================================================

   // fill some info for visualization with Iris Explorer
   statusOK = fillTraceCommonInfo( particleRef );
   if (statusOK != true ) return 1 ;

   // show Rob how a dummy Kalman loop would look like
   dummyKalmanLoop( particleRef );
 
   return 0 ;

}


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:34  eugenio
// Initial revision
//
// Revision 1.5  1999/10/28 23:30:40  yarba_j
// put all secondaries in g_particleList
//
// Revision 1.4  1999/06/07  22:29:15  yarba_j
// first step toward c++ event representation : now pick up particles one by one from particleList (updated in fill_mcparticle_list_ on the event by event basis) and trace them through detector
//
// Revision 1.3  1998/11/20  23:48:13  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.2  1998/08/04  19:41:51  mkl
// cleanup and pretty-format
//
// Revision 1.1  1998/07/07  16:28:24  yarba_j
// new - routine for tracing (C++) given particle
//


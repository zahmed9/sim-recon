// -*- C++ -*-
//
// Package:     
// Module:      fill_mcparticle_list_
// 
// Description:
//
// Implimentation:
//
//      Use "extern \"C\"" construct to be callable by Fortran
//
// Author:      Julia Yarba
// Created:     May 27, 1999
// RCS(Id)
//
// Revision history
//
// RCS(Log)

extern "C" void fill_mcparticle_list_( void ); // c linkage

// STL files
#include <vector>

// user include files
#include "MCParticle.hh"

#include "stdhep.h"
#include "UserSettings.hh"

vector<MCParticle> g_particleList ;

// forward declarations

//
// constants, enums and typedefs
//

//
// static data member definitions
//


void fill_mcparticle_list_( void ) 
{

   // read UserSettings (only once!)
   UserSettings* userSettings = UserSettings::instance();

   if ( g_particleList.capacity() == 0 )
      g_particleList.reserve( 100 ) ; 
   if ( ! g_particleList.empty() )
      g_particleList.erase( g_particleList.begin(), g_particleList.end() ) ;
   
   if (hepevt_.nhep <= 0 ) return ;
   
   int iPart, nParts ;
   nParts = hepevt_.nhep ;
   for (iPart=0; iPart<nParts; iPart++ )
   {
      g_particleList.push_back( MCParticle(iPart) ) ;
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
// Revision 1.2  1999/11/04 00:02:05  kutschke
// Instantiate UserSettings before starting.
//
// Revision 1.1  1999/06/07  22:27:51  yarba_j
// first step toward c++ event representation : new routine (maybe temporary one) to fill list of particles; called from mcp_analyze is integrated tracing selected by user
//
//


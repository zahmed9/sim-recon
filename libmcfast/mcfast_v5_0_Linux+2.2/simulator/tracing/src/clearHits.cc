// -*- C++ -*-
//
// Package:     Tracing
// Module:      clear_hits
// 
// Description:
//
//   Clears out g_hitList & g_hitIndexList 
//
// Implimentation:
//      Use "extern \"C\"" construct to be callable by Fortran
//
// Author:      Julia Yarba
// Created:     June 30, 1998
// RCS(Id)
//
// Revision history
//
// RCS(Log)

// system include files
#include <vector>

#include "cc_fortran_types.hh"
#include "functions.hh"
#include "report.hh"
#include "fortranAccess.hh"

#include "clearHits.hh"

#include "CompositeMedium.hh"
#include "DetCalorimeter.hh"
#include "WorldFactory.hh"
#include "DenseMedium.hh"

// forward declarations

//
// constants, enums and typedefs
//

//
// static data member definitions
//

// global variables
// global hit and hit fortran index list
//vector<Hit*> g_hitList; 
vector<int>  g_hitIndexList; 

void clear_hits_( void ) 
{

   // Clean House for global variables
   //g_hitList.erase( g_hitList.begin(), g_hitList.end() );
   g_hitIndexList.erase( g_hitIndexList.begin(), g_hitIndexList.end() );

   CompositeMedium* world = WorldFactory::createWorld();

   vector<Medium*>::const_iterator iter, end = world->listOfTubes().end() ;
   Calorimeter* detCal ;
      
   // clear hits in tube-shaped volumes
   for ( iter=world->listOfTubes().begin(); iter!=end; iter++ )
   {
      if ( (*iter)->pDetector() != 0 )
      {	
	 detCal = (Calorimeter*)((*iter)->pDetector()) ;
	 if ( detCal->numberOfHits() > 0 ) detCal->clearHits() ;
      }
   }
   
   // clear hits in box-shaped volumes
   end = world->listOfBoxes().end() ;
   
   for ( iter=world->listOfBoxes().begin(); iter!=end; iter++ )
   {
      if ( (*iter)->pDetector() != 0 && (*iter)->pMaterial() != 0 )
      {
         detCal = (Calorimeter*)((*iter)->pDetector()) ;
	 if ( detCal->numberOfHits() > 0 ) detCal->clearHits() ;
      }
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
// Revision 1.3  1999/02/17 20:25:45  yarba_j
// clear out hits in box-shaped calorimeter after each event
//
// Revision 1.2  1999/01/15  18:06:00  yarba_j
// clear out calorimetric hits on the event-by event basis now that we have reimplemented hit generation in calorimeters in C++
//
// Revision 1.1  1998/07/07  16:26:52  yarba_j
// new - routine for clearing global hit list
//


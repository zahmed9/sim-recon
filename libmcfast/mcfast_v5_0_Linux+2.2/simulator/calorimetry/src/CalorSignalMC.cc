//
// -*- C++ -*-
//
// Package:     Calorimetry
// Module:      CalorSignalMC
//
// Description: 
//
// Implimentation:
//
// Author:      Julia Yarba
// Created:     Sept.14, 1999
//

// STL files

// system include files
#include <assert.h>

// user include files
#include "CalorSignalMC.hh"

// forward declarations

// Constructors and destructors
CalorSignalMC::CalorSignalMC()
   : CalorSignal()
{
   fInfoTracks.reserve( 3 ) ;  // reserve something realistic
                                // (as more memory needed, the system 
				//  will automatically double the capacity) ;
                                // otherwise the system will reserve 1024
				// once the cell is hit, and eventually 
				// we'll with a huge unused memory which
				// in its turn may lead to memory shortage
}

CalorSignalMC::~CalorSignalMC()
{
   // no need to delete stored objects one-by-one
   // (since "real" objects, not pointers)
}

//
// assignment operators
//
const CalorSignalMC& CalorSignalMC::operator=( const CalorSignalMC& hit ) 
{
   if ( this != &hit )
   {
      // clear list of contributing tracks
      clearInfoTracks() ;
      // copy all the info
      fEnergy = hit.fEnergy ;
      vector< CalorInfoTrack >::const_iterator iter, end = hit.getInfoTracks().end() ; 
      for ( iter=hit.getInfoTracks().begin(); iter!=end; iter++ )
      {
	 fInfoTracks.push_back( CalorInfoTrack() ) ;
	 fInfoTracks.back().trackID = (*iter).trackID ;
	 fInfoTracks.back().EMIP = (*iter).EMIP ;
	 fInfoTracks.back().EEM  = (*iter).EEM  ;
	 fInfoTracks.back().EHAD = (*iter).EHAD ;
      }      
   }
   return *this ;
}

// member functions
void
CalorSignalMC::clear() 
{
   fEnergy = 0 ;
   clearInfoTracks() ;
}

void
CalorSignalMC::clearInfoTracks() 
{
   if ( !fInfoTracks.empty() )
   {
      fInfoTracks.erase( fInfoTracks.begin(), fInfoTracks.end() ) ;
   }
}

void 
CalorSignalMC::update( double signal, int trackID, int trackStatus )
{

   fEnergy += signal ;

   if ( trackID < 0 || trackStatus < 0 ) return ;

   if ( fInfoTracks.empty() || fInfoTracks.back().trackID != trackID ) // either first touch of the cell
                                                                     // or another track contributes
   {
      fInfoTracks.push_back( CalorInfoTrack() ) ;
      fInfoTracks.back().trackID = trackID ;
      fInfoTracks.back().EMIP    = 0 ;
      fInfoTracks.back().EEM     = 0 ;
      fInfoTracks.back().EHAD    = 0 ;
   }
   switch( trackStatus )
   {
      case 0 : // MIP
         fInfoTracks.back().EMIP += signal ;
	 break ;
      case 1 : // EM shower
         fInfoTracks.back().EEM  += signal ;
	 break ;
      case 2 : // HAD shower
         fInfoTracks.back().EHAD += signal ;
	 break ;
   }
}

// const member functions
double CalorSignalMC::getEMIP() const
{
   double EMIP = 0 ;
   vector< CalorInfoTrack >::const_iterator iter, end=fInfoTracks.end();
   for ( iter=fInfoTracks.begin(); iter!=end; iter++ )
   {
      EMIP += iter->EMIP ;
   }
   return EMIP ;
}

double CalorSignalMC::getEEM() const
{
   double EEM = 0 ;
   vector< CalorInfoTrack >::const_iterator iter, end=fInfoTracks.end();
   for ( iter=fInfoTracks.begin(); iter!=end; iter++ )
   {
      EEM += iter->EEM ;
   }
   return EEM ;
}

double CalorSignalMC::getEHAD() const
{
   double EHAD = 0 ;
   vector< CalorInfoTrack >::const_iterator iter, end=fInfoTracks.end();
   for ( iter=fInfoTracks.begin(); iter!=end; iter++ )
   {
      EHAD += iter->EHAD ;
   }
   return EHAD ;
}

double CalorSignalMC::getEMIP( const int tr ) const
{
   return fInfoTracks[tr].EMIP ;
}

double CalorSignalMC::getEEM( const int tr ) const
{
   return fInfoTracks[tr].EEM ;
}

double CalorSignalMC::getEHAD( const int tr ) const
{
   return fInfoTracks[tr].EHAD ;
}

// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:09  eugenio
// Initial revision
//
// Revision 1.4  1999/11/30 00:38:03  yarba_j
// minot change in CalorSignalMC::update
//
// Revision 1.3  1999/09/24  20:16:17  yarba_j
// more cleanup (agreed with Andreas on naming)
//
// Revision 1.2  1999/09/23  22:28:28  yarba_j
// minor modifications
//
// Revision 1.1  1999/09/23  15:56:26  yarba_j
// updated/modifed calorimtry classes moved from showering area + a new calss CalorSignalMC
//
//

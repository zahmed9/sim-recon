#if !defined(CALORSIGNALMC_H)
#define CALORSIGNALMC_H
// -*- C++ -*-
//
// Package : Calorimetry
// Module:   CalorSignalMC
//
// Description :
//
// Author :  Julia Yarba
// Created : Aug.13, 1999
//

// system include files

// STL files
#include <vector>

// user include files
#include "CalorSignal.hh"
#include "CalorInfoTrack.hh"

// forward declarations

class CalorSignalMC : public CalorSignal
{
      // friend classes and functions
   
   public :
      // Constructor and destructor
      CalorSignalMC() ;
      ~CalorSignalMC() ;

      // assignment operator
      const CalorSignalMC& operator=( const CalorSignalMC& ) ;
   
      // member functions
      virtual void clear() ;
      virtual void update( double signal, int trackID=-1, int trackStatus=-1 ) ;
      
      vector< CalorInfoTrack >& getInfoTracks() { return fInfoTracks ; }

      // const member functions
      double getEMIP() const ; 
      double getEEM()  const ; 
      double getEHAD() const ; 
      double getEMIP( const int ) const ; 
      double getEEM(  const int ) const ; 
      double getEHAD( const int ) const ; 

      const vector< CalorInfoTrack >& getInfoTracks() const { return fInfoTracks ; }

   protected :
      // protected member functions
      void   clearInfoTracks() ;

   private :
      // Constructors and destructors
      
      // private member functions
      
      // private const member functions
      
      // private data members
      vector< CalorInfoTrack > fInfoTracks ;
      
      // static data members
} ;

// inline function definitions
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:09  eugenio
// Initial revision
//
// Revision 1.5  1999/10/06 21:15:15  yarba_j
// have default params in update(...)
//
// Revision 1.4  1999/10/04  21:56:23  yarba_j
// clear() is now virtual
//
// Revision 1.3  1999/09/24  20:16:17  yarba_j
// more cleanup (agreed with Andreas on naming)
//
// Revision 1.2  1999/09/23  22:28:29  yarba_j
// minor modifications
//
// Revision 1.1  1999/09/23  15:56:26  yarba_j
// updated/modifed calorimtry classes moved from showering area + a new calss CalorSignalMC
//
//


#endif /* CALORSIGNALMC_H */


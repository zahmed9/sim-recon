
// -*- C++ -*-
//
// Package:     Showering
// Module:      Calorimeter
// 
// Description: Detector-based class implementing Calorimeter.
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner, Julia Yarba
// Created:     Jan 23, 1997
// RCS(Id)
//
// Revision history
//

// RCS(Log)

// system include files
#include <math.h>
#include <assert.h>

// user include files
#include "const.hh"
#include "cc_fortran_types.hh"
#include "DetCalorimeter.hh"
#include "CalorSignal.hh"
#include "MCParticle.hh"
#include "externFortran.hh"
#include "UserSettings.hh"
#include "report.hh"

// STL files

//
// constants, enums and typedefs
//

//
// static data member definitions
//

//
// constructors and destructor
//
Calorimeter::Calorimeter()
             : m_stochasticTermEM( 0 ) ,
               m_constantTermEM( 0 ) ,
               m_stochasticTermHAD( 0 ) ,
               m_constantTermHAD( 0 ) ,
               m_samplingFactor( 1 ) ,
               m_ratioEMtoHAD( 1 ) , 
               m_resolutionFactor( 1 ) ,
               m_segmentationType( 0 ) ,
               m_nHits( 0 ),
	       m_gridOfCells( 0 )
{

   m_numberOfSegments[0] = 1 ;
   m_numberOfSegments[1] = 1 ;
   m_cellSize[0] = 0 ;
   m_cellSize[1] = 0 ;

   m_limits = 0 ;

}

Calorimeter::Calorimeter( const DFLOAT stochTermEM,  const DFLOAT constTermEM,
                          const DFLOAT stochTermHAD, const DFLOAT constTermHAD,
                          const DFLOAT ratioEMtoHAD,
                          const DFLOAT samplingFactor)
{

   m_stochasticTermEM  = stochTermEM  ;
   m_constantTermEM    = constTermEM  ;
   m_stochasticTermHAD = stochTermHAD ;
   m_constantTermHAD   = constTermHAD ;
   m_ratioEMtoHAD      = ratioEMtoHAD ;
   m_samplingFactor    = samplingFactor ;

   m_nHits =  0;
   m_gridOfCells = 0 ;

   m_limits = 0 ;

   m_segmentationType = 0 ;
   m_numberOfSegments[0] = 1 ;
   m_numberOfSegments[1] = 1 ;
   m_cellSize[0] = 0 ;
   m_cellSize[1] = 0 ;
   
   m_resolutionFactor = 1 ;

}

Calorimeter::Calorimeter( const DFLOAT stochTermEM,  const DFLOAT constTermEM,
                          const DFLOAT stochTermHAD, const DFLOAT constTermHAD,
                          const DFLOAT ratioEMtoHAD,
                          const DFLOAT samplingFactor, 
			  const int    segmentationType,
			  const int    numberOfSegments[2] )
{

   m_stochasticTermEM  = stochTermEM  ;
   m_constantTermEM    = constTermEM  ;
   m_stochasticTermHAD = stochTermHAD ;
   m_constantTermHAD   = constTermHAD ;
   m_ratioEMtoHAD      = ratioEMtoHAD ;
   m_samplingFactor    = samplingFactor ;

   m_nHits =  0;

   m_segmentationType = segmentationType ;
   
   if ( segmentationType == 0 || segmentationType == 2 )
   {
      m_limits = new DFLOAT[2] ;
      m_limits[0] = m_limits[1] = 0 ;
   }
   else if ( segmentationType == 1 )
   {
      m_limits = new DFLOAT[4] ;
      m_limits[0] = m_limits[1] = m_limits[2] = m_limits[3] = 0 ;
   }
   
   m_numberOfSegments[0] = numberOfSegments[0] ;
   m_numberOfSegments[1] = numberOfSegments[1] ;
   m_cellSize[0] = 0 ;
   m_cellSize[1] = 0 ;
   
   m_resolutionFactor = 1 ;
   
   m_gridOfCells = new CalorSignal* [m_numberOfSegments[0]] ;
   int i ;   
   for ( i=0; i<m_numberOfSegments[0]; i++ )
   {
      m_gridOfCells[i] = new CalorSignal[m_numberOfSegments[1]] ;
   }

}

Calorimeter::Calorimeter( const Calorimeter& detector )
{
   *this = detector;
}

Calorimeter::~Calorimeter()
{
   if ( m_gridOfCells != 0 )
   {
      int i,j ;
      for (i=0; i<m_numberOfSegments[0]; i++ )
      {
         for (j=0; j<m_numberOfSegments[1]; j++ )
         {
            delete ((m_gridOfCells[i])+j) ;
         }
      }
   }   
}

//
// assignment operators
//
const Calorimeter& 
Calorimeter::operator=( const Calorimeter& detector )
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
void
Calorimeter::clearHits()
{

     if ( !m_gridOfCells ) return ;

     int ieta, iphi ;
     for ( ieta=0; ieta<m_numberOfSegments[0]; ieta++ )
     {
        for ( iphi=0; iphi<m_numberOfSegments[1]; iphi++ )
	{
	   m_gridOfCells[ieta][iphi].clear() ;
	}
     }

     m_nHits = 0 ;

}
 
void 
Calorimeter::setSegmentation( int numberOfSegments[2] )
{

   m_numberOfSegments[0] = numberOfSegments[0] ;
   m_numberOfSegments[1] = numberOfSegments[1] ;

   m_cellSize[0] = ( m_limits[1] - m_limits[0] ) / m_numberOfSegments[0] ; 

   if ( m_segmentationType == 0 || m_segmentationType == 2 ) 
   {
      m_cellSize[1] = TWOPI / m_numberOfSegments[1] ;
   }
   else if ( m_segmentationType == 1 ) 
   {
      m_cellSize[1] = ( m_limits[3] - m_limits[2] ) / m_numberOfSegments[1] ;
   }

   assert ( m_cellSize[0] > 0 ) ;
   assert ( m_cellSize[1] > 0 ) ;

}

void
Calorimeter::setLimits( int segmentationType, DFLOAT* limits ) 
{
   m_segmentationType = segmentationType ;
      
   if ( segmentationType != 1 )
   {
      if ( m_limits == 0 )
         m_limits = new DFLOAT[2] ;
      *m_limits     = limits[0] ;
      *(m_limits+1) = limits[1] ;
   }
   else
   {
      if ( m_limits == 0 ) 
         m_limits = new DFLOAT[4] ;
      *m_limits     = limits[0] ;
      *(m_limits+1) = limits[1] ;
      *(m_limits+2) = limits[2] ;
      *(m_limits+3) = limits[3] ;
   }
}

void
Calorimeter::resetResolutionFactor( MCParticle& particle, DFLOAT xSmear )
{
   if ( ! particle.showeringHasStarted() ) 
   {
    report( ::ERROR )
    << "Calorimeter::resetResolutionFactor : trying to set resolution for MIP"
    << "\n" ; 
    return ;
   }

   if ( particle.shower().N_radlen_pass > 0 )
   {
    report( ::ERROR )
    << "Calorimeter::resetResolutionFactor : trying to reset resolution 
illegally"
    << "\n" ; 
    return ;
   }

   if ( particle.isElectron() || particle.isPhoton() )
   {
    m_resolutionFactor = 
    sqrt( ( m_stochasticTermEM * m_stochasticTermEM *
            particle.shower().E_original )
    +     ( m_constantTermEM * particle.shower().E_original ) *
          ( m_constantTermEM * particle.shower().E_original ) ) ;
   }
   else
   {
    m_resolutionFactor = 
    sqrt( ( m_stochasticTermHAD * m_stochasticTermHAD *
            particle.shower().E_original )
    +     ( m_constantTermHAD * particle.shower().E_original ) *
          ( m_constantTermHAD * particle.shower().E_original ) ) ;
   }
   m_resolutionFactor *= xSmear ;
   m_resolutionFactor /= particle.shower().E_original ;
   m_resolutionFactor += 1 ;
}

//
// const member functions
//

// clone operation
Calorimeter*
Calorimeter::clone() const
{
   return new Calorimeter(*this);
}

MCFBool
Calorimeter::generateResponse( MCParticle& particle, 
			       MCFBool& oHitActiveArea,
			       DFLOAT signal ) const
{
//
// Calorimeter
//

   MCFBool returnValue = true;

   if ( signal <= 0 ) { return returnValue ; }

   if ( m_resolutionFactor <= 0 ) { return returnValue ; }

   if ( m_gridOfCells == 0 )
   {
      if ( m_numberOfSegments[0] < 0 && m_numberOfSegments[1] < 0 )
         {   return( returnValue = false ) ;   }
      ((Calorimeter*)this)->m_gridOfCells = new CalorSignal* 
[m_numberOfSegments[0]] ;
      int i ;
      for ( i=0; i<m_numberOfSegments[0]; i++ )
      {
         m_gridOfCells[i] = new CalorSignal[m_numberOfSegments[1]] ;
      }
   }

   int cellAddress[2] = {-1,-1} ;
   cellAddress[0] = findCell1( particle ) ;
   cellAddress[1] = findCell2( particle ) ;

   if ( cellAddress[0] == -1 || cellAddress[1] == -1 ) 
      { return ( returnValue = false ) ; }

   if ( m_gridOfCells[ cellAddress[0] ][ cellAddress[1] ].eMIP() <= 0 &&
        m_gridOfCells[ cellAddress[0] ][ cellAddress[1] ].eEM()  <= 0 &&
        m_gridOfCells[ cellAddress[0] ][ cellAddress[1] ].eHAD() <= 0 )
	((Calorimeter*)this)->m_nHits++ ; 

   signal *= m_resolutionFactor ;
   signal *= m_samplingFactor ;
   if (  particle.showeringHasStarted() &&
        !particle.isMuon() && !particle.isElectron() && !particle.isPhoton() )
	signal *= m_ratioEMtoHAD ;
   
   m_gridOfCells[cellAddress[0]][cellAddress[1]].updateInfo( 
particle.hepIndexF(), signal ) ;

   if ( particle.isMuon() || !particle.showeringHasStarted() )
   {
      m_gridOfCells[cellAddress[0]][cellAddress[1]].addSignalMIP( signal ) ;
   }
   else
   {
      if ( particle.isElectron() || particle.isPhoton() )
      {
         m_gridOfCells[cellAddress[0]][cellAddress[1]].addSignalEM( signal ) ;
      }
      else
      {
         m_gridOfCells[cellAddress[0]][cellAddress[1]].addSignalHAD( signal ) ;
      }
   }

   return returnValue;

}

extern "C" {
   DFLOAT phi_norm_( DFLOAT& arg ) ;
}

int
Calorimeter::findCell1( MCParticle& particle ) const
{
   assert( m_cellSize[0] > 0 ) ;
   assert( m_numberOfSegments[0] > 0 ) ;

   int address ;

   if ( m_segmentationType == 0 )
   {
      // eta-phi segmentation; find ieta 
      DFLOAT radius = sqrt( particle.wtrack().x*particle.wtrack().x
                          + particle.wtrack().y*particle.wtrack().y ) ;
      DFLOAT theta ;
      if ( particle.wtrack().z != 0 )
      {
         theta = atan2( radius, particle.wtrack().z ) ;
	 if ( theta < 0 ) theta *= -1 ;
      }
      else
         theta = kPI / 2 ;
      theta /= 2 ;
      DFLOAT eta = -log( tan( theta ) ) ;
      address = int( ( eta - m_limits[0] ) / m_cellSize[0] ) ;
      if ( eta < 0 && address < 0 ) address = 0 ;
      if ( eta > 0 && address >= m_numberOfSegments[0] ) 
         address = m_numberOfSegments[0] - 1 ; 
   }
   else if ( m_segmentationType == 1 )
   {
      // x-y segmentation; find ix
      address = int( ( particle.wtrack().x - m_limits[0] ) / m_cellSize[0] ) ;
   }
   else if ( m_segmentationType == 2 )
   {
      // z-phi segmentation; find iz
      address = int( ( particle.wtrack().z - m_limits[0] ) / m_cellSize[0] ) ;
      if ( address == m_numberOfSegments[0] ) 
         address = m_numberOfSegments[0] - 1 ;
   }
   if ( address < 0 || address >= m_numberOfSegments[0] ) return -1 ;
   return address ;
}

int
Calorimeter::findCell2( MCParticle& particle ) const
{
   assert( m_cellSize[1] > 0 ) ;
   assert( m_numberOfSegments[1] > 0 ) ;

   int address ;

   if ( m_segmentationType == 0 || m_segmentationType == 2 )
   {
      // eta-phi or z-phi segmentation; find iphi
      DFLOAT radius = sqrt( particle.wtrack().x*particle.wtrack().x
                          + particle.wtrack().y*particle.wtrack().y ) ;
      DFLOAT phi ;
      if ( radius != 0 ) 
      {
         DFLOAT arg = atan2( particle.wtrack().y, particle.wtrack().x ) ;
         phi = phi_norm_( arg ) ;
      }
      else phi = 0 ;
      address = int( phi / m_cellSize[1] ) ;
   }
   else if ( m_segmentationType == 1 )
   {
      // x-y segmentation; find iy
      address = int( ( particle.wtrack().y - m_limits[2] ) / m_cellSize[1] ) ;
   }
   if ( address < 0 || address >= m_numberOfSegments[1] ) return -1 ;
   return address ;
}

const char*
Calorimeter::segmentationType() const
{
   if ( m_segmentationType == 0 ) return "Eta-Phi" ;
   if ( m_segmentationType == 2 ) return "Z-Phi" ;
   return "X-Y" ;
}

//
// static member functions
//


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  1999/10/26 22:27:29  eugenio
// new port
//
// Revision 1.19  1999/02/17  00:58:03  yarba_j
// minor cleanup
//
// Revision 1.18  1999/02/16  23:48:55  yarba_j
// implemented z-phi and x-y segmentation
//
// Revision 1.17  1999/01/15  17:50:52  yarba_j
// hit generation in calorimeters reimplemented in C++; also includes user 
// interface on calorimetry hits for C++ programmers
//
// Revision 1.14  1998/08/04  22:58:53  mkl
// implemented Detector::generateResponse with extra output argument: 
// oHitActiveArea; only if true, do material effects
//
// Revision 1.13  1998/02/23  18:02:11  yarba_j
// implemented showering in DenseMedium (incl. trans.prof.)
//
// Revision 1.8  1997/08/25  16:12:29  mkl
// eliminated some of the unnecessary Unsuccessful Tracing of Particle messages
//
// Revision 1.7  1997/07/03  03:33:45  mkl
// new approach: surfaces vs volumes; box tracing
//
// Revision 1.6  1997/04/24  15:25:38  bphyslib
// stop traces at shower conversion point
//
// Revision 1.5  1997/04/19  21:57:20  bphyslib
// new method "distanceToDecay()" in MCParticle makes similar function in
// DetCalorimeter obsolete; added generateTimeOfDecay as private method to
// MCParticle (was static local before).
//
// Revision 1.4  1997/04/19  11:39:39  mkl
// fixes suggested by Julia: change from layerIndex to deviceIndex in
// DetCalorimeter.cc; reversal of if logic in Material::doPhotonConversion().
//
// Revision 1.3  1997/03/27  22:46:59  mkl
// changes suggested by Julia: splash-->shower, location of addTrace( Trace::kCalor )
//
// Revision 1.2  1997/03/15  19:02:17  mkl
// moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
// fixed commend headers for .inc files from # to c.
//
// Revision 1.1.1.1  1997/03/14  22:52:34  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//






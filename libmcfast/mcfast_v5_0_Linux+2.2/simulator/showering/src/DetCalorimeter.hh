#if !defined(SHOWERING_CALORIMETER_H)
#define SHOWERING_CALORIMETER_H
// -*- C++ -*-
//
// Package:     Showering
// Module:      Calorimeter
// 
// Description: derived class of Detector
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     Feb 23, 1997
// RCS(Id)
//
// Revision history
//
// RCS(Log)

// system include files
#include <float.h>

// user include files
#include "Detector.hh"

// forward declarations
class MCParticle;
class CalorSignal ;
class CalorSignalMC ; // if using CalorSignalMC*...
class ostream;


class Calorimeter : public Detector
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      // Default Constructor
      Calorimeter();
      // Constructor to build calorimeter via its characteristics
      Calorimeter( const DFLOAT stochTermEM,  const DFLOAT constTermEM,
                   const DFLOAT stochTermHAD, const DFLOAT constTermHAD,
                   const DFLOAT EMtoHADratio,
                   const DFLOAT samplingFactor) ;		   
      Calorimeter( const DFLOAT stochTermEM,  const DFLOAT constTermEM,
                   const DFLOAT stochTermHAD, const DFLOAT constTermHAD,
                   const DFLOAT EMtoHADratio,
                   const DFLOAT samplingFactor,
		   const int    segmentationType,
		   const int    numberOfSegments[2]) ;		   

      Calorimeter( const Calorimeter& );
      virtual ~Calorimeter();

      // assignment operator(s)
      const Calorimeter& operator=( const Calorimeter& );

      // member functions
      void resetResolutionFactor( MCParticle&, DFLOAT ) ;
//      void setEtaMin( DFLOAT etaMin )  { m_etaMin = etaMin ; }
//      void setEtaMax( DFLOAT etaMax )  { m_etaMax = etaMax ; }
      void setLimits( int segmentationType, DFLOAT* limits ) ;
      void setSegmentation( int numberOfSegments[2] ) ;
      void clearHits() ;

      // display 
      virtual void printOn( ostream& ) const {}

      // const member functions
      // All detectors must specify what they will do 
      // when traversed by a particle
      virtual MCFBool generateResponse( MCParticle&, 
					MCFBool& oHitActiveArea,
					DFLOAT signal ) const ;
      DFLOAT  stochasticTermEM() const { return m_stochasticTermEM ; }
      DFLOAT  constTermEM() const { return m_constantTermEM ; }
      DFLOAT  stochasticTermHAD() const { return m_stochasticTermHAD ; }
      DFLOAT  constTermHAD() const { return m_constantTermHAD ; }
      DFLOAT  ratioEMtoHAD() const { return m_ratioEMtoHAD ; }
      DFLOAT  samplingFactor() const { return m_samplingFactor ; }
      integer numberOfHits() const { return m_nHits ; } 
      CalorSignalMC*** pGridOfCells() const { return m_gridOfCells ; }
//      CalorSignal***   pGridOfCellsRL() const { return (CalorSignal***)m_gridOfCells ; }
      const   int* numberOfSegments() const { return m_numberOfSegments ; }
      const   DFLOAT* cellSize() const { return m_cellSize ; }
      const   char* segmentationType() const ;
      const   DFLOAT*  limits() const { return m_limits ; }
      DFLOAT  etaMin() const { return (  m_segmentationType ? FLT_MAX : m_limits[0] ) ; }
      DFLOAT  etaMax() const { return (  m_segmentationType ? FLT_MAX : m_limits[1] ) ; }
      DFLOAT  phiMin() const { return ( (m_segmentationType!=1) ? FLT_MAX : m_limits[0] ) ; }
      DFLOAT  phiMax() const { return ( (m_segmentationType!=1) ? FLT_MAX : m_limits[1] ) ; }
      DFLOAT  zMin()   const { return ( (m_segmentationType==2) ? m_limits[0] : FLT_MAX ) ; }
      DFLOAT  zMax()   const { return ( (m_segmentationType==2) ? m_limits[1] : FLT_MAX ) ; }
      DFLOAT  rMin()   const { return ( (m_segmentationType==3) ? m_limits[0] : FLT_MAX ) ; }
      DFLOAT  rMax()   const { return ( (m_segmentationType==3) ? m_limits[1] : FLT_MAX ) ; }
      DFLOAT  xMin()   const { return ( (m_segmentationType==1) ? m_limits[0] : FLT_MAX ) ; }
      DFLOAT  xMax()   const { return ( (m_segmentationType==1) ? m_limits[1] : FLT_MAX ) ; }
      DFLOAT  yMin()   const { return ( (m_segmentationType==1) ? m_limits[2] : FLT_MAX ) ; }
      DFLOAT  yMax()   const { return ( (m_segmentationType==1) ? m_limits[3] : FLT_MAX ) ; }
											
      virtual Calorimeter* clone() const;  // cloe operator

      virtual const char* nameOf() const { return "Calorimeter"; }

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:

      // Constructors and destructor

      // private member functions

      // private const member functions
      int  findCell1( MCParticle& particle ) const ; // find eta or x cell
      int  findCell2( MCParticle& particle ) const ; // find phi or y cell

      // data members
      DFLOAT  m_stochasticTermEM ;
      DFLOAT  m_constantTermEM ;
      DFLOAT  m_stochasticTermHAD ;
      DFLOAT  m_constantTermHAD ;
      DFLOAT  m_samplingFactor ;
      DFLOAT  m_ratioEMtoHAD ;
      DFLOAT  m_resolutionFactor ;

      DFLOAT  m_limits[4] ;
      int     m_segmentationType ;
      int     m_numberOfSegments[2] ;
      DFLOAT  m_cellSize[2] ; 
      int     m_nHits ;
      CalorSignalMC*** m_gridOfCells ;

      // static data members

};

// inline function definitions

inline 
ostream& 
operator<<( ostream& os, const Calorimeter& d )
{
   d.printOn(os);
   return os;
}

inline 
ostream& 
operator<<( ostream& os, const Calorimeter* d )
{
   d->printOn(os);
   return os;
}



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:29  eugenio
// Initial revision
//
// Revision 1.15  1999/10/06 21:21:54  yarba_j
// cal.hits storage : 2-dim.array for hits becomes a pointer to the array of hits; access methods like gridOfCells become pGridOfCells
//
// Revision 1.14  1999/09/23  15:59:32  yarba_j
// now uses CalorSignalMC for hit generation
//
// Revision 1.13  1999/03/22  17:25:26  yarba_j
// resolve FLT_MAX problem by includeing <float.h>
//
// Revision 1.12  1999/02/22  23:15:48  yarba_j
// handle hit generation in box-shaped calorimeters
//
// Revision 1.10  1999/01/15  17:50:53  yarba_j
// hit generation in calorimeters reimplemented in C++; also includes user interface on calorimetry hits for C++ programmers
//
// Revision 1.8  1998/08/04  22:58:54  mkl
// implemented Detector::generateResponse with extra output argument: oHitActiveArea; only if true, do material effects
//
// Revision 1.7  1998/02/23  18:02:12  yarba_j
// implemented showering in DenseMedium (incl. trans.prof.)
//
// Revision 1.4  1997/11/20  21:20:51  mkl
// make virtual member function nameOf() explicit
//
// Revision 1.3  1997/04/19  21:57:20  bphyslib
// new method "distanceToDecay()" in MCParticle makes similar function in
// DetCalorimeter obsolete; added generateTimeOfDecay as private method to
// MCParticle (was static local before).
//
// Revision 1.2  1997/03/27  22:46:59  mkl
// changes suggested by Julia: splash-->shower, location of addTrace( Trace::kCalor )
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//


#endif /* SHOWERING_CALORIMETER_H */

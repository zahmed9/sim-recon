#if !defined(SHOWERING_CALORINFO_H)
#define SHOWERING_CALORINFO_H
// -*- C++ -*-
//
// Package:     Showering
// Module:      CalorInfo
// 
// Description: 
//
// Usage:
//    <usage>
//
// Author:      Julia Yarba
// Created:     Mon Nov.23, 1998
// RCS(Id)
//
// Revision history
//
// RCS(Log)

// system include files

// user include files
#include "CompositeMedium.hh"
#include "CalorCellAddress.hh"

// STL files
#include <vector>

// forward declarations
class ostream;
class DenseMedium ;
class CompositeMedium ;
class CalorSignalMC ;

class CalorInfo 
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      // Default Constructor
      CalorInfo() ;
      ~CalorInfo() {} ;

      // assignment operator(s)

      // member functions
      // display 

      // const member functions

      int numberOfCalorimeters() const ;      
      const vector< const DenseMedium* >& listOfCalorimeters() const { return m_listOfCalorimeters ; }

      int                     numberOfNeighbours(       const DenseMedium* iCal ) const ;
      vector< DenseMedium* >& listOfNeighbours(         const DenseMedium* iCal ) const ;
      int                     numberOfHits(             const DenseMedium* iCal ) const ;
      vector< CalorCellAddress > listOfHits(            const DenseMedium* iCal ) const ;
      vector< CalorCellAddress > listOfHitsSortedByEnergy(const DenseMedium* iCal ) const ;
      CalorSignalMC***        pGridOfCells(             const DenseMedium* iCal ) const ;
      const int               deviceIndex(              const DenseMedium* iCal ) const ;
      const char*             segmentationType(         const DenseMedium* iCal ) const ;
      const int*              numberOfCells(            const DenseMedium* iCal ) const ;
      const double*           cellSize(                 const DenseMedium* iCal ) const ;
      const double*           limits(                   const DenseMedium* iCal ) const ;
      const double            etaMin(                   const DenseMedium* iCal ) const ;
      const double            etaMax(                   const DenseMedium* iCal ) const ;
      const double            phiMin(                   const DenseMedium* iCal ) const ;
      const double            phiMax(                   const DenseMedium* iCal ) const ;
      const double            stochasticTermEM(         const DenseMedium* iCal ) const ;
      const double            constantTermEM(           const DenseMedium* iCal ) const ;
      const double            stochasticTermHAD(        const DenseMedium* iCal ) const ;
      const double            constantTermHAD(          const DenseMedium* iCal ) const ;
      const double            ratioEMtoHAD(             const DenseMedium* iCal ) const ;
      const char*             name(                     const DenseMedium* iCal ) const ;
      const double            rmin(                     const DenseMedium* iCal ) const ;
      const double            rmax(                     const DenseMedium* iCal ) const ;
      const double            xmin(                     const DenseMedium* iCal ) const ;
      const double            xmax(                     const DenseMedium* iCal ) const ;
      const double            ymin(                     const DenseMedium* iCal ) const ;
      const double            ymax(                     const DenseMedium* iCal ) const ;
      const double            zmin(                     const DenseMedium* iCal ) const ;
      const double            zmax(                     const DenseMedium* iCal ) const ;

      int                     numberOfNeighbours(       const int iCal ) const ;
      vector< DenseMedium* >& listOfNeighbours(         const int iCal ) const ;
      int                     numberOfHits(             const int iCal ) const ;
      vector< CalorCellAddress > listOfHits(            const int iCal ) const ;
      vector< CalorCellAddress > listOfHitsSortedByEnergy( const int iCal ) const ;
      CalorSignalMC***        pGridOfCells(             const int iCal ) const ;
      const int               deviceIndex(              const int iCal ) const ;
      const char*             segmentationType(         const int iCal ) const ;
      const int*              numberOfCells(            const int iCal ) const ;
      const double*           cellSize(                 const int iCal ) const ;
      const double*           limits(                   const int iCal ) const ;
      const double            etaMin(                   const int iCal ) const ;
      const double            etaMax(                   const int iCal ) const ;
      const double            phiMin(                   const int iCal ) const ;
      const double            phiMax(                   const int iCal ) const ;
      const double            stochasticTermEM(         const int iCal ) const ;
      const double            constantTermEM(           const int iCal ) const ;
      const double            stochasticTermHAD(        const int iCal ) const ;
      const double            constantTermHAD(          const int iCal ) const ;
      const double            ratioEMtoHAD(             const int iCal ) const ;
      const char*             name(                     const int iCal ) const ;
      const double            rmin(                     const int iCal ) const ;
      const double            rmax(                     const int iCal ) const ;
      const double            xmin(                     const int iCal ) const ;
      const double            xmax(                     const int iCal ) const ;
      const double            ymin(                     const int iCal ) const ;
      const double            ymax(                     const int iCal ) const ;
      const double            zmin(                     const int iCal ) const ;
      const double            zmax(                     const int iCal ) const ;
      int                     numberOfHitsForNeighbour( const int iCal, const int iNeigh ) const ;
      vector< CalorCellAddress > listOfHitsForNeighbour(const int iCal, const int iNeigh ) const ;      
      vector< CalorCellAddress > listOfHitsSortedByEnergyForNeighbour( const int iCal, const int iNeigh ) const ;
      CalorSignalMC***        pGridOfCellsForNeighbour(  const int iCal, const int iNeigh ) const ;
      const int               deviceIndexForNeighbour(  const int iCal, const int iNeigh ) const ;
      const char*             segmentationTypeForNeighbour(const int iCal, const int iNeigh ) const ;
      const int*              numberOfCellsForNeighbour(const int iCal, const int iNeigh ) const ;
      const double*           cellSizeForNeighbour(     const int iCal, const int iNeigh ) const ;
      const double*           limitsForNeighbour(       const int iCal, const int iNeigh ) const ; 
      const double            etaMinForNeighbour(       const int iCal, const int iNeigh ) const ;
      const double            etaMaxForNeighbour(       const int iCal, const int iNeigh ) const ;
      const double            phiMinForNeighbour(       const int iCal, const int iNeigh ) const ;
      const double            phiMaxForNeighbour(       const int iCal, const int iNeigh ) const ;
      const double            stochasticTermEMForNeighbour(const int iCal, const int iNeigh ) const ;
      const double            constantTermEMForNeighbour(const int iCal, const int iNeigh ) const ;
      const double            stochasticTermHADForNeighbour(const int iCal, const int iNeigh ) const ;
      const double            constantTermHADForNeighbour(const int iCal, const int iNeigh ) const ;
      const double            ratioEMtoHADForNeighbour( const int iCal, const int iNeigh ) const ;
      const char*             nameForNeighbour(         const int iCal, const int iNeigh ) const ;
      const double            rminForNeighbour(         const int iCal, const int iNeigh ) const ;
      const double            rmaxForNeighbour(         const int iCal, const int iNeigh ) const ;
      const double            xminForNeighbour(         const int iCal, const int iNeigh ) const ;
      const double            xmaxForNeighbour(         const int iCal, const int iNeigh ) const ;
      const double            yminForNeighbour(         const int iCal, const int iNeigh ) const ;
      const double            ymaxForNeighbour(         const int iCal, const int iNeigh ) const ;
      const double            zminForNeighbour(         const int iCal, const int iNeigh ) const ;
      const double            zmaxForNeighbour(         const int iCal, const int iNeigh ) const ;

      // clone operation

      const char* nameOf() const { return "CalorimetryInfo"; }

      // static member functions
      static CalorInfo* getCalorInfo() ;

   protected:
      // protected member functions

      // protected const member functions

   private:

      // Constructors and destructor

      // private member functions
      void createListOfCalorimeters() ;

      // private const member functions
      
      // static member functions

      // data members
      const CompositeMedium* m_theWorld ;
      vector< const DenseMedium* > m_listOfCalorimeters ;


      // static data members
      static CalorInfo* m_instance ;

};

// inline function definitions


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:29  eugenio
// Initial revision
//
// Revision 1.5  1999/10/06 21:21:53  yarba_j
// cal.hits storage : 2-dim.array for hits becomes a pointer to the array of hits; access methods like gridOfCells become pGridOfCells
//
// Revision 1.4  1999/09/23  15:59:55  yarba_j
// now uses CalorSignalMC for hit generation
//
// Revision 1.3  1999/02/25  00:19:15  yarba_j
// minor cleanip/bug fix (skip dipole yokes when create list of calorimeters)
//
// Revision 1.2  1999/02/22  23:15:46  yarba_j
// handle hit generation in box-shaped calorimeters
//
// Revision 1.1  1999/01/15  17:50:50  yarba_j
// hit generation in calorimeters reimplemented in C++; also includes user interface on calorimetry hits for C++ programmers
//

#endif /* SHOWERING_CALORINFO_H */

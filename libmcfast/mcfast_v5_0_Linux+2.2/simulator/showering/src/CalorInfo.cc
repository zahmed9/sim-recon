// -*- C++ -*-
//
// Package:     <Showering>
// Module:      CalorInfo
// 
// Description: <one line class summary>
//
// Implementation:
//     <Notes on implementation>
//
// Author:      Julia Yarba
// Created:     Mon Nov.23 1998
// system include files

#if defined(STL_TEMPLATE_DEFAULT_PARAMS_FIRST_BUG)
#endif /* STL_TEMPLATE_DEFAULT_PARAMS_FIRST_BUG */

// user include files
#include "externFortran.hh"
#include "WorldFactory.hh"
#include "CompositeMedium.hh"
#include "DenseMedium.hh"
#include "DetCalorimeter.hh"
#include "Tube.hh"
#include "AlignedBox.hh"
#include "CalorInfo.hh"
#include "CalorSignalMC.hh"

//
// constants, enums and typedefs
//


//
// static data member definitions
//
CalorInfo* CalorInfo::m_instance = 0 ;


//
// constructors and destructor
//
CalorInfo::CalorInfo()
{
   m_theWorld = WorldFactory::createWorld() ;
   createListOfCalorimeters() ;
}


//
// assignment operators
//

//
// member functions
//
void
CalorInfo::createListOfCalorimeters()
{
   if ( !m_theWorld->listOfTubes().empty() )
   {
      int iVol ;
      for ( iVol=0; iVol<m_theWorld->listOfTubes().size(); iVol++ )
      {
         if ( m_theWorld->listOfTubes()[iVol]->pDetector() != 0 )
	 {
	    const DenseMedium* pMedium = new DenseMedium ;
	    pMedium = (DenseMedium*)m_theWorld->listOfTubes()[iVol] ;
	    m_listOfCalorimeters.push_back( pMedium ) ;
	 } 
      }
   } 
   if ( !m_theWorld->listOfBoxes().empty() )
   {
      int iVol ;
      for ( iVol=0; iVol<m_theWorld->listOfBoxes().size(); iVol++ )
      {
         if ( m_theWorld->listOfBoxes()[iVol]->pDetector() != 0 &&
	      m_theWorld->listOfBoxes()[iVol]->pMaterial() != 0 )  // internal trick - skip dipole yokes
	 {
	    const DenseMedium* pMedium = new DenseMedium ;
	    pMedium = (DenseMedium*)m_theWorld->listOfBoxes()[iVol] ;
	    m_listOfCalorimeters.push_back( pMedium ) ;
	 } 
      }
   } 
}

//
// const member functions
//
int
CalorInfo::numberOfCalorimeters() const
{
   return m_listOfCalorimeters.size() ;
}

int
CalorInfo::numberOfNeighbours( const int iCal ) const
{
   if ( listOfCalorimeters().empty() ) return 0 ;
   if ( iCal >= listOfCalorimeters().size() ) return 0 ;
   return listOfCalorimeters()[iCal]->listOfNeighbours().size() ;
}

int
CalorInfo::numberOfNeighbours( const DenseMedium* iCal ) const
{
   if ( iCal == 0 ) return 0 ;
   return iCal->listOfNeighbours().size() ;
}

vector< DenseMedium* >&
CalorInfo::listOfNeighbours( const int iCal ) const 
{
   if ( !listOfCalorimeters().empty() && iCal < listOfCalorimeters().size() ) 
      return listOfCalorimeters()[iCal]->listOfNeighbours() ;
} 

vector< DenseMedium* >&
CalorInfo::listOfNeighbours( const DenseMedium* iCal ) const
{
   if ( iCal != 0 ) return iCal->listOfNeighbours() ;
}
      
int
CalorInfo::numberOfHits( const int iCal ) const 
{
   if ( listOfCalorimeters().empty() ) return 0 ;
   if ( iCal >= listOfCalorimeters().size() ) return 0 ;
   return ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->numberOfHits() ;
}

int
CalorInfo::numberOfHitsForNeighbour( const int iCal, const int iNeigh ) const
{
   if ( listOfCalorimeters().empty() ) return 0 ;
   if ( iCal >= listOfCalorimeters().size() ) return 0 ;
   if ( listOfNeighbours( iCal ).empty() ) return 0 ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return 0 ;
   return ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->numberOfHits() ;
}

int
CalorInfo::numberOfHits( const DenseMedium* iCal ) const
{
   if ( iCal == 0 ) return 0 ;
   return ((Calorimeter*)iCal->pDetector())->numberOfHits() ;
}

vector< CalorCellAddress >
CalorInfo::listOfHits( const int iCal ) const
{
   vector<CalorCellAddress> HitList ;
   if ( !HitList.empty() )
      HitList.erase( HitList.begin(), HitList.end() ) ;
   if ( numberOfHits( iCal ) <= 0 ) return HitList ;
   const int* nCell = numberOfCells( iCal ) ;
   if ( nCell == 0 ) return HitList ;
   HitList.reserve( numberOfHits( iCal ) ) ;
   int i, j ;
   for ( i=0; i<(*nCell); i++ )
   {
      for ( j=0; j<(*(nCell+1)); j++ )
      {
         if ( pGridOfCells( iCal )[i][j]->getInfoTracks().empty() ) continue ;
	 HitList.push_back( CalorCellAddress() ) ;
	 HitList.back().address[0] = i ;
	 HitList.back().address[1] = j ;
      }
   }
   return HitList ;
}

vector< CalorCellAddress >
CalorInfo::listOfHitsForNeighbour( const int iCal, const int iNeigh ) const
{
   vector<CalorCellAddress> HitList ;
   if ( !HitList.empty() )
      HitList.erase( HitList.begin(), HitList.end() ) ;
   if ( iCal >= listOfCalorimeters().size() ) return HitList ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return HitList ;
   if ( numberOfHitsForNeighbour( iCal, iNeigh ) <= 0 ) return HitList ;
   const int* nCell = numberOfCellsForNeighbour( iCal, iNeigh ) ;
   if ( nCell == 0 ) return HitList ;
   HitList.reserve( numberOfHitsForNeighbour( iCal, iNeigh ) ) ;
   int i, j ;
   for ( i=0; i<(*nCell); i++ )
   {
      for ( j=0; j<(*(nCell+1)); j++ )
      {
         if ( pGridOfCellsForNeighbour( iCal, iNeigh )[i][j]->getInfoTracks().empty() ) continue ;
	 HitList.push_back( CalorCellAddress() ) ;
	 HitList.back().address[0] = i ;
	 HitList.back().address[1] = j ;
      }
   } 
   return HitList ;
}

vector< CalorCellAddress >
CalorInfo::listOfHits( const DenseMedium* iCal ) const
{
   vector<CalorCellAddress> HitList ;
   if ( !HitList.empty() )
      HitList.erase( HitList.begin(), HitList.end() ) ;
   if ( numberOfHits( iCal ) <= 0 ) return HitList ;
   const int* nCell = numberOfCells( iCal ) ;
   if ( nCell == 0 ) return HitList ;
   HitList.reserve( numberOfHits( iCal ) ) ;
   int i, j ;
   for ( i=0; i<(*nCell); i++ )
   {
      for ( j=0; j<(*(nCell+1)); j++ )
      {
         if ( pGridOfCells( iCal )[i][j]->getInfoTracks().empty() ) continue ;
	 HitList.push_back( CalorCellAddress() ) ;
	 HitList.back().address[0] = i ;
	 HitList.back().address[1] = j ;
      }
   }
   return HitList ;
}

vector< CalorCellAddress >
CalorInfo::listOfHitsSortedByEnergy( const int iCal ) const
{
   vector<CalorCellAddress> HitList ;
   if ( !HitList.empty() )
      HitList.erase( HitList.begin(), HitList.end() ) ;
   if ( numberOfHits( iCal ) <= 0 ) return HitList ;
   const int* nCell = numberOfCells( iCal ) ;
   if ( nCell == 0 ) return HitList ;
   HitList.reserve( numberOfHits( iCal ) ) ;
   CalorSignalMC*** pGrid = pGridOfCells( iCal ) ;
   if ( pGrid == NULL ) return HitList ;
   int i, j ;
   double eTotal1, eTotal2 ;
   vector<CalorCellAddress>::iterator iter, end ;
   for ( i=0; i<(*nCell); i++ )
   {
      for ( j=0; j<(*(nCell+1)); j++ )
      {
         if ( pGrid[i][j]->getInfoTracks().empty() ) continue ;
	 if ( HitList.empty() )
	 {
  	    HitList.push_back( CalorCellAddress() ) ;
	    HitList.back().address[0] = i ;
	    HitList.back().address[1] = j ;
	    continue ;
	 }
	 eTotal1 = pGrid[i][j]->getE() ;
	 eTotal2 = pGrid[HitList.back().address[0]][HitList.back().address[1]]->getE() ;
	 if ( eTotal1 < eTotal2 )
	 {
	    HitList.push_back( CalorCellAddress() ) ;
	    HitList.back().address[0] = i ;
	    HitList.back().address[1] = j ;
	    continue ;
	 }
	 end = HitList.end() ;
	 for ( iter=HitList.begin(); iter!=end; iter++ )
	 {
	    eTotal2 = pGrid[iter->address[0]][iter->address[1]]->getE() ;
	    if ( eTotal1 < eTotal2 ) continue ;
	    HitList.insert( iter, CalorCellAddress() ) ;
	    iter->address[0] = i ;
	    iter->address[1] = j ;
	    break ;
	 }
      }
   }
   return HitList ;
}

vector< CalorCellAddress >
CalorInfo::listOfHitsSortedByEnergyForNeighbour( const int iCal, const int iNeigh ) const 
{
   vector<CalorCellAddress> HitList ;
   if ( !HitList.empty() )
      HitList.erase( HitList.begin(), HitList.end() ) ;
   if ( numberOfHitsForNeighbour( iCal, iNeigh ) <= 0 ) return HitList ;
   const int* nCell = numberOfCellsForNeighbour( iCal, iNeigh ) ;
   if ( nCell == 0 ) return HitList ;
   HitList.reserve( numberOfHitsForNeighbour( iCal, iNeigh ) ) ;
   CalorSignalMC*** pGrid = pGridOfCellsForNeighbour( iCal, iNeigh ) ;
   if ( pGrid == 0 ) return HitList ;
   int i, j ;
   double eTotal1, eTotal2 ; 
   vector<CalorCellAddress>::iterator iter, end ;
   for ( i=0; i<(*nCell); i++ )
   {
      for ( j=0; j<(*(nCell+1)); j++ )
      {
         if ( pGrid[i][j]->getInfoTracks().empty() ) continue ;
	 if ( HitList.empty() )
	 {
	    HitList.push_back( CalorCellAddress() ) ;
	    HitList.back().address[0] = i ;
	    HitList.back().address[1] = j ;
	    continue ;
	 }
	 eTotal1 = pGrid[i][j]->getE() ;
	 eTotal2 = pGrid[HitList.back().address[0]][HitList.back().address[1]]->getE() ;
	 if ( eTotal1 < eTotal2 )
	 {
	    HitList.push_back( CalorCellAddress() ) ;
	    HitList.back().address[0] = i ;
	    HitList.back().address[1] = j ;
	    continue ;
	 }
	 end = HitList.end() ;
	 for ( iter=HitList.begin(); iter!=end; iter++ )
	 {
	    eTotal2 = pGrid[iter->address[0]][iter->address[1]]->getE() ;
	    if ( eTotal1 < eTotal2 ) continue ;
	    HitList.insert( iter, CalorCellAddress() ) ;
	    iter->address[0] = i ;
	    iter->address[1] = j ;
	    break ;
	 }
      }
   }
   return HitList ;
}

vector< CalorCellAddress >
CalorInfo::listOfHitsSortedByEnergy( const DenseMedium* iCal ) const
{
   vector<CalorCellAddress> HitList ;
   if ( !HitList.empty() )
      HitList.erase( HitList.begin(), HitList.end() ) ;
   if ( listOfCalorimeters().empty() ) return HitList ;
   if ( numberOfHits( iCal ) <= 0 ) return HitList ;
   const int* nCell = numberOfCells( iCal ) ;
   if ( nCell <= 0 ) return HitList ;
   HitList.reserve( numberOfHits( iCal ) ) ;
   CalorSignalMC*** pGrid = pGridOfCells( iCal ) ;
   int i, j ;
   double eTotal1, eTotal2 ;
   vector<CalorCellAddress>::iterator iter, end ;
   for ( i=0; i<(*nCell); i++ )
   {
      for ( j=0; j<(*(nCell+1)); j++ )
      {
         if ( pGrid[i][j]->getInfoTracks().empty() ) continue ;
	 if ( HitList.empty() )
	 {
	    HitList.push_back( CalorCellAddress() ) ;
	    HitList.back().address[0] = i ;
	    HitList.back().address[1] = j ;
	    continue ;
	 }
	 eTotal1 = pGrid[i][j]->getE() ;
	 eTotal2 = pGrid[HitList.back().address[0]][HitList.back().address[1]]->getE() ;
	 if ( eTotal1 < eTotal2 )
	 {
	    HitList.push_back( CalorCellAddress() ) ;
	    HitList.back().address[0] = i ;
	    HitList.back().address[1] = j ;
	    continue ;
	 }
	 end = HitList.end() ;
	 for ( iter=HitList.begin(); iter!=end; iter++ )
	 {
	    eTotal2 = pGrid[iter->address[0]][iter->address[1]]->getE() ;
	    if ( eTotal1 < eTotal2 ) continue ;
	    HitList.insert( iter, CalorCellAddress() ) ;
	    iter->address[0] = i ;
	    iter->address[1] = j ;
	    break ;
	 }
      }
   }
   return HitList ;
}

CalorSignalMC***
CalorInfo::pGridOfCells( const int iCal ) const
{
   if ( listOfCalorimeters().empty() ) return NULL ;
   return ( ( iCal < listOfCalorimeters().size() ) ?
      ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->pGridOfCells() : NULL );
}

CalorSignalMC***
CalorInfo::pGridOfCellsForNeighbour( const int iCal, const int iNeigh ) const 
{
   if ( listOfCalorimeters().empty() ) return NULL ;
   if ( iCal >= listOfCalorimeters().size() ) return NULL ;
   if ( listOfNeighbours( iCal ).empty() ) return NULL ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return NULL ;
   return ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->pGridOfCells() ;
}

CalorSignalMC***
CalorInfo::pGridOfCells( const DenseMedium* iCal ) const
{
   return ( iCal ? ((Calorimeter*)iCal->pDetector())->pGridOfCells() : NULL ) ;
}


const int
CalorInfo::deviceIndex( const int iCal ) const 
{
   if ( listOfCalorimeters().empty() ) return 0 ;
   return ( (iCal < listOfCalorimeters().size()) ? 
      listOfCalorimeters()[iCal]->pDetector()->deviceIndexF() : 0 ) ;
}

const int
CalorInfo::deviceIndexForNeighbour( const int iCal, const int iNeigh ) const
{
   if ( listOfCalorimeters().empty() ) return 0 ;
   if ( iCal >= listOfCalorimeters().size() ) return 0 ;
   return ( (iNeigh < listOfNeighbours( iCal ).size()) ?
      listOfNeighbours( iCal )[iNeigh]->pDetector()->deviceIndexF() : 0 ) ;
}

const int
CalorInfo::deviceIndex( const DenseMedium* iCal ) const
{
   return ( iCal ? iCal->pDetector()->deviceIndexF() : 0 ) ;
}
 
const char*
CalorInfo::segmentationType( const int iCal ) const
{
   if ( listOfCalorimeters().empty() ) return "unknown type" ;
   return ( ( iCal < listOfCalorimeters().size() ) ?
      ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->segmentationType() : "unknown type" );
}

const char*
CalorInfo::segmentationTypeForNeighbour( const int iCal, const int iNeigh ) const
{
   if ( listOfCalorimeters().empty() ) return "unknown type" ;
   if ( iCal >= listOfCalorimeters().size() ) return "unknown type" ;
   if ( listOfNeighbours( iCal ).empty() ) return "unknown type" ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return "unknown type" ;
   return ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->segmentationType() ;
   
}

const char*
CalorInfo::segmentationType( const DenseMedium* iCal ) const
{
   return ( iCal ? ((Calorimeter*)iCal->pDetector())->segmentationType() : "unknown type" );
}


const int*
CalorInfo::numberOfCells( const int iCal ) const 
{
   if ( listOfCalorimeters().empty() ) return 0 ; 
   return ( ( iCal < listOfCalorimeters().size() ) ?
      ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->numberOfSegments() : 0 );
}

const int*
CalorInfo::numberOfCellsForNeighbour( const int iCal, const int iNeigh ) const
{
   if ( listOfCalorimeters().empty() ) return 0 ; 
   if ( iCal >= listOfCalorimeters().size() ) return 0 ;
   if ( listOfNeighbours( iCal ).empty() ) return 0 ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return 0 ;
   return ((Calorimeter*)listOfNeighbours(iCal)[iNeigh]->pDetector())->numberOfSegments() ;
   
}

const int*
CalorInfo::numberOfCells( const DenseMedium* iCal ) const 
{
   return ( iCal ? ((Calorimeter*)iCal->pDetector())->numberOfSegments() : 0 ) ;
}

const double*
CalorInfo::cellSize( const int iCal ) const 
{
   if ( listOfCalorimeters().empty() ) return 0 ;
   return ( (iCal < listOfCalorimeters().size()) ?
       ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->cellSize() : 0 ) ;
}
 
const double*
CalorInfo::cellSizeForNeighbour( const int iCal, const int iNeigh ) const
{
   if ( listOfCalorimeters().empty() ) return 0 ;
   if ( iCal >= listOfCalorimeters().size() ) return 0 ;
   return ( (iNeigh<listOfNeighbours( iCal ).size()) ?
      ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->cellSize() : 0 ) ;
}

const double*
CalorInfo::cellSize( const DenseMedium* iCal ) const 
{
   return ( iCal ? ((Calorimeter*)iCal->pDetector())->cellSize() : 0 ) ;
}

const double*
CalorInfo::limits( const int iCal ) const
{
   if ( listOfCalorimeters().empty() ) return 0 ;
   return ( ( iCal < listOfCalorimeters().size() ) ?
      ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->limits() : 0 ) ; 
}

const double*
CalorInfo::limitsForNeighbour( const int iCal, const int iNeigh ) const
{
   if ( listOfCalorimeters().empty() ) return 0 ;
   if ( iCal >= listOfCalorimeters().size() ) return 0 ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return 0 ;
   return ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->limits() ;
}

const double*
CalorInfo::limits( const DenseMedium* iCal ) const
{
   return ( iCal ? ((Calorimeter*)iCal->pDetector())->limits() : 0 ) ;
}

const double
CalorInfo::etaMin( const int iCal ) const
{
   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   return ( ( iCal < listOfCalorimeters().size() ) ?
      ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->etaMin() : FLT_MAX );
}

const double
CalorInfo::etaMinForNeighbour( const int iCal, const int iNeigh ) const
{
   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   if ( iCal >= listOfCalorimeters().size() ) return FLT_MAX ;
   if ( listOfNeighbours( iCal ).empty() ) return FLT_MAX ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return FLT_MAX ;
   return ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->etaMin() ;
   
}

const double
CalorInfo::etaMin( const DenseMedium* iCal ) const
{
   return ( iCal ? ((Calorimeter*)iCal->pDetector())->etaMin() : FLT_MAX ) ;
}

const double
CalorInfo::etaMax( const int iCal ) const
{
   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   return ( ( iCal < listOfCalorimeters().size() ) ?
      ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->etaMax() : FLT_MAX );
}

const double
CalorInfo::etaMaxForNeighbour( const int iCal, const int iNeigh ) const
{
   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   if ( iCal >= listOfCalorimeters().size() ) return FLT_MAX ;
   if ( listOfNeighbours( iCal ).empty() ) return FLT_MAX ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return FLT_MAX ;
   return ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->etaMax() ;
   
}

const double
CalorInfo::etaMax( const DenseMedium* iCal ) const
{
   return ( iCal ? ((Calorimeter*)iCal->pDetector())->etaMax() : FLT_MAX ) ;
}

const double
CalorInfo::phiMin( const int iCal ) const
{
   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   return ( ( iCal < listOfCalorimeters().size() ) ?
      ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->phiMin() : FLT_MAX );
}

const double
CalorInfo::phiMinForNeighbour( const int iCal, const int iNeigh ) const
{
   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   if ( iCal >= listOfCalorimeters().size() ) return FLT_MAX ;
   if ( listOfNeighbours( iCal ).empty() ) return FLT_MAX ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return FLT_MAX ;
   return ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->phiMin() ;
   
}

const double
CalorInfo::phiMin( const DenseMedium* iCal ) const
{
   return ( iCal ? ((Calorimeter*)iCal->pDetector())->phiMin() : FLT_MAX ) ;
}

const double
CalorInfo::phiMax( const int iCal ) const
{
   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   return ( ( iCal < listOfCalorimeters().size() ) ?
      ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->phiMax() : FLT_MAX );
}

const double
CalorInfo::phiMaxForNeighbour( const int iCal, const int iNeigh ) const
{
   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   if ( iCal >= listOfCalorimeters().size() ) return FLT_MAX ;
   if ( listOfNeighbours( iCal ).empty() ) return FLT_MAX ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return FLT_MAX ;
   return ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->phiMax() ;
   
}

const double
CalorInfo::phiMax( const DenseMedium* iCal ) const
{
   return ( iCal ? ((Calorimeter*)iCal->pDetector())->phiMax() : FLT_MAX ) ;
}

const double
CalorInfo::stochasticTermEM( const int iCal ) const
{
   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   return ( ( iCal < listOfCalorimeters().size() ) ?
      ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->stochasticTermEM() : FLT_MAX );
}

const double
CalorInfo::stochasticTermEMForNeighbour( const int iCal, const int iNeigh ) const
{
   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   if ( iCal >= listOfCalorimeters().size() ) return FLT_MAX ;
   if ( listOfNeighbours( iCal ).empty() ) return FLT_MAX ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return FLT_MAX ;
   return ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->stochasticTermEM() ;
   
}

const double
CalorInfo::stochasticTermEM( const DenseMedium* iCal ) const
{
   return ( iCal ? ((Calorimeter*)iCal->pDetector())->stochasticTermEM() : FLT_MAX ) ;
}

const double
CalorInfo::constantTermEM( const int iCal ) const
{
   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   return ( ( iCal < listOfCalorimeters().size() ) ?
      ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->constTermEM() : FLT_MAX );
}

const double
CalorInfo::constantTermEMForNeighbour( const int iCal, const int iNeigh ) const
{
   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   if ( iCal >= listOfCalorimeters().size() ) return FLT_MAX ;
   if ( listOfNeighbours( iCal ).empty() ) return FLT_MAX ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return FLT_MAX ;
   return ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->constTermEM() ;
   
}

const double
CalorInfo::constantTermEM( const DenseMedium* iCal ) const
{
   return ( iCal ? ((Calorimeter*)iCal->pDetector())->constTermEM() : FLT_MAX ) ;
}

const double
CalorInfo::stochasticTermHAD( const int iCal ) const
{
   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   return ( ( iCal < listOfCalorimeters().size() ) ?
      ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->stochasticTermHAD() : FLT_MAX );
}

const double
CalorInfo::stochasticTermHADForNeighbour( const int iCal, const int iNeigh ) const
{
   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   if ( iCal >= listOfCalorimeters().size() ) return FLT_MAX ;
   if ( listOfNeighbours( iCal ).empty() ) return FLT_MAX ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return FLT_MAX ;
   return ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->stochasticTermHAD() ;
   
}

const double
CalorInfo::stochasticTermHAD( const DenseMedium* iCal ) const
{
   return ( iCal ? ((Calorimeter*)iCal->pDetector())->stochasticTermHAD() : FLT_MAX ) ;
}

const double
CalorInfo::constantTermHAD( const int iCal ) const
{
   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   return ( ( iCal < listOfCalorimeters().size() ) ?
      ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->constTermHAD() : FLT_MAX );
}

const double
CalorInfo::constantTermHADForNeighbour( const int iCal, const int iNeigh ) const
{
   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   if ( iCal >= listOfCalorimeters().size() ) return FLT_MAX ;
   if ( listOfNeighbours( iCal ).empty() ) return FLT_MAX ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return FLT_MAX ;
   return ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->constTermHAD() ;
   
}

const double
CalorInfo::constantTermHAD( const DenseMedium* iCal ) const
{
   return ( iCal ? ((Calorimeter*)iCal->pDetector())->constTermHAD() : FLT_MAX ) ;
}

const double
CalorInfo::ratioEMtoHAD( const int iCal ) const
{
   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   return ( ( iCal < listOfCalorimeters().size() ) ?
      ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->ratioEMtoHAD() : FLT_MAX );
}

const double
CalorInfo::ratioEMtoHADForNeighbour( const int iCal, const int iNeigh ) const
{
   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   if ( iCal >= listOfCalorimeters().size() ) return FLT_MAX ;
   if ( listOfNeighbours( iCal ).empty() ) return FLT_MAX ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return FLT_MAX ;
   return ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->ratioEMtoHAD() ;
   
}

const double
CalorInfo::ratioEMtoHAD( const DenseMedium* iCal ) const
{
   return ( iCal ? ((Calorimeter*)iCal->pDetector())->ratioEMtoHAD() : FLT_MAX ) ;
}

const char*
CalorInfo::name( const int iCal ) const 
{
   if ( listOfCalorimeters().empty() ) return "no name" ;
   return ( (iCal < listOfCalorimeters().size()) ? listOfCalorimeters()[iCal]->fortranName() : "no name" ) ;
   
}

const char*
CalorInfo::nameForNeighbour( const int iCal, const int iNeigh ) const
{
   if ( listOfCalorimeters().empty() ) return "no name" ;
   if ( iCal >= listOfCalorimeters().size() ) return "no name" ;
   if ( listOfNeighbours( iCal ).empty() ) return "no name" ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return "no name" ;
   return listOfNeighbours( iCal )[iNeigh]->fortranName() ;
}

const char* 
CalorInfo::name( const DenseMedium* iCal ) const
{
   return ( iCal ? iCal->fortranName() : "no name" ) ;
}

const double
CalorInfo::rmin( const int iCal ) const
{
//   int devIndex = deviceIndex( iCal ) ;
//   if ( devIndex <= 0 ) return FLT_MAX ;
//   if ( emcal_is_box_( devIndex ) ) return FLT_MAX ;
//   return  
//      ((Tube*)listOfCalorimeters()[iCal]->pVolume())->rmin() ;

   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   return ( ( iCal < listOfCalorimeters().size() ) ?
      ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->rMin() : FLT_MAX ) ;

}

const double
CalorInfo::rminForNeighbour( const int iCal, const int iNeigh ) const 
{
//     int devIndex = deviceIndexForNeighbour( iCal, iNeigh ) ;
//     if ( devIndex <= 0 ) return FLT_MAX ;
//     if ( emcal_is_box_( devIndex ) ) return FLT_MAX ;
//     return ((Tube*)listOfNeighbours( iCal )[iNeigh]->pVolume())->rmin() ;

   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   if ( iCal >= listOfCalorimeters().size() ) return FLT_MAX ;
   if ( listOfNeighbours( iCal ) .empty() ) return FLT_MAX ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return FLT_MAX ;
   return ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->rMin() ;
   
}

const double
CalorInfo::rmin( const DenseMedium* iCal ) const
{
//   int devIndex = deviceIndex( iCal ) ;
//   if ( devIndex <= 0 ) return FLT_MAX ;
//   if ( emcal_is_box_( devIndex ) ) return FLT_MAX ;
//   return ((Tube*)iCal->pVolume())->rmin() ;

   return ( iCal ? ((Calorimeter*)iCal->pDetector())->rMin() : FLT_MAX ) ;

}

const double
CalorInfo::rmax( const int iCal ) const
{
//   int devIndex = deviceIndex( iCal ) ;
//   if ( devIndex <= 0 ) return FLT_MAX ;
//   if ( emcal_is_box_( devIndex ) ) return FLT_MAX ;
//   return 
//      ((Tube*)listOfCalorimeters()[iCal]->pVolume())->rmax() ;

   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   return ( ( iCal < listOfCalorimeters().size() ) ?
      ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->rMax() : FLT_MAX ) ;

}

const double
CalorInfo::rmaxForNeighbour( const int iCal, const int iNeigh ) const 
{
//   int devIndex = deviceIndexForNeighbour( iCal, iNeigh ) ;
//   if ( devIndex <= 0 ) return FLT_MAX ;
//   if ( emcal_is_box_( devIndex ) ) return FLT_MAX ;
//   return 
//      ((Tube*)listOfNeighbours( iCal )[iNeigh]->pVolume())->rmax() ;

   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   if ( iCal >= listOfCalorimeters().size() ) return FLT_MAX ;
   if ( listOfNeighbours( iCal ) .empty() ) return FLT_MAX ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return FLT_MAX ;
   return ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->rMax() ;

}

const double
CalorInfo::rmax( const DenseMedium* iCal ) const
{
//   int devIndex = deviceIndex( iCal ) ;
//   if ( devIndex <= 0 ) return FLT_MAX ;
//   if ( emcal_is_box_( devIndex ) ) return FLT_MAX ;
//   return ((Tube*)iCal->pVolume())->rmax() ;

   return ( iCal ? ((Calorimeter*)iCal->pDetector())->rMax() : FLT_MAX ) ;

}
 
const double
CalorInfo::zmin( const int iCal ) const
{
   int devIndex = deviceIndex( iCal ) ;
   if ( devIndex <= 0 ) return FLT_MAX ;
   if ( emcal_is_box_( devIndex ) ) 
   {
      return  
         ((AlignedBox*)listOfCalorimeters()[iCal]->pVolume())->wall(AlignedBox::kZMinWall)->zmin() ;
   }
   else
      return  
         ((Tube*)listOfCalorimeters()[iCal]->pVolume())->zmin() ;

//   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
//   return ( ( iCal < listOfCalorimeters().size() ) ?
//      ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->zMin() : FLT_MAX ) ;
}

const double
CalorInfo::zminForNeighbour( const int iCal, const int iNeigh ) const 
{
   int devIndex = deviceIndexForNeighbour( iCal, iNeigh ) ;
   if ( devIndex <= 0 ) return FLT_MAX ;
   if ( emcal_is_box_( devIndex ) )
   {
      return 
         ((AlignedBox*)listOfNeighbours( iCal )[iNeigh]->pVolume())->wall(AlignedBox::kZMinWall)->zmin() ;
   }
   else
      return 
         ((Tube*)listOfNeighbours( iCal )[iNeigh]->pVolume())->zmin() ;

//   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
//   if ( iCal >= listOfCalorimeters().size() ) return FLT_MAX ;
//   if ( listOfNeighbours( iCal ) .empty() ) return FLT_MAX ;
//   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return FLT_MAX ;
//   return ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->zMin() ;

}

const double
CalorInfo::zmin( const DenseMedium* iCal ) const
{
   
   int devIndex = deviceIndex( iCal ) ;
   if ( devIndex <= 0 ) return FLT_MAX ;
   if ( emcal_is_box_( devIndex ) )
   {
      return ((AlignedBox*)iCal->pVolume())->wall(AlignedBox::kZMinWall)->zmin() ;
   }
   else
      return ((Tube*)iCal->pVolume())->zmin() ;

//   return ( iCal ? ((Calorimeter*)iCal->pDetector())->zMin() : FLT_MAX ) ;

}

const double
CalorInfo::zmax( const int iCal ) const
{
   int devIndex = deviceIndex( iCal ) ;
   if ( devIndex <= 0 ) return FLT_MAX ;
   if ( emcal_is_box_( devIndex ) )
   {
      return
         ((AlignedBox*)listOfCalorimeters()[iCal]->pVolume())->wall(AlignedBox::kZMaxWall)->zmax() ;
   }
   else 
      return  
         ((Tube*)listOfCalorimeters()[iCal]->pVolume())->zmax() ;

   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   return ( ( iCal < listOfCalorimeters().size() ) ?
      ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->zMax() : FLT_MAX ) ;

}

const double
CalorInfo::zmaxForNeighbour( const int iCal, const int iNeigh ) const 
{
   int devIndex = deviceIndexForNeighbour( iCal, iNeigh ) ;
   if ( devIndex <= 0 ) return FLT_MAX ;
   if ( emcal_is_box_( devIndex ) )
   {
      return 
         ((AlignedBox*)listOfNeighbours( iCal )[iNeigh]->pVolume())->wall(AlignedBox::kZMaxWall)->zmax() ;
   }
   else
      return 
         ((Tube*)listOfNeighbours( iCal )[iNeigh]->pVolume())->zmax() ;

//   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
//   if ( iCal >= listOfCalorimeters().size() ) return FLT_MAX ;
//   if ( listOfNeighbours( iCal ) .empty() ) return FLT_MAX ;
//   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return FLT_MAX ;
//   return ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->zMax() ;

}

const double
CalorInfo::zmax( const DenseMedium* iCal ) const
{
   int devIndex = deviceIndex( iCal ) ;
   if ( devIndex <= 0 ) return FLT_MAX ;
   if ( emcal_is_box_( devIndex ) )
   {
      return ((AlignedBox*)iCal->pVolume())->wall(AlignedBox::kZMaxWall)->zmax() ;
   }
   else
      return ((Tube*)iCal->pVolume())->zmax() ;

//   return ( iCal ? ((Calorimeter*)iCal->pDetector())->zMax() : FLT_MAX ) ;

}

const double
CalorInfo::xmin( const int iCal ) const
{

   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   return ( ( iCal < listOfCalorimeters().size() ) ?
      ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->xMin() : FLT_MAX ) ;

}

const double
CalorInfo::xminForNeighbour( const int iCal, const int iNeigh ) const 
{

   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   if ( iCal >= listOfCalorimeters().size() ) return FLT_MAX ;
   if ( listOfNeighbours( iCal ) .empty() ) return FLT_MAX ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return FLT_MAX ;
   return ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->xMin() ;

}

const double
CalorInfo::xmin( const DenseMedium* iCal ) const
{

   return ( iCal ? ((Calorimeter*)iCal->pDetector())->xMin() : FLT_MAX ) ;

}

const double
CalorInfo::xmax( const int iCal ) const
{

   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   return ( ( iCal < listOfCalorimeters().size() ) ?
      ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->xMax() : FLT_MAX ) ;

}

const double
CalorInfo::xmaxForNeighbour( const int iCal, const int iNeigh ) const 
{

   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   if ( iCal >= listOfCalorimeters().size() ) return FLT_MAX ;
   if ( listOfNeighbours( iCal ) .empty() ) return FLT_MAX ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return FLT_MAX ;
   return ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->xMax() ;

}

const double
CalorInfo::xmax( const DenseMedium* iCal ) const
{

   return ( iCal ? ((Calorimeter*)iCal->pDetector())->xMax() : FLT_MAX ) ;

}

const double
CalorInfo::ymin( const int iCal ) const
{

   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   return ( ( iCal < listOfCalorimeters().size() ) ?
      ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->yMin() : FLT_MAX ) ;

}

const double
CalorInfo::yminForNeighbour( const int iCal, const int iNeigh ) const 
{

   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   if ( iCal >= listOfCalorimeters().size() ) return FLT_MAX ;
   if ( listOfNeighbours( iCal ) .empty() ) return FLT_MAX ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return FLT_MAX ;
   return ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->yMin() ;

}

const double
CalorInfo::ymin( const DenseMedium* iCal ) const
{

   return ( iCal ? ((Calorimeter*)iCal->pDetector())->yMin() : FLT_MAX ) ;

}

const double
CalorInfo::ymax( const int iCal ) const
{

   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   return ( ( iCal < listOfCalorimeters().size() ) ?
      ((Calorimeter*)listOfCalorimeters()[iCal]->pDetector())->yMax() : FLT_MAX ) ;

}

const double
CalorInfo::ymaxForNeighbour( const int iCal, const int iNeigh ) const 
{

   if ( listOfCalorimeters().empty() ) return FLT_MAX ;
   if ( iCal >= listOfCalorimeters().size() ) return FLT_MAX ;
   if ( listOfNeighbours( iCal ) .empty() ) return FLT_MAX ;
   if ( iNeigh >= listOfNeighbours( iCal ).size() ) return FLT_MAX ;
   return ((Calorimeter*)listOfNeighbours( iCal )[iNeigh]->pDetector())->yMax() ;

}

const double
CalorInfo::ymax( const DenseMedium* iCal ) const
{

   return ( iCal ? ((Calorimeter*)iCal->pDetector())->yMax() : FLT_MAX ) ;

}

//
// static member functions
//
CalorInfo*
CalorInfo::getCalorInfo()
{
   if ( m_instance == 0 )
   {
      m_instance = new CalorInfo ;
   }
   return m_instance ;
}


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:29  eugenio
// Initial revision
//
// Revision 1.7  1999/10/06 21:21:52  yarba_j
// cal.hits storage : 2-dim.array for hits becomes a pointer to the array of hits; access methods like gridOfCells become pGridOfCells
//
// Revision 1.6  1999/09/24  20:18:31  yarba_j
// more cleanup (agreed with Andreas on naming)
//
// Revision 1.5  1999/09/23  22:31:09  yarba_j
// now using CalorSignalMC for hit generation + minor modifications
//
// Revision 1.3  1999/02/25  00:19:14  yarba_j
// minor cleanip/bug fix (skip dipole yokes when create list of calorimeters)
//
// Revision 1.2  1999/02/22  23:15:45  yarba_j
// handle hit generation in box-shaped calorimeters
//
// Revision 1.1  1999/01/15  17:50:49  yarba_j
// hit generation in calorimeters reimplemented in C++; also includes user interface on calorimetry hits for C++ programmers
//


// -*- C++ -*-
//
// Package:     <Showering>
// Module:      DenseMedium
// 
// Description: <one line class summary>
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner, Julia Yarba
// Created:     Sat Aug  2 12:50:06 CDT 1997
//

// system include files
#include <math.h>

// user include files
#include "externFortran.hh"
#include "RealMaterial.hh"
#include "Detector.hh"
#include "Trace.hh"
#include "MCParticle.hh"
#include "UserSettings.hh"
#include "Material.hh"
#include "DenseMedium.hh"
#include "ProxyMedium.hh"
// #include "Surface.hh"
#include "RSurface.hh"
#include "ZCircularSurface.hh"
// #include "Volume.hh"
#include "Tube.hh"
#include "DetCalorimeter.hh"

#include "changeWTrack.hh"

#include "report.hh"

// forward declaration
//class RealMaterial ;

// STL classes

//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Tracing.DenseMedium";

typedef vector<Medium*> MediumList ;
typedef vector<DenseMedium*> DenseMediumList ;

//
// static data member definitions
//

//
// constructors and destructor
//
DenseMedium::DenseMedium()
  : m_listOfNeighbours( *new DenseMediumList )
{
   assert( &m_listOfNeighbours != 0 ) ;
}

DenseMedium::DenseMedium( const DenseMedium& denseMedium )
  :  m_listOfNeighbours( *new DenseMediumList )
{
  *this = denseMedium;
}

DenseMedium::~DenseMedium()
{
   while ( m_listOfNeighbours.size() > 0 )
   {
     delete m_listOfNeighbours.back() ;
     m_listOfNeighbours.pop_back() ;
   }
   delete &m_listOfNeighbours ;
}

//
// assignment operators
//
const DenseMedium& DenseMedium::operator=( const DenseMedium& denseMedium )
{
   if( this != &denseMedium ) 
   {
      if ( &m_listOfNeighbours == 0 ) 
         m_listOfNeighbours = *new DenseMediumList ;
      while ( !m_listOfNeighbours.empty() )
      {
	 // only delete pointers; no need to delete objects 
	 // since neigbours cross-referrence each other
	 m_listOfNeighbours.pop_back() ;
      }
      int iMed, listSize = denseMedium.listOfNeighbours().size() ;
      for ( iMed=0; iMed<listSize; iMed++ )
      {
	 m_listOfNeighbours.push_back( denseMedium.listOfNeighbours()[iMed] ) ;
      } 
      Medium::operator=( denseMedium );
   }

   return *this;
}

//
// comparison operators
//
bool 
DenseMedium::operator==( const Medium& medium ) const 
{
#if defined(MKLDEBUG)
   report( INFO, kFacilityString ) << "DenseMedium==medium" << endl;
#endif
   return medium.operator==( *this );
}

bool 
DenseMedium::operator==( const DenseMedium& denseMedium ) const 
{
#if defined(MKLDEBUG)
   report( INFO, kFacilityString ) << "DenseMedium==medium" << endl;
#endif
   return ( this == &denseMedium ) ? true : false;
}

bool 
DenseMedium::operator==( const ProxyMedium& proxyMedium ) const 
{
#if defined(MKLDEBUG)
   report( INFO, kFacilityString ) << "DenseMedium==medium" << endl;
#endif
   return ( (Medium*)this == &proxyMedium.m_realMedium ) ? true : false;
}

//
// member functions
//

// Collection of neighbouring DenseMedia
void
DenseMedium::collectRNeighbours( MediumList& mediaList,
                                 MediumList::iterator& iIndex ) 
{

   MediumList::iterator indexOuter, indexPlus, indexMinus ;  

   for ( indexOuter = iIndex+1; indexOuter != mediaList.end(); indexOuter++ )
   {
      if ( (*indexOuter)->classType() != Medium::kDenseMedium ) continue ;
      if ( **indexOuter == **iIndex ) break ;
   }

   if ( indexOuter == mediaList.end() ) return ; 

   DFLOAT radiusToStopAt = 0 ;
   DFLOAT rOfNeigh = 0 ;

   // search for -r-neighbours
   if ( iIndex != mediaList.begin() )
   {
      for ( indexMinus = iIndex-1; 
            indexMinus != mediaList.begin(); indexMinus-- )
      {
         if ( (*indexMinus)->classType() != Medium::kDenseMedium ) continue ;
         // we get here if found another DenseMedium
         if ( ((RSurface*)(*indexMinus)->pSurface())->zmin() <= 
              ((RSurface*)(*iIndex)->pSurface())->zmin() && 
              ((RSurface*)(*indexMinus)->pSurface())->zmax() >= 
              ((RSurface*)(*iIndex)->pSurface())->zmax() )
         {
         // only one neighbour through inner surface
         // ( covers whole z-range of **iIndex ) 
         // add to the **iIndex list of neighbours if it's a detector
            if ( (*indexMinus)->pDetector() != 0 )
            {
               (*iIndex)->addNeighbour( ((ProxyMedium*)(*indexMinus))->realMedium() ) ;
            }
            break ; // break -r-loop in case only one neighbour allowed
         }
         // we get here if next found DenseMedium 
         // does NOT cover whole z-range of **iIndex
         // try to search further for z-overlapping
         if ( ((RSurface*)(*indexMinus)->pSurface())->zmax() <= 
              ((RSurface*)(*iIndex)->pSurface())->zmin() || 
              ((RSurface*)(*indexMinus)->pSurface())->zmin() >= 
              ((RSurface*)(*iIndex)->pSurface())->zmax() )
            continue ;   // continue if no z-overlapping 
         // we get here if z-overlapping 
         // stop searching beyond rmin of previous neighbour 
         rOfNeigh =  
  ((Tube*)(((ProxyMedium*)(*indexMinus))->realMedium())->pVolume())->rmin() ;
         radiusToStopAt = max( radiusToStopAt, rOfNeigh ) ;
         if ( ((RSurface*)(*indexMinus)->pSurface())->radius() 
               <= radiusToStopAt ) break ; // break -r-loop 
         // valid neighbour;
         // put in the **iIndex neighbours list if a detector
         if ( (*indexMinus)->pDetector() != 0 )
         {
            (*iIndex)->addNeighbour( ((ProxyMedium*)(*indexMinus))->realMedium() ) ;
         }
      }
   }

   // search for +r-neighbours
   radiusToStopAt = 
      ((RSurface*)(*(mediaList.end()-1))->pSurface())->radius() ;
   for ( indexPlus = indexOuter+1; indexPlus != mediaList.end(); indexPlus++ )
   {
      if ( (*indexPlus)->classType() != Medium::kDenseMedium ) continue ;
      // we get here if found another DenseMedium
      if ( ((RSurface*)(*indexPlus)->pSurface())->zmin() <= 
           ((RSurface*)(*iIndex)->pSurface())->zmin() && 
           ((RSurface*)(*indexPlus)->pSurface())->zmax() >= 
           ((RSurface*)(*iIndex)->pSurface())->zmax() )
      {
         // only one neighbour through outer surface
         // ( covers whole z-range of **iIndex ) 
         // add to the **iIndex list of neighbours if it's a detector
         if ( (*indexPlus)->pDetector() != 0 )
         {
            (*iIndex)->addNeighbour( ((ProxyMedium*)(*indexPlus))->realMedium() ) ;
         }
         break ; // break +r-loop in case only one neighbour allowed
      }
      // we get here if next found DenseMedium 
      // does NOT cover whole z-range of **iIndex
      // try to search further for z-overlapping
      if ( ((RSurface*)(*indexPlus)->pSurface())->zmax() <= 
           ((RSurface*)(*iIndex)->pSurface())->zmin() || 
           ((RSurface*)(*indexPlus)->pSurface())->zmin() >= 
           ((RSurface*)(*iIndex)->pSurface())->zmax() )
         continue ;   // continue if no z-overlapping 
      // we get here if z-overlapping 
      // stop searching beyond rmax of previous neighbour 
      rOfNeigh =
  ((Tube*)(((ProxyMedium*)(*indexPlus))->realMedium())->pVolume())->rmax() ;
      radiusToStopAt = min( radiusToStopAt, rOfNeigh ) ;
      if ( ((RSurface*)(*indexPlus)->pSurface())->radius() 
           >= radiusToStopAt ) break ; // break +r-loop 
      // valid neighbour;
      // put in the **iIndex neighbours list if a detector
      if ( (*indexPlus)->pDetector() != 0 )
      {
         (*iIndex)->addNeighbour( ((ProxyMedium*)(*indexPlus))->realMedium() ) ;
      }
   }

   return ;
}

void
DenseMedium::collectZNeighbours( MediumList& mediaList,
                                 MediumList::iterator& iIndex ) 
{

   // DO NOT TAKE DIPOLES FOR NOW !!!
   if ( pMaterial() == 0 ) return ;

   // DO NOT TAKE BOX-SHAPED VOLUMES FOR NOW !!!
   int fIndex ;
   fIndex = commonIndexF() ; 
   if ( emcal_is_box_( fIndex) ) return ;


   MediumList::iterator indexOuter, indexPlus, indexMinus ;  

   for ( indexOuter = iIndex+1; indexOuter != mediaList.end(); indexOuter++ )
   {
      if ( (*indexOuter)->classType() != Medium::kDenseMedium ) continue ;
      if ( **indexOuter == **iIndex ) break ;
   }

   if ( indexOuter == mediaList.end() ) return ; 

   DFLOAT zToStopAt, zOfNeigh ;

   // search for -z-neighbours
   zToStopAt = 
      ((ZSurface*)(*(mediaList.begin()))->pSurface())->z() ;
   if ( iIndex != mediaList.begin() )
   {
      for ( indexMinus = iIndex-1; 
            indexMinus != mediaList.begin(); indexMinus-- )
      {	 
	 if ( (*indexMinus)->classType() != Medium::kDenseMedium ) continue ;
         // DO NOT TAKE DIPOLES FOR NOW !!!
         if ( (*indexMinus)->pMaterial() == 0 ) continue ;
         // DO NOT TAKE BOX-SHAPED VOLUMES FOR NOW !!!
	 fIndex = ((ProxyMedium*)(*indexMinus))->realMedium()->commonIndexF() ;
	 if ( emcal_is_box_( fIndex ) ) continue ;
         // we get here if found another DenseMedium (TUBE-shaped !!!) 
         if ( ((ZCircularSurface*)(*indexMinus)->pSurface())->rmin() <= 
              ((ZCircularSurface*)(*iIndex)->pSurface())->rmin() && 
              ((ZCircularSurface*)(*indexMinus)->pSurface())->rmax() >= 
              ((ZCircularSurface*)(*iIndex)->pSurface())->rmax() )
         {
         // only one neighbour through zmin surface
         // ( covers whole r-range of **iIndex ) 
         // add to the **iIndex list of neighbours if it's a detector
            if ( (*indexMinus)->pDetector() != 0 )
            {
               (*iIndex)->addNeighbour( ((ProxyMedium*)(*indexMinus))->realMedium() ) ;
            }
            break ; // break -z-loop in case only one neighbour allowed
         }
         // we get here if next found DenseMedium 
         // does NOT cover whole r-range of **iIndex
         // try to search further for r-overlapping
         if ( ((ZCircularSurface*)(*indexMinus)->pSurface())->rmax() <= 
              ((ZCircularSurface*)(*iIndex)->pSurface())->rmin() || 
              ((ZCircularSurface*)(*indexMinus)->pSurface())->rmin() >= 
              ((ZCircularSurface*)(*iIndex)->pSurface())->rmax() )
            continue ;   // continue if no r-overlapping 
         // we get here if r-overlapping 
         // stop searching beyond zmin of previous neighbour 
         zOfNeigh =
 ((Tube*)(((ProxyMedium*)(*indexMinus))->realMedium())->pVolume())->zmin() ;
	 zToStopAt = max( zToStopAt, zOfNeigh ) ;
         if ( ((ZSurface*)(*indexMinus)->pSurface())->z() 
              <= zToStopAt ) break ; // break -z-loop 
         // valid neighbour;
         // put in the **iIndex neighbours list if a detector
         if ( (*indexMinus)->pDetector() != 0 )
         {
            (*iIndex)->addNeighbour( ((ProxyMedium*)(*indexMinus))->realMedium() ) ;
         }
      }
   }

   // search for +z-neighbours
   zToStopAt = 
      ((ZSurface*)(*(mediaList.end()-1))->pSurface())->z() ;
   for ( indexPlus = indexOuter+1; indexPlus != mediaList.end(); indexPlus++ )
   {
      if ( (*indexPlus)->classType() != Medium::kDenseMedium ) continue ;
      // DO NOT TAKE DIPOLES FOR NOW !!!
      if ( (*indexPlus)->pMaterial() == 0 ) continue ;
      // DO NOT TAKE BOX-SHAPED VOLUMES FOR NOW !!!
      fIndex = ((ProxyMedium*)(*indexPlus))->realMedium()->commonIndexF() ;
      if ( emcal_is_box_( fIndex ) ) continue ;
      // we get here if found another DenseMedium (TUBE-shaped !!!)
      if ( ((ZCircularSurface*)(*indexPlus)->pSurface())->rmin() <= 
           ((ZCircularSurface*)(*iIndex)->pSurface())->rmin() && 
           ((ZCircularSurface*)(*indexPlus)->pSurface())->rmax() >= 
           ((ZCircularSurface*)(*iIndex)->pSurface())->rmax() )
      {
         // only one neighbour through zmax surface
         // ( covers whole r-range of **iIndex ) 
         // add to the **iIndex list of neighbours if it's a detector
         if ( (*indexPlus)->pDetector() != 0 )
         {
            (*iIndex)->addNeighbour( ((ProxyMedium*)(*indexPlus))->realMedium() ) ;
         }
         break ; // break +z-loop in case only one neighbour allowed
      }
      // we get here if next found DenseMedium 
      // does NOT cover whole r-range of **iIndex
      // try to search further for r-overlapping
      if ( ((ZCircularSurface*)(*indexPlus)->pSurface())->rmax() <= 
           ((ZCircularSurface*)(*iIndex)->pSurface())->rmin() || 
           ((ZCircularSurface*)(*indexPlus)->pSurface())->rmin() >= 
           ((ZCircularSurface*)(*iIndex)->pSurface())->rmax() )
         continue ;   // continue if no r-overlapping 
      // we get here if r-overlapping 
      // stop searching beyond rmax of previous neighbour 
      zOfNeigh =
  ((Tube*)(((ProxyMedium*)(*indexPlus))->realMedium())->pVolume())->zmax() ;
      zToStopAt = min( zToStopAt, zOfNeigh ) ;
      if ( ((ZSurface*)(*indexPlus)->pSurface())->z() 
           >= zToStopAt ) break ; // break +z-loop 
      // valid neighbour;
      // put in the **iIndex neighbours list if a detector
      if ( (*indexPlus)->pDetector() != 0 )
      {
         (*iIndex)->addNeighbour( ((ProxyMedium*)(*indexPlus))->realMedium() ) ;
      }
   }

   return ;
}

// add medium to the list of neighbours
void
DenseMedium::addNeighbour( Medium* medium )
{
   m_listOfNeighbours.push_back( (DenseMedium*)medium ) ;
}

//
// const member functions
//
// medium response
extern "C" {
   DFLOAT phi_norm_( DFLOAT& phi ) ;
   float  get_gauss_( int& seq ) ;
}


MCFBool 
DenseMedium::reactTo( MCParticle& particle ) const
{
// -------------------------------------------------------------------
// mkl, Feb 14, 1998.
// DenseMedia need reactTo and implementReactTo functions for
// the following reason:
// If we're in fact exiting this volume, just return
// else we just entered a new volume and need to proceed
// "implementReactTo", the real thing!
// -------------------------------------------------------------------

   MCFBool returnValue = true;

   // add a small distance to see if we're actually exiting;
   // if not, we actually have to do work
   WTrackStruct wtrack = addSmallDistance( particle.wtrack() );
   if( true == volume().contains( wtrack ) )
   {
	returnValue = implementReactTo( particle );
   }

   return returnValue;
}

MCFBool
DenseMedium::implementReactTo( MCParticle& particle ) const
{

   MCFBool returnValue = true;

   // Step inside the volume and do "physics" as needed 
   // We choose STEP be 1 rad.len of the material filling the volume
   // since both EM and HAD showering scale with it  

   // if there's NO material do nothing
   if ( pMaterial() == 0 ) { return returnValue ; }
   
   RealMaterial* mat = (RealMaterial*)pMaterial() ;

   // if material is vacuum do nothing 
   if ( mat->isVacuum() == true ) { return returnValue ; }

   DFLOAT step = mat->radLength() ;
   DFLOAT eDeposited ;
   MCFBool responseOK = true ;

   // reset magnetic field
   trk_next_bfield_( particle.wtrack(), particle.bfield() );

   if ( !particle.showeringHasStarted() ) 
   {
      // Showering has not started; we still deal with particle
      DFLOAT pathInside = 0 ;
      DFLOAT distToPass = FLT_MAX ; 
      enum STATUS { CONVERSION, DECAY, SAILTHROUGH } mStatus ;
      DFLOAT distToConversion = mat->distanceToConversion( particle ) ;
      if ( distToConversion >= FLT_MAX )
      {
	 mStatus = SAILTHROUGH ;
      }
      else
      {
	 WTrackStruct wConv ;
	 int status = move_wtk_arc_( particle.wtrack(), 
				     distToConversion, 
				     particle.bfield(),
				     wConv ) ;
	 if ( status != 0 )
	 {
	    report( ::ERROR )
	       << "DenseMedium::reactTo : error from move_wtk_arc" << "\n" ;
	    particle.setStatus( MCParticle::LOST ) ;
	    return (returnValue=false) ;
	 }
	 wConv = addSmallDistance( wConv );
	 if ( volume().contains( wConv ) )
	 {
	    // Particle's going to convert inside
	    // See if it's going to happen first - dacys or showering(conv.)
	    if ( UserSettings::kDecayInFlight )
	    {
	       DFLOAT distToDecay = particle.distanceToDecay() ;
	       mStatus = (distToDecay < distToConversion) ? DECAY : CONVERSION ;     
	       distToPass = min( distToDecay, distToConversion ) ;
	    } 
	    else
	    {
	       mStatus = CONVERSION ;
	       distToPass = distToConversion ;
	    }
	 } 
	 else 
	 {
	    // particle is going to sail through
	    mStatus = SAILTHROUGH ;
	 }
      }
      if ( mStatus == SAILTHROUGH )
      {
	 if ( UserSettings::kMScat ) { distToPass = FLT_MAX ; }
	 else distToPass = volume().distanceToExit( particle ) ;
      }

      if ( !UserSettings::kMScat  &&
	   ( pDetector() == 0 || 
	     !UserSettings::kHitGenerationByShowers ) ) 
	 // No multiple scattering AND
	 // either it's not a Calorimeter or hit generation multiple scattering is OFF ;
	 // make one big step
      {
	 step = distToPass ;
	 // Step reduction will be done automatically
	 // if the particle is going to range out inside volume
	 // (for MIPs moving inside volume will be done by RealMaterial::doEloss...)
	 eDeposited = mat->interactWith( particle, step ) ;
	 pathInside += step ;
      } 
      else
      {   
	 // Either multiple scattering is ON or
	 // it's a calorimeter and hit generation is required ;
	 // move step by step while while particle is alive
	 while( particle.wtrack().p > 0 )
	 {
	    // Check for step limitaion due to geometry/physics processes
	    if ( (pathInside+step) > distToPass )
	    {
	       step = distToPass - pathInside ;
	    }
	    // Step reduction will be done automatically
	    // if the particle is going to range out inside volume
	    eDeposited = mat->interactWith( particle, step ) ;
	    if ( !volume().contains( particle.wtrack() ) )
	    {
	       // We step outside volume
	       // Restore prev. position and energy-momentum 
	       particle.wtrack() = particle.wtrack_prev() ;
	       // Leave the volume
	       return( returnValue = leaveVolume( particle ) ) ;
	    }
	    // We're still inside volume
	    // Increase length of pathInside
	    pathInside += step ;       
	    // Generate hits if it's a detector 
	    if ( pDetector() != 0 )
	    {
	       MCFBool oHitActiveArea;
	       responseOK = detector().generateResponse( particle, 
							 oHitActiveArea,
							 eDeposited );
	       if( false == responseOK ) returnValue = false ;
	    }
	    if ( pathInside >= distToPass ) break ;
	 }
      }

      // End of tracing particle
      // Check if particle is still alive
      if ( particle.wtrack().p <= 0 )
      {
	 // Particle's ranging out
	 // Add absorption trace
	 particle.addTrace( TraceType::kAbsorb ) ;
	 // Set internal status
	 particle.setStatus( MCParticle::ABSORBED ) ;
	 return returnValue ;
      }
      // See if we've sailed through and now exit the volume
      // (appropriate status will be set if particle's ranging out)
      if ( mStatus == SAILTHROUGH ) 
      {
	 return( returnValue = leaveVolume( particle ) ) ;
      }
      // We come here if particle is still alive but reaches decay/conversion point
      if ( UserSettings::kDecayInFlight && mStatus == DECAY )
      {
	 // Do decay and give up (appropriate status and trace will be set)
	 return(returnValue = doDecay( particle ) ) ;
      }
      // We come here if NOT a decay -> it must be showering
      if ( mStatus != CONVERSION ) 
      {
	 // Report error if internal status != conversion
	 report( ::ERROR )
	    << "DenseMedium::reactTo : we come to illegal conversion point" << "\n" ;
	 particle.setStatus( MCParticle::LOST ) ;
	 return( returnValue = false ) ;
      }
      // Everything is OK; initiate showering
      setShowering( particle ) ;
      // Reset resolution factor - the random number is generated ONCE per shower !
      // (resolution factor set with the SAME randon number for all neighbouring detectors)
      if ( UserSettings::kHitGenerationByShowers &&
           ( pDetector() != 0 || !listOfNeighbours().empty() ) )
      {
         Calorimeter* detCal ;
	 int seq = 0 ;
	 double rndmResolution = double( get_gauss_( seq ) ) ;
         if ( pDetector() != 0 )
	 {
	    detCal = (Calorimeter*)pDetector() ;
	    detCal->resetResolutionFactor( particle, rndmResolution ) ;
         }
	 if ( !listOfNeighbours().empty() )
	 {
	    for ( int iNeigh = 0; iNeigh < listOfNeighbours().size(); iNeigh++ )
	    {
	       detCal = (Calorimeter*)(m_listOfNeighbours[iNeigh]->pDetector()) ;
	       detCal->resetResolutionFactor( particle, rndmResolution ) ;
	    }
	 }
      }
   }

   // We come to showering 
   // Disregard magnetic field - showers should NOT feel it !
   disregardBField( particle ) ;
   
   if ( !UserSettings::kHitGenerationByShowers ||
        ( pDetector() == 0 && listOfNeighbours().empty() ) )
      // Hit generation is not required; make one big step
      // (it only matters whether hit generation is required 
      //  and doesn't matter whether it's a calorimeter or an absorber
      //  because a part of a shower started in absorber may touch 
      //  a neighboring calorimeter)
   {
      step = volume().distanceToExit( particle ) ;
      // No step reduction will be done if shower's ranging out
      // but the CORRECT amount of energy will be deposited
      eDeposited = mat->interactWith( particle, step ) ;
      if (particle.shower().wtrack.E <= 0)
      {
	 // Since it's a shower, do NOT add traces anymore ! 
	 particle.setStatus( MCParticle::ABSORBED ) ;
      }
      return returnValue ;
   } 
   else
   {
      // Hit generation is required; 
      // Reset step length (it might have been changed due to geometry or physics)
      step = mat->radLength() ;
      DFLOAT thresholdToStop = UserSettings::kThreshToStopShower ;
      thresholdToStop *= particle.shower().E_original ;
      // Things for transverse profile generation
      MCFBool TransProfDone ;
      DFLOAT  Signal, depRadius=0, depPhi=0 ;    
      MCParticle pseudoParticle( particle.hepIndexC() ) ;
      pseudoParticle.startShowering() ;
      DFLOAT cosPhiPart, sinPhiPart, cosThetaPart, sinThetaPart ;
      cosThetaPart = particle.shower().wtrack.pz / particle.shower().wtrack.p ; 
      sinThetaPart = particle.shower().wtrack.pt / particle.shower().wtrack.p ; 
      DFLOAT phiPart=0 ;
      if (particle.shower().wtrack.pt != 0) 
      {
	 DFLOAT arg = atan2( particle.shower().wtrack.py ,
			     particle.shower().wtrack.px ) ;
	 phiPart = phi_norm_( arg ) ;
      }
      cosPhiPart = cos(phiPart) ;
      sinPhiPart = sin(phiPart) ;
      // Move step by step while energy is above threshold (% of original energy 
      // at which we stop tracing shower inside given volume); 
      // also check if inside volume
      while ( particle.shower().wtrack.E > thresholdToStop )
      {
	 // No step reduction will be done if shower's ranging out
	 // but the CORRECT amount of energy will be deposited	 
	 eDeposited = mat->interactWith( particle, step ) ;
	 // Check if ranging out
	 if ( particle.shower().wtrack.E <= 0 )
	 {
	    // Since it's a shower, do NOT add traces anymore ! 
	    particle.setStatus( MCParticle::ABSORBED ) ;
	 }
	 if ( volume().contains( particle.wtrack() ) )
	    // We're still inside volume
	 {
	    if ( UserSettings::kShowerTransProfile )
	    {
	       // Generate shower transverse profile if necessary and see
	       // whether, where and how the deposited energy should be recorded
	       TransProfDone = false ;
	       Signal = eDeposited ;
	       DFLOAT localPoint[3] ;
	       while ( false == TransProfDone )
	       {
		  TransProfDone = mat->transProfileOfShower( particle, 
							     Signal, 
							     depRadius, depPhi ) ;
		  localPoint[0] = depRadius*cos(depPhi)  ;
		  localPoint[1] = depRadius*sin(depPhi)  ;
		  localPoint[2] = - step / 2 ;
		  pseudoParticle.wtrack().x = localPoint[0]*cosPhiPart*cosThetaPart
		     - localPoint[1]*sinPhiPart
		     + localPoint[2]*cosPhiPart*sinThetaPart ;         
		  pseudoParticle.wtrack().y = localPoint[0]*sinPhiPart*cosThetaPart
		     + localPoint[1]*cosPhiPart
		     + localPoint[2]*sinPhiPart*sinThetaPart ;
		  pseudoParticle.wtrack().z = - localPoint[0]*sinThetaPart
		     + localPoint[2]*cosThetaPart ;

		  pseudoParticle.wtrack().x += particle.wtrack().x ;
		  pseudoParticle.wtrack().y += particle.wtrack().y ;
		  pseudoParticle.wtrack().z += particle.wtrack().z ;
		  if ( volume().contains( pseudoParticle.wtrack() ) )
		  {
                     if ( pDetector() != 0 )
                     {
			MCFBool oHitActiveArea;
		        responseOK 
			   = detector().generateResponse( pseudoParticle, 
							  oHitActiveArea,
							  Signal );
		        if( false == responseOK ) returnValue = false ;
                     }
		  }
                  else
                  {
                     if ( !listOfNeighbours().empty() )
                     {
                        for ( int iMed = 0; iMed < listOfNeighbours().size(); iMed++ )
                        {
                           if ( (m_listOfNeighbours[iMed]->volume()).contains(pseudoParticle.wtrack()) )
                           {
                              // no need to check if detector 
                              // since only detectors allowed in the listOfNeighbours
			      MCFBool oHitActiveArea;
                              responseOK = 
                              (m_listOfNeighbours[iMed]->detector()).
				 generateResponse( pseudoParticle, 
						   oHitActiveArea,
						   Signal );
		              if( false == responseOK ) returnValue = false ;
                              break ;
                           }
                        }
                     }
                  }
	       }
	    }
	    else
	    {
	       // Transverse profile is NOT required but hit generation is 
	       // => deposited energy must be recorded if it's a calorimeter
	       if ( pDetector() != 0 )
	       {
		  MCFBool oHitActiveArea;
		  responseOK = detector().generateResponse( particle, 
							    oHitActiveArea,
							    eDeposited );
		  if( false == responseOK ) returnValue = false ;
	       }
	    }
	 }
	 else
	 {
	    // We come here if shower leaves volume 
	    // Restore previous position and energy-momentum
	    particle.wtrack() = particle.wtrack_prev() ;
	    particle.shower().wtrack = particle.wtrack_prev() ;
	    // Restore # of rad.len. passed by shower
	    particle.shower().N_radlen_pass -= 1 ;
	    // leave the volume 
	    //(appropriate status will be set if shower is ranging out)
	    return( returnValue = leaveVolume( particle ) ) ;
	 }
      }
      // We come here only if still inside volume but energy is below threshold
      // If non-zero energy, try to leave volume and see if the remaining energy 
      // is going to be lost inside or there'll be some leakage to the back;
      if ( particle.shower().wtrack.p > 0 )
      {
	 return ( returnValue = leaveVolume( particle ) ) ;
      }
      return returnValue ;
   }
   // In principal, we should never get here... 
   return returnValue ;
}

MCFBool
DenseMedium::leaveVolume( MCParticle& particle ) const
{

   MCFBool returnValue = true ;
   
   if ( pMaterial() == 0 ) { return returnValue ; }

   WTrackStruct wtrack = addSmallDistance( particle.wtrack() );

   if ( volume().contains( wtrack ) ) 
   {
      RealMaterial* mat = (RealMaterial*)pMaterial() ;
      if ( mat->isVacuum() == true ) { return returnValue ; }
      DFLOAT step = volume().distanceToExit( particle ) ;
      DFLOAT eDeposited = mat->interactWith( particle, step ) ;
      MCFBool responseOK = true ;
      if ( UserSettings::kHitGenerationByShowers &&
           !( pDetector()==0 && listOfNeighbours().empty() ) )
      // Hit generation is required 
      // AND it's not an absorber with no neighbours
      {
	 if ( UserSettings::kShowerTransProfile &&
	      particle.showeringHasStarted() )
	 {
	    // It's a shower and shower transverse profile generation is required
	    MCFBool TransProfDone = false ;
	    DFLOAT depRadius = 0 ;
	    DFLOAT depPhi = 0 ;
	    DFLOAT localPoint[3] ;
	    MCParticle pseudoParticle( particle. hepIndexC() ) ;
	    pseudoParticle.startShowering() ;
	    DFLOAT cosPhiPart, sinPhiPart, cosThetaPart, sinThetaPart ;
	    // Use previous values of energy/momentum to avoid 0-momentum 
	    // (it's OK for showers since they're not sensitive to mag.fld.)
	    cosThetaPart = particle.wtrack_prev().pz / particle.wtrack_prev().p ; 
	    sinThetaPart = particle.wtrack_prev().pt / particle.wtrack_prev().p ; 
	    DFLOAT phiPart=0 ;
	    if (particle.wtrack_prev().pt != 0) 
	    {
	       DFLOAT arg = atan2( particle.wtrack_prev().py ,
				   particle.wtrack_prev().px ) ;
	       phiPart = phi_norm_( arg ) ;
	    }
	    cosPhiPart = cos(phiPart) ;
	    sinPhiPart = sin(phiPart) ;
	    DFLOAT Signal = eDeposited ;
	    while ( false == TransProfDone )
	    {
	       TransProfDone = mat->transProfileOfShower( particle,
							  Signal, 
							  depRadius, depPhi ) ;
	       localPoint[0] = depRadius*cos(depPhi) ;
	       localPoint[1] = depRadius*sin(depPhi) ;
	       localPoint[2] = - step / 2 ;
	       pseudoParticle.wtrack().x = localPoint[0]*cosPhiPart*cosThetaPart
		  - localPoint[1]*sinPhiPart
		  + localPoint[2]*cosPhiPart*sinThetaPart ;         
	       pseudoParticle.wtrack().y = localPoint[0]*sinPhiPart*cosThetaPart
		  + localPoint[1]*cosPhiPart
		  + localPoint[2]*sinPhiPart*sinThetaPart ;
	       pseudoParticle.wtrack().z = - localPoint[0]*sinThetaPart
		  + localPoint[2]*cosThetaPart ;
	       pseudoParticle.wtrack().x += particle.wtrack().x ;
	       pseudoParticle.wtrack().y += particle.wtrack().y ;
	       pseudoParticle.wtrack().z += particle.wtrack().z ;
	       if ( volume().contains( pseudoParticle.wtrack() ) )
	       {
                  if ( pDetector() != 0 )
                  {
		     MCFBool oHitActiveArea;
		     responseOK = 
		        detector().generateResponse( pseudoParticle, 
						     oHitActiveArea,
						     Signal );
		     if( false == responseOK ) returnValue = false ;
                  }
	       }
               else
               {
                  if ( !listOfNeighbours().empty() )
                  {
                     for ( int iMed = 0; iMed < listOfNeighbours().size(); iMed++ )
                     {
                        if ( (m_listOfNeighbours[iMed]->volume()).contains(pseudoParticle.wtrack()) )
                        {
                           // no need to check if detector 
                           // since only detectors allowed in the 
			   // listOfNeighbours
			   MCFBool oHitActiveArea;
                           responseOK = 
                              (m_listOfNeighbours[iMed]->detector()).
			      generateResponse( pseudoParticle, 
						oHitActiveArea,
						Signal );
		           if( false == responseOK ) returnValue = false ;
                           break ;
                        }
                     }
                  }
               }
	    }
	 }
	 else
	 {
	    // Either it's still a particle or
	    // transverse profile is NOT required but hit generation is 
	    // => deposited energy must be recorded if it's a calorimeter
	    if ( pDetector() != 0 )
	    {
	       MCFBool oHitActiveArea;
	       responseOK = 
		  detector().generateResponse( particle, 
					       oHitActiveArea,
					       eDeposited ) ;
	       if( false == responseOK ) return( returnValue = false );
	    }
	 }
      }
   }

   // Check if particle/shower is ranging out
   if (particle.wtrack().E <= 0)
   {
      particle.setStatus( MCParticle::ABSORBED ) ;
      if ( !particle.showeringHasStarted() )
	 particle.addTrace( TraceType::kAbsorb ) ;
   }

// Temporary fix to make it pick up entry to next volume !!!
// Will serve until we find good way to set particle.currentMedium()="exit"
// as particle leaves volume !!! 
   if ( particle.wtrack().p != 0 )
   {
      DFLOAT smallAmount = 1.5 * SMALLDISTANCE / particle.wtrack().p ;
      particle.wtrack().x -= particle.wtrack().px * smallAmount ;
      particle.wtrack().y -= particle.wtrack().py * smallAmount ;
      particle.wtrack().z -= particle.wtrack().pz * smallAmount ;
   }

   return returnValue ;
} 

MCFBool
DenseMedium::doDecay( MCParticle& particle ) const
{
   MCFBool returnValue = true ;
   
   particle.path().tau = particle.timeOfDecay() ; 
   particle.setStatus( MCParticle::DECAYED ) ;

   // make decay products
   int error = trk_decay_( particle.hepIndexF(),
                           particle.wtrack(),
                           particle.path() ) ;
   if ( error != 0 )
   {
    particle.setStatus( MCParticle::LOST ) ;
    return ( returnValue=false ) ;
   }

   // add trace indicating decay 
   particle.addTrace( TraceType::kDecay ) ;   

   return returnValue ;

}

void
DenseMedium::setShowering( MCParticle& particle ) const
{
   particle.startShowering() ;
   particle.addTrace( TraceType::kShower ) ;
   particle.shower().hepIndexF = particle.hepIndexF() ;
   particle.shower().wtrack = particle.wtrack() ;
   particle.shower().E_original = particle.wtrack().E ;

   // If magnetic field != 0, set it to 0
   // (since showers are pretty insensitive to magnetic field)
   disregardBField( particle ) ;

}

void
DenseMedium::disregardBField( MCParticle& particle ) const
{
   if (particle.bfield().type != 0)
   {
      particle.bfield().bmag = 0 ;
      for (int idir=0; idir<3; idir++)
      {
	 particle.bfield().bdir[idir] = 0 ;
      }
      particle.bfield().type = 0 ;
   }
}

// I/O
void 
DenseMedium::printOn( ostream& os ) const
{
   // simply call Medium::printOn for the rest
   Medium::printOn( os );
}

//
// static member functions
//



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:29  eugenio
// Initial revision
//
// Revision 1.28  1999/05/06 23:09:17  yarba_j
// more cleanup
//
// Revision 1.26  1999/03/24  18:50:34  yarba_j
// trate box-shaped volumes with inner gaps properly, using fisrt version of AlignedBoxWithGap
//
// Revision 1.25  1999/02/22  23:15:46  yarba_j
// handle hit generation in box-shaped calorimeters
//
// Revision 1.23  1999/02/12  00:03:24  yarba_j
// disregard magnetic field for showers
//
// Revision 1.22  1999/01/15  17:50:51  yarba_j
// hit generation in calorimeters reimplemented in C++; also includes user interface on calorimetry hits for C++ programmers
//
// Revision 1.20  1998/11/24  23:36:50  yarba_j
// listOfNeighbours is now vector<DenseMedium*>
//
// Revision 1.19  1998/11/20  23:46:00  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.18  1998/10/13  23:17:12  yarba_j
// spped up hit generation in calorimeters
//
// Revision 1.17  1998/08/04  22:58:52  mkl
// implemented Detector::generateResponse with extra output argument: oHitActiveArea; only if true, do material effects
//
// Revision 1.16  1998/07/29  17:15:39  yarba_j
// fixed hit generation/handling in neighbouring calorimeters
//
// Revision 1.15  1998/07/01  18:17:41  yarba_j
// for now, do NOT try to put dipole yokes in the list of neighbouring volumes
//
// Revision 1.14  1998/06/09  23:36:02  yarba_j
// minor update
//
// Revision 1.13  1998/05/18  16:42:29  yarba_j
// updated to account for showers spread over multiple volumes
//
// Revision 1.12  1998/05/04  22:08:29  mkl
// equality operator properly working for Medium pointers
//
// Revision 1.11  1998/02/23  18:02:10  yarba_j
// implemented showering in DenseMedium (incl. trans.prof.)
//
// Revision 1.4  1997/08/25  19:53:36  mkl
// added volume() accessor functions to Medium for convenience
//
// Revision 1.3  1997/08/25  16:12:28  mkl
// eliminated some of the unnecessary Unsuccessful Tracing of Particle messages
//
// Revision 1.2  1997/08/23  01:10:10  mkl
// toward volume-based tracing
//
// Revision 1.1  1997/08/02  19:39:20  mkl
// added DenseMedium for real volume-based tracing
//



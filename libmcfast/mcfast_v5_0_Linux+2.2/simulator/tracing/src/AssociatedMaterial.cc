// -*- C++ -*-
//
// Package:     <package>
// Module:      AssociatedMaterial
// 
// Description: implements material behavior (energy loss, MS, etc.)
//              for scatter surfaces (only!).
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
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
#include "tracingCPPFlags.inc"

#include "report.hh"
#include "UserSettings.hh"

#include "AssociatedMaterial.hh"
#include "MCParticle.hh"
#include "Medium.hh"

//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Tracing.AssociatedMaterial";

//
// static data member definitions
//

//
// constructors and destructor
//
AssociatedMaterial::AssociatedMaterial( 
   float radl=0, float dedx=0, float coll=0, float abs=0 ) 
   : m_radiationLength( radl ), 
     m_dedx( dedx ), 
     m_collisionLength( coll ), 
     m_absorptionLength( abs ) 
{
}

AssociatedMaterial::AssociatedMaterial( const AssociatedMaterial& material )
{
   *this = material;
}

AssociatedMaterial::~AssociatedMaterial()
{
}

//
// assignment operators
//
// const AssociatedMaterial& AssociatedMaterial::operator=( const AssociatedMaterial& )
// {
// }

//
// member functions
//
//
// const member functions
//

// clone operation
AssociatedMaterial*
AssociatedMaterial::clone() const
{
   return new AssociatedMaterial(*this);
}

MCFBool
AssociatedMaterial::interactWith( MCParticle& particle ) const
{
   MCFBool statusOK = true;

   // do 2ndary interactions if wanted
   if( UserSettings::k2ndInter 
       && collLength() > 0 
       && particle.isHadron() )
   {
      statusOK = do2ndInteraction( particle );

      if( false == statusOK ) return false;
   }

   // do energy loss and multiple scattering only for charged particles
   if( particle.isCharged() ) 
   {
      if( UserSettings::kEloss || UserSettings::kMScat )
      {
	 // if not electron, do normal Eloss and MS
	 if( ! particle.isElectron() )
	 { 
	    statusOK = doElossAndMScat( particle );
	 }
	 // and bremsstrahlung for electron
	 else {
	    statusOK = doBremsStrahlung( particle );
	 }

	 particle.addTrace( TraceType::kMSEloss );
	 if ( particle.pCurrentMedium()->pDetector() != 0 ) 
	 {
	    // reset eta to corresopnd detector (bar.sil. problem)
	    TraceStruct* tr = (TraceStruct*)&(particle.traceList().back().traceInfo()) ;
            int nTr = particle.traceList().size() ;
	    for ( int itr=0; itr<3; itr++)
	       tr->eta[itr] = particle.traceList()[nTr-1].traceInfo().eta[itr] ; 
	 }
      }
      else // signify that MSEloss was not applied!
      { 
#if defined(SPEED)
	 // print dummy traces no more 
	 particle.addTrace( TraceType::kMSElossNOT );
#endif
      }

   } else
   if( particle.isPhoton() ) // for photons do pair conversions
   {
      if( UserSettings::kPairConversion ) 
      {
	 MCFBool statusOK = doPairConversion( particle );
      }
   }
   else
   {
#if defined(MKLDEBUG) /* mostly pi0 and K0 */
      report( INFO, kFacilityString ) 
	 << "I(particle) am neither charged nor photon; what am I? "
	 << "idhep=" << particle.idHep() << endl;
#endif   
   }

   return statusOK;
}

extern "C" {
   void wtk_mscat_( const WTrackStruct& w1,       // input wtrack parms 
		    const DFLOAT& radl,           // radiation length
		    const DFLOAT eta[3],          // direction cosines
		    WTrackStruct& w2);            // output wtrack parms

   void wtk_mscat_dedx_( const WTrackStruct& w1,       // input wtrack parms 
			 const DFLOAT& radl,           // radiation length
			 const DFLOAT& dedx,           // dedx for minI
			 const DFLOAT eta[3],          // direction cosines
			 WTrackStruct& w2);            // output wtrack parms
}

MCFBool
AssociatedMaterial::doElossAndMScat( MCParticle& particle ) const
{
   MCFBool statusOK = true;

   // assertions necessary for this routine
   assert( true  == particle.isCharged() );
   assert( false == particle.isElectron() );

   DFLOAT elossMinIon = dedx();
   DFLOAT radiationLength = radLength();
   if( ! UserSettings::kEloss ) elossMinIon=0;
   if( ! UserSettings::kMScat ) radiationLength=0;
   
   // ugly fix in order to extract and use the correct eta 
   // to the barrel silicon wafer
   if ( particle.pCurrentMedium()->pDetector() != 0 )
   {
      DFLOAT eta[3] ;
      eta[0] = particle.traceList().back().traceInfo().eta[0] ;
      eta[1] = particle.traceList().back().traceInfo().eta[1] ;
      eta[2] = particle.traceList().back().traceInfo().eta[2] ;
   
      wtk_mscat_dedx_( particle.wtrack(), radiationLength, elossMinIon, 
		       &particle.traceList().back().traceInfo().eta[0], 
		       particle.wtrack() );
   }
   else
   {
      wtk_mscat_dedx_( particle.wtrack(), radiationLength, elossMinIon, 
	   	       particle.eta(), 
		       particle.wtrack() );
   }

   if( 0 == particle.wtrack().p ) 
   {
#if defined( MKLDEBUG )
      report( WARNING, kFacilityString ) 
	 << "AssociatedMaterial::doElossAndMscat: particle " 
	 << particle.hepIndexF() 
	 << " lost too much energy -- stopping." << endl;
#endif
      particle.setStatus( MCParticle::STOPPED );
   }

   return statusOK;
}


extern "C" {
   void wtk_mscat_brem_elec_( const WTrackStruct& w1,       // input wtrack parms 
			      const DFLOAT& radl,           // radiation length
			      const DFLOAT eta[3],          // direction cosines
			      const DFLOAT& minBremEnergy,  // minE for bremphoton
			      WTrackStruct& w2              // output wtrack parms
			      );

   // create bremstrahlung photon from bremming parent
   integer trk_brem_photon_( const integer& hep,             // hep # of parent
			     const WTrackStruct& wtrack_brem,// photon trackparms 
			     const PathStruct& path );       // path info

   void wtk_photon_brem_( const WTrackStruct& wtrackElectronIn, 
			  const WTrackStruct& wtrackElectronOut, 
			  WTrackStruct& wtrackBremPhoton );
}

MCFBool
AssociatedMaterial::doBremsStrahlung( MCParticle& particle ) const
{
   MCFBool statusOK = true;

   // assertions for this routine
   assert( particle.isElectron() == true );

   // is electron; make brem event and add photon to HEPEVT list

   DFLOAT elossMinIon = dedx();
   DFLOAT radiationLength = radLength();
   if( ! UserSettings::kEloss ) elossMinIon=0;
   if( ! UserSettings::kMScat ) radiationLength=0;
   
   // first see how much we can make electron suffer
   const WTrackStruct wtrackBefore = particle.wtrack();
   wtk_mscat_brem_elec_( particle.wtrack(), radiationLength, particle.eta(), 
			 UserSettings::kMIN_BREMENERGY, particle.wtrack() );

   // if we did in fact lose energy, add new photon to hep list and initialize its
   // track parameters
   const WTrackStruct& wtrackAfter = particle.wtrack();
   if( wtrackAfter.p < wtrackBefore.p ) 
   {
      // fill photon track parameters
      WTrackStruct wtrackBremPhoton;
      wtk_photon_brem_( wtrackBefore, wtrackAfter, wtrackBremPhoton );

      // add photon to hep list (with hep as its parent), created at path info 
      int status = trk_brem_photon_( particle.hepIndexF(), 
				     wtrackBremPhoton, 
				     particle.path() );
      if( status != 0 ) return( statusOK = false );
   }

   // check if electron lost all energy
   if( particle.wtrack().p <= 0. ) 
   {
#if defined( MKLDEBUG )
      report( WARNING, kFacilityString ) 
	 << "AssociatedMaterial::doBremsStrahlung: electron "
	 << particle.hepIndexF() 
	 << " lost too much energy -- stopping" << endl;
#endif
      particle.setStatus( MCParticle::STOPPED );
   }

   return statusOK;
}

extern "C" {
   integer trk_trace_gamma_( const integer& hep,          // particle hep number
			     const PathStruct& path,      // path info
			     const WTrackStruct& wtrack,  // track parms 
			     const integer& typeOfSurface,// r- or z-plane
			     const integer& planeNumber,  // number of plane
			     integer& convert );          // conversion? y=1, no=0
}


MCFBool
AssociatedMaterial::doPairConversion( MCParticle& particle ) const
{
   MCFBool statusOK = true;

   // assertions for this routine
   assert( particle.isPhoton() == true ); 

   // make sure we're NOT already at the showering stage in the calorimeter
   // for this particle!
   if( !particle.showeringHasStarted() ) 
   {
      integer didItConvert;

      // the following few lines are VERY UGLY, because they break the design,
      // but to avoid having to rewrite trk_trace_gamma.F
      const Medium* medium = particle.pCurrentMedium();
      assert( medium != 0 );
      integer typeOfPlane = medium->typeOfSurfaceF();
      integer planeIndex  = medium->commonIndexF();

      // try conversion
      // if there is a conversion, this routine will actually add an e+e- pair
      // to he hep list by calling trk_pair_convert()
      integer status = trk_trace_gamma_( particle.hepIndexF(), 
					 particle.path(), 
					 particle.wtrack(), 
					 typeOfPlane,
					 planeIndex,
					 didItConvert );
   
      if( status != 0 ) // check status
      {
	 report( ERROR, kFacilityString ) 
	    << "doPairConversion: can't make conversion" << endl;

	 particle.setStatus( MCParticle::STOPPED );

	 return( statusOK=false );
      }

      if( 1 == didItConvert ) // did it convert? yes ...
      {
#ifdef MKLDEBUG
	 report( DEBUG, kFacilityString ) 
	    << "doPairConversion: photon converted" << endl;
#endif
	 //path_list.convert = trace_for_num;
	 // add a conversion trace and stop this photon
	 if( statusOK == true ) 
	 {
	    particle.addTrace( TraceType::kPair );
	    particle.setStatus( MCParticle::STOPPED );
	 }

      } else 
      if( didItConvert == 0 ) // it didn't ...
      { 
#ifdef MKLDEBUG
	 report( DEBUG, kFacilityString ) 
	    << "doPairConversion: photon didn't convert" << endl;
#endif
	 statusOK = true;
      } 
      else 
      {
	 report( ERROR, kFacilityString ) 
	    << "doPairConversion: unknown return value" << endl;
	 statusOK=false;
      }

   } // showering has NOT started in the calorimeter

   return statusOK;
}

extern "C" {
   integer trk_sec_int_( const WTrackStruct& wIn,
			 const Integer& hep,
			 const DFLOAT& coll,
			 const DFLOAT& absl,
			 const DFLOAT eta[3],          // direction cosines
			 const DFLOAT& wtime,
			 WTrackStruct& wOut,
			 Integer& int_type );
}

MCFBool
AssociatedMaterial::do2ndInteraction( MCParticle& particle ) const
{
   MCFBool statusOK = true;

   // assertions for this routine
   assert( particle.isHadron() == true ); 
   assert( collLength() != 0 );

   integer int_type=-1; // type of 2ndary interaction
   integer status = trk_sec_int_( particle.wtrack(), 
				  particle.hepIndexF(), 
				  collLength(),
				  absLength(),
				  particle.eta(),
				  particle.path().time,
				  particle.wtrack(), 
				  int_type );

   if( int_type == 2 || particle.wtrack().p == 0 )
   {
     // successful secondary interaction; don't trace particle further!
     statusOK = false;
   }
      
   return statusOK;
}

 
// I/O
void
AssociatedMaterial::printOn( ostream& str ) const
{
   str << "\nAssociatedMaterial of type( " << nameOf() << " )\n";

   str << "radiationLength( " << radLength() << " )\n";
   str << "dedx( "            << dedx()      << " )\n";

}

//
// static member functions
//
AssociatedMaterial*
AssociatedMaterial::createMaterial( 
   float radl, float dedx, float coll, float absp )
{
   AssociatedMaterial* material=0;

#if defined(SPEED)
   // if no material
   if( radl==0 && dedx==0 && coll==0 && absp==0 ) return material=0;
#endif

#if 0 /* always create proper material */
   // or if User doesn't care about material
   if(    false == UserSettings::kEloss
       && false == UserSettings::kMScat
       && false == UserSettings::k2ndInter
       && false == UserSettings::kDecayInFlight
       && false == UserSettings::kPairConversion ) return material=0;

   // otherwise
#endif

   material = new AssociatedMaterial( radl, dedx, coll, absp );

   return material;
}


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:31  eugenio
// Initial revision
//
// Revision 1.13  1999/06/16 22:42:53  yarba_j
// use correct normal to a given bsvx wafer when do hit generation and/or mscat/dedx
//
// Revision 1.12  1998/11/20  23:47:43  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.11  1998/10/21  19:59:34  mkl
// implement eta correctly
//
// Revision 1.10  1998/09/17  21:55:30  mkl
// take out info message from 2ndary interaction code
//
// Revision 1.9  1998/02/18  05:11:23  mkl
// new SPEED cpp parameter to set either for speed or comparisons with Fortran
//
// Revision 1.8  1998/02/17  05:12:55  mkl
// don't record traces for material, when no material flags are set
//
// Revision 1.7  1998/02/16  21:30:02  mkl
// added new TraceType class that deals with trace types exclusively
//
// Revision 1.6  1998/02/16  04:33:40  mkl
// first version of 2ndary interactions
//
// Revision 1.5  1997/11/21  22:02:27  mkl
// compile-time fix
//
// Revision 1.4  1997/11/21  04:15:03  mkl
// write traces for material planes even when MS/Eloss flags aren't set
//
// Revision 1.3  1997/11/11  20:14:06  mkl
// doCorrections --> interactWith
//
// Revision 1.2  1997/08/25  16:12:28  mkl
// eliminated some of the unnecessary Unsuccessful Tracing of Particle messages
//
// Revision 1.1  1997/08/02  02:59:50  mkl
// RealMaterial and AssociatedMaterial derive from placeholder Material
//
// Revision 1.9  1997/08/01  20:56:31  mkl
// forward declare stl containers
//
// Revision 1.8  1997/07/03  03:33:50  mkl
// new approach: surfaces vs volumes; box tracing
//
// Revision 1.7  1997/05/10  01:41:38  mkl
// minor adjustments as part of the bug hunt
//
// Revision 1.6  1997/04/23  14:42:45  bphyslib
// assert instead of fancy error messages
//
// Revision 1.5  1997/04/23  02:42:41  bphyslib
// debugged Bremsstrahlung
//
// Revision 1.4  1997/04/23  01:56:18  bphyslib
// debugged photon conversions
//
// Revision 1.3  1997/04/23  01:48:17  bphyslib
// debugged photon conversions
//
// Revision 1.2  1997/04/19  11:39:39  mkl
// fixes suggested by Julia: change from layerIndex to deviceIndex in
// DetCalorimeter.cc; reversal of if logic in AssociatedMaterial::doPhotonConversion().
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//



// -*- C++ -*-
//
// Package:     Tracing
// Module:      MCParticle
// 
// Description: Collector of traces, hits etc. 
//              as particle moves thru detector.
//
//              The approach taken here is that we figure out what
//              medium to move to. We take a step towards it and at
//              the end of the step record all the info relevant.
//              (B-field, material encountered etc.)
//
// Implimentation:
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
#include <fstream.h>
#include <assert.h>

// user include files
#include "stdhep.h"

#include "const.hh"
#include "cc_fortran_types.hh"
#include "report.hh"
#include "externFortran.hh"
#include "functions.hh"
#include "wtrack_struct.hh"
#include "path_struct.hh"

#include "UserSettings.hh"
#include "MCParticle.hh"
#include "Medium.hh"
#include "CompositeMedium.hh"
#include "Surface.hh"

// will we ever get rid of these?
//#include "HitStruct.hh"
//#include "HitTrack.hh"

// external functions
extern "C" {
   void hep_to_w_( const integer&, WTrackStruct& );
   real productiontime_( const integer& hepIndexF );
   DFLOAT trk_lifetime_( const Integer & );
   integer geo_in_detector_( const DFLOAT[3] );
}

//extern vector<const Hit*> g_hitList;      // global hit list
extern vector<int>        g_hitIndexList; // global hit index list

extern const DFLOAT SMALLDISTANCE;


//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Tracing.MCParticle";

//
// static data member definitions
//

// allocate static variables

//
// static functions
//

//
// constructors and destructor
//
MCParticle::MCParticle( int iHepIndexC ) 
   : GenParticle( iHepIndexC ),
     m_status( ALIVE )
{
   // reserve N_ALLOC vector items to make code more efficient
   m_traceList     .reserve( N_ALLOC*10 );
   //m_hitList       .reserve( N_ALLOC );
   m_hitIndexList  .reserve( N_ALLOC );
   //m_smearedHitList.reserve( N_ALLOC );

   // create initial track params
   hep_to_w_( hepIndexF(), m_wtrack_atProduction );

   // set charge of GenParticle; have to do it here (ugly)
   setCharge( m_wtrack_atProduction.q );


   // --------------------------------------------------------------
   // and the internal keeping-track parameters
   m_currentMedium = 0;
   m_turnAngle = 0;
   m_turns = 0;
   m_step = 0;
   m_stepcount = 0;

   m_timeOfDecay = generateTimeOfDecay();

   hep_to_w_( hepIndexF(), m_wtrack );
   m_wtrack_prev = m_wtrack;
	    
   // fill with initial b-field (needed! for production trace)
   trk_next_bfield_( m_wtrack, m_bfield );
   
   m_path.arc  = 0.;  // total path
   // the production time info is only good if we have a "stable" particle!
   m_path.time = ( isStable() == true ) ? productiontime_(hepIndexF()) : 0;
   m_path.tau  = 0.;  // total proper time                                       

   // material stuff
   for( int i=0; i<NHYP; ++i ) {
      m_eloss[i]=0;
      m_sigma_ms[i]=0;
   }

   // reset Calorimetry stuff
   resetShowering();
   m_shower.hepIndexF = hepIndexF();
   m_shower.N_radlen_pass = 0;
   m_shower.E_original = 0;
   //shouldn't be necessary m_shower.wtrack = 0;
}

//
// destructor
//
//MCParticle::MCParticle()

//
// copy constructor
//
//MCParticle::MCParticle( const MCParticle& particle )

//
// assignment operators
//
//const MCParticle& 
//MCParticle::operator=( const MCParticle& particle)

//
// member functions
//

// --------------------------------------------------------
//    Actual Tracing Routine:
//      the following is the algorithm used:
//
//      assign specific lifetime, rad length
//      get dedx step length, mult. scat. step length
//
//      create production trace
//
//      do while (location is in detector)
//
//        find r+ r- z+ z- intersections
//
//        if (cones)
//          for each cone
//             am I within its z range?
//               am I within its r range?
//                 find cone intersection
//
//        if (x(y)-planes)
//          for each x(y) plane
//            am I within its z range?
//              find x(y) intersection
//
//        step = min(r+,r-,z+,z-,cone,dedx,MS,lifetime,rad)
//
//        move arc by step length to new location
//
//        calculate new track params at new location
//          (includes scattering and energy loss)
//
//        update path information
//
//        if (active detector surface) generate hit
//
//  -------------------------------------------------------------
// not handled at this point:
//
//
///////////////////////////////////////////////////////////////////////
//  MCParticle::propagate -- propagate the particle through a medium
//
MCFBool
MCParticle::propagate( const CompositeMedium& world )
{
   MCFBool statusOK = true;

   // reset medium indices (for caching)
   world.reset();

   // create production trace
   addTrace( TraceType::kProd );

#ifdef MKLDEBUG
   // print out about Medium and Particle
   static ofstream of( "tracing.txt" );
   static counter=0;
   report( DEBUG ) << "\n----------------------------\n";
   report( DEBUG ) << "Particle " << ++counter << "\n";
   report( DEBUG ) << *this << "\n";
#endif

   // now propagate as long as we have a particle in our detector
   while( status()==ALIVE ) // the only way to break out of loop is to change
   {                        // the status of the particle to something other
                            // than alive
      // get B-field for region we're in; since B-field boundaries are media,
      // we're assured that b-field is the same till next b-field boundary.
      // (for caching purposes)
      if ( !showeringHasStarted() )
         trk_next_bfield_( m_wtrack, m_bfield );

      // find next Medium
      m_currentMedium = nextMediumIn( world );
      if( 0 == m_currentMedium ) continue;

#ifdef MKLDEBUG
      {
      // print out about Medium and Particle
      report( DEBUG ) << "-----------------------\n";
      report( DEBUG ) << "MCParticle::propagate()\n";
      report( DEBUG ) << "-----------------------\n";
      report( DEBUG ) << "hepIndexF=" << hepIndexF() << "\n";
      report( DEBUG ) << "lastStep=" << m_step << "\n";
      report( DEBUG ) << "current " << traceList().back();
      report( INFO ) << "\ntracing towards " << currentMedium().name();
      report( DEBUG ) << currentMedium() << "\n";
      int howMany=1;
      DFLOAT distance = currentMedium().maxStep( *this, howMany );
      report( DEBUG ) 
	 << "current step: length="<<distance<<", howMany=" <<howMany<<"\n"; 
      report( DEBUG ) << "Bfield: " << m_bfield;
      report( DEBUG ) << "----------------------\n";
      report( DEBUG ) << endl;
      }
#endif      

      // find maximum step allowed to take (including MS, Eloss, lifetime, rad)
      int howMany=1;
      MCFBool oneStepToMedium = false;
      stepLength() = checkStep( howMany, oneStepToMedium );
      if( 0 == howMany ) continue;
      
      while( howMany-- > 0 ) 
      {
	 // take one step (if step is zero, don't bother)
	 if( stepLength() != 0 ) {
	    statusOK = stepBy( stepLength(), oneStepToMedium );
	    if( statusOK != true ) break;
	 }

	 // add dummy Trace, peform decays, update stepcount, turning angle 
         // etc., at end of step
	 MCFBool isLastStep = howMany==0 ? true:false;
	 endStep( isLastStep );
      } 
      
      // if we actually made it to Material or Detector
      // (eg. taking into account that we might have exited through endplates)
      // (or decays)
      if( currentMedium().contains( wtrack() ) == true ) {

	 // if we hit anything:
	 // 1.) make hit
	 // 2.) correct for material effects
	 statusOK = currentMedium().reactTo( *this );
	 //if( statusOK != true ) continue;
	 if( statusOK != true ) break;

      }

   } // while status() ==  ALIVE

   // add final trace
   addTrace( TraceType::kFinal );

   return statusOK;
}

Medium*
MCParticle::nextMediumIn( const CompositeMedium& world )
{
   Medium* nextMedium = 0;
   
   nextMedium = (Medium*)world.nextMediumTo( *this );
   DFLOAT currentPosition[3] = { wtrack().x, wtrack().y, wtrack().z };

   if( nextMedium == 0 || geo_in_detector_( currentPosition ) == 0 ) {
#ifdef MKLDEBUG
      report( INFO, kFacilityString ) 
	 << "nextMedium: particle left detector" << endl; 
#endif
      setStatus( LEFT );
      nextMedium = 0;
   }
   
   return nextMedium;
}

DFLOAT 
MCParticle::checkStep( int& howMany, MCFBool& oneStepToMedium )
// calculate maximum allowed step, allowing for decay, interaction etc.
// return distance is >=0!
{
   // one step should be the default
   // if it is ==0, something went wrong --> error handling
   howMany = 1;
   DFLOAT distance = FLT_MAX;
   oneStepToMedium = false;

   // ----------------------- beyond user-set limits -------------------------
   // check if we're beyond the max number of steps, turns, turningAngle allowed
   if( stepCount() > UserSettings::kMAX_STEPS 
      )
   {
      report( WARNING, kFacilityString ) 
	 << hepIndexF()
	 << " propagate - more than " << UserSettings::kMAX_STEPS 
	 << " steps ... stopping" << endl; 
      setStatus( STOPPED );

      // stop immediately!
      howMany=0;
      return( distance=0 );
   }

   if( turns()     > UserSettings::kMAX_TURNS
      )
   {
      report( WARNING, kFacilityString ) 
	 << hepIndexF()
	 << " propagate - more than " << UserSettings::kMAX_TURNS 
	 << " turns ... stopping" << endl;
      setStatus( STOPPED );

      // stop immediately!
      howMany=0;
      return( distance=0 );
   }

   // --------------------- low on fuel (user-set energy limit)-------------
   if( wtrack().E < UserSettings::kMIN_KINETIC )
   {
#ifdef MKLDEBUG
      report( WARNING, kFacilityString ) 
	 << "propagate - too low energy...stopping" << endl;
#endif
      setStatus( STOPPED );

      // to speed things up, stop right there
      howMany=0;
      return( distance=0 );
   }

   // ------------------------ decay of particle -------------------------
   // Approach: 
   // 1.) find decay distance
   // 2.) if it turns out to be the smallest of all (material etc.), 
   //     go that distance
   // 3.) next time around, we should be AT decay point, in which case
   //     we mark the particle for decay.
   //  To be more precise, we actually have two cases:
   //    i) If we're at or just beyond the decay point (because of finite 
   //       precision of move), mark particle for decay.
   //    ii) If we're still before decay point (either because of finite 
   //        precision of move OR because step distance in material was smaller)
   //        we will need to go another round!
   // 4.) The actual decay is done in "endStep()"!!!

   if( UserSettings::kDecayInFlight
       && timeOfDecay() < UserSettings::kMAX_TIME 
       && false == showeringHasStarted()
      ) 
   {
      DFLOAT distToDecay = distanceToDecay();

      if( distToDecay <= 0 )  // if we either are at decay point or just beyond
      {                       // set particle up for decay
	 setStatus( DECAYED );
      }
      // reset distance to 0, in case <0!
      // (SHOULDN'T HAPPEN and if negative, shouldn't matter; 
      // code should be able to handle it!)
      distance = (distToDecay > 0.) ? distToDecay : 0.;

      // take minimum
      if( distToDecay < distance ) {
	 distance = distToDecay;
	 howMany = 1;
      }

      // to speed things up, stop right there
      if( distance <= 0 ) {
	 return distance;
      }
   }

   // ------------------------- step in material -------------------------
   // find the max step for this material
   // takes into account MS, dedx, maxstep in vaccuum and medium boundaries
   // WARNING: be careful in comparisons: always compare with "distance*howMany"!
   int howManyInMaterial=1;
   DFLOAT distanceInMaterial = currentMedium().maxStep( *this, 
							howManyInMaterial );

   // take the minimum
   if( distanceInMaterial*howManyInMaterial < distance ) {
      distance = distanceInMaterial;
      howMany  = howManyInMaterial;

      if( 1==howMany ) {
	 oneStepToMedium = true;
      }
   }

   // Force the decay.
   if ( fabs(distanceToDecay()-distance) < SMALLDISTANCE ) {
     setStatus( DECAYED );
   }

   // ------------------------------ error handling ---------------------
   // what to do about errors?
   // if distance is still max or negative, something went wrong
   if( distance == FLT_MAX ) {
#ifdef MKLDEBUG
      report( WARNING, kFacilityString ) 
	 << "checkStep: distance==max" << endl;
#endif
      setStatus( LOST );
      howMany = 0;
   }

   if( distance == 0 ) {
#ifdef MKLDEBUG
      report( WARNING, kFacilityString ) 
	 << "checkStep: distance=0 --> equidistant Medium?" << endl;
#endif
      howMany = 1;
   }

   if( distance < 0 ) {
#ifdef MKLDEBUG
      report( WARNING, kFacilityString ) 
	 << "checkStep: distance<0" << endl;
#endif
      setStatus( LOST );
      howMany = 0;
   }

   return  distance;
}


MCFBool
MCParticle::stepBy( DFLOAT step, MCFBool oneStepToMedium )
{
   MCFBool statusOK = true;

   // 1.) move arc by step length to new location and
   // 2.) calculate new track params at new location
   wtrack_prev() = wtrack();    // hold previous track parameters
#ifdef MKLDEBUG
   report( DEBUG, kFacilityString ) 
      << "stepBy: stepping by step=" << step << endl;
#endif
   
#undef ONESTEPTOMEDIUM
#if defined(ONESTEPTOMEDIUM)
   if( true == oneStepToMedium ) {
      // set wtrack to currentMedium's
      wtrack() = currentMedium().wtrackTo();
#ifdef MKLDEBUG
      report( INFO, kFacilityString ) 
	 << "m_wtrack.px/y/z=" 
	 << m_wtrack.px << " " 
	 << m_wtrack.py << " " 
	 << m_wtrack.pz << endl;
#endif
   }
   else {
#endif
      int status = move_wtk_arc_( wtrack(), step, bfield(), wtrack() );
      if( status != 0 ) {
	 report( ::ERROR, kFacilityString ) 
	    << "stepBy: error from move_wtk_arc" << endl;
	 setStatus( LOST );
	 return (statusOK=false);
      }
#if defined(ONESTEPTOMEDIUM)
   }
#endif

   stepCount()++ ;
   // ----------------------- beyond user-set limits -------------------------
   // check if we're beyond the max number of steps, turns, turningAngle allowed
   if( stepCount() > UserSettings::kMAX_STEPS 
      )
   {
      report( WARNING, kFacilityString ) 
	 << hepIndexF()
	 << " propagate - more than " << UserSettings::kMAX_STEPS 
	 << " steps ... stopping" << endl; 
      setStatus( STOPPED );
      wtrack() = wtrack_prev() ;
      return (statusOK=false) ;
   }
   updateTurns() ;
   if( turns()     > UserSettings::kMAX_TURNS
      )
   {
      report( WARNING, kFacilityString ) 
	 << hepIndexF()
	 << " propagate - more than " << UserSettings::kMAX_TURNS 
	 << " turns ... stopping" << endl;
      setStatus( STOPPED );
      wtrack() = wtrack_prev() ;
      return (statusOK=false ) ;
   }

   
   // 3.) update path information
   updatePath( step );
   
   return statusOK ;

}

void 
MCParticle::endStep( const MCFBool isLastStep )
{
   // update stepcount
//   stepCount()++;

   // update turning angle and number of turns
//   updateTurns();

   // different particle states
   if( status() == STOPPED )
   {
      // if at rest, it might eventually decay or annihilate
      if( UserSettings::kDecayInFlight 
	  && timeOfDecay() > 0 && timeOfDecay() < UserSettings::kMAX_TIME 
	  && false == showeringHasStarted()
	 )
      {  
	 // update time to time of decay
	 //setTime( time() + timeOfDecay() );
	 path().time = timeOfDecay();
	 setStatus( DECAYED );

	 // make decay products
	 int error = trk_decay_( hepIndexF(), 
				 wtrack(), 
				 path() );
	 if( error != 0 ) {
	    report( ::ERROR, kFacilityString ) 
	       << "endStep: trk_decay error" << endl;
	    setStatus( STOPPED );
	 } 
	 
	 // add trace indicating decay
	 addTrace( TraceType::kDecay );
      } 
//      else if( charge() != 0 && "interacted" ) 
//      {  // NOTE: it might interact; NOT IMPLEMENTED
//	 // this case for a stopped positron or anti-proton
//	 doInteraction();
//	 setStatus( INTERACTED );
//      }

   } else 
   if( status()==DECAYED ) // Now actually decay
   {
      // make decay products
      int error = trk_decay_( hepIndexF(), 
			      wtrack(), 
			      path() );
      if( error != 0 ) {
	 report( ::ERROR, kFacilityString ) 
	    << "endStep: trk_decay error" << endl;
	 setStatus( STOPPED );
      } 
      
      // add trace indicating decay
      addTrace( TraceType::kDecay );
      // status = trk_add_final_trace( hep, w, 0, path, 1, jtrace_decay );

   } 
   else 
   {  // add dummy Trace for intermediate steps

      // don't addstep for last intermediate step!!!
      if( ! isLastStep ) 
      { 
	 addTrace( TraceType::kDummy );
      }
   }


}

void
//MCParticle::addTrace( Trace::Type iType, const Hit* iHit, int iHitIndexF )
MCParticle::addTrace( Trace::Type iType, int iHitIndexF )
{
   Trace trace( iType );

   trace.setWTrack( wtrack() );
   trace.setBField( bfield() );

   trace.setTraceInfo( *this );

   // got hit info?
   //if( iHit != 0 ) {
   //   trace.setHit( iHit );
   //   assert( iHitIndexF > 0 );
   if( iHitIndexF > 0 ) {
      trace.setHitIndexF( iHitIndexF );
   }

   //trace.setGeom( GeomStruct* iGeom );

   // now put trace in list
   m_traceList.push_back( trace );
}

//extern "C" {
//   void fortran_hitbank_( const integer& hitIndexF, HitStruct*& hit );
//}

//const HitStruct*
void
MCParticle::addHit( int hitIndexF )
{
   // point to position in Fortran common block
   //assert( hitIndexF != 0 );
   //const HitStruct* hit = &hit_trk_c_.hit_trk[hitIndexF-1];

   // global hit list
   //g_hitList.push_back( hit );
   g_hitIndexList.push_back( hitIndexF );

   // local hit list
   //m_hitList.push_back( hit );
   m_hitIndexList.push_back( hitIndexF );

   // local smeared hit list
   //m_smearedHitList.push_back( hit );

   //return hit;
}

void 
MCParticle::updatePath( DFLOAT step )
{
   path_update_( wtrack(), mass(), step, path() );
}

void 
MCParticle::updatePath( const PathStruct& iPath )
{
   m_path.arc  += iPath.arc;
   m_path.time += iPath.time;
   m_path.tau  += iPath.tau;
}

// local little function to calculate phi from x, y
static DFLOAT phi( DFLOAT x, DFLOAT y )
{
   if( x == 0 && y == 0 ) return 0;

   DFLOAT phi = ( x != 0. ) ? abs( atan( abs( y/x) ) ) : 0;

   if ( x <=0 && y > 0 )
   {
      phi -= TWOPI/2 ;   // i.e. phi = PI - phi
      phi *= -1 ;
   }
   else if ( x< 0 && y <= 0 )
      phi += TWOPI/2 ;
   else if ( x>=0 && y < 0 )
   {
      phi -= TWOPI ;   // i.e. phi = TWOPI - phi
      phi *= -1 ;
   }
   
   return phi;
}

void 
MCParticle::updateTurns()
{
   // can only do it for solenoidal b-fields along z-axis for now
   if( bfield().devtype == 1 && bfield().type == 4 ) 
   {
      
      DFLOAT dphi, phiCurrent, phiPrevious ;
      phiCurrent  = phi( wtrack().px,     wtrack().py ) ;
      phiPrevious = phi( wtrack_prev().px, wtrack_prev().py ) ;
      dphi        = phiCurrent - phiPrevious ;      
      
      if ( m_wtrack.q * m_bfield.bdir[2] < 0 && dphi < 0) // if against counterclock
      {                                                   // phi must increase
         dphi += TWOPI ;
      }
      else if ( m_wtrack.q * m_bfield.bdir[2] > 0  && dphi > 0 )  // if counterclockwise
      {                                                           // phi must decrease
         dphi -= TWOPI ;
      }

// another way to update turnAngle/turns...
//      DFLOAT dPhiTest ;
//      dPhiTest = ( 0.0001 * m_step * C_B * m_wtrack.q * m_bfield.bmag ) 
//              / m_wtrack.pt ; 
//      DFLOAT dTurnTest ;
//      dTurnTest = dPhiTest / TWOPI ;

      turnAngle() += dphi; 
      turns() = abs( turnAngle() )/TWOPI;
#ifdef MKLDEBUG
      report( DEBUG, kFacilityString ) 
	 << "endStep: updating turns()=" << turns() << endl;
#endif
   } 
   else
   {
#ifdef MKLDEBUG
      report( WARNING, kFacilityString ) 
	 << "ONCE: endStep: can\'t update turns with this kind of Bfield" 
	 << endl;
#endif MKLDEBUG
      ;
   }
}

//
// const member functions
//
DFLOAT
MCParticle::generateTimeOfDecay() const
{
   // assign specific lifetime; if user doesn't want decays, set it to infinity
   DFLOAT lifetime = FLT_MAX;

   if( UserSettings::kDecayInFlight == true 
       && isStable() )    // lifetime only valid for "stable" particles
   {
      lifetime = trk_lifetime_( idHep() );

      // in case negative means stable particle!
      if( lifetime < 0 ) {
	 report( ::ERROR, kFacilityString ) 
	    << "generateTimeOfDecay(): "
	    << "negative lifetime; resetting to infinity" << endl;
	 lifetime = FLT_MAX;
      }
   }

   return lifetime;
}

DFLOAT
MCParticle::distanceToDecay() const
{
   DFLOAT distance = FLT_MAX;

   if( mass() != 0 ) { // if we have a particle w/ mass=0, must be long-lived
      distance = (timeOfDecay()-path().tau)*(wtrack().p*CLIGHT)/mass();
   }

   return distance;
}

const DFLOAT* 
MCParticle::eta() const
// ----------------------------------------------------------------------
// Note: this routine is just a convenient access point. (an ugly one at that!)
// Eta is a property of both the particle's trajectory and 
// the medium/surface it's hitting. The implementation uses the surface's
// eta passing in the particle's wtrack parms.
// ----------------------------------------------------------------------
{
   const Medium* medium = pCurrentMedium();
   // be assertive: medium here should ALWAYS be defined!
   assert( medium != 0 ); 

   return medium->surface().eta( wtrack() );
}


// Printable interface
void
MCParticle::printOn( ostream& str ) const
{
   str << "MCParticle {\n";

   GenParticle::printOn( str );

   str << "status( ";
   switch( status() ) {
      case ALIVE:      str << "alive";     break;
      case STOPPED:    str << "stopped";   break;
      case DECAYED:    str << "decayed";   break;
      case INTERACTED: str << "interacted";break;
      case LOOPING:    str << "looping";   break;
      case LEFT:       str << "left";      break;
      case STUCK:      str << "stuck";     break;
      case PRIMARY:    str << "primary";   break;
      case ERROR:      str << "error";     break;
      default:         str << "unknown";   break;
   }
   str << " )\n";
   
   // now print out trace info
   vector<Trace>::const_iterator beginTrace = traceList().begin();
   vector<Trace>::const_iterator endTrace = traceList().end();
   for( vector<Trace>::const_iterator i=beginTrace; i!=endTrace; ++i ) 
   {
      (*i).printOn( str );
   }

#if 0   
   for( int i=traceList().size()-2; i<traceList().size(); ++i )
   {
      (*i).printOn( str );
      traceList()[i].printOn( str );
   }
#endif
   
}


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:32  eugenio
// Initial revision
//
// Revision 1.35  1999/11/17 01:53:50  kutschke
// Decay on step that they decay, not the next one.  In checkStep.
//
// Revision 1.34  1999/10/28  23:31:57  yarba_j
// fixed stepBy
//
// Revision 1.33  1999/06/17  00:08:18  yarba_j
// update stepCount and turnAngle/turn as step is made; check if they valid; if not, restore previous wtrack and break tracing loop
//
// Revision 1.32  1999/02/12  00:05:05  yarba_j
// disregard magnetic field for showers
//
// Revision 1.31  1999/02/09  17:04:56  yarba_j
// fixed phi() and updateTurns() methods
//
// Revision 1.30  1998/11/20  23:47:53  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.29  1998/10/21  19:59:34  mkl
// implement eta correctly
//
// Revision 1.28  1998/08/14  02:05:16  kutschke
// Temporary hack to fix up eta member function.
//
// Revision 1.27  1998/08/08  19:45:11  mkl
// rookie needs to be on a direction basis
//
// Revision 1.26  1998/08/05  20:54:31  mkl
// clearer printout if particle is stopped because of too many steps or turns
//
// Revision 1.25  1998/08/05  16:12:07  mkl
// change some UserSettings defaults and now by default print when max # of steps or turns is reached
//
// Revision 1.24  1998/08/04  22:58:39  mkl
// implemented Detector::generateResponse with extra output argument: oHitActiveArea; only if true, do material effects
//
// Revision 1.23  1998/08/04  19:44:34  mkl
// new flag for initialization status
//
// Revision 1.22  1998/07/16  18:26:34  bphyslib
// sigh, it really is const.hh
//
// Revision 1.21  1998/07/15  16:40:44  garren
// rename const.hh to const.h
//
// Revision 1.20  1998/05/29  21:05:36  yarba_j
// updateTurns() - switch from x/y to py/py for phi definition
//
// Revision 1.19  1998/05/15  04:13:00  mkl
// fixed problem with new onestep solution: forgot to updated wtrack properly
//
// Revision 1.18  1998/05/15  03:50:53  mkl
// first attempt at taking one step to new wtrack without using move_wtk_arc routine
//
// Revision 1.17  1998/02/17  22:58:28  mkl
// now handle equidistant media correctly for the first time; have to handle distance=0 correctly!
//
// Revision 1.16  1998/02/16  21:30:07  mkl
// added new TraceType class that deals with trace types exclusively
//
// Revision 1.15  1998/02/15  01:54:49  mkl
// don't decay, if already showering
//
// Revision 1.14  1997/11/21  04:17:20  mkl
// comment fix
//
// Revision 1.13  1997/11/12  07:49:08  mkl
// major bug fixes (mostly reverse_iterator specific) -- now good agreement with fortran tracing found number of tracks
//
// Revision 1.12  1997/11/11  06:43:57  mkl
// beautification of debug print-out
//
// Revision 1.11  1997/11/11  01:17:34  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.10  1997/09/03  02:14:51  mkl
// minor cleanup
//
// Revision 1.9  1997/08/27  03:31:37  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.8  1997/08/02  18:31:40  mkl
// fix for switch-backs
//
// Revision 1.7  1997/07/31  14:53:04  bphyslib
// minor changes
//
// Revision 1.6  1997/07/03  03:33:49  mkl
// new approach: surfaces vs volumes; box tracing
//
// Revision 1.4  1997/04/22  20:01:08  bphyslib
// fixes for decay-in-flights
//
// Revision 1.3  1997/04/19  21:57:21  bphyslib
// new method "distanceToDecay()" in MCParticle makes similar function in
// DetCalorimeter obsolete; added generateTimeOfDecay as private method to
// MCParticle (was static local before).
//
// Revision 1.2  1997/03/15  19:02:20  mkl
// moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
// fixed commend headers for .inc files from # to c.
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//



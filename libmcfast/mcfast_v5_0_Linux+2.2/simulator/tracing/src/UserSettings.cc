// -*- C++ -*-
//
// Package:     Tracing
// Module:      UserSettings
// 
// Description: contains all user-settable UserSettings tracing parameters
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
#include <iostream.h>
#include <limits.h>
//#include <float.h>

// user include files
#include "const.hh"
#include "UserSettings.hh"
#include "report.hh"

extern "C" {
   void get_fortran_usersettings_( DFLOAT& step_max_distance,
				 DFLOAT& step_max_angle,
				 DFLOAT& step_max_dedx, 
				 DFLOAT& step_max_mscat,
				 DFLOAT& trk_max_turns, 
				 DFLOAT& trk_min_kinetic, 
				 DFLOAT& trk_min_brem,

				 logical& trk_ldecays, 
				 logical& trk_lpair, 
				 logical& trk_lhits, 
				 logical& trk_lscat, 
				 logical& trk_ldedx,
				 logical& trk_lint,

                                 logical& shw_trans,
                                 real&    thresh,
                                 real&    e_vis_min,
                                 integer& max_ndep,
                                 logical& hit_generation
      );
}

//
// constants, enums and typedefs
//

// these are the settings in mcfast/src/track/trk_init.F:
//
//      step_max_distance = 1.e10
//      step_max_angle = 1.e10
//      step_max_dedx = 1.e10
//      step_max_mscat = 1.e10
//      trk_max_turns = 0.5
//      trk_min_kinetic = 1.e6 * unit_ev
//      trk_min_brem    = 1.e6 * unit_ev
//
//      trk_ldecays = .TRUE.   !  make decays in flight
//      trk_lpair = .TRUE.     !  make conversions
//      trk_lhits = .TRUE.     !  make hits (not fully implemented)
//      trk_lscat = .FALSE.    !  scattering during trace -- off
//      trk_ldedx = .FALSE.    !  energy loss during trace -- off

// these are the settings in mcfast/src/gen/ctl_shw_init.F:
//      shw_trans = .true.
//      thresh = 0.05
//      e_vis_min = 0.002
//      max_ndep = 25
//      hit_generation = .true.
  
// parameters in user common block "trace_params.inc"
DFLOAT  UserSettings::kSTEP_MAX_DISTANCE=1.e10; //Max distance to 
                                                      // take during step
DFLOAT  UserSettings::kSTEP_MAX_ANGLE=1.e10;    //Max angle to take 
                                                      // during step
DFLOAT  UserSettings::kSTEP_MAX_DEDX=1.e10;     //Max Eloss during step
DFLOAT  UserSettings::kSTEP_MAX_MSCAT=1.e10;    //Max MS angle to allow 
                                                      // during step
DFLOAT  UserSettings::kMAX_TURNS=2;        // max number of turns
DFLOAT  UserSettings::kMIN_KINETIC=1.e6*UNIT_EV; //Stop tracing when E 
                                                       // falls below
DFLOAT  UserSettings::kMIN_BREMENERGY=1.e6*UNIT_EV; // MinE bremstr photon emit 


MCFBool UserSettings::kDecayInFlight=false;     //TRUE ==> do decays in 
                                                      // flight
MCFBool UserSettings::kPairConversion=false;    //TRUE ==> do pair 
                                                      // conversions
MCFBool UserSettings::kMakeHits=true;           //TRUE ==> make hits 
                                                      //  in tracking detector
MCFBool UserSettings::kMScat=false;             //TRUE ==> use multiple 
                                                      // scattering
MCFBool UserSettings::kEloss=false;             //TRUE ==> use energy loss
MCFBool UserSettings::k2ndInter=false;     //TRUE ==> use 2ndary interactions

//    Control of showering and hit generation in calorimeters
MCFBool UserSettings::kHitGenerationByShowers=true ;  
        // TRUE ==> generate hits in "sensitive" volumes
MCFBool UserSettings::kShowerTransProfile=true ;      
        // TRUE ==> generate transverse
        // profile for showers, otherwise do only energy loss by a shower;
        // turns OFF automaticaly if hit generation is OFF
Real    UserSettings::kThreshToStopShower=0.05 ;      
        // % of init.energy at which we stop tracing shower (default=5%)
Real    UserSettings::kMinVisEnergy=0.002 ;
        // minimum energy visible in CALs (default=2MeV)
Integer UserSettings::kMaxShowerHitsPerStep=25 ;

// other parameters that Martin finds useful
//DFLOAT  UserSettings::kMAX_FLIGHT=FLT_MAX;//max fligh distance ("infinity")
DFLOAT  UserSettings::kMAX_TIME=1.e10;   //nsec?...
Integer UserSettings::kMAX_STEPS=1000;   // max number of steps per track
//DLFOAT  UserSettings::kMAX_BEND=31;       //radians .. 5 loops...
Integer UserSettings::kMAX_INTER_STEPS=UserSettings::kMAX_STEPS; 
                                                     // max# intermediate steps
MCFBool UserSettings::kAllowCurlers=false;      //TRUE ==> allow curlers



// only one instance of UserSettings
UserSettings* UserSettings::m_instance=0;

extern "C" void lookatfortranvariables_();
//
// constructors and destructor
//
UserSettings::UserSettings()
{
//   lookatfortranvariables_();

   // fill from fortran common block through function call, because
   // this way it's safer!
   DFLOAT step_max_distance, 
      step_max_angle, 
      step_max_dedx, 
      step_max_mscat,
      trk_max_turns, 
      trk_min_kinetic, 
      trk_min_brem;

   logical trk_ldecays, 
      trk_lpair, 
      trk_lhits, 
      trk_lscat, 
      trk_ldedx,
      trk_lint;

   logical shw_trans, hit_generation ;
   real    thresh, e_vis_min ;
   integer max_ndep ;

   get_fortran_usersettings_( step_max_distance, 
			    step_max_angle, 
			    step_max_dedx, 
			    step_max_mscat,
			    trk_max_turns, 
			    trk_min_kinetic, 
			    trk_min_brem,
			    
			    trk_ldecays, 
			    trk_lpair, 
			    trk_lhits, 
			    trk_lscat, 
			    trk_ldedx,
			    trk_lint,

                            shw_trans,
                            thresh,
                            e_vis_min,
                            max_ndep,
                            hit_generation
      );

   UserSettings::kSTEP_MAX_DISTANCE = step_max_distance;
   UserSettings::kSTEP_MAX_ANGLE    = step_max_angle;
   UserSettings::kSTEP_MAX_DEDX     = step_max_dedx;
   UserSettings::kSTEP_MAX_MSCAT    = step_max_mscat;
   UserSettings::kMAX_TURNS         = trk_max_turns;
   UserSettings::kMIN_KINETIC       = trk_min_kinetic;
//   UserSettings::kMIN_BREMENERGY    = trk_min_brem;

   UserSettings::kDecayInFlight     = (trk_ldecays!=0)?true:false;
   UserSettings::kPairConversion    = (trk_lpair!=0)?true:false;
   UserSettings::kMakeHits          = (trk_lhits!=0)?true:false;
   UserSettings::kMScat             = (trk_lscat!=0)?true:false;
   UserSettings::kEloss             = (trk_ldedx!=0)?true:false;
   UserSettings::k2ndInter          = (trk_lint!=0)?true:false;

   UserSettings::kHitGenerationByShowers=(hit_generation!=0)?true:false ;  
   UserSettings::kShowerTransProfile=(shw_trans!=0)?true:false ;      
   UserSettings::kThreshToStopShower=thresh ;      
   UserSettings::kMinVisEnergy=e_vis_min ;
   UserSettings::kMaxShowerHitsPerStep=max_ndep ;

   // new one for curlers (to speed up tracing)
   UserSettings::kAllowCurlers      = ( UserSettings::kMAX_TURNS>0.5 )?true:false;

   // now print out all user-settable parameters

   // first the ones from fortran
   report( INFO ) << "UserSettings:\n";
   report( INFO ) << "UserSettings::kSTEP_MAX_DISTANCE=" 
		   <<  UserSettings::kSTEP_MAX_DISTANCE << "\n";
   report( INFO ) << "UserSettings::kSTEP_MAX_ANGLE="
		   <<  UserSettings::kSTEP_MAX_ANGLE << "\n";
   report( INFO ) << "UserSettings::kSTEP_MAX_DEDX=" 
		   <<  UserSettings::kSTEP_MAX_DEDX << "\n";
   report( INFO ) << "UserSettings::kSTEP_MAX_MSCAT=" 
		   <<  UserSettings::kSTEP_MAX_MSCAT << "\n";
   report( INFO ) << "UserSettings::kMAX_TURNS="
		   <<  UserSettings::kMAX_TURNS << "\n";
   report( INFO ) << "UserSettings::kMIN_KINETIC="
		   <<  UserSettings::kMIN_KINETIC << "\n";

   report( INFO ) << "UserSettings::kDecayInFlight="
		   <<  UserSettings::kDecayInFlight << "\n";
   report( INFO ) << "UserSettings::kPairConversion="
		   <<  UserSettings::kPairConversion << "\n";
   report( INFO ) << "UserSettings::kMakeHits="
		   <<  UserSettings::kMakeHits << "\n";
   report( INFO ) << "UserSettings::kMScat="
		   <<  UserSettings::kMScat << "\n";
   report( INFO ) << "UserSettings::kEloss="
		   <<  UserSettings::kEloss << "\n";
   report( INFO ) << "UserSettings::k2ndInter="
		  <<  UserSettings::k2ndInter << "\n";

// Control of showering and hit generation in calorimeters
   report( INFO ) << "UserSettings::kHitGenerationByShowers="
                  <<  UserSettings::kHitGenerationByShowers << "\n";  
   report( INFO ) << "UserSettings::kShowerTransProfile="
                  <<  UserSettings::kShowerTransProfile << "\n" ;
   report( INFO ) << "UserSettings::kThreshToStopShower="
                  <<  UserSettings::kThreshToStopShower << "\n" ;      
   report( INFO ) << "UserSettings::kMinVisEnergy="
                  <<  UserSettings::kMinVisEnergy << "\n" ;
   report( INFO ) << "UserSettings::kMaxShowerHitsPerStep="
                  <<  UserSettings::kMaxShowerHitsPerStep << "\n" ;

   // and now the rest
//   report( INFO ) << "UserSettings::kMAX_FLIGHT="
//		   <<  UserSettings::kMAX_FLIGHT << "\n";
   report( INFO ) << "UserSettings::kMAX_TIME=" 
		   <<  UserSettings::kMAX_TIME << "\n";
   report( INFO ) << "UserSettings::kMAX_STEPS="
		   <<  UserSettings::kMAX_STEPS << "\n";
//   report( INFO ) << "UserSettings::kMAX_BEND="
//		   <<  UserSettings::kMAX_BEND << "\n";
   report( INFO ) << "UserSettings::kMAX_INTER_STEPS="
		   <<  UserSettings::kMAX_INTER_STEPS << "\n";
   report( INFO ) << "UserSettings::kAllowCurlers="
		   <<  UserSettings::kAllowCurlers << "\n";


   report( INFO ) << "\n";

}

UserSettings::~UserSettings()
{
}

//
// static member functions
//
UserSettings*
UserSettings::instance()
{
   if( m_instance == 0 ) {
      m_instance = new UserSettings;
   }

   return m_instance;
}


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:33  eugenio
// Initial revision
//
// Revision 1.9  1998/11/20 23:48:03  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.8  1998/08/05  20:55:23  mkl
// make 1000 max steps the default
//
// Revision 1.7  1998/08/05  16:12:09  mkl
// change some UserSettings defaults and now by default print when max # of steps or turns is reached
//
// Revision 1.6  1998/07/16  18:26:34  bphyslib
// sigh, it really is const.hh
//
// Revision 1.5  1998/07/15  16:40:44  garren
// rename const.hh to const.h
//
// Revision 1.4  1998/02/16  00:45:08  mkl
// new 2ndary interaction user flag
//
// Revision 1.3  1997/07/24  22:06:22  yarba_j
// added control for showering and hit generation in calorimeters
//
// Revision 1.2  1997/07/03  03:33:54  mkl
// new approach: surfaces vs volumes; box tracing
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//



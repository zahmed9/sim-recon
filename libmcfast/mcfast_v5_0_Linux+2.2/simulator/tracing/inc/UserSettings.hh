#if !defined(TRACING_USERSETTINGS_H)
#define TRACING_USERSETTINGS_H
// -*- C++ -*-
//
// Package:     <package>
// Module:      UserSettings
//
// Description: contains all user settable global tracing parameters
//              (The reason to put them in a class is to avoid name pollution.)
//            
//              To use "static <type>" is ugly and dangerous (because can be
//                modified easily), but ok for now.
// Usage:
//              To actually set them, edit USERSETTINGS.cc!!!!!!!!!!!!!!!!!!!
//
// Author:      Martin Lohner
// Created:     Jan 23, 1997
// RCS(Id)
//
// Revision history
// Julia Yarba, 7-23-97 :
// added control of showering and hit generation in calorimeters
//
//
// RCS(Log)

// system include files

// user include files
#include "cc_fortran_types.hh"

// forward declarations

class UserSettings
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // parameters in user common block "trace_params.inc"
      static DFLOAT  kSTEP_MAX_DISTANCE; //Max distance to take during step
      static DFLOAT  kSTEP_MAX_ANGLE;    //Max angle to take during step
      static DFLOAT  kSTEP_MAX_DEDX;     //Max Eloss during step
      static DFLOAT  kSTEP_MAX_MSCAT;    //Max MS angle to allow during step
      static DFLOAT  kMAX_TURNS;         // max number of turns
      static DFLOAT  kMIN_KINETIC;       //Stop tracing when E falls below
      static DFLOAT  kMIN_BREMENERGY;    // Min energy photon to emit for bremstr

      static MCFBool kDecayInFlight;     //TRUE ==> do decays in flight
      static MCFBool kPairConversion;    //TRUE ==> do pair conversions
      static MCFBool kMakeHits;          //TRUE ==> make hits 
      static MCFBool kMScat;             //TRUE ==> use multiple scattering
      static MCFBool kEloss;             //TRUE ==> use energy loss
      static MCFBool k2ndInter;          //TRUE ==> use 2ndary interactions

//    Control of showering and hit generation in calorimeters
      static MCFBool kHitGenerationByShowers; // TRUE ==> generate hits in
                                              // "sensitive" volumes
      static MCFBool kShowerTransProfile;     // TRUE ==> generate transverse
      // profile for showers, otherwise do only energy loss by a shower;
      // turns OFF automaticaly if hit generation is OFF
      static Real    kThreshToStopShower;     // % of init.energy at which 
                                              // we stop tracing shower
      static Real    kMinVisEnergy;           // minimum energy visible in CALs
      static Integer kMaxShowerHitsPerStep;   
      // maximum number of "showering hits" per step 
      // (i.e. maximum numbre of portions energy deposited at each step 
      //  maybe subdivided into)

      // others that Martin finds useful
      // static DFLOAT  kMAX_FLIGHT;        //max fligh distance
      static DFLOAT  kMAX_TIME;          //nsec...
      static Integer kMAX_STEPS;         // max number of steps overall per track
      // static DFLOAT  kMAX_BEND=31;       //radians .. 5 loops...
      static integer kMAX_INTER_STEPS; // max # of intermediate steps
      static MCFBool kAllowCurlers;      //TRUE ==> allow curlers

      // constructor and destructor
      virtual ~UserSettings();

      // member functions

      // const member functions
      
      // static member functions
      static UserSettings* instance();                           

   protected:
      // protected member functions

      // Constructors and destructor
      UserSettings();
 
      // protected const member functions

   private:
      // Constructors and destructor
      UserSettings( const UserSettings& );

       // assignment operator(s)
      const UserSettings& operator=( const UserSettings& );
         
      // private member functions

      // private const member functions

      // data members

      // static data members
      static UserSettings* m_instance;
};



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:30  eugenio
// Initial revision
//
// Revision 1.7  1998/11/20 23:47:41  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.6  1998/08/05  16:12:06  mkl
// change some UserSettings defaults and now by default print when max # of steps or turns is reached
//
// Revision 1.5  1998/02/16  00:45:09  mkl
// new 2ndary interaction user flag
//
// Revision 1.4  1997/07/24  22:05:48  yarba_j
// added control for showering and hit generation in calorimeters
//
// Revision 1.3  1997/07/03  03:33:55  mkl
// new approach: surfaces vs volumes; box tracing
//
// Revision 1.2  1997/03/15  19:02:23  mkl
// moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
// fixed commend headers for .inc files from # to c.
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//


#endif /* TRACING_USERSETTINGS_H */    

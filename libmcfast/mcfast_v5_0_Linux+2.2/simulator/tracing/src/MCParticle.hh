#if !defined(TRACING_PARTICLE_H)
#define TRACING_PARTICLE_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      MCParticle
// 
// Description: Container for traces, hits etc as particle moves through 
//              detector.
//
// Usage:
//    MCParticle particle( hepIndexC );  // initialize with fortran hepIndex-1
//
// Author:      Martin Lohner
// Created:     Jan 23, 1997
// RCS(Id)
//
// Revision history
//
// RCS(Log)

// system include files
#include <vector>
#include <float.h>

// user include files
#include "cc_fortran_types.hh"

#include "GenParticle.hh"
#include "path_struct.hh"
#include "bfield_struct.hh"
#include "Trace.hh"
#include "shower_trace_struct.hh"

// forward declarations
//class HitStruct;
class Medium;
class CompositeMedium;


class MCParticle : public GenParticle
{
      // ------- friend classses and functions ---------------

   public:
      // ------- constants, enums and typedefs ---------------
      enum Status {ALIVE, DECAYED, INTERACTED,
		   ABSORBED, LEFT, STOPPED, 
		   LOOPING, LOST, STUCK, 
		   PRIMARY,
		   ERROR   
      };
      enum { NHYP=5 };              // number of hypotheses NHYP
      enum { N_ALLOC=100 };         // how many vector elements to allocate

      //typedef HitStruct Hit;        // shorten the name

      // -------- Constructors and destructor ----------------
      MCParticle( int hepIndexC=0 );
      virtual ~MCParticle() {}

      // -------- copy constructor and assignment operator ---
      // needed by stl vector
      //MCParticle( const MCParticle& );
      //const MCParticle& operator=( const MCParticle& );

      // -------- member functions ---------------------------

      // particle status
      void setStatus( MCParticle::Status iStatus );

      // path related 
      PathStruct& path();

      // propagate the particle and all of its progeny.
      MCFBool propagate( const CompositeMedium& );

      // used for propagation
      Medium* nextMediumIn( const CompositeMedium& compMedium ); 
      DFLOAT checkStep( int& howMany, MCFBool& oneStepToMedium );
      MCFBool stepBy( DFLOAT step, MCFBool oneStepToMedium=false );
      void endStep( const MCFBool isLastStep );
      void updateTurns();

      // adding to traces, hist etc.
      //void addTrace( Trace::Type iType, const Hit* iHit=0, int iHitIndexF=0 );
      void addTrace( Trace::Type iType, int iHitIndexF=0 );
      //const Hit* addHit( int hitIndexF );  
      void addHit( int hitIndexF );  

      // calorimetry stuff
      void resetShowering();
      void startShowering();
      MCFBool showeringHasStarted() const;
      ShowerStruct& shower();
      const ShowerStruct& shower() const;

      // --------- const member functions ---------------------
      MCParticle::Status status() const;

      virtual const char* nameOf() const { return "MCParticle"; }
      virtual void printOn( ostream& ) const;
      
      const vector<Trace>& traceList() const;
      //const vector<const Hit*>&  hitList() const;
      const vector<int>&         hitIndexList() const;
      //const vector<const Hit*>&  smearedHitList() const;

      const WTrackStruct& wtrack_atProduction() const ;


      // member functions for internal implementation

      WTrackStruct& wtrack();
      WTrackStruct& wtrack_prev();
      BFieldStruct& bfield();

      const WTrackStruct& wtrack() const;
      const WTrackStruct& wtrack_prev() const;
      const BFieldStruct& bfield() const;

      DFLOAT timeOfDecay() const;

      int& stepCount();
      DFLOAT& stepLength();
      DFLOAT& turnAngle();
      DFLOAT& turns();

      int stepCount()    const;
      DFLOAT stepLength() const;
      DFLOAT turnAngle()  const;
      DFLOAT turns()      const;

      void updatePath( DFLOAT step );
      void updatePath( const PathStruct& path );
      const PathStruct& path()       const;
      const Medium& currentMedium()  const;
      const Medium* pCurrentMedium() const;
      Medium*& pCurrentMedium();

      DFLOAT* eloss();
      DFLOAT* sigma_ms();
      const DFLOAT* eloss() const;
      const DFLOAT* sigma_ms() const;
 
      const DFLOAT* eta() const;
      int typeOfPlane() const;

      // find distance to decay point from current point
      DFLOAT distanceToDecay() const;

      // ------------ static member functions ---------------

   protected:
      // ------------ protected member functions ------------

      // ------------ protected const member functions ------

   private:
      // ------------ Constructors and destructor ----------- 

      // ------------ private member functions --------------

      // ------------ private const member functions --------

      // decay: interface to trk_lifetime_()
      DFLOAT generateTimeOfDecay() const;

      // ------------ data members --------------------------
      Status m_status;             // current status
      
      vector<Trace> m_traceList;         // list of traces
      //vector<const Hit*> m_hitList;    // list of hits
      vector<int>        m_hitIndexList; // list of fortran indices to hits
      // list of pointers to smeared hits
      // (into main large store of all 
      //  smeared hits!)
      //vector<const Hit*> m_smearedHitList;  
      WTrackStruct m_wtrack_atProduction;// track parameters at production
      
      // ------------------------------------------------------------------
      // the following are used to keep track of internal parameters 
      // during propagation only; keep them internal; 
      // not all of them need to be initialized!
      // ------------------------------------------------------------------

      Medium* m_currentMedium;  // the current medium

      DFLOAT m_turnAngle;        // total angular deflection so far 
      DFLOAT m_turns;            // number of turns so far
      
      DFLOAT m_step;             // distance of present step
      int m_stepcount;          // step counter
      
      DFLOAT m_timeOfDecay;      // actual decay time
      
      WTrackStruct m_wtrack;    // keep track of track parameters
      WTrackStruct m_wtrack_prev; // keep track of track parameters
      BFieldStruct m_bfield;    // keep track of kinematics
      
      PathStruct m_path;             // keep track of current path

      // material effects of last step
      DFLOAT m_eloss[NHYP];
      DFLOAT m_sigma_ms[NHYP];
      
      // calorimetry stuff
      MCFBool m_startedShowering; // has particle started showering yet
      ShowerStruct m_shower;      // calorimeter shower info


      // ------------- static data members -------------------

};

// inline function definitions

inline
ostream&
operator<<( ostream& os, const MCParticle& particle )
{
   particle.printOn(os);
   return os;
}

inline
ostream&
operator<<( ostream& os, const MCParticle* particle )
{
   particle->printOn(os);
   return os;
}                                                  

inline
ostream&
operator<<( ostream& os, const BFieldStruct& bfield )
{
   os << "bfield: "
      << "bmag=" << bfield.bmag << ", "
      << "bdir=( " 
      << bfield.bdir[0] << ", " 
      << bfield.bdir[1] << ", "
      << bfield.bdir[2] << " )" << ", "
      << "type=" << bfield.type << ", "
      << "devtype=" << bfield.devtype << ", "
      << "devnum=" << bfield.devnum << "\n";
 
   return os;
}


inline
void 
MCParticle::setStatus( MCParticle::Status iStatus ) 
{ 
   m_status = iStatus; 
}

inline
MCParticle::Status 
MCParticle::status() const 
{ 
   return m_status; 
}

inline
const vector<Trace>& 
MCParticle::traceList() const 
{ 
   return m_traceList; 
}

//inline
//const vector<const MCParticle::Hit*>&  
//MCParticle::hitList() const
//{ 
//   return m_hitList; 
//}

inline
const vector<int>&  
MCParticle::hitIndexList() const
{ 
   return m_hitIndexList; 
}

//inline
//const vector<const MCParticle::Hit*>&  
//MCParticle::smearedHitList() const 
//{ 
//   return m_smearedHitList; 
//}

inline
const WTrackStruct& 
MCParticle::wtrack_atProduction() const 
{ 
   return m_wtrack_atProduction; 
}

// internal implementation
inline
PathStruct& 
MCParticle::path() 
{ 
   return m_path; 
}

inline
const PathStruct& 
MCParticle::path() const 
{ 
   return m_path; 
}

inline
WTrackStruct& 
MCParticle::wtrack() 
{ 
   return m_wtrack; 
}


inline
const WTrackStruct& 
MCParticle::wtrack() const 
{ 
   return m_wtrack; 
}

inline
WTrackStruct& 
MCParticle::wtrack_prev() 
{ 
   return m_wtrack_prev; 
}

inline
const WTrackStruct& 
MCParticle::wtrack_prev() const 
{ 
   return m_wtrack_prev; 
}

inline
BFieldStruct& 
MCParticle::bfield() 
{ 
   return m_bfield; 
}

inline
const BFieldStruct& 
MCParticle::bfield() const 
{ 
   return m_bfield; 
}

inline
DFLOAT 
MCParticle::timeOfDecay() const 
{ 
   return m_timeOfDecay; 
}

inline
int&
MCParticle::stepCount()
{ 
   return m_stepcount; 
}

inline
int 
MCParticle::stepCount() const 
{ 
   return m_stepcount; 
}

inline
DFLOAT& 
MCParticle::stepLength()
{ 
   return m_step; 
}

inline
DFLOAT 
MCParticle::stepLength() const 
{ 
   return m_step; 
}

inline
DFLOAT& 
MCParticle::turnAngle()
{ 
   return m_turnAngle; 
}

inline
DFLOAT 
MCParticle::turnAngle() const 
{ 
   return m_turnAngle; 
}

inline
DFLOAT&   
MCParticle::turns()
{ 
   return m_turns; 
}

inline
DFLOAT
MCParticle::turns() const
{ 
   return m_turns; 
}

inline
const Medium& 
MCParticle::currentMedium() const 
{ 
   return *m_currentMedium; 
}

inline
const Medium* 
MCParticle::pCurrentMedium() const 
{ 
   return m_currentMedium; 
}
 
inline
Medium*&
MCParticle::pCurrentMedium()
{ 
   return m_currentMedium; 
}
 
inline
DFLOAT*
MCParticle::eloss()
{
   return m_eloss;
}

inline
DFLOAT* 
MCParticle::sigma_ms()
{
   return m_sigma_ms;
}

inline
const DFLOAT* 
MCParticle::eloss() const
{
   return m_eloss;
}

inline
const DFLOAT* 
MCParticle::sigma_ms() const
{
   return m_sigma_ms;
}

inline
void 
MCParticle::resetShowering()
{
   m_startedShowering=false;
}

inline
void 
MCParticle::startShowering()
{
   m_startedShowering=true;
}

inline
MCFBool 
MCParticle::showeringHasStarted() const
{
   return m_startedShowering;
}

inline
const ShowerStruct&
MCParticle::shower() const
{
   return m_shower;
}

inline
ShowerStruct&
MCParticle::shower()
{
   return m_shower;
}



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:32  eugenio
// Initial revision
//
// Revision 1.14  1998/11/20 23:47:53  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.13  1998/08/08  19:45:12  mkl
// rookie needs to be on a direction basis
//
// Revision 1.12  1998/08/04  19:44:29  mkl
// new flag for initialization status
//
// Revision 1.11  1998/05/15  03:50:54  mkl
// first attempt at taking one step to new wtrack without using move_wtk_arc routine
//
// Revision 1.10  1997/09/03  02:09:18  mkl
// made internal stepping methods public for outside use
//
// Revision 1.9  1997/08/23  01:10:12  mkl
// toward volume-based tracing
//
// Revision 1.8  1997/08/03  06:01:46  mkl
// small fixes
//
// Revision 1.7  1997/08/02  19:38:03  mkl
// fix for switch-backs
//
// Revision 1.6  1997/08/01  20:56:31  mkl
// forward declare stl containers
//
// Revision 1.5  1997/07/31  14:53:04  bphyslib
// minor changes
//
// Revision 1.4  1997/07/03  03:33:50  mkl
// new approach: surfaces vs volumes; box tracing
//
// Revision 1.3  1997/04/19  21:57:21  bphyslib
// new method "distanceToDecay()" in MCParticle makes similar function in
// DetCalorimeter obsolete; added generateTimeOfDecay as private method to
// MCParticle (was static local before).
//
// Revision 1.2  1997/03/15  19:02:21  mkl
// moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
// fixed commend headers for .inc files from # to c.
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//


#endif /* TRACING_PARTICLE_H */

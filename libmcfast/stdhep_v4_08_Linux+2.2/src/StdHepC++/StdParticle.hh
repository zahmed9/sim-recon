// ----------------------------------------------------------------------
// StdParticle.hh
// ----------------------------------------------------------------------
#ifndef STDPARTICLE_HH
#define STDPARTICLE_HH

#include "CLHEP/Vector/ThreeVector.h"
#include "CLHEP/Vector/LorentzVector.h"

namespace StdHep {

class Particle {

public:

  // ---  birth/death:
  //
  Particle( int ParticleID, int StatusCode, int Mother, int SecondMother,
          int BeginDaughters, int EndDaughters, int Color, int CollisionNumber,
	    HepLorentzVector Momentum, double Mass, 
	    HepLorentzVector CreationVertex, HepLorentzVector DecayVertex );	
  Particle( );
  Particle( Particle const & orig );
  Particle& operator=( Particle const& );
  ~Particle();

  // ---  accessors:
  //
  int const              ParticleID()     const  { return itsParticleID; }
  int const              StatusCode()     const  { return itsStatusCode; }
  int const              Mother()         const  { return itsMother; }
  int const              SecondMother()   const  { return itsSecondMother; }
  int const              BeginDaughters() const  { return itsBeginDaughters; }
  int const              EndDaughters()   const  { return itsEndDaughters; }
  int const              Color()          const  { return itsColor; }
  int const              CollisionNumber() const { return itsCollisionNumber; }
  HepLorentzVector const Momentum()       const  { return itsMomentum; }
  double const           Mass()           const  { return itsMass; }
  HepLorentzVector const CreationVertex() const  { return itsCreationVertex; }	
  HepLorentzVector const DecayVertex()    const  { return itsDecayVertex; }	

  // ---  mutators:
  //
  void  setParticleID     ( int pid )     { itsParticleID = pid; }
  void  setStatusCode     ( int status )  { itsStatusCode = status; }
  void  setMother         ( int mth )     { itsMother = mth; }
  void  setSecondMother   ( int mth2 )    { itsSecondMother = mth2; }
  void  setBeginDaughters ( int dtr )     { itsBeginDaughters = dtr; }
  void  setEndDaughters   ( int dtr2 )    { itsEndDaughters = dtr2; }
  void  setColor          ( int clr )     { itsColor = clr; }
  void  setCollisionNumber ( int coll )   { itsCollisionNumber = coll; }
  void  setMomentum       ( HepDouble px, HepDouble py, HepDouble pz, HepDouble E );
  void  setMass           ( double mass ) {  itsMass = mass; }
  void  setCreationVertex ( HepDouble cx, HepDouble cy, HepDouble cz, HepDouble ct );
  void  setDecayVertex    ( HepDouble dx, HepDouble dy, HepDouble dz, HepDouble dt );

private:

  int itsParticleID;

  int itsStatusCode;

  int itsMother;
  int itsSecondMother;
  int itsBeginDaughters;
  int itsEndDaughters; 
  
  int itsColor;
  int itsCollisionNumber;
  
  HepLorentzVector itsMomentum;
  double           itsMass;	// (in GeV/c**2)
  
  HepLorentzVector itsCreationVertex; 	
  HepLorentzVector itsDecayVertex; 	

};	// Particle

}
#endif // STDPARTICLE_HH

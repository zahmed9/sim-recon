// ----------------------------------------------------------------------
//
// StdParticle.cc
//
// ----------------------------------------------------------------------

#include "StdParticle.hh"

namespace StdHep  {

Particle::Particle( int ParticleID, int StatusCode, int Mother, int SecondMother,
          int BeginDaughters, int EndDaughters, int Color, int CollisionNumber,
	    HepLorentzVector Momentum, double Mass, 
	    HepLorentzVector CreationVertex, HepLorentzVector DecayVertex )	
: itsParticleID      ( ParticleID ), 
  itsStatusCode      ( StatusCode ),
  itsMother          ( Mother ),
  itsSecondMother    ( SecondMother ),
  itsBeginDaughters  ( BeginDaughters ),
  itsEndDaughters    ( EndDaughters ), 
  itsColor           ( Color ), 
  itsCollisionNumber ( CollisionNumber ), 
  itsMomentum        ( Momentum ), 
  itsMass            ( Mass ),
  itsCreationVertex  ( CreationVertex ), 	
  itsDecayVertex     ( DecayVertex )	
{ ; }

Particle::Particle( )	
: itsParticleID      ( 0 ), 
  itsStatusCode      ( 0 ),
  itsMother          ( 0 ),
  itsSecondMother    ( 0 ),
  itsBeginDaughters  ( 0 ),
  itsEndDaughters    ( 0 ), 
  itsColor           ( 0 ), 
  itsCollisionNumber ( 0 ), 
  itsMomentum        ( 0 ), 
  itsMass            ( 0 ),
  itsCreationVertex  ( 0 ), 	
  itsDecayVertex     ( 0 )	
{ ; }

Particle::Particle( Particle const & orig )
: itsParticleID      ( orig.itsParticleID ), 
  itsStatusCode      ( orig.itsStatusCode ), 
  itsMother          ( orig.itsMother ),
  itsSecondMother    ( orig.itsSecondMother ),
  itsBeginDaughters  ( orig.itsBeginDaughters ),
  itsEndDaughters    ( orig.itsEndDaughters ), 
  itsColor           ( orig.itsColor ), 
  itsCollisionNumber ( orig.itsCollisionNumber ), 
  itsMomentum        ( orig.itsMomentum ), 
  itsMass            ( orig.itsMass ),
  itsCreationVertex  ( orig.itsCreationVertex ), 	
  itsDecayVertex     ( orig.itsDecayVertex )	
{ ; }

Particle& Particle::operator=( Particle const & rhs )
{ if( this != & rhs )
  {
    itsParticleID      = rhs.itsParticleID;
    itsStatusCode      = rhs.itsStatusCode;
    itsMother          = rhs.itsMother;
    itsSecondMother    = rhs.itsSecondMother;
    itsBeginDaughters  = rhs.itsBeginDaughters;
    itsEndDaughters    = rhs.itsEndDaughters;
    itsColor           = rhs.itsColor;
    itsCollisionNumber = rhs.itsCollisionNumber;
    itsMomentum        = rhs.itsMomentum;
    itsMass            = rhs.itsMass;
    itsCreationVertex  = rhs.itsCreationVertex;	
    itsDecayVertex     = rhs.itsDecayVertex;	
  }
  return *this;
}

Particle::~Particle()  { ; }

// ---  mutators:
//
void Particle::setMomentum( HepDouble px, HepDouble py, HepDouble pz, HepDouble E ) {
  itsMomentum.setPx( px );
  itsMomentum.setPx( px );
  itsMomentum.setPy( py );
  itsMomentum.setPz( pz );
  itsMomentum.setE( E );
}
void  Particle::setCreationVertex( HepDouble cx, HepDouble cy, HepDouble cz, HepDouble ct ) {
  itsCreationVertex = HepLorentzVector( cx, cy, cz, ct );
}
void  Particle::setDecayVertex( HepDouble dx, HepDouble dy, HepDouble dz, HepDouble dt ) {
  itsDecayVertex = HepLorentzVector( dx, dy, dz, dt );
}

}  // StdHep

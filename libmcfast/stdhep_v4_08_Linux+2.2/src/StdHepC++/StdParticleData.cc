// ----------------------------------------------------------------------
//
// StdParticleData.cc
//
// ----------------------------------------------------------------------

#include "StdParticleData.hh"

namespace StdHep  {

ParticleData::ParticleData( int ID, std::string const & ParticleName, int Charge, 
                            double Mass, double Width )
: itsID           ( ID ), 
  itsParticleName ( ParticleName ), 
  itsCharge       ( Charge ),
  itsMass         ( Mass ),
  itsWidth        ( Width )
{ ; }

ParticleData::ParticleData( )
: itsID           ( 0 ), 
  itsParticleName ( 0 ), 
  itsCharge       ( 0 ),
  itsMass         ( 0 ),
  itsWidth        ( 0 )
{ ; }

ParticleData::ParticleData( ParticleData const & orig )
: itsID           ( orig.itsID ), 
  itsParticleName ( orig.itsParticleName ), 
  itsCharge       ( orig.itsCharge ),
  itsMass         ( orig.itsMass ),
  itsWidth        ( orig.itsWidth )
{ ; }

ParticleData::~ParticleData()  { ; }

// ---  accessors:
//
int const  ParticleData::ID() const  {  return itsID; }

std::string const &  ParticleData::ParticleName() const  {  return itsParticleName; }

int const  ParticleData::Charge() const  {  return itsCharge; }

double const  ParticleData::Mass() const  {  return itsMass; }

double const  ParticleData::Width() const  {  return itsWidth; }

// ---  mutators:
//
void  ParticleData::setID( int ID )          {  itsID = ID; }
void  ParticleData::setCharge( int Charge )  {  itsCharge = Charge; }
void  ParticleData::setMass( double mass )   {  itsMass = mass; }
void  ParticleData::setWidth( double width ) {  itsWidth = width; }

}  // StdHep

// ----------------------------------------------------------------------
// StdEvent.hh
// ----------------------------------------------------------------------
#ifndef STDEVENT_HH
#define STDEVENT_HH

#include <vector>

#include "StdParticle.hh"
#include "StdCollision.hh"

namespace StdHep  {

class Event {

public:

  // ---  birth/death:
  //
  Event( int EventNumber, int Entries, int NumberCollisions );
  Event( );
  Event( Event const & orig );
  Event& operator=( Event const& );
  ~Event();

  // ---  accessors:
  //
  int      const    EventNumber()      const  {  return itsEventNumber; }
  int      const    Entries()          const  {  return itsEntries; }
  int      const    NumberCollisions() const  {  return itsNumberCollisions; }

  Particle  HEParticle( int i )   const  {  return *(itsParticleList[i]); }
  Collision HEPCollision( int i ) const  {  return *(itsCollisionList[i]); }

  // ---  mutators:
  //
  void  setEventNumber      ( int nmbr )     { itsEventNumber = nmbr; }
  void  setEntries          ( int ntries )   { itsEntries = ntries; }
  void  setNumberCollisions ( int cnum )     { itsNumberCollisions = cnum; }
  void  appendParticle      ( Particle* p )  { itsParticleList.push_back( p ); }
  void  appendCollision     ( Collision* c ) { itsCollisionList.push_back( c ); }

private:

  int itsEventNumber;
  int itsEntries;
  int itsNumberCollisions;
  vector<Particle*> itsParticleList;
  vector<Collision*> itsCollisionList;
  
};	// Event

}

#endif // STDEVENT_HH

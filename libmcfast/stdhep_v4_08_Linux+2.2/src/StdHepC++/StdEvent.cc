// ----------------------------------------------------------------------
// StdEvent.cc
// ----------------------------------------------------------------------

#include "StdEvent.hh"

namespace StdHep  {

Event::Event( int EventNumber, int Entries, int NumberCollisions )
: itsEventNumber      ( EventNumber ), 
  itsEntries          ( Entries ),
  itsNumberCollisions ( NumberCollisions )
{ ; }

Event::Event( )
: itsEventNumber      ( 0 ), 
  itsEntries          ( 0 ),
  itsNumberCollisions ( 0 ),
  itsParticleList     ( 0 ),
  itsCollisionList    ( 0 )
{ ; }

Event::Event( Event const & orig )
: itsEventNumber      ( orig.itsEventNumber ), 
  itsEntries          ( orig.itsEntries ),
  itsNumberCollisions ( orig.itsNumberCollisions )
{ ; }

Event& Event::operator=( Event const & rhs )
{ if( this != & rhs )
  {
    itsEventNumber      = rhs.itsEventNumber;
    itsEntries          = rhs.itsEntries;
    itsNumberCollisions = rhs.itsNumberCollisions;
    itsParticleList     = rhs.itsParticleList;
    itsCollisionList    = rhs.itsCollisionList;
  }
  return *this;
}

Event::~Event()  
{
  typedef vector<Particle*>::const_iterator citP;
  typedef vector<Collision*>::const_iterator citC;
  for( citP i = itsParticleList.begin(), j = itsParticleList.end(); i != j; i++ )
  {
      delete *i;
  }
  for( citC i = itsCollisionList.begin(), j = itsCollisionList.end(); i != j; i++ )
  {
      delete *i;
  }
}


}  // StdHep

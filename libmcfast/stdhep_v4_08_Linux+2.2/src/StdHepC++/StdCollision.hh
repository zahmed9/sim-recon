// ----------------------------------------------------------------------
// StdCollision.hh
// ----------------------------------------------------------------------
// This class is temporary.  
// It will be removed when events include other events.
// This class is the equivalent of the fortran HEPEV3 common block
//
#ifndef STDCOLLISION_HH
#define STDCOLLISION_HH

namespace StdHep {

class Collision {

public:

  // ---  birth/death:
  //
  Collision( int InteractionEventNumber, int IOStream,
             int BeginCollision, int EndCollision );	
  Collision( );
  Collision( Collision const & orig );
  Collision& operator=( Collision const& );
  ~Collision();

  // ---  accessors:
  //
  int const  InteractionEventNumber()  const  { return itsInteractionEventNumber; }
  int const  IOStream()                const  { return itsIOStream; }
  int const  BeginCollision()          const  { return itsBeginCollision; }
  int const  EndCollision()            const  { return itsEndCollision; }

  // ---  mutators:
  //
  void  setInteractionEventNumber ( int evn )  { itsInteractionEventNumber = evn; }
  void  setIOStream               ( int str )  { itsIOStream = str; }
  void  setBeginCollision         ( int bcol ) { itsBeginCollision = bcol; }
  void  setEndCollision           ( int ecol ) { itsEndCollision = ecol; }

private:

  int itsInteractionEventNumber;
  int itsIOStream;
  int itsBeginCollision;
  int itsEndCollision; 

};	// Collision

}
#endif // STDCOLLISION_HH

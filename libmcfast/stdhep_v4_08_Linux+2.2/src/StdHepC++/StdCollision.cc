// ----------------------------------------------------------------------
//
// StdCollision.cc
//
// ----------------------------------------------------------------------

#include "StdCollision.hh"

namespace StdHep  {

Collision::Collision( int InteractionEventNumber, int IOStream,
                      int BeginCollision, int EndCollision  )	
: itsInteractionEventNumber      ( InteractionEventNumber ), 
  itsIOStream                    ( IOStream ), 
  itsBeginCollision              ( BeginCollision ),
  itsEndCollision                ( EndCollision ) 
{ ; }

// default constructor
Collision::Collision( )	
: itsInteractionEventNumber      ( 0 ), 
  itsIOStream                    ( 0 ), 
  itsBeginCollision              ( 0 ),
  itsEndCollision                ( 0 ) 
{ ; }

Collision::Collision( Collision const & orig )
: itsInteractionEventNumber  ( orig.itsInteractionEventNumber ), 
  itsIOStream                ( orig.itsIOStream ), 
  itsBeginCollision          ( orig.itsBeginCollision ),
  itsEndCollision            ( orig.itsEndCollision )
{ ; }

Collision& Collision::operator=( Collision const & rhs )
{ if( this != & rhs )
  {
    itsInteractionEventNumber = rhs.itsInteractionEventNumber;
    itsIOStream               = rhs.itsIOStream;
    itsBeginCollision         = rhs.itsBeginCollision;
    itsEndCollision           = rhs.itsEndCollision;
  }
  return *this;
}

Collision::~Collision()  { ; }

}  // StdHep

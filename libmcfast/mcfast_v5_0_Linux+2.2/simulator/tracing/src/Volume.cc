// -*- C++ -*-
//
// Package:     Tracing
// Module:      Volume
// 
// Description: <one line class summary>
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     Wed June 25 15:21:36 EDT 1997

// system include files
#include <assert.h>
#include <stdlib.h>
#include <vector>

// user include files
#include "Volume.hh"
#include "MCParticle.hh"

#include "functions.hh"

// STL classes

//
// constants, enums and typedefs
//

//
// static data member definitions
//

//
// constructors and destructor
//
Volume::Volume()
{
}

Volume::Volume( const Volume& volume )
{
   *this = volume;
}

Volume::~Volume()
{
   deleteSurfaceList();
}

//
// assignment operators
//
const Volume& Volume::operator=( const Volume& volume ) 
{
   if( this != &volume ) 
   {
      // clear surface list
      deleteSurfaceList();

      // do deep copy of surfaces
      vector<Surface*>::const_iterator end = volume.m_surfaces.end();
      for( vector<Surface*>::const_iterator i = volume.m_surfaces.begin();
	   i != end; 
	   ++i )
      {
	 m_surfaces.push_back( (*i)->clone() );
      }

      Surface::operator=( volume );
   }

   return *this;
}


//
// member functions
//
void 
Volume::deleteSurfaceList()
{
   // since contains pointers, need to delete one by one
   while( m_surfaces.size() > 0 ) 
   {
      delete m_surfaces.back();
      m_surfaces.pop_back();
   }
}

void
Volume::insert( Surface* iSurface )
{
   m_surfaces.push_back( iSurface );
}

//
// const member functions
//
// base implementation of distanceTo (derived classes might want to inherit)
DFLOAT
Volume::distanceTo( const MCParticle& iParticle,
		    DFLOAT iDistanceToBeat,
		    MCFBool& oWithinSides ) const
{
   DFLOAT minDistance = FLT_MAX;

   vector<Surface*>::const_iterator end = m_surfaces.end();
   for( vector<Surface*>::const_iterator i = m_surfaces.begin();
	i != end;
	++i )
   {
      MCFBool withinSides;
      DFLOAT distance = (*i)->distanceTo( iParticle, 
					  iDistanceToBeat, 
					  withinSides );

      // only update minDistance if within side boundaries
      if( distance < minDistance 
	  && true == oWithinSides )
      {
	 oWithinSides = withinSides;
	 minDistance  = distance;
      } 
   }

   return minDistance;
}

// base implementation of distanceToExit (derived classes might want to inherit)
DFLOAT
Volume::distanceToExit( const MCParticle& iParticle ) const
{
   DFLOAT minDistance = FLT_MAX;

   // assert that we're inside the volume!
   //assert( true == contains( iParticle.wtrack() ) );
   if( false == contains( iParticle.wtrack() ) ) {
      return minDistance = FLT_MAX;
   }

   vector<Surface*>::const_iterator end = m_surfaces.end();
   for( vector<Surface*>::const_iterator i = m_surfaces.begin();
	i != end;
	++i ) 
   {
      MCFBool withinSides;
      DFLOAT distance = (*i)->distanceTo( iParticle, minDistance, withinSides );
      
      minDistance = min( distance, minDistance );
   }

   return minDistance;
}

const DFLOAT* 
Volume::eta( const WTrackStruct& ) const
{
   cerr << "Volume::eta() not implemented yet; this is BAD!" << endl;
   assert( false );
   ::exit(1);
}

void
Volume::printOn( ostream& os ) const
{
   os << "Printing Volume surfaces:\n";

   vector<Surface*>::const_iterator end = m_surfaces.end();
   for( vector<Surface*>::const_iterator i = m_surfaces.begin();
	i != end;
	++i )
   {
      (*i)->printOn( os );
   }

   os << "\n";
}

//
// static member functions
//



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:33  eugenio
// Initial revision
//
// Revision 1.8  1999/04/22 01:28:58  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.7  1998/11/20  23:48:03  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.6  1998/11/03  17:43:36  mkl
// changes to compile under egcs
//
// Revision 1.5  1998/10/21  19:59:38  mkl
// implement eta correctly
//
// Revision 1.4  1998/02/15  01:55:38  mkl
// for DenseMedia, need base reactTo figure out if entering or leaving volume, and call implementReactTo if entering
//
// Revision 1.3  1997/08/27  03:31:45  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.2  1997/08/23  01:10:16  mkl
// toward volume-based tracing
//
// Revision 1.1  1997/07/03  03:33:56  mkl
// new approach: surfaces vs volumes; box tracing
//
//               

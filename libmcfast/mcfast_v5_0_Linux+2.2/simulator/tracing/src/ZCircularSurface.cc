// -*- C++ -*-
//
// Package:     Tracing
// Module:      ZCircularSurface
// 
// Description: Z-type circular-shaped Surface
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     Jan 23, 1997

// system include files
#include <math.h>
#include <float.h>
#include <assert.h>

// user include files
#include "report.hh"
#include "UserSettings.hh"
#include "externFortran.hh"

#include "ZCircularSurface.hh"
#include "MCParticle.hh"
#include "functions.hh"
#include "bfield_struct.hh"
#include "wtrack_struct.hh"
#include "changeWTrack.hh"
//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Tracing.ZCircularSurface";

//
// static data member definitions
//

//
// constructors and destructor
//
ZCircularSurface::ZCircularSurface( float z=0, float rmin=0, float rmax=0 )
   : ZSurface( z ), m_rmin( rmin ), m_rmax( rmax )
{
}

ZCircularSurface::ZCircularSurface( const ZCircularSurface& zCircularSurface )
{
   *this = zCircularSurface;
}

ZCircularSurface::~ZCircularSurface()
{
}

//
// assignment operators
//
const ZCircularSurface& 
ZCircularSurface::operator=( const ZCircularSurface& surface )
{
   if( this != &surface ) {
      m_rmin = surface.m_rmin;
      m_rmax = surface.m_rmax;
      ZSurface::operator=( surface );
   }

   return *this;
}

//
// member functions
//

//
// const member functions
//

// clone operation
ZCircularSurface*
ZCircularSurface::clone() const
{
   return new ZCircularSurface(*this);
}

// are within side walls?
MCFBool 
ZCircularSurface::withinSides( const WTrackStruct& wtrack ) const
{
   DFLOAT trackRadius = sqrt( wtrack.x * wtrack.x + wtrack.y * wtrack.y );
   return ( ( trackRadius >= rmin() && trackRadius <= rmax() ) ? true:false );
}

// is the point inside this surface?
MCFBool
ZCircularSurface::contains( const WTrackStruct& iWTrack ) const 
{
   // make sure it's within round-off error
   static const DFLOAT deltaStep = SMALLDISTANCE;   //particle.stepLength()/2;

   return ( (    iWTrack.z >= (z()-deltaStep) 
	      && iWTrack.z <= (z()+deltaStep)
	      && withinSides( iWTrack )
      ) ? true : false );
}

// I/O
void
ZCircularSurface::printOn( ostream& str ) const
{
   str << nameOf() << ": "
       << "z( "    << z()    << " ), "
       << "rmin( " << rmin() << " ), "
       << "rmax( " << rmax() << " )";
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
// Revision 1.5  1998/11/20 23:48:08  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.4  1997/11/11  06:44:00  mkl
// beautification of debug print-out
//
// Revision 1.3  1997/11/11  01:17:48  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.2  1997/08/27  03:31:47  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.1  1997/07/03  03:33:56  mkl
// new approach: surfaces vs volumes; box tracing
//
//

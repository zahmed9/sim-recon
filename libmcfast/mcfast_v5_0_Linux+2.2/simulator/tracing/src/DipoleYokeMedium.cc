// -*- C++ -*-
//
// Package:     <Tracing>
// Module:      DipoleYokeMedium
// 
// Description: <one line class summary>
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     Fri Aug 22 16:45:42 CDT 1997
//

// system include files
#include <assert.h>
#include <stdlib.h>
#include <float.h>

// user include files
#include "RealMaterial.hh"
#include "DipoleYokeMedium.hh"
#include "AlignedBox.hh"
#include "Detector.hh"

#include "report.hh"
#include "externFortran.hh"


// user include files

// STL classes

//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Tracing.DipoleYokeMedium";

//
// static data member definitions
//

//
// constructors and destructor
//
DipoleYokeMedium::DipoleYokeMedium( int iFortranIndex, WhichHalf whichHalf )
   : m_whichHalf( whichHalf )
{
   if( 0 >= iFortranIndex )
   {
      report( EMERGENCY, kFacilityString ) 
	 << "-E-DipoleYokeMedium::iFortranIndex == 0!\n";
      assert( false );
      ::exit(-1);
   }

   // fill info from common blocks
   char name[Medium::kFortranNameLength];
   real xmin, xmax, ymin, ymax, zmin, zmax, direction_cosines[3];

   get_dipole_info_( iFortranIndex,
		     name,
		     xmin, xmax, ymin, ymax, zmin, zmax, 
		     direction_cosines,
		     Medium::kFortranNameLength );


   // now construct objects
   Volume *volume=0; 
   Medium::Type type;

   if( kZeroHalf == m_whichHalf ) // make B-field cage
   {
      type = Medium::kDipoleMagnet;
      volume = new AlignedBox( xmin, xmax, ymin, ymax, zmin, zmax );

   } else 
   if( kFirstHalf == m_whichHalf ) // first half of dipole yoke
   {
      type = Medium::kDipoleYoke;

      // surface
      // have to figure out if dipole field is pointed along x or y
      if( 0 != direction_cosines[0] && 0 == direction_cosines[1] )
      { // x-direction
	 volume = new AlignedBox( xmin, xmax, -FLT_MAX, ymin, zmin, zmax );
      } else 
      if( 0 == direction_cosines[0] && 0 != direction_cosines[1] )
      { // y-direction
	 volume = new AlignedBox( -FLT_MAX, xmin, ymin, ymax, zmin, zmax );
      }
      else
      { // confusion
	 report( ERROR, kFacilityString ) 
	    << "DipoleYokeMedium::error constructing dipole yoke\n";
	 assert( false );
	 ::exit( 1 );
      }
   } else 
   if( kSecondHalf == m_whichHalf ) // second half of dipole yoke
   {
      type = Medium::kDipoleYoke;

      // surface
      // have to figure out if dipole field is pointed along x or y
      if( 0 != direction_cosines[0] && 0 == direction_cosines[1] )
      { // x-direction
	 volume = new AlignedBox( xmin, xmax, ymax,  FLT_MAX, zmin, zmax );
      } else 
      if( 0 == direction_cosines[0] && 0 != direction_cosines[1] )
      { // have y-direction
	 volume = new AlignedBox( xmax,  FLT_MAX, ymin, ymax, zmin, zmax );
      }
      else
      { // confusion
	 report( ERROR, kFacilityString ) 
	    << "DipoleYokeMedium::error constructing dipole yoke\n";
	 assert( false );
	 ::exit( 1 );
      }
   }
   else 
   {
      report( ERROR, kFacilityString )
	 << "no such \"half\" of DipoleYoke!" << endl;
      assert( false );
      ::exit( 1 );
   }

   // set name
   setName( type, "dipole" );

   // surface
   setSurface( volume );

   // detector
   Detector *detector = Detector::createDetector( type );
   setDetector( detector );
 
   // material
   //Material *material 
   //  = AssociatedMaterial::createMaterial( radl, dedx, coll, absp );
   //setMaterial( material );
   
}

// DipoleYokeMedium::DipoleYokeMedium( const DipoleYokeMedium& )
// {
// }

DipoleYokeMedium::~DipoleYokeMedium()
{
}

//
// assignment operators
//
// const DipoleYokeMedium& DipoleYokeMedium::operator=( const DipoleYokeMedium& )
// {
// }

//
// member functions
//

//
// const member functions
//
MCFBool
DipoleYokeMedium::implementReactTo( MCParticle& particle ) const
{
// -------------------------------------------------------------------
// Override DenseMedium::implementReactTo(); just return true
// -------------------------------------------------------------------

   MCFBool returnValue = true;

   MCFBool oHitActiveArea;
   MCFBool status = detectorResponse( particle, oHitActiveArea );
   if( false == status ) return( returnValue = false );
   
   return returnValue;
}

//
// static member functions
//



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:32  eugenio
// Initial revision
//
// Revision 1.10  1998/11/20 23:47:51  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.9  1998/08/04  22:58:38  mkl
// implemented Detector::generateResponse with extra output argument: oHitActiveArea; only if true, do material effects
//
// Revision 1.8  1998/05/18  16:46:44  yarba_j
// minor cleanup
//
// Revision 1.7  1998/02/16  18:23:14  mkl
// override DenseMedium::implementReactTo
//
// Revision 1.6  1998/02/16  04:33:40  mkl
// first version of 2ndary interactions
//
// Revision 1.5  1998/01/14  20:01:19  mkl
// beautifications of printouts
//
// Revision 1.4  1997/11/22  20:26:31  mkl
// keep track of fortran name of planes
//
// Revision 1.3  1997/11/11  06:43:11  mkl
// fixed x-, y-oriented dipoles; had to flip the two cases
//
// Revision 1.2  1997/11/11  01:17:32  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.1  1997/08/23  01:10:11  mkl
// toward volume-based tracing
//



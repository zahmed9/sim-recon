// -*- C++ -*-
//
// Package:     Tracing
// Module:      CompositeMedium
// 
// Description: Container for r, z, cone-type media
//              Finds next closest Medium to given particle wtrack parms.
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     Jan 23, 1997
// RCS(Id)
//
// Revision history
//
// RCS(Log)

// system include files
#include <assert.h>
#include <stdlib.h>
#include <vector>
#include <algorithm>

// user include files
#include "functions.hh"
#include "report.hh"
#include "externFortran.hh"

#include "UserSettings.hh"

#include "CompositeMedium.hh"
#include "Tracer.hh"

#include "Medium.hh"
#include "RMedium.hh"
#include "ZMedium.hh"
#include "DenseMedium.hh"
#include "TubeDenseMedium.hh"
#include "BoxDenseMedium.hh"
#include "DipoleYokeMedium.hh"

#include "RSurface.hh"
#include "ZSurface.hh"
#include "Tube.hh"
#include "AlignedBoxWithGap.hh"

#include "ProxyVisitor.hh"

#include "MCParticle.hh"

//
// constants, enums and typedefs
//
const char* const kFacilityString = "Tracing.CompositeMedium";

typedef vector<Medium*> MediumList;

//
// static data member definitions
//

//
// constructors and destructor
//
CompositeMedium::CompositeMedium() : 

   // tracing algorithm
   m_tracer( new Tracer( *this ) )

{
   if( 0 == m_tracer )
   {
      report( EMERGENCY, kFacilityString ) 
	 << "can't allocate memory" << endl;
      assert( false );
      ::exit( 1 );
   }

   // reset indices
   reset();

   // --------------------------------------------------------------
   // fill from list of r and z planes and cones and xy planes
   // --------------------------------------------------------------
   fillRPlanes();

   // --------------------------------------------------------------
   // next z planes
   // --------------------------------------------------------------
   fillZPlanes();

   // --------------------------------------------------------------
   // Volume-based media
   // --------------------------------------------------------------
   fillTubes();

   // --------------------------------------------------------------
   // Boxes
   // --------------------------------------------------------------
   fillAlignedBoxes();

   // --------------------------------------------------------------
   // Cones
   // --------------------------------------------------------------
   // fillCones();

   // --------------------------------------------------------------
   // make dummy all-enclosing surface
   // --------------------------------------------------------------
   fillEnvelope();

   // check for neighbouring volumes, if there're any 


   if ( !m_volumeMediaOwner.empty() )  createNeighbourhood() ;

}

// CompositeMedium::CompositeMedium( const CompositeMedium& )
// {
// }

CompositeMedium::~CompositeMedium()
{
   // delete in reverse order!

   // tracing algorithm
   delete m_tracer;

   // ---------- object owner containers --------------
   // have to delete each element!

   while( m_alignedBoxMediaOwner.size() > 0 ) {
      delete m_alignedBoxMediaOwner.back();
      m_alignedBoxMediaOwner.pop_back();
   }

   while( m_volumeMediaOwner.size() > 0 ) {
      delete m_volumeMediaOwner.back();
      m_volumeMediaOwner.pop_back();
   }

   while( m_yMediaOwner.size() > 0 ) {
      delete m_yMediaOwner.back();
      m_yMediaOwner.pop_back();
   }

   while( m_xMediaOwner.size() > 0 ) {
      delete m_xMediaOwner.back();
      m_xMediaOwner.pop_back();
   }

   while( m_zMediaOwner.size() > 0 ) {
      delete m_zMediaOwner.back();
      m_zMediaOwner.pop_back();
   }

   while( m_rMediaOwner.size() > 0 ) {
      delete m_rMediaOwner.back();
      m_rMediaOwner.pop_back();
   }

   // ---------- tracing media containers -------------
   // no need to delete each element
}

//
// assignment operators
//
// const CompositeMedium& CompositeMedium::operator=( const CompositeMedium& )
// {
// }

//
// member functions
//
void
CompositeMedium::fillRPlanes()
{
   // --------------------------------------------------------------
   // fill r plane info from fortran geometry description
   // --------------------------------------------------------------
   const int numRPlanes = get_rplane_num_();
   for( int i=0; i< numRPlanes; ++i ) 
   {
      Medium* medium = new RMedium( i+1 );

      m_rMediaOwner.push_back( medium );
      m_rMedia     .push_back( medium );
   }
}

void
CompositeMedium::fillZPlanes()
{
   // --------------------------------------------------------------
   // fill z plane info from fortran geometry description
   // --------------------------------------------------------------
   const int numZPlanes = get_zplane_num_();
   for( int i=0; i< numZPlanes; ++i ) 
   {
      Medium* medium = new ZMedium( i+1 );

      m_zMediaOwner.push_back( medium );
      m_zMedia     .push_back( medium );
   }
}

void
CompositeMedium::fillTubes()
{
   // --------------------------------------------------------------
   // fill tubes:
   // --------------------------------------------------------------
   report( INFO, kFacilityString ) << "adding Tubes:\n";
   report( INFO ) << "------------\n";

   // --------------------------------------------------------------
   // fill cylindrically-shaped calorimeters/absorbers
   // --------------------------------------------------------------

   const int numEMCals = get_emcal_num_();

   report( INFO ) << "Calorimeters: " << numEMCals << "\n";

   for( int i=0; i< numEMCals; ++i ) 
   {
      integer fortranIndex = i+1;
      if( ! emcal_is_tube_( fortranIndex ) ) continue;

      Medium* medium = new TubeDenseMedium( fortranIndex );

      // now store in vector
      m_volumeMediaOwner.push_back( medium );

      // now fill Proxies!
      ProxyVisitor visitor( *medium, 
			    m_rMedia, m_zMedia, m_xMedia, m_yMedia );
      Tube* tube = (Tube*)medium->pSurface();
      tube->accept( visitor );

   } // loop over emcal_num

   // end of printing
   report( INFO ) << "------------" << endl;
}

void
CompositeMedium::fillAlignedBoxes()
{
   // --------------------------------------------------------------
   // fill box info from fortran geometry description
   // --------------------------------------------------------------

   // --------------------------------------------------------------
   // first fill dipole yokes
   // --------------------------------------------------------------
   report( INFO, kFacilityString ) << "adding Box Media:\n";
   report( INFO ) << "------------\n";

   report( INFO ) << "dipole yokes:\n";

   const int numDipoles = get_dipole_num_();
   for( int i=0; i< numDipoles; ++i ) 
   {
      Medium* medium=0;
      AlignedBox* box = 0;
      
      // loop over magnet cage, and the two dipole yokes
      for( int j=DipoleYokeMedium::kZeroHalf; 
	   j<DipoleYokeMedium::kNumberOfHalfs; 
	   ++j )
      {
	 DipoleYokeMedium::WhichHalf whichHalf = (DipoleYokeMedium::WhichHalf)j;

	 medium = new DipoleYokeMedium( i+1, whichHalf );

	 // now store in vector
	 m_alignedBoxMediaOwner.push_back( medium );

	 // now fill Proxies!
	 ProxyVisitor visitor( *medium, 
			       m_rMedia, m_zMedia, m_xMedia, m_yMedia );
	 box = (AlignedBox*)medium->pSurface();
	 box->accept( visitor );
      }

   } // loop over dipoles



// ugly trick to fix problem with unresolved reference AlighedBoxWithGap 
// (when called from showering code)
// will go away when we break things into 3 libs instead of 2
   AlignedBoxWithGap fakeBox( 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ) ;


   // ----------------------------
   // box-shaped calorimeters
   // ----------------------------
   const int numEMCals = get_emcal_num_();

   report( INFO ) << "Calorimeters: " << numEMCals << "\n";

   for( int i=0; i< numEMCals; ++i ) 
   {
      integer fortranIndex = i+1;
      if( ! emcal_is_box_( fortranIndex ) ) continue;

      Medium* medium = new BoxDenseMedium( fortranIndex );

      // now store in vector
      m_alignedBoxMediaOwner.push_back( medium );

      // now fill Proxies!
      ProxyVisitor visitor( *medium, 
			    m_rMedia, m_zMedia, m_xMedia, m_yMedia );
      AlignedBox* box = (AlignedBox*)medium->pSurface();
      box->accept( visitor );

   } // loop over emcal_num

   // end of printing
   report( INFO ) << "------------" << endl;
}

void
CompositeMedium::fillEnvelope()
{
   // --------------------------------------------------------------
   // create allencompassing envelope:
   // --------------------------------------------------------------
   report( INFO, kFacilityString ) 
      << "adding all-encompassing envelope\n";

   // get info from geo_in_detector
   DFLOAT rmax, zmin, zmax;
   get_detector_dimensions_( rmax, zmin, zmax );
   Tube* tube = new Tube( -1, rmax, zmin, zmax ); // first -1 signifies 
                                                  // no inner cylinder
   assert( 0 != tube );
   Medium* medium = new Medium;
   assert( 0 != medium );
   medium->setSurface( tube );

   medium->setName( Medium::kEnclosingTube, "enclosing tube" );

   // now store in vector
   m_volumeMediaOwner.push_back( medium );
   
   // now fill Proxies!
   ProxyVisitor visitor( *medium, m_rMedia, m_zMedia, m_xMedia, m_yMedia );
   tube->accept( visitor );
   
#if 0 /* old, no replaced by proxies */
   Medium* medium = new Medium;
   medium->setSurface( new RSurface( rmax, zmin, zmax ) );
   m_rMedia.push_back( medium );
   medium->setSurface( new ZCircularSurface( zmin, 0, rmax ) );
   m_zMedia.push_back( medium );
   medium->setSurface( new ZCircularSurface( zmax, 0, rmax ) );
   m_zMedia.push_back( medium );
#endif
}

// locally used functional objects
   class comp_rmed { // Function Object
      public: 
	 MCFBool operator()( const Medium* x, const Medium* y ) {
	    // sort based on r
	    return( (   ((const RSurface*)x->pSurface())->radius() 
		      < ((const RSurface*)y->pSurface())->radius() ) 
		    ? true : false );
	 }
   };

   class comp_zmed {
      public: 
	 MCFBool operator()( const Medium* x, const Medium* y ) const {
	    // sort based on z
	    return( (   ((const ZSurface*)x->pSurface())->z() 
		      < ((const ZSurface*)y->pSurface())->z() ) 
		    ? true : false );
	 }
   };
   
void
CompositeMedium::createNeighbourhood()
{

   // --------------------------------------------------------------
   // sort out mediaLists and check on neighbours for DenseMedia
   // --------------------------------------------------------------


   stable_sort( m_rMedia.begin(), m_rMedia.end(), comp_rmed() ); 
   stable_sort( m_zMedia.begin(), m_zMedia.end(), comp_zmed() ); 

   MediumList::iterator iMed ;
   // collect r-neighbours
   for ( iMed = m_rMedia.begin(); iMed != m_rMedia.end(); iMed++ )
   {
      (*iMed)->collectRNeighbours( m_rMedia, iMed ) ;
   }
   // collect z-neighbours
   for ( iMed = m_zMedia.begin(); iMed != m_zMedia.end(); iMed++ )
   {
      (*iMed)->collectZNeighbours( m_zMedia, iMed ) ;
   }

}

//
// const member functions
//

void
CompositeMedium::reset() const
{
   m_tracer->reset(); // reset indices
}

const Medium*
CompositeMedium::nextMediumTo( const MCParticle& particle ) const
{
   const Medium* medium=0;

   medium = m_tracer->nextMediumTo( particle );

   return medium;
}

// -----------------------------------------------------------------
//   Printing and GUI Methods
//
void 
CompositeMedium::printOn( ostream& str ) const
{
   // print out info on all the media
   str << "CompositeMedium: listing all Media\n";
   str << "----------------------------------\n\n";

   // RMedia
   str << "CompositeMedium: listing all RMedia\n";
   str << "-----------------------------------\n";
   MediumList::const_iterator firstRMedium = m_rMedia.begin();
   MediumList::const_iterator lastRMedium  = m_rMedia.end();
   for( MediumList::const_iterator i=firstRMedium; i!=lastRMedium; ++i )
   {
      (*i)->printOn( str );
      str << "\n";
   }
   str << "\n";
 
   // ZMedia
   str << "CompositeMedium: listing all ZMedia\n";
   str << "-----------------------------------\n";
   MediumList::const_iterator firstZMedium = m_zMedia.begin();
   MediumList::const_iterator lastZMedium  = m_zMedia.end();
   for( MediumList::const_iterator i=firstZMedium; i!=lastZMedium; ++i )
   {
      (*i)->printOn( str );
      str << "\n";
   }
   str << "\n";
 
   // XMedia
   str << "CompositeMedium: listing all XMedia\n";
   str << "-----------------------------------\n";
   MediumList::const_iterator firstXMedium = m_xMedia.begin();
   MediumList::const_iterator lastXMedium  = m_xMedia.end();
   for( MediumList::const_iterator i=firstXMedium; i!=lastXMedium; ++i )
   {
      (*i)->printOn( str );
      str << "\n";
   }
   str << "\n";
 
   // YMedia
   str << "CompositeMedium: listing all YMedia\n";
   str << "-----------------------------------\n";
   MediumList::const_iterator firstYMedium = m_yMedia.begin();
   MediumList::const_iterator lastYMedium  = m_yMedia.end();
   for( MediumList::const_iterator i=firstYMedium; i!=lastYMedium; ++i )
   {
      (*i)->printOn( str );
      str << "\n";
   }
   str << "\n";
 
   // cone media

   str << "CompositeMedium: end of Media listing\n";

}

//
// static member functions
//


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:31  eugenio
// Initial revision
//
// Revision 1.27  1999/04/22 01:28:50  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.26  1999/04/16  22:51:16  yarba_j
// ugly trick in fillAlignedBoxes to avoid problem with unresolved referrence AlignedBoxWithGap called from showering code
//
// Revision 1.25  1999/02/15  19:03:30  mkl
// added Box-shaped Calorimeters
//
// Revision 1.24  1998/11/20  23:47:45  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.23  1998/11/03  17:43:30  mkl
// changes to compile under egcs
//
// Revision 1.22  1998/10/19  21:01:36  yarba_j
// fixed ~CompositeMedium()
//
// Revision 1.21  1998/05/18  16:42:15  yarba_j
// updated to account for showers spread over multiple volumes
//
// Revision 1.20  1998/02/17  23:38:19  mkl
// rename TubeCalorimeterMedium to TubeDenseMedium (Julia Yarba)
//
// Revision 1.19  1997/12/17  18:34:05  yarba_j
// first implementation of passage of particle through calorimeters and absorbers, including hit generation in calorimeters; no transverse profile of showers yet
//
// Revision 1.16  1997/11/22  20:26:31  mkl
// keep track of fortran name of planes
//
// Revision 1.15  1997/11/12  07:49:05  mkl
// major bug fixes (mostly reverse_iterator specific) -- now good agreement with fortran tracing found number of tracks
//
// Revision 1.14  1997/11/11  01:17:30  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.13  1997/08/25  19:23:02  mkl
// new Visitor classes to keep from cluttering volume class
//
// Revision 1.12  1997/08/23  01:10:09  mkl
// toward volume-based tracing
//
// Revision 1.11  1997/08/03  04:19:43  mkl
// moved Box to AlignedBox
//
// Revision 1.10  1997/08/02  03:01:27  mkl
// RealMaterial and AssociatedMaterial derive from placeholder Material
//
// Revision 1.9  1997/08/01  19:21:53  mkl
// switched from vector<Medium> to vector<Medium*> for dynamic Medium behavior
//
// Revision 1.8  1997/07/03  03:33:43  mkl
// new approach: surfaces vs volumes; box tracing
//
// Revision 1.7  1997/05/11  04:54:30  mkl
// efficiency studies
//
// Revision 1.6  1997/05/10  21:17:12  mkl
// speed improvements by using info on r for z tracing and vice versa.
//
// Revision 1.5  1997/05/10  01:41:37  mkl
// minor adjustments as part of the bug hunt
//
// Revision 1.4  1997/05/09  06:36:54  mkl
// added get_detector_dimensions to make large enveloping volume for tracing.
// fixed curler tracing in forward direction.
//
// Revision 1.3  1997/04/22  20:01:07  bphyslib
// fixes for decay-in-flights
//
// Revision 1.2  1997/04/03  21:05:32  mkl
// fixed half-hemisphere problem
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//



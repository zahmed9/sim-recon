// -*- C++ -*-
//
// Package:     Tracing
// Module:      Medium
// 
// Description: mere Handler class for surfaces, detectors, material planes
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
#include <float.h>
#include <map>
#include <string.h>

// user include files
#include "UserSettings.hh"
#include "report.hh"

#include "Medium.hh"
#include "DenseMedium.hh"
#include "ProxyMedium.hh"
#include "Trace.hh"
#include "Surface.hh"
#include "Detector.hh"
#include "Material.hh"
#include "MCParticle.hh"

//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Tracing.Medium";

//
// static data member definitions
//
map< Medium::Type, char*, less<Medium::Type> >* Medium::m_stringMap = 0;

//
// constructors and destructor
//
Medium::Medium()
   : m_type( kNoType ),
     m_surface(0), 
     m_material(0), 
     m_detector(0), 
     m_name(0),
     m_fortranName(0),
     m_commonIndexF(0)
{
   // only needs to be done once since static
   if ( 0 == m_stringMap ) {
      createStringMap();
   }
}

Medium::Medium( const Medium& medium )
   : m_type( kNoType ),
     m_surface(0), 
     m_material(0), 
     m_detector(0), 
     m_name(0),
     m_fortranName(0),
     m_commonIndexF(0)
{
   m_type = medium.m_type;

   // clone pointer members
   clonePointerMembers( medium );

   // since points to stringMap, no need to do anything special
   m_name = medium.m_name;
   // but do need to duplicate the fortranName, because we've made a copy
   m_fortranName = strdup( m_fortranName );

   m_commonIndexF = medium.m_commonIndexF;
}

Medium::~Medium()
{
   // clear pointer members
   clearPointerMembers();

   // no need to delete m_name, but do need to delete m_fortranName!
   if( m_fortranName ) delete [] m_fortranName;

   // don't need to delete stringMap, since static!
}

void
Medium::clearPointerMembers()
{
   if( m_surface  ) delete m_surface;
   if( m_detector ) delete m_detector;
   if( m_material ) delete m_material;
}

void
Medium::clonePointerMembers( const Medium& medium )
{
   // only clone, if we really have an object
   if( 0 != medium.m_surface ) 
   {
      m_surface = medium.surface().clone();
   }
   if( 0 != medium.m_material ) 
   {
      m_material = medium.material().clone();
   }
   if( 0 != medium.m_detector ) 
   {
      m_detector = medium.detector().clone();
   }
}

//
// assignment operators
//
const Medium& 
Medium::operator=( const Medium& medium )
{
   if( this != &medium ) 
   {
      m_type = medium.m_type;

      // clear pointer members;
      clearPointerMembers();

      // clone pointer members
      clonePointerMembers( medium );

      // since points to stringMap, no need to do anything special
      m_name = medium.m_name;

      m_commonIndexF = medium.m_commonIndexF;
   }

   return *this;
}

//
// equality operators
//
bool 
Medium::operator==( const Medium& medium ) const 
{
#if defined(MKLDEBUG)
   report( INFO, kFacilityString ) << "Medium==medium" << endl;
#endif
   return ( this == &medium ) ? true : false;
}

bool 
Medium::operator==( const DenseMedium& denseMedium ) const 
{
#if defined(MKLDEBUG)
   report( INFO, kFacilityString ) << "Medium==denseMedium" << endl;
#endif
   return ( this == (Medium*)&denseMedium ) ? true : false;
}

bool 
Medium::operator==( const ProxyMedium& proxyMedium ) const 
{ 
#if defined(MKLDEBUG)
   report( INFO, kFacilityString ) << "Medium==proxyMedium" << endl;
#endif
   return ( this == &proxyMedium.m_realMedium ) ? true : false;
}

// member functions
//
void
Medium::setName( Medium::Type type, const char* fortranName )
{
   m_name = (*m_stringMap)[ type ];

   if( m_name == 0 ) 
   {
      report( ERROR, kFacilityString ) 
	 << "Medium::setName: m_name==0; type=" << type 
	 << " and stringMap.size()=" << (*m_stringMap).size() 
	 << endl;
   }

   m_fortranName = new char[kFortranNameLength+1];
   strncpy( m_fortranName, fortranName, kFortranNameLength );
   m_fortranName[kFortranNameLength] = '\0';

#ifdef MKLDEBUG
   report( DEBUG, kFacilityString) 
      << "found Medium " << m_name << ": " << m_fortranName << endl;
#endif
}

//
// const member functions
//
// geometrical functionality
DFLOAT 
Medium::maxStep( const MCParticle& particle, int& howMany ) const
{
   DFLOAT distance = FLT_MAX;

   if( m_surface != 0 ) 
   {
      distance = surface().maxStep( particle, howMany );
   } 
   else 
   {
      report( ERROR, kFacilityString ) 
	 << "Medium::maxStep: no surface defined" << endl;
   }

   return distance;
}

DFLOAT 
Medium::distanceTo( const MCParticle& particle, 
		    DFLOAT iDistanceToBeat,
		    MCFBool& oWithinSides ) const
{
   DFLOAT distance = FLT_MAX;

   if( m_surface != 0 ) 
   {
      distance = surface().distanceTo( particle, iDistanceToBeat, oWithinSides );
   } 
   else 
   {
      report( ERROR, kFacilityString ) 
	 << "Medium::distanceTo: no surface defined" << endl;
   }

   return distance;
}

// interface to surface routine
void
Medium::setDistanceTo( const DFLOAT iDistance ) const
{
   surface().setDistanceTo( iDistance );
}

void
Medium::setWTrackTo( const WTrackStruct& iWTrack ) const
{
   surface().setWTrackTo( iWTrack );
}

const WTrackStruct&
Medium::wtrackTo() const
{
   return surface().wtrackTo();
}

MCFBool 
Medium::contains( const WTrackStruct& iWTrack ) const
{
   MCFBool returnValue = false;

   if( m_surface != 0 ) 
   {
      returnValue = surface().contains( iWTrack );
   } 
   else 
   {
      report( ERROR, kFacilityString ) 
	 << "Medium::contains: no surface defined" << endl;
   }

   return returnValue;
}

extern "C"
{
   void check_ftrk_gap_( const WTrackStruct& w,
                         const int& orderedIndex, 
			 logical& lStrike) ;
}

// medium response
MCFBool
Medium::reactTo( MCParticle& particle ) const
{
   MCFBool returnValue = true;

   // if we hit anything:
   // 1.) make hit
   // iff hit active area, then
   // 2.) correct for material effects

    // ugly fix for inner gapo in FTRK - do NOT apply mscat and dedx if in gap !
   if ( m_detector == 0 && m_material != 0 && particle.isCharged() )
   {
      int index = commonIndexF() ;
      logical lStrike = false ;
      check_ftrk_gap_( particle.wtrack(), index, lStrike ) ;
      if ( !lStrike ) 
      {
         return returnValue ;
      }
   }

  // if at active detector, generate response (eg. hit)
   MCFBool oHitActiveArea;
   MCFBool status = detectorResponse( particle, oHitActiveArea );
   if( false == status ) return( returnValue = false );

   // only do material effects, if hit active area!
   if( false == oHitActiveArea ) return( returnValue = true );

   // take material effects into account
   MCFBool statusOK = correctForMaterial( particle );
   if( statusOK == false ) return( returnValue = false );
   
   return returnValue;
}

// Detector response
MCFBool
Medium::detectorResponse( MCParticle& particle, 
			  MCFBool& oHitActiveArea ) const
{
   // IMPORTANT: if there is no detector, we still might have to 
   // correct for material therefore default return value is true!
   MCFBool statusOK = true;

   // only generate response, if we have a detector
   if( m_detector != 0 ) 
   {
      // check, if we'are actually at detector
//      if( contains( particle.wtrack() ) ) {
   
#ifdef MKLDEBUG
	 report( DEBUG, kFacilityString ) 
	    << "making hit in detector" << endl;
#endif
	 statusOK = detector().generateResponse( particle, 
						 oHitActiveArea );

//      } else {
//	 report( ERROR, kFacilityString ) 
//	    << "Medium::generateResponse: particle not in Medium" 
//	    << endl;
//	 statusOK = false;
//      }
   }

   return statusOK; 
}

// Material response
MCFBool
Medium::correctForMaterial( MCParticle& particle ) const
{
   MCFBool statusOK = true;

   // only do something, if we have material
   if( m_material != 0 ) 
   {
      // check first if we're actually inside a material-containing surface
      if( contains( particle.wtrack() ) ) {

#ifdef MKLDEBUG
	 report( DEBUG, kFacilityString ) 
	    << "correcting for Material" << endl;
#endif
	 statusOK = material().interactWith( particle );

//      } else {
//	 report( ERROR, kFacilityString ) 
//	    << "Medium::correctForMaterial: particle not in Medium" 
//	    << endl;
//	 statusOK = false;
      }
   }

   return statusOK;
}

// ugly fix for some fortran routines which need the surface type (1=r, 2=z)
int 
Medium::typeOfSurfaceF() const 
{ 
   return (*m_surface).type(); 
}

// I/O
const char* 
Medium::name() const 
{ 
   return m_name ? m_name : "no name"; 
}

const char* 
Medium::fortranName() const 
{ 
   return m_fortranName ? m_fortranName : "no fortranName"; 
}

void 
Medium::printOn( ostream& os ) const
{
   os << "Medium " << name() << ": " << fortranName() << "\n";

   // surface should always be there!
   if( m_surface != 0 ) 
   {
      surface().printOn(os);
   }

   if( m_detector != 0 ) 
   {
      detector().printOn(os);
   }

//    if( m_field != 0 ) 
//    {
//       m_field->printOn(os);
//    }

   if( m_material != 0 ) {
      material().printOn(os);
   }

   os << flush;
}


//
// static member functions
//
void 
Medium::createStringMap()
{
   m_stringMap = new map< Medium::Type, char*, less<Medium::Type> > ;

   // base types
   (*m_stringMap).insert( pair< const Medium::Type, char* >
			  ( Medium::kProxy, "Proxy" ) ) ;
   // r planes
   (*m_stringMap).insert( pair< const Medium::Type, char* >
			  ( Medium::kDriftChamberAnode, "DriftChamberAnode" ) ) ;
   (*m_stringMap).insert( pair< const Medium::Type, char* >
			  ( Medium::kDriftChamberCathode, "DriftChamberCathode"));
   (*m_stringMap).insert( pair< const Medium::Type, char* >
			  ( Medium::kBarrelSiliconLayer, "BarrelSiliconLayer" ) );
   (*m_stringMap).insert( pair< const Medium::Type, char* >
			  ( Medium::kRMaterial, "RMaterial" ) );
   (*m_stringMap).insert( pair< const Medium::Type, char* >
			  ( Medium::kRMagnet, "RMagnet" ) );
   (*m_stringMap).insert( pair< const Medium::Type, char* >
			  ( Medium::kREMCalorimeter, "REMCalorimeter" ) );
   (*m_stringMap).insert( pair< const Medium::Type, char* >
			  ( Medium::kRHadCalorimeter, "RHadCalorimeter" ) );

   // z planes
   (*m_stringMap).insert( pair< const Medium::Type, char* >
			  ( Medium::kForwardDriftChamber, "ForwardDriftChamber"));
   (*m_stringMap).insert( pair< const Medium::Type, char* >
			  ( Medium::kSiliconDiskLayer, "SiliconDisk" ) );
   (*m_stringMap).insert( pair< const Medium::Type, char* >
			  ( Medium::kZMaterial, "ZMaterial" ) );
   (*m_stringMap).insert( pair< const Medium::Type, char* >
			  ( Medium::kZMagnet, "ZMagnet" ) );
   (*m_stringMap).insert( pair< const Medium::Type, char* >
			  ( Medium::kZEMCalorimeter, "ZEMCalorimeter" ) );
   (*m_stringMap).insert( pair< const Medium::Type, char* >
			  ( Medium::kZHadCalorimeter, "ZHadCalorimeter" ) );
   (*m_stringMap).insert( pair< const Medium::Type, char* >
			  ( Medium::kXYPixelPlane, "SiliconXYPlane" ) );

   // Boxes
   (*m_stringMap).insert( pair< const Medium::Type, char* >
			  ( Medium::kDipoleYoke, "Dipole Yoke"));

   (*m_stringMap).insert( pair< const Medium::Type, char* >
			  ( Medium::kDipoleMagnet, "Dipole Magnet"));

   (*m_stringMap).insert( pair< const Medium::Type, char* >
			  ( Medium::kBoxCalorimeter, "BoxCalorimeter"));

   // cones

   // Volumes
   (*m_stringMap).insert( pair< const Medium::Type, char* >
			  ( Medium::kTubeCalorimeter, "TubeCalorimeter"));

   // enclosing volume
   (*m_stringMap).insert( pair< const Medium::Type, char* >
			  ( Medium::kEnclosingTube, "EnclosingTube"));

   
}


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:32  eugenio
// Initial revision
//
// Revision 1.18  1999/04/22 01:28:52  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.17  1999/03/26  23:24:59  yarba_j
// temporary fixes for handling inner gap in scattering layers of forward tracking chambers
//
// Revision 1.16  1999/02/15  19:03:32  mkl
// added Box-shaped Calorimeters
//
// Revision 1.15  1998/11/20  23:47:55  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.14  1998/10/16  21:31:12  yarba_j
// fixed clearPointerMembers(...)
//
// Revision 1.13  1998/08/11  17:01:49  mkl
// clean up
//
// Revision 1.12  1998/08/04  22:58:39  mkl
// implemented Detector::generateResponse with extra output argument: oHitActiveArea; only if true, do material effects
//
// Revision 1.11  1998/05/15  03:50:55  mkl
// first attempt at taking one step to new wtrack without using move_wtk_arc routine
//
// Revision 1.10  1998/05/04  22:08:30  mkl
// equality operator properly working for Medium pointers
//
// Revision 1.9  1997/11/22  20:26:32  mkl
// keep track of fortran name of planes
//
// Revision 1.8  1997/11/11  20:14:39  mkl
// doCorrections --> interactWith
//
// Revision 1.7  1997/11/11  01:17:35  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.6  1997/08/27  03:31:38  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.5  1997/08/23  01:10:12  mkl
// toward volume-based tracing
//
// Revision 1.4  1997/08/02  19:38:59  mkl
// minor
//
// Revision 1.3  1997/07/03  03:33:51  mkl
// new approach: surfaces vs volumes; box tracing
//
// Revision 1.2  1997/04/23  01:48:18  bphyslib
// debugged photon conversions
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//



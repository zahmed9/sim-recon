#if !defined(TRACING_MEDIUM_H)
#define TRACING_MEDIUM_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      Medium
// 
// Description: 
//      Medium is a mere handler class;
//      it combines information on material, field, detector, and geometry. 
//
//      Notice: The field info is not used at present, rather the correct 
//              field is obtained (through fortran routine) 
//              depending on track parameters of MCParticle. 
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     Jan 23, 1997
//

// system include files
#include <vector>
#include <map>

// user include files
#include "Printable.hh"

#include "rplane_types.hh"
#include "zplane_types.hh"

// forward declarations
struct WTrackStruct;
class Surface;
class Volume;
class Detector;
class Material;
class MCParticle;
class ProxyMedium;
class DenseMedium;

class Medium : public Printable
{
      // friend classses and functions

   public:
      // constants, enums and typedefs
      enum { kFortranNameLength = 40 };

      enum ClassType { kMedium, kDenseMedium };

      enum Type { 

	 // if no type defined
	 kNoType = 0,
	 kProxy,
	 kLastBase,

         // r planes
	 kDriftChamberAnode    =jrpl_drf_anode   +kLastBase,
	 kDriftChamberCathode  =jrpl_drf_cathode +kLastBase,
	 kBarrelSiliconLayer   =jrpl_sibarrel    +kLastBase,
	 kRMaterial            =jrpl_material    +kLastBase,
	 kRMagnet              =jrpl_magnet      +kLastBase,
	 kREMCalorimeter       =jrpl_emcal       +kLastBase,
	 kRHadCalorimeter      =jrpl_hcal        +kLastBase,
	 kLastRPlane,

	 // z planes
	 kForwardDriftChamber  =jzpl_drift    +kLastRPlane,
	 kSiliconDiskLayer     =jzpl_sidisk   +kLastRPlane,
	 kZMaterial            =jzpl_material +kLastRPlane,
	 kZMagnet              =jzpl_magnet   +kLastRPlane,
	 kZEMCalorimeter       =jzpl_emcal    +kLastRPlane,
	 kZHadCalorimeter      =jzpl_hcal     +kLastRPlane,
	 kXYPixelPlane         =jzpl_siz_rect +kLastRPlane,
	 kCircPixelPlane       =jzpl_siz_circ +kLastRPlane,
	 kLastZPlane,

	 // boxes
	 kDipoleYoke,
	 kDipoleMagnet,
         kBoxCalorimeter,
	 kLastBox,

	 // cones
	 kLastCone,

	 // volumes
	 kTubeCalorimeter,
	 kLastVolume,

	 // enclosing tube
	 kEnclosingTube
      };


      // Constructors and destructor
      Medium();
      Medium( const Medium& );
      virtual ~Medium();

      // assignment operator(s)
      const Medium& operator=( const Medium& );

      // equality operator
      // equality operator
      virtual bool operator==( const Medium&      medium ) const;
      virtual bool operator==( const DenseMedium& medium ) const;
      virtual bool operator==( const ProxyMedium& medium ) const;

      // member functions

      void setMaterial( Material *iMaterial ) { m_material = iMaterial; }
      void setDetector( Detector *iDetector ) { m_detector = iDetector; }
      void setSurface( Surface *iSurface )       { m_surface   = iSurface;   }
      //void setField( BFieldStruct* bfield ) { m_bfield = bfield; }

      void setName( Medium::Type, const char* iFortranName );
      //void setName( const char* newName );

      // collect neighbouring media -
      // makes sense ONLY for DenseMedium and will be overwritten by it
      virtual void collectRNeighbours
                   ( vector<Medium*>&, 
                     vector<Medium*>::iterator& ) { return ; }
      virtual void collectZNeighbours
                   ( vector<Medium*>&, 
                     vector<Medium*>::iterator& ) { return ; }

      // add neighbouring medium to the list of neigbours -
      // makes sense ONLY for DenseMedium and will be overwritten by it
      virtual void addNeighbour( Medium* medium ) { return ; }

      //  const member functions
      virtual ClassType classType() const { return Medium::kMedium; }

      Type type() const { return m_type; }

      const Surface& surface()     const { return *m_surface; }
      const Surface* pSurface()    const { return m_surface;  }
      const Volume& volume()      const { return *(Volume*)m_surface; }
      const Volume* pVolume()     const { return (Volume*)m_surface;  }
      //const Field& field()       const { return *m_field; } 
      const Material& material() const { return *m_material; } 
      const Material* pMaterial() const { return m_material; } 
      const Detector& detector() const { return *m_detector; } 
      const Detector* pDetector() const { return m_detector; } 

      // quick fix for some fortran routines
      void setCommonIndexF( int index ) { m_commonIndexF=index; }
      int commonIndexF() const { return m_commonIndexF; }
      int typeOfSurfaceF() const;

      // interface to Surface method
      void setDistanceTo( const DFLOAT iDistance ) const;
      void setWTrackTo  ( const WTrackStruct& iWTrack ) const;
      const WTrackStruct& wtrackTo() const;

      // ------------------------------------------------------
      // handler functions; just fowarding to the real objects 
      //  (surface, material, detector)

      // surface -------------------------------------------------
      // maximum step towards boundary; howMany if more than one
      virtual DFLOAT maxStep( const MCParticle& iParticle, int& iHowMany ) const;

      // distance to Medium
      virtual DFLOAT distanceTo( const MCParticle& iParticle,
				 DFLOAT iDistanceToBeat,
				 MCFBool& oWithinSides ) const;

      // is the point inside the surface?
      virtual MCFBool contains( const WTrackStruct& iWTrack ) const;
      
      // react with particle (this just calls detector and material methods)
      virtual MCFBool reactTo( MCParticle& iParticle ) const;

      // print and display 
      void printOn( ostream& os = cout ) const;
      const char* nameOf() const { return "Medium"; }
      const char* name() const;
      const char* fortranName() const;

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

      // detector -----------------------------------------------
      // detector response etc -- apply to the detector if present
      MCFBool detectorResponse( MCParticle& iParticle, 
				MCFBool& oHitActiveArea ) const;

      // material -----------------------------------------------
      // take into account material (MS, Eloss, etc.)
      MCFBool correctForMaterial( MCParticle& iParticle ) const;

   private:
      // Constructors and destructor

      // private member functions
      void createStringMap();

      void clearPointerMembers();
      void clonePointerMembers( const Medium& );

      // private const member functions

      // data members
      Type m_type;

      // Medium Container Items
      Surface*  m_surface;       // Container surface
      Material* m_material; 	 // Material description
      Detector*	m_detector;	 // (optional) Detector
      //BFieldStruct* m_field;     // Magnetic Field, null for no field

      char* m_name; 	    // name of medium
      char* m_fortranName;  // name of medium

      // fix for some of the fortran routines
      int m_commonIndexF;

      // static data members
      static map< Medium::Type, char*, less<Medium::Type> >* m_stringMap;

};

// inline function definitions

// Operator overloads for <<
inline 
ostream& 
operator<<( ostream& os, const Medium &m )
{
   m.printOn( os );
   return os;
}

inline 
ostream& 
operator<<( ostream& os, const Medium *m )
{
   m->printOn(os);
   return os;
}


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:32  eugenio
// Initial revision
//
// Revision 1.25  1999/04/22 01:28:53  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.24  1999/02/15  19:03:32  mkl
// added Box-shaped Calorimeters
//
// Revision 1.23  1998/11/20  23:47:55  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.22  1998/11/03  17:43:33  mkl
// changes to compile under egcs
//
// Revision 1.21  1998/08/04  22:58:40  mkl
// implemented Detector::generateResponse with extra output argument: oHitActiveArea; only if true, do material effects
//
// Revision 1.20  1998/05/18  16:41:55  yarba_j
// updated to account for showers spread over multiple volumes
//
// Revision 1.19  1998/05/15  03:50:56  mkl
// first attempt at taking one step to new wtrack without using move_wtk_arc routine
//
// Revision 1.18  1998/05/04  22:08:30  mkl
// equality operator properly working for Medium pointers
//
// Revision 1.17  1998/04/28  16:13:21  mkl
// added equality operator
//
// Revision 1.16  1998/04/27  22:00:13  mkl
// renamed 'Class' 'ClassType'
//
// Revision 1.15  1998/04/27  20:43:26  mkl
// added class type
//
// Revision 1.14  1997/11/22  20:26:32  mkl
// keep track of fortran name of planes
//
// Revision 1.13  1997/11/13  06:38:07  mkl
// had to add siz_circ type detectors to Medium enum
//
// Revision 1.12  1997/11/13  05:12:57  mcbride
// update sixy to siz_rect
//
// Revision 1.11  1997/11/11  01:17:36  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.10  1997/09/03  17:56:18  mkl
// -m
//
// Revision 1.9  1997/08/27  03:31:38  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.8  1997/08/25  19:53:36  mkl
// added volume() accessor functions to Medium for convenience
//
// Revision 1.7  1997/08/23  01:10:13  mkl
// toward volume-based tracing
//
// Revision 1.6  1997/08/03  04:19:44  mkl
// moved Box to AlignedBox
//
// Revision 1.5  1997/08/02  19:39:03  mkl
// minor
//
// Revision 1.4  1997/08/01  20:56:32  mkl
// forward declare stl containers
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


#endif /* TRACING_MEDIUM_H */

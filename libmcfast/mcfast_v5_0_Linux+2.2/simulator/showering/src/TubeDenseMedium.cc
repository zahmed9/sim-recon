// -*- C++ -*-
//
// Package:     Showering
// Module:      TubeDenseMedium
// 
// Description: <one line class summary>
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner, Julia Yarba
// Created:     Fri Aug 22 16:45:07 CDT 1997
//

// system include files
#include <assert.h>
#include <stdlib.h>

// user include files
#include "RealMaterial.hh"
#include "MaterialLookupTable.hh"
#include "TubeDenseMedium.hh"
#include "Tube.hh"
#include "Detector.hh"
#include "DetCalorimeter.hh"

#include "report.hh"
#include "externFortran.hh"

// STL classes

//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Showering.TubeDenseMedium";

//
// static data member definitions
//

//
// constructors and destructor
//

extern "C" {
   void get_emcal_info_(
      const integer& index,
      char* name,
      integer& shapeType, integer& directionType,
      real& rmin, real& rmax, real& zmin, real& zmax,
      integer& materialIndex, integer& activeMaterialIndex,
      integer nameLength
      );
   
     void get_name_length_( const int& index,
                                  int& nameLength ) ;
     void get_name_material_(const int& index,
                                   char* name,
                                   int nameLength ) ;
     void get_emcal_resol_( const int& index,
                                  float& aEM,  float& bEM,
                                  float& aHAD, float& bHAD,
                                  float& EMtoHAD ) ;
     void get_emcal_segm_( const int&  index,
                                 int&  type,
				 int   nSegments[2] ) ;
     void geteta_( int& iType, float rMin[2], float rMax[2], 
                   float& zMin, float& zMax,
		   float& etaMin, float& etaMax ) ;
}

TubeDenseMedium::TubeDenseMedium( int iFortranIndex )
{
   if( 0 >= iFortranIndex )
   {
      report( EMERGENCY, kFacilityString ) 
	 << "iFortranIndex == 0!\n";
      assert( false );
      ::exit(-1);
   }

   // fill info from common blocks
   char name[Medium::kFortranNameLength];
   integer shapeType, directionType;
   real rmin, rmax, zmin, zmax;
   integer materialIndex, activeMaterialIndex;

   get_emcal_info_( iFortranIndex,
		    name,
		    shapeType, directionType,
		    rmin, rmax,
		    zmin, zmax,
		    materialIndex, activeMaterialIndex,
		    Medium::kFortranNameLength
      );

   // make sure we have a cylindrically-shaped volume here
   if( Volume::kCylinder != shapeType ) 
   {
      report( EMERGENCY, kFacilityString ) 
	 << "NOT kCylinder!\n";
      assert( false );
      ::exit(-1);
   }

   Medium::Type type = Medium::kTubeCalorimeter ;
   // set name
   setName( type, name );

   // volume
   Tube* tube = new Tube( rmin, rmax, zmin, zmax );
   setSurface( tube );

   // material 
   int nameLength ;
   char* nameMat ;
   get_name_length_( materialIndex, nameLength ) ;
   nameMat = new char[nameLength+1] ;
   get_name_material_( materialIndex, nameMat, nameLength ) ;
   *(nameMat+nameLength) = '\0' ;
   Material *material = (Material*)MaterialLookupTable::instance()->get( nameMat ) ;
   setMaterial( material );

   // detector (for calorimeters only, skip absorbers)
   Detector* detector ;
   // UGLY FIX TO AVOID HIT GENERATION IN ABSORBERS !!!
   // WILL BE FIXED LATER...
   if ( directionType < 100 ) 
   {
      // get resolution parameters
      float aEM, bEM, aHAD, bHAD, EMtoHAD ;
      get_emcal_resol_( iFortranIndex, aEM, bEM, aHAD, bHAD, EMtoHAD ) ;

      //get segmentation
      integer segmentationType ;
      integer numberOfSegments[2] ;
      get_emcal_segm_( iFortranIndex, 
                       segmentationType, numberOfSegments ) ;

      // define eta-coverage
      float etaMin, etaMax ;      
      // ugly fix in order to be able to use geteta_ ...
      float rMin[2], rMax[2] ;
      rMin[0] = rMin[1] = rmin ;
      rMax[0] = rMax[1] = rmax ;
      geteta_( directionType, rMin, rMax, zmin, zmax, etaMin, etaMax ) ;

      // define sampling factor if sampling calorimeter
      DFLOAT sampling = 1;
      RealMaterial* Mat = (RealMaterial*)material ;
      // use FORTRAN indeces for materials comparison for now (for speed)
      // may want to reconsider as we switch to dynamic geometry definition	 
      if ( Mat->isMixture() && activeMaterialIndex != materialIndex )
      {
	 get_name_length_( activeMaterialIndex, nameLength ) ;
	 nameMat = new char[nameLength+1] ;
	 get_name_material_( activeMaterialIndex, nameMat, nameLength ) ;
	 *(nameMat+nameLength) = '\0' ;
	 RealMaterial* actMat = 
	    (RealMaterial*)MaterialLookupTable::instance()->get( nameMat ) ;
	 if ( Mat->portionOfContribution( nameMat ) <= 0 )
         {
	    report( EMERGENCY, kFacilityString ) 
	       << "Active Material has NOT contributed to Average Material !\n";
            assert( false );
            ::exit(-1);
	 }
	    sampling = double( actMat->density() * Mat->portionOfContribution( nameMat ) )
	       / double( Mat->density() ) ;
      }
      detector = new Calorimeter( double(aEM),  double(bEM), 
				  double(aHAD), double(bHAD), 
				  double(EMtoHAD), sampling) ;

      DFLOAT limits[4] ;
      if ( segmentationType == 0 )
      {
         limits[0] = etaMin ;
	 limits[1] = etaMax ;
      }
      else if ( segmentationType == 2 )
      {
         limits[0] = zmin ;
	 limits[1] = zmax ;
      }
      else if ( segmentationType == 3 )
      {
         limits[0] = rmin ;
	 limits[1] = rmax ;
      }
      limits[2] = 0 ;
      limits[3] = TWOPI ;
      ((Calorimeter*)detector)->setLimits( segmentationType, &limits[0] ) ;
      ((Calorimeter*)detector)->setSegmentation( numberOfSegments ) ;
   } 
   else detector = 0 ; 
   setDetector( detector );
   if (detector != 0 )
   {
      detector->setDeviceIndices( iFortranIndex ) ;
   }
   // need this at least temporary to access fortran emcal db 
   // in order to avoid boxes when looking for neighbours...
   setCommonIndexF( iFortranIndex ) ;
   
}

// TubeDenseMedium::TubeDenseMedium( const TubeDenseMedium& )
// {
// }

TubeDenseMedium::~TubeDenseMedium()
{
}

//
// assignment operators
//
// const TubeDenseMedium& TubeDenseMedium::operator=( const TubeDenseMedium& )
// {
// }

//
// member functions
//

//
// const member functions
//

//
// static member functions
//



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:29  eugenio
// Initial revision
//
// Revision 1.9  1999/02/22 23:15:48  yarba_j
// handle hit generation in box-shaped calorimeters
//
// Revision 1.7  1999/02/15  19:19:51  mkl
// use new default-parm version of Detector::setDeviceIndices function
//
// Revision 1.6  1999/02/15  19:04:16  mkl
// added Box-shaped Calorimeters
//
// Revision 1.5  1999/01/15  17:50:53  yarba_j
// hit generation in calorimeters reimplemented in C++; also includes user interface on calorimetry hits for C++ programmers
//
// Revision 1.4  1998/05/18  16:45:55  yarba_j
// minor cleanup
//
// Revision 1.3  1998/03/18  21:24:11  yarba_j
// sampling factor calculation - small bug fix
//
// Revision 1.2  1998/02/23  18:02:13  yarba_j
// implemented showering in DenseMedium (incl. trans.prof.)
//
// Revision 1.1  1998/02/17  23:38:19  mkl
// rename TubeCalorimeterMedium to TubeDenseMedium (Julia Yarba)
//
// Revision 1.7  1997/12/17  18:34:09  yarba_j
// first implementation of passage of particle through calorimeters and absorbers, including hit generation in calorimeters; no transverse profile of showers yet
//
// Revision 1.3  1997/11/22  20:26:35  mkl
// keep track of fortran name of planes
//
// Revision 1.2  1997/11/12  22:04:26  yarba_j
// updated use of real materials for volume based tracing
//
// Revision 1.1  1997/08/23  01:10:15  mkl
// toward volume-based tracing
//



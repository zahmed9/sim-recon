// -*- C++ -*-
//
// Package:     Showering
// Module:      BoxDenseMedium
// 
// Description: <one line class summary>
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner, Julia Yarba
// Created:     Mon Feb 15 16:45:07 CDT 1998
//

// system include files
#include <assert.h>
#include <stdlib.h>

// user include files
#include "RealMaterial.hh"
#include "MaterialLookupTable.hh"
#include "BoxDenseMedium.hh"
#include "AlignedBoxWithGap.hh"
#include "Detector.hh"
#include "DetCalorimeter.hh"

#include "report.hh"

// STL classes

//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Showering.BoxDenseMedium";

//
// static data member definitions
//

//
// constructors and destructor
//

extern "C" {
   void get_emcal_info_box_(
      const integer& index,
      char* name,
      integer& shapeType, integer& directionType,
      real& xmin, real& xmax, real& ymin, real& ymax, real& zmin, real& zmax,
      integer& materialIndex, integer& activeMaterialIndex,
      integer nameLength
      );

   void get_emcal_gap_info_box_( const integer& index, real gap[4]);
   
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


BoxDenseMedium::BoxDenseMedium( int iFortranIndex )
{
   report( INFO, kFacilityString )
      << "here in ctor" << endl;

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
   real xmin, xmax, ymin, ymax, zmin, zmax;
   integer materialIndex, activeMaterialIndex;

   get_emcal_info_box_( iFortranIndex,
			name,
			shapeType, directionType,
			xmin, xmax,
			ymin, ymax,
			zmin, zmax,
			materialIndex, activeMaterialIndex,
			Medium::kFortranNameLength
      );
   float gap[4] ;
   get_emcal_gap_info_box_( iFortranIndex, gap ) ;

   // make sure we have a box volume here
   if( Volume::kBox != shapeType ) 
   {
      report( EMERGENCY, kFacilityString ) 
	 << "NOT kBox!\n";
      assert( false );
      ::exit(-1);
   }

   Medium::Type type = Medium::kBoxCalorimeter;
   // set name
   setName( type, name );

   // volume
   AlignedBoxWithGap* 
      box = new AlignedBoxWithGap( xmin, xmax, ymin, ymax, zmin, zmax, 
                                   gap[0], gap[1], gap[2], gap[3] );

   setSurface( box );

   // material 
   int nameLength=0;
   char* nameMat;
   get_name_length_( materialIndex, nameLength ) ;
   nameMat = new char[nameLength+1] ;
   get_name_material_( materialIndex, nameMat, nameLength ) ;
   *(nameMat+nameLength) = '\0' ;
   Material *material 
      = (Material*)MaterialLookupTable::instance()->get( nameMat ) ;
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
	    report( EMERGENCY, kFacilityString ) << 
	       "Active Material has NOT contributed to Average Material !\n";
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
      if ( segmentationType == 1 )  // actually not necessary since only x-y segmentation is allowed for boxes...
      {
         limits[0] = xmin ;
	 limits[1] = xmax ;
	 limits[2] = ymin ;
	 limits[3] = ymax ;
      }
      ((Calorimeter*)detector)->setLimits( segmentationType, &limits[0] ) ;
      ((Calorimeter*)detector)->setSegmentation( numberOfSegments) ;
   } 
   else detector = 0 ; 
   setDetector( detector );
   if (detector != 0 )
   {
      detector->setDeviceIndices( iFortranIndex, 0, 0 ) ;
   }
   setCommonIndexF( iFortranIndex ) ;
   
}

// BoxDenseMedium::BoxDenseMedium( const BoxDenseMedium& )
// {
// }

BoxDenseMedium::~BoxDenseMedium()
{
}

//
// assignment operators
//
// const BoxDenseMedium& BoxDenseMedium::operator=( const BoxDenseMedium& )
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
// Revision 1.1  2000/06/19 19:59:28  eugenio
// Initial revision
//
// Revision 1.3  1999/03/24 18:50:34  yarba_j
// trate box-shaped volumes with inner gaps properly, using fisrt version of AlignedBoxWithGap
//
// Revision 1.2  1999/02/16  23:53:32  yarba_j
// box-shaped volumes - updates on first version
//
// Revision 1.1  1999/02/15  19:04:16  mkl
// added Box-shaped Calorimeters
//
//



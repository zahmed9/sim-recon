// -*- C++ -*-
//
// Package:     <package>
// Module:      ZMedium
// 
// Description: <one line class summary>
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     Fri Aug 22 15:39:25 CDT 1997
//

// system include files
#include <assert.h>
#include <stdlib.h>

// user include files
#include "ZMedium.hh"
#include "ZCircularSurface.hh"
#include "ZRectangularSurface.hh"
#include "Detector.hh"
#include "AssociatedMaterial.hh"

#include "report.hh"
#include "externFortran.hh"

// STL classes

//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Tracing.ZMedium";

//
// static data member definitions
//

//
// constructors and destructor
//
ZMedium::ZMedium( int iFortranIndex )
{
   if( 0 >= iFortranIndex )
   {
      report( EMERGENCY, kFacilityString ) 
	 << "-E-ZMedium::iFortranIndex == 0!" << endl;
      assert( false );
      ::exit(-1);
   }

   // fill info from common blocks
   integer orderedIndex;
   char name[Medium::kFortranNameLength];
   integer itype, shape;
   real radl, dedx, coll, absp;
   real z, rmin, rmax; 
   real xmin, xmax, ymin, ymax;
   integer deviceIndexF, layerIndexF, wedgeIndexF;

   get_zplane_info_( iFortranIndex,
		     orderedIndex,
		     name,
		     itype, shape,
		     radl, dedx, coll, absp,
		     z, rmin, rmax, 
		     xmin, xmax, ymin, ymax,
		     deviceIndexF, layerIndexF, wedgeIndexF, 
		     Medium::kFortranNameLength );

   Medium::Type type = Medium::Type( itype + Medium::kLastRPlane );

      // can I trust the rplane zmin and zmax info?
#ifdef MKLDEBUG
   static MCFBool first=true;
   if( first == true ) {
      first = false;
      report( DEBUG, kFacilityString ) 
	 << "using zplane info for rmin and rmax (reliable?)" << endl;
   }
#endif

   // set name
   setName( type, name );

   // save common block index (ugly fix for some fortran routines needing it)
   setCommonIndexF( orderedIndex );

   // surface
   Surface *surface;
   if( shape==1 ) {
      surface = new ZCircularSurface( z, rmin, rmax );
   } else if( shape==2 || shape > 100 ) {
      surface = new ZRectangularSurface( z, xmin, xmax, ymin, ymax );
   } else {
      report( ERROR, kFacilityString ) 
	 << "Surface type=" << shape << " not implemented; exiting..." 
	 << endl;
      ::exit( 1 );
   }
      
   setSurface( surface );

      // detector
   Detector *detector = Detector::createDetector( type );
   if( 0 != detector ) {
      (*detector).setDeviceIndices( deviceIndexF, 
				    layerIndexF, 
				    wedgeIndexF );
   }
   setDetector( detector );
 
      // material
   Material *material 
      = AssociatedMaterial::createMaterial( radl, dedx, coll, absp );
   setMaterial( material );

}

// ZMedium::ZMedium( const ZMedium& )
// {
// }

ZMedium::~ZMedium()
{
}

//
// assignment operators
//
// const ZMedium& ZMedium::operator=( const ZMedium& )
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
// Revision 1.1  2000/06/19 19:59:34  eugenio
// Initial revision
//
// Revision 1.7  1999/03/25 23:52:14  yarba_j
// put in constructor temporary fix for handling inner gap in scattering layers of forward tracking chambers
//
// Revision 1.6  1999/02/15  19:03:33  mkl
// added Box-shaped Calorimeters
//
// Revision 1.5  1998/11/20  23:48:09  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.4  1998/02/16  04:33:43  mkl
// first version of 2ndary interactions
//
// Revision 1.3  1997/11/22  20:26:36  mkl
// keep track of fortran name of planes
//
// Revision 1.2  1997/11/11  06:44:01  mkl
// beautification of debug print-out
//
// Revision 1.1  1997/08/23  01:10:17  mkl
// toward volume-based tracing
//



// -*- C++ -*-
//
// Package:     <package>
// Module:      RMedium
// 
// Description: <one line class summary>
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     Fri Aug 22 15:39:19 CDT 1997
//

// system include files
#include <assert.h>
#include <stdlib.h>

// user include files
#include "RMedium.hh"
#include "RSurface.hh"
#include "Detector.hh"
#include "AssociatedMaterial.hh"

#include "report.hh"
#include "externFortran.hh"

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
RMedium::RMedium( int iFortranIndex )
{
   if( 0 >= iFortranIndex )
   {
      report( EMERGENCY ) << "-E-RMedium::iFortranIndex == 0!\n";
      assert( false );
      ::exit(-1);
   }

   // fill info from common blocks
   integer orderedIndex;
   integer itype;
   char name[Medium::kFortranNameLength];
   real radl, dedx, coll, absp;
   real radius, zmin, zmax;
   integer deviceIndexF,layerIndexF, wedgeIndexF;
   
   get_rplane_info_( iFortranIndex, 
		     orderedIndex,
		     name,
		     itype, 
		     radl, dedx, coll, absp,
		     radius, zmin, zmax,
		     deviceIndexF, layerIndexF, wedgeIndexF,
		     Medium::kFortranNameLength );
   
   Medium::Type type = Medium::Type( itype + Medium::kLastBase );
   
   // can I trust the rplane zmin and zmax info?
   //float zmin, zmax;
   //volume_parms_( deviceIndexF, zmin, zmax );
#ifdef MKLDEBUG
   static MCFBool first=true;
   if( first == true ) {
      first = false;
      report( DEBUG ) << "using rplane info for zmin and zmax (reliable?)\n";
   }
#endif
   
   // set name
   setName( type, name );
   
   // save common block index (ugly fix for some fortran routines needing it)
   setCommonIndexF( orderedIndex );
   
   // surface
   Surface *surface = new RSurface( radius, zmin, zmax );
   setSurface( surface );
   
   // detector
   Detector *detector = Detector::createDetector( type );
   if( 0 != detector ) {
      (*detector).setDeviceIndices( deviceIndexF, layerIndexF, wedgeIndexF );
   }
   setDetector( detector );
   
   // material
   Material *material 
      = AssociatedMaterial::createMaterial( radl, dedx, coll, absp );
   setMaterial( material );
   
}

// RMedium::RMedium( const RMedium& )
// {
// }

RMedium::~RMedium()
{
}

//
// assignment operators
//
// const RMedium& RMedium::operator=( const RMedium& )
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
// Revision 1.1  2000/06/19 19:59:33  eugenio
// Initial revision
//
// Revision 1.4  1998/11/20 23:47:58  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.3  1998/02/16  04:33:43  mkl
// first version of 2ndary interactions
//
// Revision 1.2  1997/11/22  20:26:33  mkl
// keep track of fortran name of planes
//
// Revision 1.1  1997/08/23  01:10:14  mkl
// toward volume-based tracing
//



// -*- C++ -*-
//
// Package:     Tracing
// Module:      ProxyVisitor
// 
// Description: <one line class summary>
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     Mon Aug 25 12:12:32 CDT 1997
//

// system include files

// user include files
#include "ProxyVisitor.hh"
#include "ProxyMedium.hh"
#include "Tube.hh"
#include "AlignedBox.hh"

#include "RSurface.hh"
#include "ZCircularSurface.hh"
#include "ZRectangularSurface.hh"
#include "XSurface.hh"
#include "YSurface.hh"

//#include "STL_FunctionObjects.hh"

#include "report.hh"

// STL classes
#include <vector>
#include <algorithm>

//
// constants, enums and typedefs
//
typedef vector<Medium*> MediumList;             

//
// static data member definitions
//

//
// constructors and destructor
//
ProxyVisitor::ProxyVisitor( Medium& iMedium,
			    MediumList& iRMedia,
			    MediumList& iZMedia,
			    MediumList& iXMedia,
			    MediumList& iYMedia )
   : VolumeVisitor( iMedium, 
		    iRMedia, 
		    iZMedia, 
		    iXMedia, 
		    iYMedia ) 
{
}

// ProxyVisitor::ProxyVisitor( const ProxyVisitor& )
// {
// }

ProxyVisitor::~ProxyVisitor()
{
}

//
// assignment operators
//
// const ProxyVisitor& ProxyVisitor::operator=( const ProxyVisitor& )
// {
// }

//
// member functions
//
void
ProxyVisitor::visitTube( Tube& tube )
{
   // -----------------------------------------------------------
   // now have to store "walls" in ProxyMedia in the r-, z-loops
   // -----------------------------------------------------------
   ProxyMedium* proxy = 0;

   // inner cylinder (be careful, not always present!)
   const RSurface& innerCylinder = tube.innerCylinder();
   if( 0 != &innerCylinder ) // only if there is an inner cylinder!
   {
      proxy = new ProxyMedium( medium(), innerCylinder );
      rMedia().push_back( proxy );
   }

   // outer cylinder
   const RSurface& outerCylinder = tube.outerCylinder();
   proxy = new ProxyMedium( medium(), outerCylinder );
   rMedia().push_back( proxy );

   // zmin plane
   const ZCircularSurface& zminRing = tube.zminRing();
   proxy = new ProxyMedium( medium(), zminRing );
   zMedia().push_back( proxy );

      // zmax plane
   const ZCircularSurface& zmaxRing = tube.zmaxRing();
   proxy = new ProxyMedium( medium(), zmaxRing );
   zMedia().push_back( proxy );

}

void
ProxyVisitor::visitAlignedBox( AlignedBox& box )
{
   // ------------------------------------------------------------------
   // now have to store "walls" in ProxyMedia in the z-, x-, and y-loops
   // ------------------------------------------------------------------

   // **** this is absolutely horrible code *****
   // **** have to clean up soon!!!!        *****

   ProxyMedium* proxy = 0;
   const RectPlane* wall = 0;

   // xmin
   wall = box.wall( AlignedBox::kXMinWall );
   if( 0 != wall ) {
      XSurface surface( *wall );
      proxy = new ProxyMedium( medium(), surface );
      xMedia().push_back( proxy );
   }

   // xmax
   wall = box.wall( AlignedBox::kXMaxWall );
   if( 0 != wall ) {
      XSurface surface( *wall );
      proxy = new ProxyMedium( medium(), surface );
      xMedia().push_back( proxy );
   }

   // ymin
   wall = box.wall( AlignedBox::kYMinWall );
   if( 0 != wall ) {
      YSurface surface( *wall );
      proxy = new ProxyMedium( medium(), surface );
      yMedia().push_back( proxy );
   }

   // ymax
   wall = box.wall( AlignedBox::kYMaxWall );
   if( 0 != wall ) {
      YSurface surface( *wall );
      proxy = new ProxyMedium( medium(), surface );
      yMedia().push_back( proxy );
   }

   // zmin
   wall = box.wall( AlignedBox::kZMinWall );
   if( 0 != wall ) {
      ZRectangularSurface surface( *wall );
      proxy = new ProxyMedium( medium(), surface );
      zMedia().push_back( proxy );
   }

   // zmax
   wall = box.wall( AlignedBox::kZMaxWall );
   if( 0 != wall ) {
      ZRectangularSurface surface( *wall );
      proxy = new ProxyMedium( medium(), surface );
      zMedia().push_back( proxy );
   }

}

//
// const member functions
//

//
// static member functions
//


#if 0 /* old version, but keep around just in case */
void
ProxyVisitor::visitTube( Tube& tube )
{
   // -----------------------------------------------------------
   // now have to store "walls" in ProxyMedia in the r-, z-loops
   // -----------------------------------------------------------
   ProxyMedium* proxy = 0;
   MediumList::iterator firstGreater;

   // inner cylinder
   const RSurface& innerCylinder = tube.innerCylinder();
   if( 0 < innerCylinder.radius() ) // only if not cylinder w/ r=0
   {
      proxy = new ProxyMedium( medium(), innerCylinder );
      firstGreater = find_if( rMedia().begin(), 
			      rMedia().end(), 
			      GreaterInRadius( innerCylinder ) );
      rMedia().insert( firstGreater, proxy );
   }

   // outer cylinder
   const RSurface& outerCylinder = tube.outerCylinder();
   proxy = new ProxyMedium( medium(), outerCylinder );
   firstGreater = find_if( rMedia().begin(), 
			   rMedia().end(), 
			   GreaterInRadius( outerCylinder ) );
   rMedia().insert( firstGreater, proxy );
   
   // zmin plane
   const ZCircularSurface& zminRing = tube.zminRing();
   proxy = new ProxyMedium( medium(), zminRing );
   firstGreater = find_if( zMedia().begin(), 
			   zMedia().end(), 
			   GreaterInZ( zminRing ) );
   zMedia().insert( firstGreater, proxy );

   // zmax plane
   const ZCircularSurface& zmaxRing = tube.zmaxRing();
   proxy = new ProxyMedium( medium(), zmaxRing );
   firstGreater = find_if( zMedia().begin(), 
			   zMedia().end(), 
			   GreaterInZ( zmaxRing ) );
   zMedia().insert( firstGreater, proxy );

}
#endif

// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:33  eugenio
// Initial revision
//
// Revision 1.3  1997/11/11 01:17:37  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.2  1997/08/27  03:31:41  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.1  1997/08/25  19:23:03  mkl
// new Visitor classes to keep from cluttering volume class
//





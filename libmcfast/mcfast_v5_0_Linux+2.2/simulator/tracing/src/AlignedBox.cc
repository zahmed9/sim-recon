// -*- C++ -*-
//
// Package:     Tracing
// Module:      AlignedBox
// 
// Description: <one line class summary>
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     Wed June 25 15:21:36 EDT 1997

// system include files
#include <assert.h>
#include <vector>
#include <float.h>

// user include files
#include "AlignedBox.hh"
#include "Point.hh"
#include "RectPlane.hh"
#include "Direction.hh"
#include "VolumeVisitor.hh"
#include "functions.hh"
#include "report.hh"
#include "changeWTrack.hh"

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
AlignedBox::AlignedBox( const DFLOAT xmin, const DFLOAT xmax, 
	  const DFLOAT ymin, const DFLOAT ymax, 
	  const DFLOAT zmin, const DFLOAT zmax )
   : m_xmin( xmin ), m_xmax( xmax ),
     m_ymin( ymin ), m_ymax( ymax ),
     m_zmin( zmin ), m_zmax( zmax )
{
   for( int i = 0; i<int(kNumberOfWalls); ++i ) {
      m_walls[i] = 0;
   }
   constructPlanes();
}

AlignedBox::AlignedBox( const AlignedBox& alignedBox )
{
   *this = alignedBox;
}

AlignedBox::~AlignedBox()
{
   // don't delete "RectPlane* m_walls[] here; will get deleted in ~Volume
}

//
// assignment operators
//
const AlignedBox& AlignedBox::operator=( const AlignedBox& alignedBox ) 
{
   if( this != &alignedBox ) 
   {
      m_xmin = alignedBox.m_xmin; 
      m_xmax = alignedBox.m_xmax;
      m_ymin = alignedBox.m_ymin; 
      m_ymax = alignedBox.m_ymax;
      m_zmin = alignedBox.m_zmin; 
      m_zmax = alignedBox.m_zmax;

      // get new pointers from Volume!
      for( int i = 0; i<kNumberOfWalls; ++i ) {
	 m_walls[i] = (RectPlane*)(alignedBox.surfaces())[i];
      }

      Volume::operator=( alignedBox );
   }

   return *this;
}


//
// member functions
//
void
AlignedBox::accept( VolumeVisitor& visitor )
{
   visitor.visitAlignedBox( *this );
}

void
AlignedBox::constructPlanes( void )
{
   static Direction x_hat_plus (  1,  0,  0 );
   static Direction x_hat_minus( -1,  0,  0 );
   static Direction y_hat_plus (  0,  1,  0 );
   static Direction y_hat_minus(  0, -1,  0 );
   static Direction z_hat_plus (  0,  0,  1 );
   static Direction z_hat_minus(  0,  0, -1 );

   Point xmin_point( m_xmin, 0, 0 );
   Point xmax_point( m_xmax, 0, 0 );
   Point ymin_point( 0, m_ymin, 0 );
   Point ymax_point( 0, m_ymax, 0 );
   Point zmin_point( 0, 0, m_zmin );
   Point zmax_point( 0, 0, m_zmax );

   // now construct planes

   // x
   if( abs( m_xmin ) != FLT_MAX ) {
      m_walls[kXMinWall] 
	 = new RectPlane( xmin_point, x_hat_minus, 
			  m_xmin, m_xmin, m_ymin, m_ymax, m_zmin, m_zmax );
      insert( m_walls[kXMinWall] );
   }

   if( abs( m_xmax ) != FLT_MAX ) {
      m_walls[kXMaxWall]
	 = new RectPlane( xmax_point, x_hat_plus,
			  m_xmax, m_xmax, m_ymin, m_ymax, m_zmin, m_zmax );
      insert( m_walls[kXMaxWall] );
   }

   // y
   if( abs( m_ymin ) != FLT_MAX ) {
      m_walls[kYMinWall]
	 = new RectPlane( ymin_point, y_hat_minus,
			  m_xmin, m_xmax, m_ymin, m_ymin, m_zmin, m_zmax );
      insert( m_walls[kYMinWall] );
   }

   if( abs( m_ymax ) != FLT_MAX ) {
      m_walls[kYMaxWall]
	 = new RectPlane( ymax_point, y_hat_plus,
			  m_xmin, m_xmax, m_ymax, m_ymax, m_zmin, m_zmax );
      insert( m_walls[kYMaxWall] );
   }

   // z
   if( abs( m_zmin ) != FLT_MAX ) {
      m_walls[kZMinWall]
	 = new RectPlane( zmin_point, z_hat_minus,
			  m_xmin, m_xmax, m_ymin, m_ymax, m_zmin, m_zmin );
      insert( m_walls[kZMinWall] ); 
   }

   if( abs( m_zmax ) != FLT_MAX ) {
      m_walls[kZMaxWall]
	 = new RectPlane( zmax_point, z_hat_plus,
			  m_xmin, m_xmax, m_ymin, m_ymax, m_zmax, m_zmax );
      insert( m_walls[kZMaxWall] ); 
   }

}

//
// const member functions
//
// clone operation
AlignedBox*
AlignedBox::clone() const 
{
   return new AlignedBox(*this);
}

// is the point inside
MCFBool 
AlignedBox::contains( const WTrackStruct& wtrack ) const
{
   MCFBool returnValue = false;

   // check that particle coordinates are 
   // within xmin, xmax, ymin, ymax, zmin, zmax
   if(    wtrack.x <= m_xmax && wtrack.x >= m_xmin 
       && wtrack.y <= m_ymax && wtrack.y >= m_ymin 
       && wtrack.z <= m_zmax && wtrack.z >= m_zmin 
      )
   {
      returnValue = true;
   }

   return returnValue;
}
      
void
AlignedBox::printOn( ostream& os ) const
{
   os << "Printing AlignedBox surfaces:\n";

   Volume::printOn( os );

   os << "\n";
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
// Revision 1.8  1998/11/20 23:47:42  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.7  1998/02/15  20:56:10  mkl
// implemented 'contains' method
//
// Revision 1.6  1998/02/15  01:55:35  mkl
// for DenseMedia, need base reactTo figure out if entering or leaving volume, and call implementReactTo if entering
//
// Revision 1.5  1998/01/08  22:20:40  mkl
// added small distance along direction of flight to figure out if entering or exiting volume
//
// Revision 1.4  1997/11/11  01:17:29  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.3  1997/08/27  03:31:35  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.2  1997/08/23  01:10:09  mkl
// toward volume-based tracing
//
// Revision 1.1  1997/08/03  04:19:42  mkl
// moved Box to AlignedBox
//
//               

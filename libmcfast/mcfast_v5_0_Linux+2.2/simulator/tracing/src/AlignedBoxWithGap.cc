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
#include "AlignedBoxWithGap.hh"
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

AlignedBoxWithGap::AlignedBoxWithGap( const DFLOAT xmin, const DFLOAT xmax, 
	                              const DFLOAT ymin, const DFLOAT ymax, 
	                              const DFLOAT zmin, const DFLOAT zmax,
	                              const DFLOAT gapXMin,
				      const DFLOAT gapXMax,
				      const DFLOAT gapYMin,
				      const DFLOAT gapYMax )
    : AlignedBox( xmin, xmax, ymin, ymax, zmin, zmax )
{
   m_gap[0] = gapXMin ;
   m_gap[1] = gapXMax ;
   m_gap[2] = gapYMin ;
   m_gap[3] = gapYMax ;
   
}

AlignedBoxWithGap::AlignedBoxWithGap( const AlignedBoxWithGap& alignedBox )
   : AlignedBox( ((RectPlane*)alignedBox.wall(kXMinWall))->xmin(), 
                 ((RectPlane*)alignedBox.wall(kXMinWall))->xmax(),
                 ((RectPlane*)alignedBox.wall(kXMinWall))->ymin(),
                 ((RectPlane*)alignedBox.wall(kXMinWall))->ymax(),
                 ((RectPlane*)alignedBox.wall(kXMinWall))->zmin(),
                 ((RectPlane*)alignedBox.wall(kXMinWall))->zmax() )
{
   *this = alignedBox;
}

AlignedBoxWithGap::~AlignedBoxWithGap()
{
   // don't delete "RectPlane* m_walls[] here; will get deleted in ~Volume
}

//
// assignment operators
//
const AlignedBoxWithGap& 
AlignedBoxWithGap::operator=( const AlignedBoxWithGap& alignedBox ) 
{
   if( this != &alignedBox ) 
   {

      AlignedBox::operator=( alignedBox ) ;

      for ( int i=0; i<4; ++i ) {
         m_gap[i] = alignedBox.m_gap[i] ;
      }
   }

   return *this;
}


//
// member functions
//

//
// const member functions
//

// is the point inside
MCFBool 
AlignedBoxWithGap::contains( const WTrackStruct& wtrack ) const
{
   MCFBool returnValue = false;
   
   // first check if wtrack falls into gap
   if(    wtrack.x < m_gap[1] && wtrack.x > m_gap[0]
       && wtrack.y < m_gap[3] && wtrack.y > m_gap[2] 
     )
   {
      return returnValue ;
   }

   // check that particle coordinates are 
   // within xmin, xmax, ymin, ymax, zmin, zmax
   returnValue = AlignedBox::contains( wtrack ) ;

   return returnValue;
}
      
void
AlignedBoxWithGap::printOn( ostream& os ) const
{
   os << "Printing AlignedBoxWithGap surfaces:\n";

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
// Revision 1.1  1999/03/24 18:46:02  yarba_j
// first version of box-shaped volume with inner gap
//
//

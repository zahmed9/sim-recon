#if !defined(TRACING_ALIGNEDBOXWITHGAP_H)
#define TRACING_ALIGNEDBOXWITHGAP_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      AlignedBoxWithGap
//
// Description: AlignedBox Volume
//
//              The AlignedBoxWithGap derives from Aligned Box and 
//              so far differs by inner gap represented by m_gap[4] 
//              data member. It has up to 6 plane outer surfaces; 
//              it is allowed to have open sides!
//            
//              The assumptions are:
//              1.) the box is ALIGNED along x, y, z axes!
//              2.) defined by 6 (or less) planes; since planes are defined
//                  by a point and a normal, the edges of the box are
//                  defined by two planes each meeting along a line (the edge!).
//
//              The inner gap is taken into account in the contains() method.
//
// Usage:
//
// Author:      Julia Yarba
// Created:     March 1999
//
// system include files

// user include files
#include "AlignedBox.hh"

// forward declarations
class MCParticle;
class WTrackStruct;
class VolumeVisitor;


class AlignedBoxWithGap : public AlignedBox
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      AlignedBoxWithGap( const DFLOAT xmin, const DFLOAT xmax, 
		         const DFLOAT ymin, const DFLOAT ymax, 
		         const DFLOAT zmin, const DFLOAT zmax,
			 const DFLOAT gapXMin,
			 const DFLOAT gapXMax,
			 const DFLOAT gapYMin,
			 const DFLOAT gapYMax );
      AlignedBoxWithGap( const AlignedBoxWithGap& );
      virtual ~AlignedBoxWithGap();

      // assignment operator(s)
      const AlignedBoxWithGap& operator=( const AlignedBoxWithGap& );

      // member functions

      // const member functions

      // clone operation

      // is the point inside
      virtual MCFBool contains( const WTrackStruct& iWTrack ) const;
      
      virtual void printOn( ostream& os = cout ) const;
      virtual const char* nameOf() const { return "AlignedBoxWithGap"; }

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor

      // private member functions

      // private const member functions

      // data members
      DFLOAT m_gap[4] ;

      // static data members

};

// inline function definitions

inline 
ostream& 
operator<<( ostream& os, const AlignedBoxWithGap& v )
{
   v.printOn(os); 
   return os; 
}

inline 
ostream& 
operator<<( ostream& os, const AlignedBoxWithGap* v )
{
   v->printOn(os); 
   return os;
}

//inline
//RectPlane*
//AlignedBoxWithGap::wall( WhichWall which )
//{ 
//   return m_walls[ which ]; 
//}

//inline
//const RectPlane* 
//AlignedBoxWithGap::wall( WhichWall which ) const
//{ 
//   return m_walls[ which ]; 
//}


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

#endif /* TRACING_ALIGNEDBOXWITHGAP_H */

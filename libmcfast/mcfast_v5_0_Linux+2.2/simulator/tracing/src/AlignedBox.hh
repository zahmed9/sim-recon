#if !defined(TRACING_ALIGNEDBOX_H)
#define TRACING_ALIGNEDBOX_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      AlignedBox
//
// Description: AlignedBox Volume
//
//              The AlignedBox has up to 6 plane surfaces; 
//              it is allowed to have open sides!
//            
//              The assumptions are:
//              1.) the box is ALIGNED along x, y, z axes!
//              2.) defined by 6 (or less) planes; since planes are defined
//                  by a point and a normal, the edges of the box are
//                  defined by two planes each meeting along a line (the edge!).
//
// Usage:
//
// Author:      Martin Lohner
// Created:     June 25, 1997
//
// system include files

// user include files
#include "Volume.hh"
#include "Plane.hh"
#include "RectPlane.hh"

// forward declarations
class MCParticle;
class WTrackStruct;
class VolumeVisitor;


class AlignedBox : public Volume
{
      // friend classses and functions

   public:
      // constants, enums and typedefs
      enum WhichWall { kXMinWall=0, kXMaxWall, 
		       kYMinWall, kYMaxWall, 
		       kZMinWall, kZMaxWall,
		       kNumberOfWalls };

      // Constructors and destructor
      AlignedBox( const DFLOAT xmin, const DFLOAT xmax, 
		  const DFLOAT ymin, const DFLOAT ymax, 
		  const DFLOAT zmin, const DFLOAT zmax );
      AlignedBox( const AlignedBox& );
      virtual ~AlignedBox();

      // assignment operator(s)
      const AlignedBox& operator=( const AlignedBox& );

      // member functions
      RectPlane* wall( WhichWall which );

      void accept( VolumeVisitor& visitor );

      // const member functions
      const RectPlane* wall( WhichWall which ) const;

      // clone operation
      virtual AlignedBox* clone() const;

      // is the point inside
      virtual MCFBool contains( const WTrackStruct& iWTrack ) const;
      
      virtual void printOn( ostream& os = cout ) const;
      virtual const char* nameOf() const { return "AlignedBox"; }

      // static member functions

   protected:
      // protected member functions
      void constructPlanes( void ); // make surfaces from dimensions given

      // protected const member functions

   private:
      // Constructors and destructor

      // private member functions

      // private const member functions

      // data members
      DFLOAT m_xmin, m_xmax;
      DFLOAT m_ymin, m_ymax;
      DFLOAT m_zmin, m_zmax;
      RectPlane* m_walls[kNumberOfWalls];

      // static data members

};

// inline function definitions

inline 
ostream& 
operator<<( ostream& os, const AlignedBox& v )
{
   v.printOn(os); 
   return os; 
}

inline 
ostream& 
operator<<( ostream& os, const AlignedBox* v )
{
   v->printOn(os); 
   return os;
}

inline
RectPlane*
AlignedBox::wall( WhichWall which )
{ 
   return m_walls[ which ]; 
}

inline
const RectPlane* 
AlignedBox::wall( WhichWall which ) const
{ 
   return m_walls[ which ]; 
}


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:31  eugenio
// Initial revision
//
// Revision 1.4  1998/11/20 23:47:42  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.3  1997/11/11  01:17:30  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.2  1997/08/27  03:31:36  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.1  1997/08/03  04:19:42  mkl
// moved Box to AlignedBox
//
//


#endif /* TRACING_ALIGNEDBOX_H */

#if !defined(COMPOSITEMEDIUM_H)
#define COMPOSITEMEDIUM_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      CompositeMedium
// 
// Description:
//
//   Container for:
//
//   1.) Ordered Media in coordinate R.
//   2.)  "       "    "    "        Z.
//   3.) Aligned Boxes (walls along x, y, z axes).
//   4.) maybe eventually Cones.
//
//   Implements operations addMedium, removeMedium and iteration over mediums.
//   Finds next closest Medium to a given wtrack parameter.
//
//   The actual tracing algorithm is implemented as a strategy pattern
//   (to be found in "Design Patterns", Gamma et al.), which means 
//   the smarts of tracing are implemented as a separate object.
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     Jan 23, 1997
// RCS(Id)
//
// Revision history
//
// RCS(Log)

// system include files
#include <vector>

// user include files
#include "Medium.hh"

// forward declarations
class Tracer;
class MCParticle;
class ostream;


class CompositeMedium : public Medium
{
      // friend classses and functions
      friend class Tracer;  // tracing algorithm

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      CompositeMedium();
      virtual ~CompositeMedium();
      
      // member functions
      
      // const member functions

      void reset() const;

      //   Methods for tracking
      const Medium* nextMediumTo( const MCParticle& particle ) const;

      // check if we're still inside
      // MCFBool contains( const WTrackStruct& iWTrack ) const;
 
      // Printing and I/O
      const char* nameOf() const{ return "CompositeMedium"; }  
      void printOn( ostream& os = cout ) const;

      void printResponse(ostream& = cout) const;
      
      // asscess method for list of volumes
      const vector<Medium*>& listOfVolumes() const { return m_volumeMediaOwner ; }
      const vector<Medium*>& listOfTubes() const { return m_volumeMediaOwner ; }
      const vector<Medium*>& listOfBoxes() const { return m_alignedBoxMediaOwner ; }

      // static member functions
 

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor
      CompositeMedium( const CompositeMedium& );

      // assignment operator(s)
      const CompositeMedium& operator=( const CompositeMedium& );

      // private member functions
      // fill functions for constructing media
      void fillRPlanes     ( void );
      void fillZPlanes     ( void );
      void fillTubes       ( void );
      void fillAlignedBoxes( void );
      void fillEnvelope    ( void );
      void createNeighbourhood( void ) ;

      // private const member functions
      
      // data members

      // media containers
      // ----------------
      // There are two kinds of containers: 
      // i.) containers which own their contents   --> tracing containers
      // ii.) containers whose contents only point --> object containers
      //      to items in containers in i.)
      // Both are necessary, because e.g. walls in a box have to appear
      // in tracing containers, but are owned by the box object in the 
      // object container

      // 1.) tracing containers -- don't own media!!!!
      vector<Medium*> m_rMedia;          // not owner
      vector<Medium*> m_zMedia;          // not owner
      vector<Medium*> m_xMedia;          // not owner
      vector<Medium*> m_yMedia;          // not owner

      // 2.) object containers  -- own objects!!!
      vector<Medium*> m_rMediaOwner;          // owner
      vector<Medium*> m_zMediaOwner;          // owner
      vector<Medium*> m_xMediaOwner;          // owner
      vector<Medium*> m_yMediaOwner;          // owner
      vector<Medium*> m_volumeMediaOwner;     // owner
      vector<Medium*> m_alignedBoxMediaOwner; // owner
      //vector<Medium*> m_coneMedia;

      // tracing algorithm
      Tracer* m_tracer;

      // static data members

};

// inline function definitions

inline
ostream&
operator<<( ostream& os, const CompositeMedium& compM )
{
   compM.printOn(os);
   return os;
}

inline
ostream&
operator<<( ostream& os, const CompositeMedium* compM )
{
   compM->printOn(os);
   return os;
}                                                  




// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:31  eugenio
// Initial revision
//
// Revision 1.16  1999/02/17 18:14:42  yarba_j
// added listOfTubes() and listOfBoxes() access methods
//
// Revision 1.15  1998/11/24  23:46:52  yarba_j
// implemented public access method listOfVolumes()
//
// Revision 1.14  1998/11/20  23:47:45  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.13  1998/11/03  17:43:31  mkl
// changes to compile under egcs
//
// Revision 1.12  1998/05/18  16:42:11  yarba_j
// updated to account for showers spread over multiple volumes
//
// Revision 1.11  1997/11/11  01:17:31  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.10  1997/08/27  03:31:36  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.9  1997/08/25  19:23:03  mkl
// new Visitor classes to keep from cluttering volume class
//
// Revision 1.8  1997/08/23  01:10:10  mkl
// toward volume-based tracing
//
// Revision 1.7  1997/08/01  20:56:28  mkl
// forward declare stl containers
//
// Revision 1.6  1997/08/01  19:21:56  mkl
// switched from vector<Medium> to vector<Medium*> for dynamic Medium behavior
//
// Revision 1.5  1997/07/03  03:33:43  mkl
// new approach: surfaces vs volumes; box tracing
//
// Revision 1.4  1997/05/11  04:54:30  mkl
// efficiency studies
//
// Revision 1.3  1997/05/10  21:17:12  mkl
// speed improvements by using info on r for z tracing and vice versa.
//
// Revision 1.2  1997/05/09  06:36:55  mkl
// added get_detector_dimensions to make large enveloping volume for tracing.
// fixed curler tracing in forward direction.
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//


#endif /* COMPOSITEMEDIUM_H */


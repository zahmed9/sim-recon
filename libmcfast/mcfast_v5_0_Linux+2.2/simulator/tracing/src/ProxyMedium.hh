#if !defined(TRACING_PROXYMEDIUM_H)
#define TRACING_PROXYMEDIUM_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      ProxyMedium
// 
// Description: 
//         Acts as a stand-in for a DenseMedium with one of its 
//         surfaces exposed. Is used to allow walls of DenseMedia 
//         to be used in tracing loops.
//         Therefore a DenseMedium with a real Volume appears multiple 
//         times in the tracing loops with each of its walls.
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     Sat Aug  2 14:48:41 CDT 1997
//

// system include files

// user include files
#include "Medium.hh"

// forward declarations
class DenseMedium;

class ProxyMedium : public Medium
{
      // friend classes and functions
      // (needed to have wide interface for operator==)
      friend class Medium;
      friend class DenseMedium;

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      ProxyMedium( Medium& realMedium, const Surface& surface );
      virtual ~ProxyMedium();

      // equality operator
      virtual bool operator==( const Medium&      medium ) const;
      virtual bool operator==( const DenseMedium& medium ) const;
      virtual bool operator==( const ProxyMedium& medium ) const;
      
      // member functions
      // collect neighbouring media -
      // makes sense ONLY for DenseMedium and will be overwritten by it
      virtual void collectRNeighbours
                   ( vector<Medium*>&, vector<Medium*>::iterator& ) ;
      virtual void collectZNeighbours
                   ( vector<Medium*>&, vector<Medium*>::iterator& ) ;

      // add neighbouring medium to the list of neigbours -
      // makes sense ONLY for DenseMedium and will be overwritten by it
      virtual void addNeighbour( Medium* medium ) ;

      // const member functions
      virtual ClassType classType() const { return m_realMedium.classType(); }

      // ------------------------------------------------------
      // handler functions; just fowarding to the real objects 
      //  (surface, material, detector)

      // surface -------------------------------------------------
      // maximum step towards boundary; howMany if more than one
      virtual DFLOAT maxStep( const MCParticle& particle, 
			      int& howMany ) const;

      // distance to Medium
      virtual DFLOAT distanceTo( const MCParticle& particle,
				 DFLOAT iDistanceToBeat,
				 MCFBool& oWithinSides ) const;

      // is the point inside the surface?
      virtual MCFBool contains( const WTrackStruct& iWTrack ) const;
      
      // react with particle (this just calls detector and material methods)
      virtual MCFBool reactTo( MCParticle& particle ) const;

      // accessor method
      Medium* realMedium() const { return &m_realMedium ; }

      // print and display 
      void printOn( ostream& os = cout ) const;
      const char* nameOf() const { return "ProxyMedium"; }

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor
      ProxyMedium( const ProxyMedium& );
      // assignment operator(s)
      const ProxyMedium& operator=( const ProxyMedium& );

      // private member functions

      // private const member functions

      // data members
      Medium& m_realMedium;  // "real medium"

      // static data members

};

// inline function definitions


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:33  eugenio
// Initial revision
//
// Revision 1.11  1999/04/22 01:28:55  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.10  1998/11/20  23:47:57  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.9  1998/05/18  16:42:47  yarba_j
// updated to account for showers spread over multiple volumes
//
// Revision 1.8  1998/05/04  22:08:31  mkl
// equality operator properly working for Medium pointers
//
// Revision 1.7  1998/04/28  18:01:34  mkl
// unconst ProxyMedium association with real medium
//
// Revision 1.6  1998/04/28  16:13:22  mkl
// added equality operator
//
// Revision 1.5  1998/04/27  22:00:13  mkl
// renamed 'Class' 'ClassType'
//
// Revision 1.4  1998/04/27  20:43:26  mkl
// added class type
//
// Revision 1.3  1997/08/27  03:31:40  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.2  1997/08/23  01:10:13  mkl
// toward volume-based tracing
//
// Revision 1.1  1997/08/03  04:19:44  mkl
// moved Box to AlignedBox
//


#endif /* TRACING_PROXYMEDIUM_H */

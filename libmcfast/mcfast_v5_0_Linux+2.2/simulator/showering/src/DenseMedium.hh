#if !defined(SHOWERING_DENSEMEDIUM_H)
#define SHOWERING_DENSEMEDIUM_H
// -*- C++ -*-
//
// Package:     Showering
// Module:      DenseMedium
// 
// Description:
//         DenseMedium is a special type of Medium that has 
//         "internal structure"; basically DenseMedium is used for real 
//         volume-based tracing.
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner, Julia Yarba
// Created:     Sat Aug  2 12:50:08 CDT 1997
//

// system include files

// user include files
#include "externFortran.hh"
#include "Medium.hh"

// forward declarations
class ProxyMedium;

class DenseMedium : public Medium
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      DenseMedium();
      DenseMedium( const DenseMedium& );
      virtual ~DenseMedium();

      // assignment operator(s)
      const DenseMedium& operator=( const DenseMedium& );

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
      virtual ClassType classType() const { return Medium::kDenseMedium; }

      // react with particle (this just calls detector and material methods)
      // the reactTo function is a wrapper for implementReactTo
      // necessary because of we may be entering or leaving volumes
      virtual MCFBool reactTo( MCParticle& particle ) const;

      // accessor method
      vector<DenseMedium*>& listOfNeighbours() const { return m_listOfNeighbours ; }

      // print and display 
      void printOn( ostream& os = cout ) const;
      const char* nameOf() const { return "DenseMedium"; }

      // static member functions

   protected:
      // protected member functions

      // protected const member functions
      virtual MCFBool implementReactTo( MCParticle& particle ) const;
      MCFBool doDecay( MCParticle& particle ) const;
      void    setShowering( MCParticle& particle ) const;
      MCFBool leaveVolume( MCParticle& particle ) const ;
      void    disregardBField( MCParticle& particle ) const ;

   private:
      // Constructors and destructor

      // private member functions

      // private const member functions

      // data members
      vector<DenseMedium*>& m_listOfNeighbours ;

      // static data members

};

// inline function definitions



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:29  eugenio
// Initial revision
//
// Revision 1.16  1999/02/22 23:15:47  yarba_j
// handle hit generation in box-shaped calorimeters
//
// Revision 1.14  1999/02/12  00:03:24  yarba_j
// disregard magnetic field for showers
//
// Revision 1.13  1999/01/15  17:50:52  yarba_j
// hit generation in calorimeters reimplemented in C++; also includes user interface on calorimetry hits for C++ programmers
//
// Revision 1.12  1998/11/24  23:36:50  yarba_j
// listOfNeighbours is now vector<DenseMedium*>
//
// Revision 1.11  1998/11/20  23:46:00  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.10  1998/05/18  16:42:25  yarba_j
// updated to account for showers spread over multiple volumes
//
// Revision 1.9  1998/05/04  22:08:29  mkl
// equality operator properly working for Medium pointers
//
// Revision 1.8  1998/04/28  16:13:21  mkl
// added equality operator
//
// Revision 1.7  1998/04/27  22:00:13  mkl
// renamed 'Class' 'ClassType'
//
// Revision 1.6  1998/04/27  20:43:27  mkl
// added class type
//
// Revision 1.5  1998/02/23  18:02:11  yarba_j
// implemented showering in DenseMedium (incl. trans.prof.)
//
// Revision 1.1  1997/08/02  19:39:20  mkl
// added DenseMedium for real volume-based tracing
//


#endif /* SHOWERING_DENSEMEDIUM_H */

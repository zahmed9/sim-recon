#if !defined(TRACING_GENPARTICLE_H)
#define TRACING_GENPARTICLE_H
// -*- C++ -*-
//
// Package:     <package>
// Module:      GenParticle
// 
// Description: generated Particle
//                 contains basic particle features (mass, spin, charge, etc.);
//                 a 4-vector is not part of it (in principle it could 
//                 derive from CLHEP::LorentzVector), 
//                 because the derived class MCParticle contains "wtrack_struct".
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

// user include files
#include "cc_fortran_types.hh"
#include "Printable.hh"
//#include "CLHEP/LorentzVector.h"

// forward declarations
class ostream;

//class GenParticle : public LorentzVector
class GenParticle : public Printable
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor

      // define default argument for default constructor
      GenParticle( int hepIndexC=0 );
      //GenParticle( const GenParticle& );
      virtual ~GenParticle() {}

      // assignment operator(s)
      //const GenParticle& operator=( const GenParticle& );

      // member functions

      void setCharge( DFLOAT charge );

      // const member functions
 
      integer hepIndexC() const { return m_hepIndexC; }
      integer hepIndexF() const { return m_hepIndexF; }

      integer idHep() const { return m_idHep; }

      DFLOAT mass()   const { return m_mass; }
      DFLOAT  charge() const { return m_charge; }
      DFLOAT  spin()   const { return m_spin; }

      MCFBool isCharged() const;
      MCFBool isStable()  const;   // "stable" here means NOT INTERMEDIARY!
      MCFBool isTraceable() const;

      MCFBool isPhoton() const;
      MCFBool isElectron() const;
      MCFBool isMuon() const;
      MCFBool isHadron() const;

      virtual const char* nameOf() const { return "GenParticle"; }
      virtual void printOn( ostream& ) const;               

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor

      // private member functions

      // private const member functions

      // data members

      //vector<GenParticle*> m_children;   // list of children

      int m_hepIndexC, m_hepIndexF; // first is c-index, second fortran
      int m_idHep;                  // Hep id of particle (cache)

      DFLOAT m_mass;       // mass
      DFLOAT m_spin;        // spin
      DFLOAT m_charge;      // charge

      // static data members

};


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:32  eugenio
// Initial revision
//
// Revision 1.8  1998/11/20 23:47:52  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.7  1998/08/11  17:10:53  mkl
// converted some floats to DFLOATs to be in sync with wtrack
//
// Revision 1.6  1998/02/16  04:33:42  mkl
// first version of 2ndary interactions
//
// Revision 1.5  1997/11/11  01:17:33  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.4  1997/08/01  20:56:29  mkl
// forward declare stl containers
//
// Revision 1.3  1997/04/22  20:01:08  bphyslib
// fixes for decay-in-flights
//
// Revision 1.2  1997/03/15  19:02:20  mkl
// moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
// fixed commend headers for .inc files from # to c.
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//


#endif /* TRACING_GENPARTICLE_H */

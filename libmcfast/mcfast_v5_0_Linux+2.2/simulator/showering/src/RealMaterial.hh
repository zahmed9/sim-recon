#if !defined(SHOWERING_REALMATERIAL_H)
#define SHOWERING_REALMATERIAL_H
// -*- C++ -*-
//
// Package:     Showering
// Module:      RealMaterial
//
// Description: real material for real volume-based tracing
//
// Usage:
//    <usage>
//
// Author:      Julia Yarba
// Created:     May 6, 1997
// RCS(Id)
//
// Revision history
//
// RCS(Log)

// system include files
#include <assert.h>
#include <iostream.h>
#include <string>
#include <map>

// user include files
#include "Material.hh"

// forward declarations


class RealMaterial : public Material
{
      // friend classes and functions
//      friend class MaterialLookupTable ;

   public:
      // constants, enums and typedefs

      // Constructors and Destructor

      // Default Constructor
      // In principal, this Constructor should work for Vacuum only...
      // We need it ONLY because we plan to deal with a 
      // map<string,Material,...>
      RealMaterial(); 

      // Constructor to build Material using its basic characteristics
      //  In principal, the way this constructor is designed for now, 
      //  it allows to create only a "pure" material, not a mixture...
      RealMaterial( const float A, const float Z, 
		    const float density, 
		    const float radL, 
		    const float absL, 
		    const float dedx ); 

      // Constructor to build Material via taking info from FORTRAN DB
      RealMaterial( const int index ) ;

      ~RealMaterial();

      // member functions

      // const member functions
      virtual RealMaterial* clone() const;
      
      MCFBool interactWith( MCParticle& ) const ; 
      DFLOAT  interactWith( MCParticle& , DFLOAT& ) const;

      MCFBool transProfileOfShower( MCParticle& , DFLOAT&, DFLOAT&, DFLOAT& ) const ;

      MCFBool isVacuum() const { return ((m_dedx==0) ? true:false); }

      float   A()          const { return m_A ; }
      float   Z()          const { return m_Z ; }
      float   density()    const { return m_density ; }
      float   radLength()  const { return m_radLength; }
      float   absLength()  const { return m_absLength; }
      float   collLength() const { cout << "not implemented yet" << endl; ::exit; return 0; }
      float   dedx()       const { return m_dedx; }
      float   rMoliere()   const { return m_rMoliere; }
      MCFBool isMixture()  const ; // returns TRUE if there's a list 
                                  // of contributing materials,
                                  // otherwise returns FALSE
      int     numberOfContributions() const ; // returns # of contributing 
                                              // materials if mixture 
      float   portionOfContribution(const char* name ) const ;
                                   // returns portion by volume of a given 
                                   // contributing material (spec. by name) 

      DFLOAT  distanceToConversion( MCParticle& particle ) const ;

      virtual void  printOn( ostream& os = cout ) const;
      virtual const char* nameOf() const { return "RealMaterial"; }

   protected:

      // Constructor and Destructor
      
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor

      // assignment operator(s)

      // private member functions
      DFLOAT findConversionPoint( MCParticle& ) const ;
      DFLOAT doElossAndMscat    ( MCParticle& , DFLOAT& ) const ;
      DFLOAT doEMShowering      ( MCParticle& , DFLOAT& ) const ;
      DFLOAT doHADShowering     ( MCParticle& , DFLOAT& ) const ;

      // private const member functions

      // data members

      float  m_A ;                   
      float  m_Z ;
      float  m_density ;
      float  m_radLength;         // radiation length
      float  m_absLength;         // absorbtion (interaction) length
      float  m_dedx;              // constants used by dedx
      float  m_rMoliere;          // Moliere radius
// Contributions, name vs proportion by volume, if mixture or compound 
      map< string, float, less<string > > m_contribution ; 

      // static data members

};

// inline function definitions
// inline function definitions

inline
ostream&
operator<<( ostream& os, const RealMaterial& m )
{
   m.printOn(os);
   return os;
}

inline
ostream&
operator<<( ostream& os, const RealMaterial* m )
{
   m->printOn(os);
   return os;
}

// ==================================================================

#endif /* SHOWERING_REALMATERIAL_H */


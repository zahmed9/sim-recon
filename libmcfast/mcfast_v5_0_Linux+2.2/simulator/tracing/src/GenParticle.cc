// -*- C++ -*-
//
// Package:     Tracing
// Module:      GenParticle
// 
// Description: generated Particle 
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     Jan 23, 1997
// RCS(Id)
//
// Revision history
//
// RCS(Log)

// system include files
#include <iostream.h>

// user include files
#include "stdhep.h"

#include "GenParticle.hh"
#include "functions.hh"

//
// constants, enums and typedefs
//

//
// static data member definitions
//

//
// constructors and destructor
//
//GenParticle::GenParticle()
//{
//}

GenParticle::GenParticle( int iHepIndexC )
{
   m_hepIndexC = iHepIndexC;
   m_hepIndexF = iHepIndexC+1;

   m_idHep = hepevt_.idhep[ hepIndexC() ];

   m_mass = hepevt_.phep[ hepIndexC() ][ 4 ];

   m_spin = 0;       // don't know how to access
   m_charge = 0;     // ugly: will be later set by derived class
}

// 
// copy constructor
//
//GenParticle::GenParticle( const GenParticle& iParticle )

//
// destructor
//
//GenParticle::~GenParticle()
//

//
// assignment operators
//
//const GenParticle& 
//GenParticle::operator=( const GenParticle& iParticle )

//
// member functions
//
void
GenParticle::setCharge( DFLOAT charge )
{
   m_charge = charge;
}

//
// const member functions
//

// "stable" here means, particle is not just intermediary!
MCFBool 
GenParticle::isStable() const
{ 
   return ( hepevt_.isthep[m_hepIndexC]==1 ) ? true:false;
}

MCFBool 
GenParticle::isTraceable() const
{
   int id = abs( m_idHep );

   // don't trace neutrinos
   return ( ( id==12 || id==14 || id==16 ) ? false : true );
}

MCFBool 
GenParticle::isPhoton() const
{
   int id = abs( m_idHep );

   return ( ( id==22 ) ? true : false );
}

MCFBool 
GenParticle::isElectron() const
{
   int id = abs( m_idHep );

   return ( ( id==11 ) ? true : false );
}

MCFBool 
GenParticle::isMuon() const
{
   int id = abs( m_idHep );

   return ( ( id==13 ) ? true : false );
}

MCFBool 
GenParticle::isHadron() const
{
   int id = abs( m_idHep );

   return ( ( id>100 ) ? true : false );
}

MCFBool 
GenParticle::isCharged() const
{
   return ( (charge() != 0) ? true : false );
}


void
GenParticle::printOn( ostream& str ) const
{
   str << "nameOf( " << nameOf() << " )\n";
   str << "id( "     << idHep()  << " )\n";
   str << "mass( "   << mass()   << " )\n";
   str << "charge( " << charge() << " )\n";
   str << "spin( "   << spin()   << " )\n";
   
   str << "hepIndexC( " << hepIndexC() << " )\n";
   str << "hepIndexF( " << hepIndexF() << " )\n";

}

//
// static member functions
//


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:32  eugenio
// Initial revision
//
// Revision 1.6  1998/11/20 23:47:52  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.5  1998/08/11  17:10:54  mkl
// converted some floats to DFLOATs to be in sync with wtrack
//
// Revision 1.4  1998/02/16  04:33:41  mkl
// first version of 2ndary interactions
//
// Revision 1.3  1997/07/03  03:33:49  mkl
// new approach: surfaces vs volumes; box tracing
//
// Revision 1.2  1997/04/22  20:01:07  bphyslib
// fixes for decay-in-flights
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//



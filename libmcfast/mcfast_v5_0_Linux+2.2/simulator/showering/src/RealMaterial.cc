// -*- C++ -*-
//
// Package:     Showering
// Module:      RealMaterial
// 
// Description: real material for volume-based tracing
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Julia Yarba
// Created:     May 6, 1997
// RCS(Id)
//
// Revision history
//
// RCS(Log)

// system include files
#include <math.h>
#include <string>
#include <map>

// user include files
// #include "Report.hh"
#include "UserSettings.hh"
#include "RealMaterial.hh"
#include "MCParticle.hh"
#include "report.hh"
#include "functions.hh"

extern "C" {

// ugly fix to get a character name of unknown length from FORTRAN to C++
     void get_name_length_( const integer& index, 
                                  integer& nameLength ) ;
     void get_name_material_( const integer& index,
                                    char* name,
                                    int nameLength ) ;
     void get_info_material_( const integer& index,
                                    float& A, float& Z,
                                    float& density,
                                    float& radL, float& absL, float& dedx) ;
     void get_n_cont_materials_(const integer& index, 
                                      integer& numberCont) ;
     void get_cont_index_and_ratio_( const integer& index, 
                                     const integer& ic, 
                                           integer& indexCont, 
                                           float&   ratioCont ) ; 
}

//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Showering.RealMaterial";

//
// static data member definitions
//

//
// constructors and destructor
//

RealMaterial::RealMaterial()
   : m_A( 0 ), m_Z( 0 ), m_density( 0 ),
     m_radLength( 1.e+16 ),
     m_absLength( 1.e+16 ),
     m_dedx( 0 ),
     m_rMoliere( 0 )
{
}


RealMaterial::RealMaterial( const int index ) 
{
   // get "basic" parameters
   float A, Z, density, radl, absl, dedx ;

   get_info_material_(index,                        
		      A, Z, 
		      density,
		      radl, absl, dedx) ;
   m_A = A ;
   m_Z = Z ;
   m_density = density ;
   m_radLength = radl ;
   m_absLength = absl ;
   m_dedx = dedx ;
   m_rMoliere = 0.021 * (Z+1.2) / 0.8 ;

// now get contributions, if mixture or compound 
   int numberCont ;
   get_n_cont_materials_( index, numberCont ) ;
   if (numberCont > 1) {
      int nameLength ;
      char* nameCont ;
      int indexCont;
      float ratioCont ;
      for (int ic=1; ic<=numberCont; ic++) {
	 get_cont_index_and_ratio_( index, ic, indexCont, ratioCont ) ; 
// we use the ugly fix to get name from FORTRAN
	 get_name_length_( indexCont, nameLength ) ;
	 nameCont = new char[nameLength+1] ;
	 get_name_material_( indexCont, nameCont, nameLength ) ;
// Do we need it here ? 
	 *(nameCont + nameLength) = '\0' ;
// now add to Map of contributions
	 (m_contribution).insert( pair< const string, float >
				  ( nameCont, ratioCont ) ) ;
	 delete [] nameCont ;
      }
   }

}

RealMaterial::RealMaterial( const float A, const float Z, 
			    const float density, 
			    const float radL, 
			    const float absL, 
			    const float dedx ) 
   : m_A( A ), m_Z( Z ), m_density( density ),
     m_radLength( radL ), m_absLength( absL ), m_dedx( dedx )
{
   m_rMoliere = 0.021 * (Z+1.2) / 0.8 ;
}

RealMaterial::~RealMaterial()
{
}

//
// member functions
//
//
// const member functions
//
// clone operation
RealMaterial*
RealMaterial::clone() const
{
   return new RealMaterial(*this);
}

MCFBool
RealMaterial::interactWith( MCParticle& particle) const 
{
   MCFBool statusOK = false ;

   report( ERROR, kFacilityString ) 
      << "interactWith: dummy function " << endl;

   return statusOK;
} 


DFLOAT
RealMaterial::interactWith( MCParticle& particle, DFLOAT& step ) const
{
   DFLOAT eDeposited = 0;

   if (step <= 0 ) return eDeposited ;

   if ( !particle.showeringHasStarted() )
   {
// still particle
    if ( !particle.isCharged() ) 
    {    
// neutral particle -> no energy loss, only move
     particle.stepBy( step ) ;
     particle.stepLength() = step ;
     return eDeposited=0 ;
    }
// charged particle - > move and looses energy
    eDeposited = doElossAndMscat( particle, step ) ;
   }
   else
   {
// shower
    if ( particle.isPhoton() || particle.isElectron() )
     eDeposited = doEMShowering( particle, step ) ;
    else
     eDeposited = doHADShowering( particle, step ) ;
   }
   return eDeposited ;
}

extern "C" {
   float rann_( const integer& seq ) ;
}

MCFBool
RealMaterial::transProfileOfShower( MCParticle& particle, 
                                    DFLOAT& Signal,
                                    DFLOAT& depRadius, 
                                    DFLOAT& depPhi ) const
{

   MCFBool Done = false ;

   if ( Signal <= 0 ) return( Done=true ) ;

   static int iDep = 0 ;
   static int nDep = 1 ;
   static MCFBool first = true ;
   static DFLOAT sigmaN = -1 , sigmaW = -1, ampRatio = 1, ampThresh = 1 ;
   static DFLOAT passOfShower = 0, passLimit = 40 ;
   static DFLOAT rLimit ;
   
   if (first) 
   {
     first = false ;
     nDep = max( 1, int( Signal/UserSettings::kMinVisEnergy ) ) ;
     nDep = min(nDep,
                UserSettings::kMaxShowerHitsPerStep ) ;

     Signal /= float(nDep) ;
     if ( particle.stepLength() <= m_radLength )
     {
        passOfShower = particle.shower().N_radlen_pass ;
     }
     else
     {
        passOfShower = particle.shower().N_radlen_pass 
	   - particle.stepLength() / m_radLength ;
	passOfShower += 1 ;
     }
     if ( particle.isElectron() || particle.isPhoton() )
     {
      sigmaN /= 
      ((60/m_rMoliere)
       *exp((-1/m_rMoliere)*min(passLimit,passOfShower))
      +2*exp(-0.02*min(passLimit,passOfShower))) ;
      sigmaW /= 
      (5/m_rMoliere)*exp(-0.25*min(passLimit,passOfShower)) ;
      ampRatio = 0.01 * min(passLimit,passOfShower) ;
      rLimit = 4.5*m_rMoliere ;
     }
     else
     {
      sigmaN /= (exp(-0.7-0.364*min(passLimit,passOfShower))
                +exp(-0.56-0.06*min(passLimit,passOfShower))) ;
      sigmaW /= exp(-2.5-0.25*min(passLimit,passOfShower)) ;
      if (sigmaW < -2000 ) sigmaW = -2000 ;
      ampRatio = exp(-1.75-0.45*min(passLimit,passOfShower)) ;
      rLimit = 35*m_rMoliere ;
     }
     ampThresh = ampRatio*sigmaW / (ampRatio*sigmaW+sigmaN) ;
   }

   if ( nDep > 1 && iDep < nDep )
   {
    int seq = 0 ;
    DFLOAT sigma = ( double(rann_( seq )) > ampThresh ) ? sigmaN : sigmaW ;
    for ( int i=0 ; ; i++ )
    {
     depRadius = abs( sigma * log( rann_( seq ) ) ) ;
     if (depRadius < rLimit ) break ;
    }
    depRadius *= m_radLength ;
    depPhi = TWOPI * rann_( seq ) ;
   }

   iDep++ ;

   if ( iDep == nDep )
   {
    iDep = 0 ;
    first = true ;
    sigmaN = sigmaW = -1 ;
    ampRatio = 1 ;
    Done = true ;
   }

   return Done ;

}

MCFBool
RealMaterial::isMixture() const
{
   return ( ((m_contribution).empty()) ? false : true ) ;
} 

int
RealMaterial::numberOfContributions() const
{
   int SizeOfMap = (m_contribution).size() ;
   return SizeOfMap ;
}

float 
RealMaterial::portionOfContribution(const char* name) const
{
   float rWeight = 0. ;

   map<string, float, less<string> >::const_iterator 
      ifind = (m_contribution).find( name ) ; 
   if ( ifind != (m_contribution).end() )
   {
      rWeight = (*ifind).second ;
   }
   return rWeight ;
} 

DFLOAT
RealMaterial::distanceToConversion( MCParticle& particle ) const
{
   DFLOAT distance = findConversionPoint( particle ) ;
   return distance ;
}

DFLOAT
RealMaterial::findConversionPoint( MCParticle& particle ) const
{
   DFLOAT distance ;

   if ( particle.isMuon() ) { return( distance=FLT_MAX ) ; }

   int seq ;
   distance = double( rann_( seq=0 ) ) ;

   if ( particle.isElectron() || particle.isPhoton() )
   {
      distance *= m_radLength ;
   }
   else
   {
      distance *= m_absLength ;
   }

   return distance ;

}

extern "C" {
   void wtk_mscat_( const WTrackStruct& w1,       // input wtrack parms 
		    const DFLOAT& radl,           // radiation length
		    const DFLOAT eta[3],          // direction cosines
		    WTrackStruct& w2);            // output wtrack parms
}

DFLOAT
RealMaterial::doElossAndMscat( MCParticle& particle, DFLOAT& step ) const 
{
   DFLOAT eDeposited = 0 ;

   DFLOAT mass2 = (particle.wtrack().E+particle.wtrack().p)
      * (particle.wtrack().E-particle.wtrack().p) ;
   DFLOAT mass = sqrt( mass2 ) ;
   DFLOAT eKine = particle.wtrack().E - mass ; 
   eDeposited = m_dedx * step ;
   if ( eDeposited > eKine )
// step limitaion by ranging out
   {
      step *= eKine / eDeposited ;
      eDeposited = eKine ;
      eKine = 0 ;
   }    
   else
   {
// update eKine 
      eKine -= eDeposited ;
// check if eKine is above min.visible energy (set by a user);
// if not deposite the remaining energy too and stop the particle
      if (eKine <= UserSettings::kMinVisEnergy)
      {
       eDeposited += eKine ;
       eKine = 0 ;
      }
   }

// first, move the particle; 
// do it before applying mult.scat.(if any) since for sailing through particles
// distance to exit is defined before mult.scat. applies;
// also, do it before updates to avoid 0-momentun and move_... crash
   particle.stepBy( step ) ;
   particle.stepLength() = step ;

// Do multiple scattering if required 
// (before doing updates to avoid a chance to deal with 0-momentum)
   if ( particle.wtrack().p > 0 && UserSettings::kMScat )
   {
      DFLOAT stepInRadLen = step / m_radLength ;
      DFLOAT  eta[3] ;
      eta[0] = particle.wtrack().px / particle.wtrack().p ;
      eta[1] = particle.wtrack().py / particle.wtrack().p ;
      eta[2] = particle.wtrack().pz / particle.wtrack().p ;
      wtk_mscat_( particle.wtrack(), stepInRadLen, eta,
		  particle.wtrack() );
   }

//  update momentum and energy
//  all other updates will be done in DenseMedium::reactTo( particle ) 
   DFLOAT pSave = particle.wtrack().p ;
   particle.wtrack().E = eKine + mass ;
//  I just don't know how to write it in more elegant way... 
   if ( (particle.wtrack().E*particle.wtrack().E - mass*mass) > 0 )
   {
      particle.wtrack().p = 
      sqrt(particle.wtrack().E*particle.wtrack().E-mass*mass) ;
   }
   else
   {
      particle.wtrack().p = 0 ;
   }
   particle.wtrack().px *= ( particle.wtrack().p / pSave ) ;
   particle.wtrack().py *= ( particle.wtrack().p / pSave ) ;
   particle.wtrack().pz *= ( particle.wtrack().p / pSave ) ;
   particle.wtrack().pt *= ( particle.wtrack().p / pSave ) ;

   return eDeposited ;

}

extern "C" {

// The GAMDIS(X,P) is a the function which calculates the gamma distribution
// (incomplete gamma function) for parameter p>0, defined as
// gamdis(X,P) = inegral(0,x)( (t**(p-1)*e**(-t)/gamma(p) dt ).
// We use it to calculate energy deposited (lost) by a shower (either EM or HAD)
// over a distance dt, where dt is expressed in units of rad.length of the material.
// Language : FORTRAN
// Belongs to : CERNLIB(GENLIB)

   float gamdis_( float& dt, float& alpha ) ;
}

DFLOAT 
RealMaterial::doEMShowering( MCParticle& particle, DFLOAT& step ) const
{

   DFLOAT eDeposited = 0 ;

// Define some basic EM shower things
// (it'd be nice to define them once per particle per RealMaterial
//  but probably the only way to do it is make them data members 
//  to be reset as particle->shower)
   float ci, alpha, beta = 0.5 ;
   float tMax ;
   if ( particle.isPhoton() )   ci = -0.5 ;
   if ( particle.isElectron() ) ci =  0.5 ;
   tMax = log( particle.shower().E_original*(m_Z+1.2)/0.8  ) + ci ;
   alpha = 1. + beta * tMax ;

   if ( tMax <= 0 ) 
   {
// Do not shower very low energy particles 
// Deposite the whole energy and "kill" the particle 
      eDeposited = particle.shower().wtrack.E ;
      particle.wtrack().E =  0 ;
      particle.wtrack().px = 0 ;
      particle.wtrack().py = 0 ;
      particle.wtrack().pz = 0 ;
      particle.wtrack().pt = 0 ;
      particle.wtrack().p  = 0 ;
      particle.shower().wtrack.E  = 0 ;
      particle.shower().wtrack.px = 0 ;
      particle.shower().wtrack.py = 0 ;
      particle.shower().wtrack.pz = 0 ;
      particle.shower().wtrack.pt = 0 ;
      particle.shower().wtrack.p  = 0 ;
      particle.shower().N_radlen_pass = 0 ; // just for safety...
      return eDeposited ;
   }

// Everything's OK, calculate energy lost over the step

   float stepTemp = particle.shower().N_radlen_pass + step / m_radLength ;               
   stepTemp *= beta ;
   eDeposited = abs( particle.shower().E_original*gamdis_( stepTemp, alpha ) )
      - ( particle.shower().E_original - particle.shower().wtrack.E ) ;

// move before doing energy-momentum updates in order to store proper
// wtrack_prev() and to avoid moving 0-momentum particles/showers
   particle.stepBy( step ) ;
   particle.stepLength() = step ;

   if ( eDeposited >= particle.shower().wtrack.E )
   {
// Shower is ranging out 
    eDeposited = particle.shower().wtrack.E ;
    particle.wtrack().E = 0 ;
    particle.shower().wtrack.E = 0 ;
   } 
   else 
   {
    particle.wtrack().E -=  eDeposited ;
    particle.shower().wtrack.E  -= eDeposited ;
    if ( particle.shower().wtrack.E <= UserSettings::kMinVisEnergy )
    {
// Remaining energy is below threshold;
     eDeposited += particle.shower().wtrack.E ;
     particle.wtrack().E = 0 ;
     particle.shower().wtrack.E = 0 ;
    }
   }

// Do updates to account for the deposited energy
   particle.wtrack().x = particle.wtrack().x ;
   particle.wtrack().y = particle.wtrack().y ;
   particle.wtrack().z = particle.wtrack().z ;
   particle.wtrack().px *= (particle.wtrack().E / ( particle.wtrack().E+eDeposited ) ) ;
   particle.wtrack().py *= (particle.wtrack().E / ( particle.wtrack().E+eDeposited ) ) ;
   particle.wtrack().pz *= (particle.wtrack().E / ( particle.wtrack().E+eDeposited ) ) ;
   particle.wtrack().pt *= (particle.wtrack().E / ( particle.wtrack().E+eDeposited ) ) ;
   particle.wtrack().p  *= (particle.wtrack().E / ( particle.wtrack().E+eDeposited ) ) ;
   particle.shower().wtrack.px *= 
      (particle.wtrack().E / ( particle.wtrack().E+eDeposited ) ) ;
   particle.shower().wtrack.py *=  
      (particle.wtrack().E / ( particle.wtrack().E+eDeposited ) ) ;
   particle.shower().wtrack.pz *=  
      (particle.wtrack().E / ( particle.wtrack().E+eDeposited ) ) ;
   particle.shower().wtrack.pt *=  
      (particle.wtrack().E / ( particle.wtrack().E+eDeposited ) ) ;
   particle.shower().wtrack.p  *=  
      (particle.wtrack().E / ( particle.wtrack().E+eDeposited ) ) ;
   particle.shower().N_radlen_pass += step / m_radLength ; 

   return eDeposited ;
}

DFLOAT
RealMaterial::doHADShowering( MCParticle& particle, DFLOAT& step ) const
{

   DFLOAT eDeposited = 0 ;

// Define some basic HAD shower things
// (it'd be nice to define them once per particle per RealMaterial
//  but probably the only way to do it is make them data members 
//  to be reset as particle->shower)
   float beta = 0.2198, w = 0.4634 ;
   float alpha, c ;
   alpha = c = 0.6165 + 0.3183 * log( particle.shower().E_original ) ;
   float d = 0.9099 - 0.0237 * log( particle.shower().E_original ) ;
   float tMax = m_absLength * ( 0.7 + 0.2 * log( particle.shower().E_original ) ) ;

   if ( tMax < 0 || alpha <= 0 ) 
   {
// Do not shower very low energy particles 
// Deposite the whole energy and "kill" the particle 
      eDeposited = particle.shower().wtrack.E ;
      particle.wtrack().E =  0 ;
      particle.wtrack().px = 0 ;
      particle.wtrack().py = 0 ;
      particle.wtrack().pz = 0 ;
      particle.wtrack().pt = 0 ;
      particle.wtrack().p  = 0 ;
      particle.shower().wtrack.E  = 0 ;
      particle.shower().wtrack.px = 0 ;
      particle.shower().wtrack.py = 0 ;
      particle.shower().wtrack.pz = 0 ;
      particle.shower().wtrack.pt = 0 ;
      particle.shower().wtrack.p  = 0 ;
      particle.shower().N_radlen_pass = 0 ; // just for safety...
      return eDeposited ;
   }

// Everythis's OK, calculate energy lost over the step

   float stepTemp = particle.shower().N_radlen_pass + step / m_radLength ;
   stepTemp *= beta ;
   float dLambda = ( particle.shower().N_radlen_pass*m_radLength + step )
      / m_absLength ;
   dLambda *= d ;
   eDeposited = abs( w*gamdis_(stepTemp,alpha) + (1.-w)*gamdis_(dLambda,c) ) ;
   eDeposited *= particle.shower().E_original ;
   eDeposited -= ( particle.shower().E_original - particle.shower().wtrack.E ) ;

// move before doing energy-momentum updates in order to store proper
// wtrack_prev() and to avoid moving 0-momentum particles/showers
   particle.stepBy( step ) ;
   particle.stepLength() = step ;

   if ( eDeposited >= particle.shower().wtrack.E )
   {
    eDeposited = particle.wtrack().E ;
    particle.wtrack().E = 0 ;
    particle.shower().wtrack.E = 0 ;
   } 
   else 
   {
    particle.wtrack().E -=  eDeposited ;
    particle.shower().wtrack.E  -= eDeposited ;
    if ( particle.shower().wtrack.E <= UserSettings::kMinVisEnergy)
    {
     eDeposited += particle.shower().wtrack.E ;
     particle.wtrack().E = 0 ;
     particle.shower().wtrack.E = 0 ;
    }
   }

// Do updates to account for the deposited energy
   particle.wtrack().x = particle.wtrack().x ;
   particle.wtrack().y = particle.wtrack().y ;
   particle.wtrack().z = particle.wtrack().z ;
   particle.wtrack().px *= (particle.wtrack().E / ( particle.wtrack().E+eDeposited ) ) ;
   particle.wtrack().py *= (particle.wtrack().E / ( particle.wtrack().E+eDeposited ) ) ;
   particle.wtrack().pz *= (particle.wtrack().E / ( particle.wtrack().E+eDeposited ) ) ;
   particle.wtrack().pt *= (particle.wtrack().E / ( particle.wtrack().E+eDeposited ) ) ;
   particle.wtrack().p  *= (particle.wtrack().E / ( particle.wtrack().E+eDeposited ) ) ;
   particle.shower().wtrack.px *= 
      (particle.wtrack().E / ( particle.wtrack().E+eDeposited ) ) ;
   particle.shower().wtrack.py *=  
      (particle.wtrack().E / ( particle.wtrack().E+eDeposited ) ) ;
   particle.shower().wtrack.pz *=  
      (particle.wtrack().E / ( particle.wtrack().E+eDeposited ) ) ;
   particle.shower().wtrack.pt *=  
      (particle.wtrack().E / ( particle.wtrack().E+eDeposited ) ) ;
   particle.shower().wtrack.p  *=  
      (particle.wtrack().E / ( particle.wtrack().E+eDeposited ) ) ;
   particle.shower().N_radlen_pass += step / m_radLength ; 

   return eDeposited ;

}

// I/O
void
RealMaterial::printOn( ostream& str ) const
{
   str << "\nProperties of RealMaterial "          << "  \n";

   str << "A( "                 << A()         << " )\n"; 
   str << "Z( "                 << Z()         << " )\n"; 
   str << "density( "           << density()   << " )\n";
   str << "radiationLength( "   << radLength() << " )\n";
   str << "interactionLength( " << absLength() << " )\n";
   str << "dedx( "              << dedx()      << " )\n";
   if ( isMixture() )
   {
      str << "it is a Mixture" << "\n" ;
   }
}

//
// static member functions
//

// ==================================================================
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:29  eugenio
// Initial revision
//
// Revision 1.12  1999/02/16 23:47:16  yarba_j
// minor cleanup
//
// Revision 1.11  1998/11/20  23:46:01  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.10  1998/11/03  17:44:01  mkl
// changes to compile under egcs
//
// Revision 1.9  1998/10/22  02:50:44  mkl
// now use official wtk_mscat routine
//
// Revision 1.8  1998/07/29  17:16:27  yarba_j
// fixed small bug in generation of shower transverse profile
//
// Revision 1.7  1998/06/09  23:35:01  yarba_j
// several small bugs fixed
//

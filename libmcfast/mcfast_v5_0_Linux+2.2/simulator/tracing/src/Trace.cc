// -*- C++ -*-
//
// Package:     Tracing
// Module:      Trace
// 
// Description: Trace class containing trace info and more
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
#include <assert.h>
#include <map>
#include <string.h>

// user include files
#include "report.hh"

#include "Trace.hh"
#include "mkl_trace_struct.hh"
#include "MCParticle.hh"
#include "Medium.hh"
#include "Material.hh"

//#include "HitStruct.hh"

//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Tracing.Trace";

//
// static data member definitions
//
//
// constructors and destructor
//
Trace::Trace( TraceType iType )
   : m_type(iType),
//     m_geom(0),
     m_hitIndexF(0)
//     m_hit(0)
{
   // how to initialize:
   // m_wtrack
   // m_traceInfo
}

#if 0
Trace::Trace( const Trace& iTrace )
{
   copyDataMembers( iTrace );
}
#endif

Trace::~Trace()
{
   // beware: hit pointer doesn't need to be cleaned up, because memory is
   // owned by  Fortran!
}

//
// assignment operators
//
#if 0
const Trace&
Trace::operator=( const Trace& iTrace )
{
   if( this != &iTrace ) {
      copyDataMembers( iTrace );
   }
   
   return *this;
}
#endif
//
// member functions
//
void
Trace::copyDataMembers( const Trace& iTrace )
{
   m_type      = iTrace.m_type;
   m_wtrack    = iTrace.m_wtrack;
   m_traceInfo = iTrace.m_traceInfo;
   //m_geom      = iTrace.m_geom;
   m_bfield    = iTrace.m_bfield;
   m_hitIndexF = iTrace.m_hitIndexF;
   //m_hit       = iTrace.m_hit;
}

void 
Trace::setTraceInfo( const MCParticle& particle )
{
   // index into hep particle list
   m_traceInfo.hep = particle.hepIndexF();

   // reference point
   m_traceInfo.ref_x = particle.wtrack().x;
   m_traceInfo.ref_y = particle.wtrack().y;
   m_traceInfo.ref_z = particle.wtrack().z;
   
   m_traceInfo.path = particle.path().arc;  // Total track length up to this hit 
   m_traceInfo.tau  = particle.path().tau;  // Proper flight time to intersection 
   m_traceInfo.time = particle.path().time; // Time at which track made hit 
   
   // material
   fillMaterialInfo( particle );


   // ----------------------------------------------------------------------
   // the following are only filled because some tracking routines need them
   m_traceInfo.type = int(type());
   m_traceInfo.plane = 0;
   for( int i=0; i<3; i++ ) m_traceInfo.eta[i] = 0;
   
   // only if we have a medium
   const Medium* medium = particle.pCurrentMedium();
   if( medium != 0 ) {
      m_traceInfo.plane = medium->commonIndexF();
      for( int i=0; i<3; i++ ) m_traceInfo.eta[i] = particle.eta()[i];
   }
}

void
Trace::fillMaterialInfo( const MCParticle& particle )
{
   // only bother if we have a material type trace
//   MCFBool relevant = (    type() == TraceType::kRPlane
//			|| type() == TraceType::kZPlane
//			|| type() == TraceType::kCone
//			|| type() == TraceType::kPair
//			|| type() == TraceType::kAbsorb
//			|| type() == TraceType::kCalor
//			|| type() == TraceType::kShower
//			|| type() == TraceType::kMaterial
   MCFBool relevant = (    type() == TraceType::kPair
			|| type() == TraceType::kAbsorb
//			|| type() == TraceType::kCalor
//			|| type() == TraceType::kShower
			|| type() == TraceType::kMSEloss
			|| type() == TraceType::kMSElossNOT
      );

   // if relevant, have Medium, and Medium has Material
   if( relevant
       && 0 != particle.pCurrentMedium()
       && 0 != particle.currentMedium().pMaterial() 
      ) 
   {
      const Material& material = particle.currentMedium().material(); 

      // Position in the material list 
      m_traceInfo.material = 0; //material.index()
   
      // # of radiation lengths of material 
      m_traceInfo.radl = material.radLength();
      m_traceInfo.dedx = material.dedx();

// not used anymore   
//      for( int i=0; i<MCParticle::NHYP; ++i ) {
//	 // RMS MS angle 
//	 m_traceInfo.sigma_ms[i] = particle.sigma_ms()[i];
//	 // dE/dx  
//	 m_traceInfo.eloss[i]    = particle.eloss()[i];
//     }
//      // the rest will be zeros
//      for( int i=MCParticle::NHYP; i<TraceStruct::NHYP; i++ ) {
//	 m_traceInfo.sigma_ms[i] = 0;
//	 m_traceInfo.eloss[i] = 0;
//      }

   } else {  // no material; just fill in zeros
      
      m_traceInfo.material = 0;
      m_traceInfo.radl = 0;
      m_traceInfo.dedx = 0;

// not used anymore   
//      for( int i=0; i<TraceStruct::NHYP; ++i ) {
//	 m_traceInfo.sigma_ms[i] = 0;
//	 m_traceInfo.eloss[i] = 0;
//      }

   }
}
//
// const member functions
//
void 
Trace::printOn( ostream& str ) const
{
   str << "Trace {\n";

   // type of Trace
   const char* name = TraceType::type2Char( type() );
   if( name == 0 ) {
      report( ERROR ) << "Trace::printOn: type=" << type() 
		      << " doesn't have name" << "\n";
      name="";
   }
   str << "Type( " << name << " )\n";
   
   // some basic info
   str << "position( " 
       << traceInfo().ref_x << ", "
       << traceInfo().ref_y << ", "
       << traceInfo().ref_z << " )\n";

   str << "p, px, py, pz, pt, E( " 
       << wtrack().p << ", "
       << wtrack().px << ", "
       << wtrack().py << ", "
       << wtrack().pz << ", "
       << wtrack().pt << ", "
       << wtrack().E << " )\n";

   str << "path( " << traceInfo().path << " )\n";
   str << "tau( "  << traceInfo().tau  << " )\n";
   str << "time( " << traceInfo().time << " )\n";

   str << "radl( "     << traceInfo().radl << " )\n";
   str << "dedx( "     << traceInfo().dedx << " )\n";

// not used anymore
//   str << "sigma_ms( "; 
//   for( int i=0; i<MCParticle::NHYP; ++i ) {
//      str << traceInfo().sigma_ms[i] << " ";
//   }
//   str << ")\n";
//   str << "eloss( ";
//   for( int i=0; i<MCParticle::NHYP; ++i ) {
//      str << traceInfo().eloss[i] << " ";
//   }
//   str << ")\n";

   str << "}\n";
   
}
//
// static member functions
//

// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:33  eugenio
// Initial revision
//
// Revision 1.11  1998/11/20 23:48:01  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.10  1998/10/21  19:59:38  mkl
// implement eta correctly
//
// Revision 1.9  1998/02/16  21:30:07  mkl
// added new TraceType class that deals with trace types exclusively
//
// Revision 1.8  1998/02/16  19:50:46  mkl
// terminate c-string with 0 for printing in fortran
//
// Revision 1.7  1997/11/22  23:49:11  mkl
// initialization of dedx part of TraceStruct not done correctly -- fixed
//
// Revision 1.6  1997/11/21  22:31:37  mkl
// turned fortran-callable subroutine into function
//
// Revision 1.5  1997/11/21  18:56:02  mkl
// added fortran-callable routine to Trace.cc to get the char string per Tracetype
//
// Revision 1.4  1997/11/21  04:15:13  mkl
// write traces for material planes even when MS/Eloss flags aren't set
//
// Revision 1.3  1997/11/20  21:19:16  mkl
// added BFieldBoundary TraceType and global function for printouts
//
// Revision 1.2  1997/07/03  03:33:54  mkl
// new approach: surfaces vs volumes; box tracing
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//



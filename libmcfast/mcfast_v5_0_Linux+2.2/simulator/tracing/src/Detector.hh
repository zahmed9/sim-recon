#if !defined(TRACING_DETECTOR_H)
#define TRACING_DETECTOR_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      Detector
// 
// Description: base class for all detectors
//
// This is an abstract base class for all detectors. Its primary
// responsibilty is to record particle traversals: a Detector object
// must be contained by a Medium, and its generateResponse method will
// be called for each particle step in the associated Medium.
//
// A detector also has a geometric identity; it and can be drawn.
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
#include "Medium.hh"           // for Medium::Type
#include "Printable.hh"

// forward declarations
class MCParticle;
class ostream;


class Detector : public Printable
{
      // friend classses and functions

   public:
      // constants, enums and typedefs
      // Constructors and destructor
      virtual ~Detector() {}
      
      // copy constructor
      //Detector( const Detector& );

      // assignment operator(s)
      //const Detector& operator=( const Detector& );

      // member functions
      void setDeviceIndices( int iDeviceIndexF, 
			     int iLayerIndexF=0, 
			     int iWedgeIndexF=0 );
   
      // All detectors must specify what they will do 
      // when traversed by a particle
      virtual MCFBool generateResponse( MCParticle&, 
					MCFBool& oHitActiveArea,
					DFLOAT = 0 ) const = 0;

      // display 
      virtual void printOn( ostream& ) const = 0;

      // const member functions

      // clone operation
      virtual Detector* clone() const = 0;

      virtual const char* nameOf() const { return "Detector"; }

      int deviceIndexF() const { return m_deviceIndexF; }
      int layerIndexF()  const { return m_layerIndexF; }
      int wedgeIndexF()  const { return m_wedgeIndexF; }

      // static member functions

      // virtual constructor
      static Detector* createDetector( Medium::Type type );

   protected:
      // protected member functions
      Detector(){};

      // protected const member functions

   private:

      // Constructors and destructor

      // private member functions

      // private const member functions

      // data members
      int m_deviceIndexF, m_layerIndexF, m_wedgeIndexF;

      // static data members

};

// inline function definitions

inline 
ostream& 
operator<<( ostream& os, const Detector& d )
{
   d.printOn(os);
   return os;
}

inline 
ostream& 
operator<<( ostream& os, const Detector* d )
{
   d->printOn(os);
   return os;
}

inline
void 
Detector::setDeviceIndices( int iDeviceIndexF, 
			    int iLayerIndexF, 
			    int iWedgeIndexF )
{
   m_deviceIndexF = iDeviceIndexF;
   m_layerIndexF  = iLayerIndexF;
   m_wedgeIndexF  = iWedgeIndexF;
}



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:32  eugenio
// Initial revision
//
// Revision 1.8  1999/02/15 19:03:31  mkl
// added Box-shaped Calorimeters
//
// Revision 1.7  1998/11/20  23:47:51  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.6  1998/08/04  22:58:38  mkl
// implemented Detector::generateResponse with extra output argument: oHitActiveArea; only if true, do material effects
//
// Revision 1.5  1997/12/09  00:33:38  yarba_j
// generateResponse( MCParticle& ) -> generateResponse( MCParticle&, DFLOAT (signal) = 0 )
//
// Revision 1.4  1997/11/20  21:22:12  mkl
// make virtual member function nameOf() explicit
//
// Revision 1.3  1997/11/11  01:17:31  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.2  1997/08/01  20:56:29  mkl
// forward declare stl containers
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//


#endif /* TRACING_DETECTOR_H */

#if !defined(TRACING_TRACE_H)
#define TRACING_TRACE_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      Trace
// 
// Description: Trace class
//
// Usage:
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
#include "mkl_trace_struct.hh"
#include "wtrack_struct.hh"
#include "bfield_struct.hh"
#include "Printable.hh"
#include "TraceType.hh"

// forward declarations
class MCParticle;
//struct GeomStruct;
//struct HitStruct;

class Trace : public Printable
{
      // friend classses and functions

   public:
      // constants, enums and typedefs
      typedef TraceType Type;

      // Constructors and destructor
      Trace( TraceType iType = TraceType::kDummy );
      // Trace( const Trace& );
      ~Trace();                   // non-virtual destructor!

      // assignment operators
      // const Trace& operator=( const Trace& );

      // member functions

      void setWTrack( const WTrackStruct& iWTrack ) { m_wtrack=iWTrack; }
      void setTraceInfo( const MCParticle& particle );

      //void setGeom( const GeomStruct* iGeom )       { m_geom=iGeom; }
      void setHitIndexF( int iHitIndexF )     { m_hitIndexF=iHitIndexF; }
      //void setHit( const HitStruct* iHit )    { m_hit=iHit; }
      void setBField( const BFieldStruct& iBField ) { m_bfield=iBField; }

      // const member functions

      virtual const char* nameOf() const { return "Trace"; }
      virtual void printOn( ostream& ) const;

      TraceType::Type type() const { return m_type.type(); }

      const WTrackStruct& wtrack() const { return m_wtrack; }
      const TraceStruct& traceInfo() const { return m_traceInfo; }

      //const GeomStruct* geom() const { return m_geom; }
      int hitIndexF() const { return m_hitIndexF; }
      //const HitStruct* hit() const { return m_hit; }
      const BFieldStruct& bfield() const { return m_bfield; }
      
      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor

      // assignment operator(s)

      // private member functions
      void copyDataMembers( const Trace& trace );
      void fillMaterialInfo( const MCParticle& particle );

      // private const member functions

      // data members

      TraceType m_type;               // trace type
      TraceStruct m_traceInfo;        // basic trace info
      WTrackStruct m_wtrack;          // track parameter
      //Geom    *m_geom;              // pointer to geometry information
      BFieldStruct m_bfield;          // B-field (can't make it pointer!)

      int m_hitIndexF;                // fortran index to hit in common block
      //const HitStruct *m_hit;         // pointer to hit information

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
// Revision 1.7  1998/02/16 21:30:08  mkl
// added new TraceType class that deals with trace types exclusively
//
// Revision 1.6  1997/11/21  04:15:21  mkl
// write traces for material planes even when MS/Eloss flags aren't set
//
// Revision 1.5  1997/11/20  21:19:13  mkl
// added BFieldBoundary TraceType and global function for printouts
//
// Revision 1.4  1997/11/11  01:17:41  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.3  1997/08/01  20:56:34  mkl
// forward declare stl containers
//
// Revision 1.2  1997/03/15  19:02:22  mkl
// moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
// fixed commend headers for .inc files from # to c.
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//


#endif /* TRACING_TRACE_H */

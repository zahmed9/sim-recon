#ifndef FORTRANACCESS_H
#define FORTRANACCESS_H

#include "cc_fortran_types.hh"

// forward declarations
struct TraceStruct;
//struct HitStruct;
//struct GeomStruct;
struct WTrackStruct;
struct BFieldStruct;


extern "C" {

   Integer rob_traceinfo_  ( const TraceStruct& );
   //Integer rob_tracehit_   ( const HitStruct* );
   Integer rob_tracehitindex_   ( const integer& index );
   //Integer rob_tracegeometry_  ( const GeomStruct * );
   Integer rob_tracewtrack_( const WTrackStruct& );
   Integer rob_tracebfield_( const BFieldStruct& );

   Integer fill_trace_commons_( const integer& TraceNumber, 
				const TraceStruct&, const WTrackStruct&,
				const integer& hitIndexF );
   Integer fill_hep_trace_commons_( const integer& counter,
				    const integer&, const integer&,
				    const integer&, const integer& );
}



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:34  eugenio
// Initial revision
//
// Revision 1.1  1997/07/03 03:34:00  mkl
// new approach: surfaces vs volumes; box tracing
//
//


#endif

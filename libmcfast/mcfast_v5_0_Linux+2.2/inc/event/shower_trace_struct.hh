#ifndef TRACING_SHOWER_TRACE_STRUCT_HH
#define TRACING_SHOWER_TRACE_STRUCT_HH

// Shower description in W form

// AUTHOR: Martin Lohner
// PURPOSE: translation of shower_trace_struct.inc
// DATE: Mar 14, 1997

// -------------------------------------------------------------
// WARNING: if you change this file, also make sure you change
//            shower_trace_struct.inc!
// -------------------------------------------------------------
 
#include "cc_fortran_types.hh"
#include "wtrack_struct.hh"

struct ShowerStruct 
{
      integer hepIndexF;     // pointer to particle which initiates shower
      DFLOAT  E_original;    // energy at shower start
      DFLOAT  N_radlen_pass; // # of RadLen passed by shower 
                             // (it does NOT include pass while particle behaves 
                             // as MIP)
      WTrackStruct wtrack; 
};
      


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:58:38  eugenio
// Initial revision
//
// Revision 1.2  1997/03/15 19:07:00  mkl
// moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
// fixed rcs comment headers from # to c.
// used cvs admin -c to change default rcs comment headers for .inc files.
//
// Revision 1.1  1997/03/14  22:50:38  mkl
// imported .hh files for equivalent .inc files for Martin Lohner's c++ tracing code
//


#endif /* TRACING_SHOWER_TRACE_STRUCT_HH */
      

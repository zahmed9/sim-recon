#ifndef TRACING_MKL_TRACE_STRUCT_H
#define TRACING_MKL_TRACE_STRUCT_H

#include "const.hh"                        /* to include NHYP */

// AUTHOR: Martin Lohner
// PURPOSE: translation of mkl_trace_struct.inc
// DATE: Mar 14, 1997

// -------------------------------------------------------------
// WARNING: if you change this file, also make sure you change 
//            mkl_trace_struct.inc!
// -------------------------------------------------------------

struct TraceStruct {

      enum { NHYP = 5 };            // number of particle hypotheses

      DFLOAT  ref_x;                // x of reference point 
      DFLOAT  ref_y;                // y of reference point 
      DFLOAT  ref_z;                // z of reference point 
	    
      // Cumulative from the start of the track 
      DFLOAT  path;                 // Total track length up to this hit 
      // Cumulative from the overall event t=0 
      DFLOAT  time;                 // Time at which track made hit 
      DFLOAT  tau;                  // Proper flight time to intersection 
    
      // Describe the outward going step from this point 
      DFLOAT  radl;                 // # of radiation lengths of material 
      DFLOAT  dedx;                 // dedx of material

      // -------------------------------------------------------------------
      // the following DFLOAT isonly filled, because of some tracking routines
      DFLOAT  eta[3];               // !Direction cosines of normal to plane

// not used anymore
//      DFLOAT  sigma_ms[NHYP];       // RMS MS angle per particle type
//      DFLOAT  eloss[NHYP];          // dE/dx per particle type

      Integer hep;                  // Position of track in /HEPEVT/ 
      Integer material;             // Position in the material list 


      // -------------------------------------------------------------------
      // the following two are only filled, because of some tracking routines
      integer type;                 // !Trace type (see trace_type.inc)
      integer plane;                // !plane index into common block array


};

// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:34  eugenio
// Initial revision
//
// Revision 1.7  1999/03/12 18:55:02  procario
// Move all doubles to the beginning of the structure so that padding will not be an issue
//
// Revision 1.6  1999/02/12  04:42:54  mkl
// reorder trace.time and trace.tau
//
// Revision 1.5  1998/10/21  19:59:39  mkl
// implement eta correctly
//
// Revision 1.4  1998/07/16  18:26:35  bphyslib
// sigh, it really is const.hh
//
// Revision 1.3  1998/07/15  16:40:45  garren
// rename const.hh to const.h
//
// Revision 1.2  1997/11/21  04:15:41  mkl
// write traces for material planes even when MS/Eloss flags aren't set
//
// Revision 1.1.1.1  1997/03/14  22:52:34  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//


#endif /* TRACING_MKL_TRACE_STRUCT_H */

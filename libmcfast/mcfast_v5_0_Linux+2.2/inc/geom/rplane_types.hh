#ifndef TRACING_RPLANE_TYPES_STRUCT_H
#define TRACING_RPLANE_TYPES_STRUCT_H

//   types of r planes

// AUTHOR: Martin Lohner
// PURPOSE: translation of rplane_types.inc
// DATE: Mar 14, 1997

// -------------------------------------------------------------
// WARNING: if you change this file, also make sure you change 
//            rplane_types.inc!
// -------------------------------------------------------------

#include "cc_fortran_types.hh"

const integer jrpl_drf_anode = 1;      // !Drift chamber anode
const integer jrpl_drf_cathode = 2;    // !Drift chamber cathode
const integer jrpl_sibarrel = 3;       // !Silicon barrel
const integer jrpl_material = 4;       // !Cylinder material
const integer jrpl_magnet = 5;         // !Magnet boundary
const integer jrpl_emcal = 6;          // !Emcal boundary
const integer jrpl_hcal = 7;           // !Hcal boundary



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:58:40  eugenio
// Initial revision
//
// Revision 1.1  1997/03/27 22:03:02  mkl
// moved detector-defining parameter statements out of r/zplane_struct.inc into r/zplane_types.inc/.hh
//
//

#endif /* TRACING_RPLANE_TYPES_STRUCT_H */

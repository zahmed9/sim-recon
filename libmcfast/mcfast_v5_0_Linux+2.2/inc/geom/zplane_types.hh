#ifndef TRACING_ZPLANE_TYPES_STRUCT_H
#define TRACING_ZPLANE_TYPES_STRUCT_H

//   types of z planes

// AUTHOR: Martin Lohner
// PURPOSE: translation of zplane_types.inc
// DATE: Mar 14, 1997

// -------------------------------------------------------------
// WARNING: if you change this file, also make sure you change 
//            zplane_types.inc!
// -------------------------------------------------------------

#include "cc_fortran_types.hh"

const integer jzpl_drift = 1;    // !Drift chamber layer
const integer jzpl_sidisk = 2;   // !Silicon disk
const integer jzpl_material = 3; // !Cylinder material
const integer jzpl_magnet = 4;   // !Magnet boundary
const integer jzpl_emcal = 5;    // !Emcal boundary
const integer jzpl_hcal = 6;     // !Hcal boundary
const integer jzpl_siz_rect = 7; // !Silicon rectangular xy plane
const integer jzpl_siz_circ = 8; // !Silicon circular plane 

// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:58:40  eugenio
// Initial revision
//
// Revision 1.3  1997/11/12 22:23:40  mkl
// update to reflect changes in zplane_types.inc
//
// Revision 1.2  1997/04/19  11:20:16  mkl
// added Silicon circular xy plane type
//
// Revision 1.1  1997/03/27  22:03:02  mkl
// moved detector-defining parameter statements out of r/zplane_struct.inc into r/zplane_types.inc/.hh
//
//

#endif /* TRACING_ZPLANE_TYPES_STRUCT_H */



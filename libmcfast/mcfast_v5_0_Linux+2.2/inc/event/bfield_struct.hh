#ifndef TRACING_BFIELD_STRUCT_HH
#define TRACING_BFIELD_STRUCT_HH

// BField structure

// AUTHOR: Martin Lohner
// PURPOSE: translation of bfield_struct.inc
// DATE: Mar 14, 1997

// -------------------------------------------------------------
// WARNING: if you change this file, also make sure you change 
//            bfield_struct.inc and bfield_struct.h !
// -------------------------------------------------------------

#include "const.hh"
#include "cc_fortran_types.hh"

struct BFieldStruct {
      DFLOAT bmag;     //Signed magnitude of field
      DFLOAT bdir[3];  //Direction cosines of field
      Integer type;    //Type of field 
      // (used by routines for special cases)
      //  The value is bit encoded as follows
      //  0 => no field
      //  1 => along x axis
      //  2 => along y axis
      //  3 => in (x,y) plane
      //  4 => along z axis
      //  5 => in (x,z) plane
      //  6 => in (y,z) plane
      //  7 => in arbitrary direction
      Integer devtype; //  1 => solenoid
      //  2 => dipole
      Integer devnum;  //Device number
      Integer dummy;  //pad to align structure
};




// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:58:36  eugenio
// Initial revision
//
// Revision 1.6  1999/11/17 16:54:05  mcbride
// added pad to align structure
//
// Revision 1.5  1998/09/15  04:23:54  kutschke
// Update comments. New .h file.
//
// Revision 1.4  1998/07/16  18:49:54  bphyslib
// sigh, it really is const.hh
//
// Revision 1.3  1998/07/15  16:44:09  garren
// rename const.hh to const.h
//
// Revision 1.2  1997/03/15  19:06:58  mkl
// moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
// fixed rcs comment headers from # to c.
// used cvs admin -c to change default rcs comment headers for .inc files.
//
// Revision 1.1  1997/03/14  22:50:36  mkl
// imported .hh files for equivalent .inc files for Martin Lohner's c++ tracing code
//


#endif /* TRACING_BFIELD_STRUCT_HH */


#ifndef BFIELD_STRUCT
#define BFIELD_STRUCT

#include "const.inc"

c -------------------------------------------------------------
c WARNING: if you change this file, also make sure you change 
c            bfield_struct.hh and bfield_struct.h !
c -------------------------------------------------------------

      structure /bfield_struct/
        DFLOAT bmag     !Signed magnitude of field
        DFLOAT bdir(3)  !Direction cosines of field
        integer type    !Type of field (used by routines for special cases)
c			!  The value is bit encoded as follows
c			!  0 => no field
c			!  1 => along x axis
c			!  2 => along y axis
c			!  3 => in (x,y) plane
c			!  4 => along z axis
c			!  5 => in (x,z) plane
c			!  6 => in (y,z) plane
c			!  7 => in arbitrary direction
        integer devtype !  1 => solenoid
c                       !  2 => dipole
        integer devnum  !Device number
	integer dummy   !pad to align structure
      end structure



c ======================================================================
c Comments, suggestions -- get on line 1!
c
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:36  eugenio
c Initial revision
c
c Revision 1.6  2000/01/19 19:38:17  garren
c fix some ! comments which can cause problems for Linux user code
c
c Revision 1.5  1999/11/17  16:54:05  mcbride
c added pad to align structure
c
c Revision 1.4  1998/09/15  04:24:14  kutschke
c Update comments. New .h file.
c
c Revision 1.3  1997/03/15  19:06:58  mkl
c moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
c fixed rcs comment headers from # to c.
c used cvs admin -c to change default rcs comment headers for .inc files.
c
c Revision 1.2  1997/03/14  22:50:36  mkl
c imported .hh files for equivalent .inc files for Martin Lohner's c++ tracing code
c

#endif

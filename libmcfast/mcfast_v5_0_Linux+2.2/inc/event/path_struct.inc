#ifndef PATH_STRUCT_HH
#define PATH_STRUCT_HH

c   Path information for a particle

c -------------------------------------------------------------
c WARNING: if you change this file, also make sure you change 
c            path_struct.hh!
c -------------------------------------------------------------

#include "const.inc"

      integer PATH_WORD
      parameter (PATH_WORD = 3*FLOAT_WORD)

      structure /path_struct/
        DFLOAT arc     !3-D arc length
        DFLOAT time    !Time since nominal crossing time
        DFLOAT tau     !Proper flight time
      end structure



c ======================================================================
c Comments, suggestions -- get on line 1!
c
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:38  eugenio
c Initial revision
c
c Revision 1.3  1997/03/15 19:07:00  mkl
c moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
c fixed rcs comment headers from # to c.
c used cvs admin -c to change default rcs comment headers for .inc files.
c
c Revision 1.2  1997/03/14  22:50:38  mkl
c imported .hh files for equivalent .inc files for Martin Lohner's c++ tracing code
c

#endif /* PATH_STRUCT_HH */

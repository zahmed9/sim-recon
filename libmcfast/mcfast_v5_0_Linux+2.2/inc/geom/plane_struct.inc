#ifndef PLANE_STRUCT
#define PLANE_STRUCT

c    Representation of plane using a point and a normal

c -------------------------------------------------------------
c WARNING: if you change this file, also make sure you change 
c            path_struct.hh!
c -------------------------------------------------------------

#include "const.inc"

      integer PLANE_WORD
      parameter (PLANE_WORD = 6*FLOAT_WORD)

      structure /plane_struct/
        DFLOAT xp(3)   !Point on plane
        DFLOAT eta(3)  !Direction cosines of normal
      end structure

c ==================================================================
c Comments, suggestions, get on line 1!
c
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:39  eugenio
c Initial revision
c
c Revision 1.2  1997/05/09 06:35:25  mkl
c added plane_struct.hh to be used by plane tracing.
c
c

#endif

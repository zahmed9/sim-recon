#ifndef ARC_STRUCT
#define ARC_STRUCT

c   Arc information for a track along its trajectory

#include "const.inc"

      integer ARC_WORD
      parameter (ARC_WORD = 4*FLOAT_WORD)

      structure /arc_struct/
        DFLOAT s       !Arc length in bend plane
        DFLOAT s3d     !3-D arc length
        DFLOAT cosps   !cos(rho*s)
        DFLOAT sinps   !sin(rho*s)
      end structure

#endif

#ifndef CONE_STRUCT
#define CONE_STRUCT

c    Representation of cone

#include "const.inc"

      integer CONE_WORD
      parameter (CONE_WORD = 9*FLOAT_WORD)

      structure /cone_struct/
        DFLOAT xc(3)   !Position of apex of cone
        DFLOAT tana    !Tan(0.5*opening angle)
        DFLOAT zmin    !Zmin (along axis relative to center)
        DFLOAT zmax    !Zmax (along axis relative to center)
        DFLOAT eta(3)  !Direction cosines of axis
      end structure

#endif

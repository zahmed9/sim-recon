#ifndef CYLINDER_STRUCT
#define CYLINDER_STRUCT

c    Representation of cylinder

#include "const.inc"

      integer CYLINDER_WORD
      parameter (CYLINDER_WORD = 9*FLOAT_WORD)

      structure /cylinder_struct/
        DFLOAT xc(3)   !Center of cylinder
        DFLOAT radius  !Radius
        DFLOAT zmin    !Zmin (along axis relative to center)
        DFLOAT zmax    !Zmax (along axis relative to center)
        DFLOAT eta(3)  !Direction cosines of axis
      end structure

#endif

#ifndef LINE_STRUCT
#define LINE_STRUCT

c    Representation of line using a point and a direction

#include "const.inc"

      integer LINE_WORD
      parameter (LINE_WORD = 6*FLOAT_WORD)

      structure /line_struct/
        DFLOAT xp(3)   !Point on line
        DFLOAT eta(3)  !Direction cosines of direction
      end structure

#endif

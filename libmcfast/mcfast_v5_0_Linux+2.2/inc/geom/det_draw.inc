#include "const.inc"
      structure /pt_s/
        DFLOAT x
        DFLOAT y
        DFLOAT z
      end structure

      structure /quad_s/
        record /pt_s/ p(4)
      end structure

      structure /diam_s/
        record /pt_s/ p(6)
      end structure

      integer lungraph
      logical geomview_out
      character*80 geomview_file_out
      common /graph_c/ lungraph, geomview_out, geomview_file_out

#include "material_struct.inc"

c    Material list

c    All variables have the prefix "mtl_"

      integer max_mtl
      parameter (max_mtl = 200)

      integer mtl_num			!Number of materials
      record /material_struct/ mtl_par	!Material parameters

      common /mtl_comm1/
     *  mtl_num,
     *  mtl_par(max_mtl)

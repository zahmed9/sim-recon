#include "const.inc"
#include "wtrack_struct.inc"
c use with track_kine.inc
      structure /cov_struct/
         DFLOAT cov(7,7)
      end structure

c    contains info for changes in tracks and temporary storage
c    dx Change from unconstrained track parameters

      record /wtrack_struct/ p1
      record /wtrack_struct/ p0
      record /cov_struct/ p1c
      common /trk_temp/ p1(max_trk) ,p0(max_trk),p1c(max_trk)
      record /wtrack_struct/ trk_dx
      common /trk_dx1/
     *  trk_dx(max_trk)

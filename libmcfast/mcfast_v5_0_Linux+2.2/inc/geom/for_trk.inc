c
#include "for_trk_struct.inc"
c
c    Forward Tracking System (drift chambers, or fibers, or whatever...)

c    All variables have the prefix "ftrk_"

      integer max_ftrk
      parameter (max_ftrk = 100)

      integer ftrk_num          !Number of detectors

      common /ftrk_comm1/
     *  ftrk_num

      record /for_trk_struct/ ftrk_par   !Tracking device parameters

      common /ftrk_comm2/
     *  ftrk_par(max_ftrk)

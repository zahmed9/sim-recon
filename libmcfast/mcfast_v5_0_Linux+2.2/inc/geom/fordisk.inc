#include "fordisk_struct.inc"

c             Patricia McBride May 27, 1996
c    Forward disk detectors 
c    Assumes that it may be not a disk but a "part" of a disk ("fan")

c    All variables have the prefix "fordisk_"

      integer max_fordisk
      parameter (max_fordisk = 50)

      integer fordisk_num        !# of circular Forward disk detectors
      record /fordisk_struct/ fordisk_par !Forward disk parameters

      common /fordisk_disk_comm1/
     *  fordisk_num,
     *  fordisk_par(max_fordisk)

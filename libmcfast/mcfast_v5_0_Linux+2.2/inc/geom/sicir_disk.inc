#include "sicir_disk_struct.inc"

c             Julia Yarba, Oct.24, 1994
c    Silicon disk detectors 
c    Assumes that it may be not a disk but a "part" of a disk ("fan")

c    All variables have the prefix "sicir_"

      integer max_sicir
      parameter (max_sicir = 32)

      integer sicir_num			   !# of circular Si disk detectors
      record /sicir_disk_struct/ sicir_par !Silicon disk parameters

      common /sicir_disk_comm1/
     *  sicir_num,
     *  sicir_par(max_sicir)

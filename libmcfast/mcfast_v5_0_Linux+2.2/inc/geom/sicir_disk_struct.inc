#include "sicir_lyr_struct.inc"
#ifndef SICIR_DISK_STRUCT
#define SICIR_DISK_STRUCT

c                     
c                               Julia Yarba, Oct.24, 1994
c   rmin, rmax and z now are supposed to be parameters of
c   a SiDisk device, NOT a layer   
c
c   Nov.18, 1994 - Number of layers increases to 30 (instead of 10)
c   Feb.23, 1996 - Number of layers increases to 50
c   June 28, 1996 -Number of layers increases to 80
c
c
c   Silicon disk detector (circular or 'fan') definition. 
c   Several of these can be defined at one time.
c

      integer max_sicir_lyr
      parameter (max_sicir_lyr = 80)

      structure /sicir_disk_struct/
        integer numlyr		!Number of layers
        integer nchan           !total # of channel
        record /sicir_lyr_struct/
     *      lyr(max_sicir_lyr)	!Layer params
        character*40 name	!Name of device
        real z                  !"global" z-position of device
      end structure
#endif

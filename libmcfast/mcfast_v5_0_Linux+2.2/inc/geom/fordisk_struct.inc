#include "fordisk_lyr_struct.inc"
#ifndef FORDISK_STRUCT
#define FORDISK_STRUCT

c                     
c                               PL McBride May 27, 1996
c   rmin, rmax and z  are parameters of
c   a FORDisk device, NOT a layer   
c
c   Forward disk detector (circular or 'fan') definition. 
c
c
c         numlyr		!Number of layers
c         nchan           	!total # of channel
c         lyr(max_fordisk_lyr)	!Layer params
c         name	        	!Name of device
c         rmin                  !Radius of inner wall
c         rmax                  !Radius of outer wall
c         zmin                  !Zmin of wall
c         zmax                  !Zmax of wall
c         material              !material filling device
c         thick_boun(4)         !effective thickness of material
c                               !at each rmin....zmax boundry
c         mat_boun(4)           !material at each rmin....zmax bound.
c

      integer max_fordisk_lyr
      parameter (max_fordisk_lyr = 50)

      structure /fordisk_struct/
        integer numlyr
        integer nchan
        record /fordisk_lyr_struct/
     *      lyr(max_fordisk_lyr)
        character*40 name
        real rmin
        real rmax
        real zmin
        real zmax
        integer material
        real thick_boun(4)
        integer mat_boun(4)
      end structure
#endif

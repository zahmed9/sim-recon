#include "for_trk_lyr_struct.inc"
#ifndef FOR_TRK_STRUCT
#define FOR_TRK_STRUCT
c
c   Forward Tracking detector definition. Several of these can
c   be defined at one time, each with different coverages.
c   Shape of detectors is supposed to be BOX.
c
c   The definition is very simple and based on geometrical coverage for now.
c   It will serve until we have a better idea of what we need.
c
c
c         name           !Name of device
c         xmin
c         xmax
c         ymin
c         ymax
c         zmin
c         zmax
c         thick_boun(6)  !effective thickness of material 
c                        !at each xmin .... zmax boundry
c         mat_boun(6)    !material at each boundry
c         material       !pointer for material filling device volume
c                        !in the mtl list (mtl. id)
c         nlyr           !number of layers
c         nchan          !total # of channels
c

      integer max_ftrk_lyr
      parameter (max_ftrk_lyr = 100)

      structure /for_trk_struct/
        character*40 name
        real xmin
        real xmax
        real ymin
        real ymax
        real zmin
        real zmax
        real thick_boun(6)
        integer mat_boun(6)
        integer material 
        integer nlyr 
        integer nchan
        record /for_trk_lyr_struct/ lyr(max_ftrk_lyr)
      end structure
#endif

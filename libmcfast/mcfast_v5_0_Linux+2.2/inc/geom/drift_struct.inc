#include "drf_anode_struct.inc"
#include "drf_cathode_struct.inc"
#ifndef DRIFT_STRUCT
#define DRIFT_STRUCT

c   Drift chamber definition. Several of these can be defined at one time.
c
c
c         num_anode		!Number of anode layers
c         num_cathode		!Number of cathode layers
c         rmin                  !Radius of inner wall
c         rmax                  !Radius of outer wall
c         zmin                  !Zmin of wall
c         zmax                  !Zmax of wall
c         thick_boun(4)         !effective thickness of material
c                               !at each rmin....zmax boundry
c         mat_boun(4)           !material at each rmin....zmax bound.
c         material              !material filling device
c         nchan                 !Total number of electronic channels
c         an(max_drf_anode)	!Array of anode params
c         cath(max_drf_cathode)	!Array of cathode params
c         name		        !Name of device
c
      integer max_drf_anode
      integer max_drf_cathode
      parameter (max_drf_anode = 100)
      parameter (max_drf_cathode = 2)

      structure /drift_struct/
        integer num_anode
        integer num_cathode
        real rmin
        real rmax
        real zmin
        real zmax
        real thick_boun(4)
        integer mat_boun(4)
        integer material
        integer nchan
        record /drf_anode_struct/
     *      an(max_drf_anode)
        record /drf_cathode_struct/
     *      cath(max_drf_cathode)
        character*40 name
      end structure
#endif

#ifndef RICH_STRUCT
#define RICH_STRUCT
c
c   Ring Imaging Cerenkov detector (RICH) definition. Several of these can
c   be defined at one time, each with different coverages.
c
c   The definition is very simple and based on geometrical coverage for now.
c   It will serve until we have a better idea of what we need.

      structure /rich_struct/
        character*4 shape       !Shape of the RICH detector
        real rmin(2)            !rmin at zmin and zmax
        real rmax(2)            !rmax at zmin and zmax
        real zmin               
        real zmax
        integer mat_rad         !Material of RICH radiator
        real thick_rad		!Thickness of RICH radiator
        real eta_min		!Min eta
        real eta_max		!Max eta
        integer material	!Type of material
        character*40 name	!Name of device
      end structure
#endif

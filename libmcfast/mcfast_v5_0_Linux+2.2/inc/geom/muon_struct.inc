#ifndef MUON_STRUCT
#define MUON_STRUCT

c   Muon detector definition. Several of these can be defined at one time,
c   each with different coverages.
c
c   The definition is very simple and based on geometrical coverage for now.
c   It will serve until we have a better idea of what we need.

      structure /muon_struct/
        integer type            !1 => barrel, 2 => forw. circular
        character*4 shape       !shape name
        real rmin(2)            !should be given at zmin and zmax
        real rmax(2)            !should be given at zmin and zmax
        real zmin               !
        real zmax               !
        real eta_min		!Min eta
        real eta_max		!Max eta
        integer nlyr            !# layers of tubes
        integer material        !Material number
        character*40 name	!Name of device
      end structure
#endif

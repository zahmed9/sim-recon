#ifndef HADCAL_STRUCT
#define HADCAL_STRUCT
c
c   June 27, 1995, Julia Yarba : added active_material
c
c
c   Hadronic calorimeter definition. Several of these can be defined
c   at one time, each with different coverages.
c
c   The definition is very simple and based on geometrical coverage for now.
c   It will serve until we have a better idea of what we need.

c   The resolution function is given by sig_E/E = a/E**0.5 + b

      structure /hadcal_struct/
        integer type            !1 => barrel, 2 => forw. circular
        character*4 shape       !shape name (can be BOX, TUBE or CONE)
        real rmin(2)            !rmin at zmin and zmax
        real rmax(2)            !rmax at zmin and zmax
        real zmin               !
        real zmax               !
        real eta_min		!Min eta
        real eta_max		!Max eta
        integer nphi            !# of phi segments
        integer neta            !# of eta segments
        integer material        !Material id 
        integer active_material !Active Material id (need for sampling calor.)
        real siga		!Constant a in resolution function
        real sigb		!Constant b in resolution function
        character*40 name	!Name of device
      end structure
#endif

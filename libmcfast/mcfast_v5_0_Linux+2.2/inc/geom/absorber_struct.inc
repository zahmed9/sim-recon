#ifndef ABSORBER_STRUCT
#define ABSORBER_STRUCT

c   Absorber definition. Several of these can be defined at one time,
c   each with different coverages.
c
c   The definition is very simple and based on geometrical coverage for now.
c   It will serve until we have a better idea of what we need.

      structure /absorber_struct/
        integer type            !1 => barrel, 2 => forw. 
        character*4 shape       !shape name
        real rmin(2)            !should be given at zmin and zmax
        real rmax(2)            !should be given at zmin and zmax
        real xlimit(2)          !xmin,xmax (forBOX)
        real ylimit(2)          !ymin,ymax (forBOX)
        real xlimit_gap(2)      !inner gap xmin,xmax (for BOX)
        real ylimit_gap(2)      !inner gap ymin,ymax (for BOX)
        real zmin               !
        real zmax               !
        real eta_min		!Min eta
        real eta_max		!Max eta
        integer material        !Material number
        character*40 name	!Name of device
      end structure
#endif

c   Volume definition. All volumes are cylindrically shaped and defined
c   by (rmin, rmax, zmin, zmax). Boundaries are infinitely thin but have
c   an "equivalent" thickness so that they have non-zero radiation length,
c   dE/dx, etc.

      structure /vol_struct/
        real rmin		!rmin of volume
        real rmax		!rmax of volume
        real zmin		!zmin of volume
        real zmax		!zmax of volume
        real thick_rmin		!Equivalent thickness of rmin bound.
        real thick_rmax		!Equivalent thickness of rmax bound.
        real thick_zmin		!Equivalent thickness of zmin bound.
        real thick_zmax		!Equivalent thickness of zmax bound.
        integer mat_rmin	!Material used in rmin boundary
        integer mat_rmax	!Material used in rmax boundary
        integer mat_zmin	!Material used in zmin boundary
        integer mat_zmax	!Material used in zmax boundary
        integer mat_fill	!Material used in volume interior
        character*40 name	!Name of volume
      end structure

c   Volume definition. All volumes are boxed shaped and defined
c   by (xmin, xmax, ,ymin, ymax, zmin, zmax). Boundaries are infinitely thin but have
c   an "equivalent" thickness so that they have non-zero radiation length,
c   dE/dx, etc.

      structure /volxy_struct/
        real xmin		!xmin of volume (1)
        real xmax		!xmax of volume (2)
        real ymin		!ymin of volume (3)
        real ymax		!ymax of volume (4)
        real zmin		!zmin of volume (5)
        real zmax		!zmax of volume (6)
        real thick_boun(6)	!Equivalent thickness of bound.
        integer mat_boun(6)	!Material used in boundary
        integer mat_fill	!Material used in volume interior
        character*40 name	!Name of volume
      end structure

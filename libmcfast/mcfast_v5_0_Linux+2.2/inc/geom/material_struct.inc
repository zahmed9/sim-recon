#ifndef MATERIAL_STRUCT
#define MATERIAL_STRUCT

c   Material definition

      integer max_mat_mix
      parameter (max_mat_mix = 10)

      structure /material_struct/
        real A                  !Atomic weight
        real Z                  !Atomic number
        real density            !Density
        real coll_len		!Collision length
        real abs_len		!Absorption length
        real rad_len		!Radiation length
        real dedx		!dE/dx per meter
        real coll_inv		!1/collision length
        real abs_inv		!1/absorption length
        real rad_inv		!1/radiation length
        character*40 name	!Name of material
        integer id(max_mat_mix) !IDs for materials composing mixture
        real ratio(max_mat_mix) !proportions by volume of materials to mix
      end structure
#endif

#ifndef FORDISK_SLICE_STRUCT
#define FORDISK_SLICE_STRUCT

c
c                             PL McBride May 27, 1996
c
c   Silicon circular disk slices definition.
c
c
c         type            ! 1 ==> r
c                         ! 2 ==> phi
c                         ! 3 ==> U 
c                         ! 4 ==> V
c                         ! ..... whatever .....
c         rmin
c         rmax
c         z               !global z position of layer
c         beta            !angle to the mid slice from x axis
c         cos_beta        !cos(beta)
c         sin_beta        !sin(beta)
c         d_phi           !"opening" angle for a slice
c         thick           !slice thickness
c         stereo          !stereo angle with respect to radius
c                         !drawn through a center of slice
c         cos_stereo      !cos(stereo)
c         sin_stereo      !sin(stereo)
c         eff_hit         !hit efficiency
c         ncells          !number of cells in a slice
c         cell_width
c         nchan
c         coord0_r        ! local r-coordinate if strip 0
c         coord0_phi      ! local phi-coordinate of strip 0
c         chan0
c         siga            !constants
c         sigb            !      in the resolution
c         sigc            !                    formula
c         material        !Material composing slice/disk
c

      structure /fordisk_slice_struct/
        integer type 
        real rmin
        real rmax
        real z 
        real beta
        real cos_beta
        real sin_beta
        real d_phi
        real thick
        real stereo
        real cos_stereo
        real sin_stereo
        real eff_hit
        integer ncells
        real cell_width
        integer nchan
        real coord0_r
        real coord0_phi
        integer chan0
        real siga
        real sigb
        real sigc
        integer material
      end structure
#endif

#ifndef SICIR_WEDGE_STRUCT
#define SICIR_WEDGE_STRUCT

c
c                             Julia Yarba, Oct.24, 1994
c
c   Silicon circular disk wedges definition.
c
c
c         type              ! 1 ==> r
c                           ! 2 ==> phi
c                           ! 3 ==> U 
c                           ! 4 ==> V
c                           ! ..... whatever .....
c         rmin
c         rmax
c         z
c         beta               !angle to the mid wedge from x axis
c         cos_beta           !cos(beta)
c         sin_beta           !sin(beta)
c         d_phi              !"opening" angle for a wedge
c         thick              !wedge thickness
c         stereo             !stereo angle with respect to radius
c                            !drawn through a center of wedge
c         cos_stereo         !cos(stereo)
c         sin_stereo         !sin(stereo)
c         eff_hit            !hit efficiency
c         nstrip             !number of strips in a wedge
c         pitch
c         nchan
c         coord0_r           ! local r-coordinate if strip 0
c         coord0_phi         ! local phi-coordinate of strip 0
c         chan0
c         siga               !constants
c         sigb               !      in the resolution
c         sigc               !                    formula
c         material           !Material composing wedge/disk
c
      structure /sicir_wedge_struct/
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
        integer nstrip 
        real pitch
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

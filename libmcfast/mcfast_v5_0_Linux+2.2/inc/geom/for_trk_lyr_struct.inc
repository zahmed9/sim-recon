#ifndef FOR_TRK_LYR_STRUCT
#define FOR_TRK_LYR_STRUCT
c
c                             Julia Yarba, Nov.10, 1994
c
      structure /for_trk_lyr_struct/
       integer type     ! See below.
       real xmin
       real xmax
       real ymin
       real ymax
       real xmin_gap
       real xmax_gap
       real ymin_gap
       real ymax_gap
       real z
       real thickness
       real stereo      !defines plane orientation with respect to x axis
       real cos_stereo  !cos(stereo) 
       real sin_stereo  !sin(stereo)
       integer ncell    !number of cells per layer
       real cell_size   !cell transverse dimension
       real coord0_x    !local x-coordinate of cell 0
       real coord0_y    !local y-coordinate of cell 0
       real eff_hit     !hit efficiency
       real siga        !constatnts 
       real sigb        !       in the
       real sigc        !          resolution formula
      end structure
#endif
c
c The type variable affects the interpretation of the stereo
c angle.  A full description can be found in the mcfast geometry
c writeup.  In brief, type=1 means that the frame remains aligned
c with the world x and y axes and that the wires are strung with the
c specified stereo angle within that frame.  Type=2 and 3 mean that
c the wires are strung parallel to the frame edges and that the entire
c device is rotated by the specified angle.
c

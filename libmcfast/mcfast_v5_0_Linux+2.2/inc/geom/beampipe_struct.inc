#ifndef BEAMPIPE_STRUCT
#define BEAMPIPE_STRUCT

c
c   Beam pipe definition
c
c
c        name           ! beampipe name
c        material       ! material filling beampipe (normaly Vacuum)
c        thick_boun(4)  ! thicknesses of beampipe boundries (rmin...zmax)
c                       ! normaly, it's non-0 only at RMAX
c        mat_boun(4)    ! material at each boundries
c
      structure /beampipe_struct/
       character*40 name
       real rmin            
       real rmax
       real zmin
       real zmax
       integer material
       real thick_boun(4)
       integer mat_boun(4)
      end structure
#endif

#ifndef EMCAL_STRUCT
#define EMCAL_STRUCT
c
c   June 27, 1995, Julia Yarba : added active_material
c
c
c   Electromagnetic detector definition. Several of these can be defined
c   at one time, each with different coverages.
c
c   The definition is very simple and based on geometrical coverage for now.
c   It will serve until we have a better idea of what we need.

c   The resolution function is given by sig_E/E = a/E**0.5 + b

c   modified 5/15/96 ASB added zero supression for output, moved ceta, cphi
c   size, added (as now) unused noise terms.

c   1/17/97 Julia Yarba : 
c   added variables to describe BOX-shaped calorimeters;
c   changed all phi-eta things to coor1-coor2 things.
c

      integer max_ncoor1  !max # of phi or x segments
      integer max_ncoor2  !max # of eta or y segments 
      parameter (max_ncoor1 = 256)
      parameter (max_ncoor2 = 333)



      structure /emcal_struct/
        integer type            !1 => barrel, 2 => forw. 
        integer seg_type        !0 eta-phi segmentation, 1 x-y segmentation
        character*4 shape       !shape name (can be BOX, TUBE or CONE)
        real rmin(2)            !rmin at zmin and zmax (for BOX/CONE)
        real rmax(2)            !rmax at zmin and zmia (for BOX/CONE)
        real xlimit(2)          !xmin,xmax (forBOX)
        real ylimit(2)          !ymin,ymax (forBOX)
        real xlimit_gap(2)      !inner gap xmin,xmax (forBOX)
        real ylimit_gap(2)      !inner gap ymin,ymax (forBOX)
        real zmin               !
        real zmax               !
        real eta_min		!Min eta
        real eta_max		!Max eta
        integer ncoor1          !# of phi or x segments
        integer ncoor2          !# of eta or y segments
        integer material        !Material number
        integer active_material !Active medium (important for sampling calorimeters)
        integer nlayers         !number of layers in a sampling calorimeter
        real siga_em		!Constant a in EM resolution function 
        real sigb_em		!Constant b in EM resolution function
        real sigc_em		!Constant c in EM resolution function (noise)
        real siga_had		!Constant a in HAD resolution function 
        real sigb_had		!Constant b in HAD resolution function
        real sigc_had		!Constant c in HAD resolution function(noise)
        real em_had_ratio       !e/pi ratio
        real zerosup            !threshold for writting out cells
        real c_coor1_size       ! cell size in phi or x units
        real c_coor2_size       ! cell size in eta or y units
        character*40 name	!Name of device
      end structure
#endif

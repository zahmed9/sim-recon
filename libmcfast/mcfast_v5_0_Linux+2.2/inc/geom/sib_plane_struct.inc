#ifndef SIB_PLANE_STRUCT
#define SIB_PLANE_STRUCT

c   Silicon barrel plane definition. a set of planes makes up a silicon
c   barrel layer. Each plane has the dimensions
c
c      [-dmin, dmax] in the r-phi direction
c      [-zmin, zmax] in the z direction
c
c Notes:
c
c 1) The resolution function is given by sig = a + b*|costh| +c*costh**2
c
c 2) The parameter beta is different than the parameter beta in
c    the template file!  See geometry.ps on
c    http://fnpspa.fnal.gov/mcfast/version_doc/vx_y/doc_index.html
c    where vx_y describes the MCFast version of interest.
c
c
c         type          !1 ==> r-phi measurement
c                       !2 ==> z measurement
c         dmin          !dmin of plane (in r-phi direction)
c         dmax          !dmax of plane (in r-phi direction)
c         zmin          !zmin of plane
c         zmax          !zmax of plane
c         beta          !Angle between normal to plane & x axis
c                       !See note 2).
c         xpos(3)       !Center of the wafer.  Undefined if it is
c                       !on the mid-plane or on the inner surface.
c         eta(3)        !Direction cosines of normal to plane
c         delta_min     !Distance from origin to mid plane
c         delta_max     !Max distance from origin to edge of plane
c         thick         !Thickness of plane
c         tilt          !tilt angle for plane
c         eff_hit       !hit efficiency
c         siga          !Constant a in resolution formula. See note 1).
c         sigb          !Constant b in resolution formula
c         sigc          !Constant c in resolution formula
c         material      !Material composing plane
c         coord0_x      !Local x-coordinate of strip 0
c         coord0_y      !Local y-coordinate of strip 0
c         pitch         !Spacing of strips
c         nstrip        !Number of strips in this plane
c         nchan         !Number of channels in this plane
c         chan0         !Channel corresp. to 1st strip in plane
c         stereo        !stereo angle in rad
c         cos_stereo    !cos(stereo)
c         sin_stereo    !sin(stereo)
c

      structure /sib_plane_struct/
        integer type 
        real dmin 
        real dmax 
        real zmin
        real zmax
        real beta 
        real xpos(3) 
        real eta(3)
        real delta_min 
        real delta_max
        real thick 
        real tilt 
        real eff_hit
        real siga 
        real sigb 
        real sigc 
        integer material 
        real coord0_x  
        real coord0_y  
        real pitch     
        integer nstrip
        integer nchan  
        integer chan0   
        real stereo   
        real cos_stereo 
        real sin_stereo 
      end structure
#endif

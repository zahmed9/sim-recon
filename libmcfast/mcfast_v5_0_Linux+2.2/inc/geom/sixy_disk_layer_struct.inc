#ifndef SIXY_DISK_LAYER_STRUCT
#define SIXY_DISK_LAYER_STRUCT

c   Silicon xy disk layer definition.
c
c
c         type          ! 1 ==> pixel
c                       ! 2 ==> strip
c         xmin		!xmin of plane
c         xmax		!xmax of plane
c         ymin		!ymin of plane
c         ymax		!ymax of plane
c         z		!z of plane
c         thick		!Thickness of plane
c         xmin_gap	!xmin of gap in plane
c         xmax_gap	!xmax of gap in plane
c         ymin_gap	!ymin of gap in plane
c         ymax_gap	!ymax of gap in plane
c         nsegm_x       !# of segments in x direction
c         nsegm_y       !# of segments in y direction
c         nchan         !# of channels in this layer
c         pitch_x       !segment pitch in x direction
c         pitch_y       !segment pitch in y direction
c         coord0_x      !x-coordinate of the 0-segment
c         coord0_y      !y-coordinate of the 0-segment
c         stereo        !strip orientation with respect to x axis
c         eff_hit	!hit efficiency
c         siga_x        !resolution of x-measurment
c         siga_y        !resolution of y-measurment
c         material	!Material composing disk
c
      structure /sixy_disk_layer_struct/
        integer type 
        real xmin
        real xmax
        real ymin
        real ymax
        real z	
        real thick
        real xmin_gap
        real xmax_gap
        real ymin_gap
        real ymax_gap
        integer nsegm_x
        integer nsegm_y 
        integer nchan
        real pitch_x
        real pitch_y
        real coord0_x
        real coord0_y 
        real stereo
        real eff_hit
        real siga_x
        real siga_y 
        integer material
      end structure
#endif

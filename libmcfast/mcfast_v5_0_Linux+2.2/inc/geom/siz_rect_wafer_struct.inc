#ifndef SIZ_RECT_WAFER_STRUCT
#define SIZ_RECT_WAFER_STRUCT

c   Silicon rectangular z disk layer definition.
c
c
c         type          ! 1 ==> pixel
c                       ! 2 ==> strip
c         xLocal	!x of plane center (layer coord.system)
c         yLocal	!y of plane center (layer coord.system)
c         z		!z of plane center (global coord.system)
c         xlen		!Length of plane along x (layer sys.)
c         ylen		!Length of plane along y (layer sys.)
c         zlen		!Thickness of plane along z direction
c         nsegm_x       !# of segments in x direction
c         nsegm_y       !# of segments in y direction
c         nchan         !# of channels in this layer
c         pitch_x       !segment pitch in x direction
c         pitch_y       !segment pitch in y direction
c         coord0_x      !x-coordinate of the 0-segment
c         coord0_y      !y-coordinate of the 0-segment
c         stereo        !strip orientation wrt wafer x axis
c         eff_hit	!hit efficiency
c         siga_x        !resolution of x-measurment
c         siga_y        !resolution of y-measurment
c         material	!Material composing disk
c
      structure /siz_rect_wafer_struct/
        integer type
        real xLocal
        real yLocal
        real z
        real xlen
        real ylen
        real zlen
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

#ifndef ZPLANE_STRUCT
#define ZPLANE_STRUCT

c   Measurement or material z plane structure

#include "zplane_types.inc"
      
      structure /zplane_struct/
        integer type    !Type of layer as defined above
        integer pos(3)  !Identifies position in list of original objects
        integer shape   !1 = circular / 2 = rectangular
        real z          !z position of layer
        real rmin       !minimum radius, if applicable
        real rmax       !maximum radius, if applicable
        real xmin       !minimum extent in x, if applicable
        real xmax       !maximum extent in x, if applicable
        real ymin       !minimum extent in y, if applicable
        real ymax       !maximum extent in y, if applicable
        real col        !# of collision lengths
        real abs        !# of absorption lengths
        real radl       !# of radiation lengths
        real dedx       !dE/dx (GeV)
        character*40 name !Name (for dumping purposes)
      end structure



c ======================================================================
c Comments, suggestions -- get on line 1!
c
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:40  eugenio
c Initial revision
c
c Revision 1.3  1997/03/27 22:03:02  mkl
c moved detector-defining parameter statements out of r/zplane_struct.inc into r/zplane_types.inc/.hh
c
c

#endif

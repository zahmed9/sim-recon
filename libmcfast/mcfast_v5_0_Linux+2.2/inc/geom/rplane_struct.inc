#ifndef RPLANE_STRUCT
#define RPLANE_STRUCT

c   Measurement or material radial structure

#include "rplane_types.inc"

      structure /rplane_struct/
        integer type    !Type of layer as defined above
        integer pos(3)  !Identifies position in list of original objects
        real radius     !Radius of layer
        real zmin       !Zmin of layer
        real zmax       !Zmaxof layer
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
c Revision 1.2  1997/03/27 22:03:01  mkl
c moved detector-defining parameter statements out of r/zplane_struct.inc into r/zplane_types.inc/.hh
c
c

#endif

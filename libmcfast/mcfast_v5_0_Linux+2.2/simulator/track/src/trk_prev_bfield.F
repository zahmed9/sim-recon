      subroutine trk_prev_bfield(w, bf)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Return the magnitude and direction cosines of the magnetic field
c   at a point just in back of a track's current position.
c
c  w        w track structure (read)
c           Track parameters
c
c *bf       bfield structure (write)
c           B field information re eturned to user
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

      save

#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     Calling arguments
      record /wtrack_struct/ w
      record /bfield_struct/ bf

c     Local variables
      DFLOAT x(3), temp
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      temp = 1.E-4 * unit_meter / w.p       !Move 100 microns along track
      x(1) = w.x - w.px*temp
      x(2) = w.y - w.py*temp
      x(3) = w.z - w.pz*temp

      call get_bfield(x, bf)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:39  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:32  garren
c add rcs log line
c

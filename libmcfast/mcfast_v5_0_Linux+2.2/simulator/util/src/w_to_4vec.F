      subroutine w_to_4vec_d ( trk, p )
c
c Convert a w_track to a 4 vector.
c

      implicit none

#include "offline_track_struct.inc"

      record /offline_track_struct/ trk
      DFLOAT p(4)

      p(1) = trk.w.px
      p(2) = trk.w.py
      p(3) = trk.w.pz
      p(4) = sqrt(trk.mass**2 + trk.w.p**2)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.5  1998/04/27 20:26:26  garren
c put "implicit none" first
c
c Revision 1.4  1998/04/27  02:18:16  kutschke
c real*8 to DFLOAT
c
c Revision 1.3  1997/04/04  20:31:59  garren
c add rcs log line
c

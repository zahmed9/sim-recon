      integer function move_wtk_arcpath(w1, slen, bf, w2)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a helix expressed in w form and calculates the new parameters
c  a distance along the trajectory in an arbitrarily oriented, fixed
c  B field.
c
c  w1       w track structure (read)
c           Initial track parameters
c
c  slen     Arc structure (read)
c           Arc length information
c
c  bf       B field structure (read)
c           B field information
c
c *w2       w track structure (write)
c           Track parameters after move
c
c return    
c           0 ==> all OK
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "arc_struct.inc"

c     Externals
      integer  move_wtk_arcpath_b0
c      integer  move_wtk_arcpath_bx
c      integer  move_wtk_arcpath_by
      integer  move_wtk_arcpath_bz
      external move_wtk_arcpath_b0
c      external move_wtk_arcpath_bx
c      external move_wtk_arcpath_by
      external move_wtk_arcpath_bz

c     calling arguments
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      record /arc_struct/ slen

c     local variables
      integer status
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w1.q .eq. 0.) goto 100

      goto (100, 110, 120, 130, 140, 150, 160, 170), bf.type + 1

 100  status = move_wtk_arcpath_b0(w1, slen, bf, w2)
      goto 500

 110  status = move_wtk_arcpath_b0(w1, slen, bf, w2)
      goto 500

 120  status = move_wtk_arcpath_b0(w1, slen, bf, w2)
      goto 500

 130  status = move_wtk_arcpath_b0(w1, slen, bf, w2)
      goto 500

 140  status = move_wtk_arcpath_bz(w1, slen, bf, w2)
      goto 500

 150  status = move_wtk_arcpath_b0(w1, slen, bf, w2)
      goto 500

 160  status = move_wtk_arcpath_b0(w1, slen, bf, w2)
      goto 500

 170  status = move_wtk_arcpath_b0(w1, slen, bf, w2)

 500  move_wtk_arcpath = status
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:42  garren
c add rcs log line
c

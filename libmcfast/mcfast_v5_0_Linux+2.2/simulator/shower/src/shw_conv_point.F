
      integer function shw_conv_point(id_part,ical,w,tconv,w1)

c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c     Author : Julia Yarba, FNAL/CD
c              8-6-96
c     Simulates either HAD or EM shower (depends on id_part)
c     conversion point in material filling calorimeter #ical;
c     checks if the point is inside calorimeter volume & returns 0;
c     if not, returns 1
c
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "material.inc"
#include "emcal.inc"
#include "wtrack_struct.inc"
#include "bfield_struct.inc"

c     Calling arguments
      integer id_part
      integer ical
      record /wtrack_struct/ w, w1 
      DFLOAT tconv

c     Externals
      external rann, move_wtk_arc
      real rann
      integer move_wtk_arc

c     Local variables
      record /bfield_struct/ bf
      integer status
      logical lstrike

c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (abs(id_part) .eq. 13) goto 500  ! no conv.point for muons

      tconv = dble(-alog(rann(0)))
      status = 0
      lstrike = .false.

      call trk_next_bfield(w, bf)
            
      if (abs(id_part) .eq. 11 .or. id_part .eq. 22) then   ! EM case
       tconv = tconv * mtl_par(emcal_par(ical).material).rad_len
      else                                                  ! HAD case
       tconv = tconv * mtl_par(emcal_par(ical).material).abs_len
      end if

      status = move_wtk_arc(w, tconv, bf, w1)

      call emcal_find_ical(w1,ical,lstrike)

      if (.not.lstrike) goto 500

      shw_conv_point = status

      return
 
  500 shw_conv_point = 1
      tconv = 0.
      call ucopy(w, w1, WTRACK_WORD)

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:28  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:11  garren
c add rcs log line
c

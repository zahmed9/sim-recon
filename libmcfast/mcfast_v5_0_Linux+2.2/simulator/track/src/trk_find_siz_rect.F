      subroutine trk_find_siz_rect(w, dev, lyr, wfr, lstrike, eta)
c================================================================
c Julia Yarba, FNAL/CD-PAT, 10/14/97
c Paul Avery,  10/18/97
c================================================================
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Determine if a track went through a rectangular silicon z wafer
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c
c Input :
c  w          w track structure
c             Track parameters
c
c  dev        integer variable
c             Silicon plane array device number
c
c  lyr        integer variable
c             Number of plane that was hit
c  Outputs:
c
c  lstrike    logical variable
c             TRUE if track hits wafer wfr
c
c  wfr        integer variable
c             The wafer #
c
c  eta(3)     DFLOAT array
c             Direction cosines normal to plane
c
c================================================================

      implicit none

#include "const.inc"
#include "siz_rect.inc"
#include "wtrack_struct.inc"

c     Calling arguments
      integer dev, lyr, wfr
      logical lstrike
      DFLOAT eta(3)
      record /wtrack_struct/ w

c     Local variables
      DFLOAT point(3)
c================================================================

      point(1) = w.x
      point(2) = w.y
      point(3) = w.z
      call geo_siz_rect_find_wafer(point, dev, lyr, wfr, lstrike )

      if(lstrike) then
        eta(1) = 0.
        eta(2) = 0.
        eta(3) = 1.
      endif

      return
      end

c Revision 1.5  1997/10/23  21:31:26  yarba_j
c updated to account for new pixel geometry
c
c Revision 1.4  1997/10/06  23:10:08  yarba_j
c renamed rotate -> tilt
c
c Revision 1.3  1997/04/04  20:30:23  garren
c add rcs log line
c

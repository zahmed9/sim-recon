      subroutine dhfill(id,x,y,wt)
c
c     created aug-17-1994 A. Boehnlein
c     interface to HFILL, converts double precision values to single for
c     histogramming.  Arguments the same as HFILL
#include "const.inc"
c
c     Inputs:
      integer id    ! the histogram id
      DFLOAT  x     ! x value for the histogram
      DFLOAT  y     ! y value for histogram 
      DFLOAT  wt    ! weighting factor
      
      real   sp_x
      real   sp_y
      real   sp_wt
      
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

      sp_x  = sngl(x)
      sp_y  = sngl(y)
      sp_wt = sngl(wt)
      
      call hfill(id,sp_x,sp_y,sp_wt)
      return 
      end            

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:27  garren
c add rcs log line
c

      subroutine dhf2(id,x,y,wt)
c
c     double precision interface to hf2, 
c     see hbook manual for restrictions to fast filling routines
c
c     created aug-18-1994, Amber Boehnlein
c
       implicit none
#include "const.inc"
c      inputs
       integer id    ! histogram id
       DFLOAT x      ! value to histogram
       DFLOAT y      ! value to histogram
       DFLOAT wt     ! weight
       
       real sng_x,sng_y
       real sng_wt
       
       sng_x  = sngl(x)
       sng_y  = sngl(y)
       sng_wt = sngl(wt)
       
       call hf2(id,sng_x,sng_y,sng_wt)
       return
       end 

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:26  garren
c add rcs log line
c


      subroutine shw_trans_prof(rlimit,sigma_n,sigma_w,thresh,
     *                         rdep,phidep)
c
c     Julia V. Yarba; 4-1-1996
c
      implicit none

#include "const.inc"

c
c     Calling arguments
c
c     Input :
c
      real rlimit,sigma_n,sigma_w,thresh
c
c     Output :
c
      real rdep, phidep
c
c     Local variables 
c
      real sigma
c
c     Externals
c
      external rann
      real rann

c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (rann(0) .ge. thresh) then
       sigma = sigma_n
      else
       sigma = sigma_w
      end if

c     Find "random" radius
   1  rdep = abs(sigma * alog(rann(0)))
      if (rdep .gt. rlimit) goto 1

c     Find angle phi
      phidep = tpi * rann(0)

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:28  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:12  garren
c add rcs log line
c

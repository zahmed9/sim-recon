c
      subroutine clear_shower_trace(shower)
c
      implicit none
c
#include "shower_trace_struct.inc"
c
c     Calling arguments
c
c     Input :
c
      record /shower_trace_struct/ shower  
c
c     Output : none
c
      shower.hep = 0
      shower.n_radlen_pass = 0.
      shower.E_original = 0.
      call vzero(shower.w,WTRACK_WORD)
c
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:28  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:07  garren
c add rcs log line
c

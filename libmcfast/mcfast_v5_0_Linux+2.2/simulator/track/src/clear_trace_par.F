c
      subroutine clear_trace_par(itrace)
c
      implicit none
c
#include "trace.inc"
c
c     Calling argument
c
c     Input :
c
      integer itrace    ! trace #
c
c     Output : none
c
      trace_par(itrace).hep   = 0
      trace_par(itrace).type  = 0
      trace_par(itrace).plane = 0
      trace_par(itrace).hit   = 0
      call vzero(trace_par(itrace).w,WTRACK_WORD)
      trace_par(itrace).eta(1)= 0.
      trace_par(itrace).eta(2)= 0.
      trace_par(itrace).eta(3)= 0.
      trace_par(itrace).time  = 0.
      trace_par(itrace).tau   = 0.
      trace_par(itrace).material = 0
      trace_par(itrace).radl  = 0.
      trace_par(itrace).dedx  = 0.
c
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:35  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:13  garren
c add rcs log line
c

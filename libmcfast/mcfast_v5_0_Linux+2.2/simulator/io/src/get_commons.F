      subroutine get_commons
*
*       Dummy routine to pull in the Fortran-defined data structure globals
*
#include "mcfdat_dst.inc"
c
c	Common added to avoid unresolved external while linking the Explorer 
c	or other I/O application possibly using the Calorimetry. 
c
c#include "cal_hit.inc"
c	Sorry, this needs to be negotiated ...
c
      integer iloop
      do iloop = 1, hit_trk_max
        hit_trk(iloop).hep   = 0
        hit_trk(iloop).trace = 0
        hit_trk(iloop).pos(1) = 0.0
        hit_trk(iloop).pos(2) = 0.0
        hit_trk(iloop).pos(3) = 0.0
        hit_trk(iloop).dircos(1) = 0.0
        hit_trk(iloop).dircos(2) = 0.0
        hit_trk(iloop).dircos(3) = 0.0
        hit_trk(iloop).dtime_exact = 0.0
        hit_trk(iloop).dtime       = 0.0
        hit_trk(iloop).dtime_sigma = 0.0
        hit_trk(iloop).dmeas_exact = 0.0
        hit_trk(iloop).dmeas       = 0.0
        hit_trk(iloop).dmeas_sigma = 0.0
        hit_trk(iloop).dpix_exact(1) = 0.0
        hit_trk(iloop).dpix(1)       = 0.0
        hit_trk(iloop).dpix_cov(1,1) = 0.0
        hit_trk(iloop).dpix_exact(2) = 0.0
        hit_trk(iloop).dpix(2)       = 0.0
        hit_trk(iloop).dpix_cov(2,1) = 0.0
      enddo
      do iloop = 1, hep_trace_max
        hep_trace(iloop).nhit         = 0
        hep_trace(iloop).first_hit    = 0
        hep_trace(iloop).ntrace       = 0
        hep_trace(iloop).first_trace  = 0      
      enddo
      do iloop = 1, trace_max
         trace_par(iloop).hep = 0
         trace_par(iloop).type = 0
         trace_par(iloop).plane = 0
         trace_par(iloop).hit = 0
         trace_par(iloop).w.px = 0.0
         trace_par(iloop).w.py = 0.0
         trace_par(iloop).w.pz = 0.0
         trace_par(iloop).w.e = 0.0
         trace_par(iloop).w.x = 0.0
         trace_par(iloop).w.y = 0.0
         trace_par(iloop).w.z = 0.0
         trace_par(iloop).w.pt = 0.0
         trace_par(iloop).w.p = 0.0
         trace_par(iloop).w.q = 0.0         
         trace_par(iloop).eta(1) = 0.0
         trace_par(iloop).eta(2) = 0.0
         trace_par(iloop).eta(3) = 0.0
         trace_par(iloop).path = 0.0
         trace_par(iloop).time = 0.0
         trace_par(iloop).tau = 0.0
         trace_par(iloop).material = 0.0
         trace_par(iloop).radl = 0.0
         trace_par(iloop).dedx = 0.0
      enddo
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:26  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:00  garren
c add rcs log line
c

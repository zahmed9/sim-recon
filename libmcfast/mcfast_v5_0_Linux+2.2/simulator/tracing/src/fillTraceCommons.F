C -*- Fortran -*-
C
C Package:     Tracing
C Module:      FillTraceCommons
C 
C Description:
C
C       fill trace common block for old-style (pre-Rob) tracking 
C         and visualization with Iris Explorer
C
C Implimentation:
C     <Notes on implimentation>
C
C Author:      Martin Lohner
C Created:     Feb 23, 1997

      Integer function fill_trace_commons( traceNumber, trace, 
     <                                                  wtrack,
     <                                                  hitIndexF )
      implicit none
C -----------------------------------------------------------------------
C   fill trace commons with trace info
C -----------------------------------------------------------------------

c global common block containing traces
#include "trace.inc"
#include "mcp_summary.inc"

c --------------- calling parameters ---------------------------

      integer traceNumber, hitIndexF

c need my own, not the one from "trace.inc"
#include "mkl_trace_struct.inc"
      record /mkl_trace_struct/ trace

c should be fine here, since I use the same as the official
#include "wtrack_struct.inc"
      record /wtrack_struct/ wtrack

c ---------------- local variables -----------------------------
      integer i

c -------------------- code ------------------------------------

c      print *, 'Here in fill_trace_commons'
c      print *, 'trace.hep', trace.hep

c Increment trace #
      trace_num = trace_num + 1 

      if( trace_num .gt. trace_max ) then
c If overflow, report error
        print *, 'fill_trace_commons: event ', mcp_all.event,
     *           ', track ', trace.hep,
     *           ' exceeding array limit ', trace_max
        trace_num = trace_num - 1
        fill_trace_commons=1
        return
      endif

c copy trace info to common block
c      print *, 'trace_num', trace_num

      trace_par(trace_num).hep  = trace.hep 

      trace_par(trace_num).hit  = hitIndexF          ! HitRecord.index

      trace_par(trace_num).w.px = wtrack.px
      trace_par(trace_num).w.py = wtrack.py
      trace_par(trace_num).w.pz = wtrack.pz
      trace_par(trace_num).w.E  = wtrack.E
      trace_par(trace_num).w.x  = wtrack.x
      trace_par(trace_num).w.y  = wtrack.y
      trace_par(trace_num).w.z  = wtrack.z
      trace_par(trace_num).w.pt = wtrack.pt
      trace_par(trace_num).w.p  = wtrack.p
      trace_par(trace_num).w.q  = wtrack.q

      do i=1,3
        trace_par(trace_num).eta(i)=0                 ! trace.eta(i)
      enddo

      trace_par(trace_num).path = trace.path
      trace_par(trace_num).time = trace.time
      trace_par(trace_num).tau  = trace.tau

      trace_par(trace_num).material = trace.material
      trace_par(trace_num).radl     = trace.radl
      trace_par(trace_num).dedx     = trace.dedx

      ! ------------------------------------------------
      ! only filled because some tracking routines want them
      trace_par(trace_num).type  = trace.type
      trace_par(trace_num).plane = trace.plane
      do i=1,3
        trace_par(trace_num).eta(i) = trace.eta(i)
      enddo

c report success
      fill_trace_commons=0
      return

      end


c ======================================================================
c Questions, suggestions -- get on line 1!
c
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:34  eugenio
c Initial revision
c
c Revision 1.4  1998/07/07 16:31:31  yarba_j
c updated so that integrated tracing routine can be called from fortran usr_before_trigger, with loop over particles be in usr_before_trigger
c
c Revision 1.3  1997/11/21  04:15:31  mkl
c write traces for material planes even when MS/Eloss flags aren't set
c
c Revision 1.2  1997/08/29  16:34:52  mkl
c abolished 'record' as part of variable names
c
c Revision 1.1  1997/07/03  03:33:59  mkl
c new approach: surfaces vs volumes; box tracing
c
c


C -*- Fortran -*-
C
C Package:     Tracing
C Module:      FillHepTraceCommons
C 
C Description:
C
C       fill hep trace common block for old-style (pre-Rob) tracking
C         and visualization with Iris Explorer
C
C Implimentation:
C     <Notes on implimentation>
C
C Author:      Martin Lohner
C Created:     Feb 23, 1997

      Integer function fill_hep_trace_commons( pnumber,
     *                                         n_traces, first_trace, 
     *                                         n_hits,   first_hit )
      implicit none
C -----------------------------------------------------------------------
C   fill hep_trace commons with trace and hit info
C -----------------------------------------------------------------------

c global common block containing traces
#include "hep_trace.inc"
#include "trace.inc"

c --------------- calling parameters ---------------------------

      integer pnumber
      integer n_traces, n_hits
      integer first_trace, first_hit
      integer first_tr
   
c ---------------- local variables -----------------------------

c -------------------- code ------------------------------------

c      print *, 'Here in fill_hep_trace_commons'

c increment counter

c      print *, 'filling hep_trace for particle #=', pnumber

      if( pnumber .gt. hep_trace_max ) then
        print *, 'fill_hep_trace_commons: track ', pnumber,
     *           ' exceeding array limit ', hep_trace_max
        fill_hep_trace_commons=1
        return
      endif

c copy hep_trace info to common block

      first_tr = trace_num - n_traces + 1
      n_obj_hep_trace = pnumber
      hep_trace(pnumber).ntrace      = n_traces
      hep_trace(pnumber).first_trace = trace_num - n_traces + 1
      hep_trace(pnumber).nhit        = n_hits
      hep_trace(pnumber).first_hit   = first_hit

c report success

      fill_hep_trace_commons=0
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
c Revision 1.2  1998/07/07 16:31:31  yarba_j
c updated so that integrated tracing routine can be called from fortran usr_before_trigger, with loop over particles be in usr_before_trigger
c
c Revision 1.1  1997/07/03  03:33:59  mkl
c new approach: surfaces vs volumes; box tracing
c
c




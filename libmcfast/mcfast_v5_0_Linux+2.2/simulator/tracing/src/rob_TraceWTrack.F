C -*- Fortran -*-
C
C Package:     Tracing
C Module:      Rob_TraceWTrack
C 
C Description:
C
C This file contains Fortran access functions to structures (records)
C internal to the C++ TRACING routines.
C
C Implimentation:
C     <Notes on implimentation>
C
C Author:      Martin Lohner
C Created:     Jan 23, 1997

C -----------------------------------------------------------------------
c mkl_take_out
c#include "stdhep.inc"   ! only included to provide memory space for now
C -----------------------------------------------------------------------


c =======================================================================

      Integer function Rob_TraceWTrack( wtrack )
C -----------------------------------------------------------------------
C   return XTrack pertinenet to Trace
C -----------------------------------------------------------------------

c --------------- calling parameters ---------------------------

#include "wtrack_struct.inc"

      record /wtrack_struct/ wtrack

c ---------------- local variables -----------------------------

c -------------------- code ------------------------------------

      !print *, 'Here in Rob_TraceWTrack'

c report success

      Rob_TraceWTrack=0
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
c Revision 1.2  1997/08/29 16:34:55  mkl
c abolished 'record' as part of variable names
c
c Revision 1.1  1997/07/03  03:34:04  mkl
c new approach: surfaces vs volumes; box tracing
c
c

C -*- Fortran -*-
C
C Package:     Tracing
C Module:      rob_TraceBField
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

      Integer function Rob_TraceBField( bfield )
C -----------------------------------------------------------------------
C   return BField pertinent to this Trace
C -----------------------------------------------------------------------

c --------------- calling parameters ---------------------------

#include "bfield_struct.inc"
      record /bfield_struct/ bfield

c ---------------- local variables -----------------------------

c -------------------- code ------------------------------------

      !print *, 'Here in Rob_TraceBField'

c report success

      Rob_TraceBField=0
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
c Revision 1.2  1997/08/29 16:34:53  mkl
c abolished 'record' as part of variable names
c
c Revision 1.1  1997/07/03  03:34:03  mkl
c new approach: surfaces vs volumes; box tracing
c
c

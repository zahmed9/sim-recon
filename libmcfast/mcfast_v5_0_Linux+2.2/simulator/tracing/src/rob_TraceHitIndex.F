C -*- Fortran -*-
C
C Package:     Tracing
C Module:      rob_TraceHitIndex
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

      Integer function Rob_TraceHitIndex( index )
C -----------------------------------------------------------------------
C   return HitRecord
C -----------------------------------------------------------------------

c --------------- calling parameters ---------------------------

#include "hit_track.inc"

c ---------------- local variables -----------------------------

      integer index

c -------------------- code ------------------------------------

#if 0
      print *, 'Here in Rob_TraceHit'

c print some numbers

      print *, 'hep=',         hit_trk(index).hep
      print *, 'trace=',       hit_trk(index).trace
      print *, 'pos(1..3)=',   hit_trk(index).pos(1), ' ', 
     >                         hit_trk(index).pos(2), ' ', 
     >                         hit_trk(index).pos(3)
      print *, 'dircos(1..3)', hit_trk(index).dircos(1), ' ', 
     >                         hit_trk(index).dircos(2), ' ', 
     >                         hit_trk(index).dircos(3)
#endif 

c report success

      Rob_TraceHitIndex=0
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
c Revision 1.2  1997/08/29 16:34:54  mkl
c abolished 'record' as part of variable names
c
c Revision 1.1  1997/07/03  03:34:04  mkl
c new approach: surfaces vs volumes; box tracing
c
c

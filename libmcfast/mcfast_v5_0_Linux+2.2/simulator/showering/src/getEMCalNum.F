C -*- Fortran -*-
C
C Package:     Tracing
C Module:      getEMCalNum
C 
C Description: fortran interface to get number of EMCalorimeters
C
C Implimentation:
C     <Notes on implimentation>
C
C Author:      Martin Lohner
C Created:     Aug 20, 1997

C -----------------------------------------------------------------------

#ifdef AIX
      function get_emcal_num()
#else
      function get_emcal_num
#endif
      integer get_emcal_num

C -----------------------------------------------------------------------
C   return number of emcals from common block
C -----------------------------------------------------------------------

#include "emcal.inc"

c --------------- calling parameters ---------------------------

c ---------------- local variables -----------------------------

c -------------------- code ------------------------------------

c fill info from common blocks
      get_emcal_num = emcal_num

c report success
      return

      end


c ======================================================================
c Questions, suggestions -- get on line 1!
c
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:30  eugenio
c Initial revision
c
c Revision 1.3  1998/07/10 23:49:15  bphyslib
c AIX is hopelessly wierd
c
c Revision 1.2  1998/07/10  22:52:38  bphyslib
c integer functions with no calling arguments
c need to be defined in 2 lines (function x, integer x)
c
c Revision 1.1  1997/08/23  01:10:20  mkl
c toward volume-based tracing
c
c
c


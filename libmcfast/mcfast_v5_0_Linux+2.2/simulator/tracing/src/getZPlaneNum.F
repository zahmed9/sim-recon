C -*- Fortran -*-
C
C Package:     Tracing
C Module:      getZPlaneNum
C 
C Description: fortran interface to get number of zplanes
C
C Implimentation:
C     <Notes on implimentation>
C
C Author:      Martin Lohner
C Created:     Feb 23, 1997

C -----------------------------------------------------------------------

#ifdef AIX
      function get_zplane_num()
#else
      function get_zplane_num
#endif
      integer get_zplane_num

C -----------------------------------------------------------------------
C   return number of zplanes from common block
C -----------------------------------------------------------------------

#include "zplane.inc"

c --------------- calling parameters ---------------------------

c ---------------- local variables -----------------------------

c -------------------- code ------------------------------------

c fill info from common blocks
      get_zplane_num = zpln_num

c report success
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
c Revision 1.3  1998/07/10 23:49:17  bphyslib
c AIX is hopelessly wierd
c
c Revision 1.2  1998/07/10  22:52:39  bphyslib
c integer functions with no calling arguments
c need to be defined in 2 lines (function x, integer x)
c
c Revision 1.1  1997/07/03  03:34:02  mkl
c new approach: surfaces vs volumes; box tracing
c
c


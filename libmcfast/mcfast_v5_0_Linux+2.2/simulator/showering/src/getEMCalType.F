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

      integer function emcal_is_not_cylinder( index )

C -----------------------------------------------------------------------
C   return number of emcals from common block
C -----------------------------------------------------------------------

#include "emcal.inc"

c --------------- calling parameters ---------------------------

      integer index

c ---------------- local variables -----------------------------

c -------------------- code ------------------------------------

      emcal_is_not_cylinder = 0

      ! make sure index is ok
      if( index .gt. emcal_num .or. index .lt. 1) then
        print *, 'getEMCalInfo: bad index=', index
        return
      endif

      if (emcal_par(index).shape .ne. 'TUBE') 
     * emcal_is_not_cylinder = 1

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
c Revision 1.2  1999/02/15 19:04:17  mkl
c added Box-shaped Calorimeters
c
c Revision 1.1  1997/08/23  01:10:20  mkl
c toward volume-based tracing
c
c
c


C -*- Fortran -*-
C
C Package:     Showering
C Module:      getEMCalType_Box
C 
C Description: find out if emcal type is box
C
C Implimentation:
C     <Notes on implimentation>
C
C Author:      Martin Lohner
C Created:     Mon Feb 15, 1999

C -----------------------------------------------------------------------

      integer function emcal_is_box( index )

C -----------------------------------------------------------------------
C   return boolean based on type
C -----------------------------------------------------------------------

#include "emcal.inc"

c --------------- calling parameters ---------------------------

      integer index

c ---------------- local variables -----------------------------

c -------------------- code ------------------------------------

      emcal_is_box = 0 

      ! make sure index is ok
      if( index .gt. emcal_num .or. index .lt. 1) then
        print *, 'getEMCalInfo: bad index=', index
        return
      endif

      if (emcal_par(index).shape .eq. 'BOX') emcal_is_box = 1

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
c Revision 1.1  1999/02/15 19:04:17  mkl
c added Box-shaped Calorimeters
c
c Revision 1.1  1997/08/23  01:10:20  mkl
c toward volume-based tracing
c
c
c


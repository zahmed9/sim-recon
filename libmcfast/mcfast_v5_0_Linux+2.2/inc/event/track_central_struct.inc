#ifndef TRACK_CENTRAL_STRUCT
#define TRACK_CENTRAL_STRUCT

c     Track parametrization in central region in solenoidal field

#include "const.inc"
#include "ctrack_struct.inc"

      structure /track_central_s/
        record /ctrack_struct/ c   !Central track parameters
        DFLOAT mass            !Mass
        DFLOAT cov(5,5)        !Covariance matrix
        integer ihep           !Track number in HEP common
        integer icov           !0 ==> covariance matrix not defined
c                               !1 ==> covariance matrix defined
c                               !2 ==> defined, but no momentum information
      end structure
#endif
c
c$Id$
c
c$Log$
cRevision 1.1  2000/06/19 19:58:38  eugenio
cInitial revision
c
cRevision 1.4  2000/01/19 19:38:22  garren
cfix some ! comments which can cause problems for Linux user code
c
c Revision 1.3  1997/03/24  17:37:00  kutschke
c Add comment for icov=2
c

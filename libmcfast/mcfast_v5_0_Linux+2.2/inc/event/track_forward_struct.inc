#ifndef TRACK_FORWARD_STRUCT_INC
#define TRACK_FORWARD_STRUCT_INC

c
c   Rob Kutschke, Oct. 23, 1998.
c
c    Track parametrization for forward direction
c    Only the first 5 parameters are used in the fit
c
c   -------------------------------------------------------
c
c   WARNING: if you change this file, also make sure you change
c            track_forward_struct.h !
c
c   --------------------------------------------------------
c


#include "const.inc"
#include "ftrack_struct.inc"

      structure /track_forward_s/
        record /ftrack_struct/ f   !Forward track parameters
        DFLOAT mass         !Mass
        DFLOAT cov(5,5)     !Covariance matrix
        integer ihep        !Track number in HEP common
        integer icov        !0 ==> covariance matrix not defined
c                            !1 ==> covariance matrix defined
c                            !2 ==> defined, but no momentum information
      end structure
#endif
c
c$Id$
c
c$Log$
cRevision 1.1  2000/06/19 19:58:38  eugenio
cInitial revision
c
cRevision 1.5  2000/01/19 19:38:23  garren
cfix some ! comments which can cause problems for Linux user code
c
c Revision 1.4  1998/11/11  03:54:42  kutschke
c Add comments. Protect against multiple inclusion.
c
c Revision 1.3  1997/03/24  17:36:56  kutschke
c Add comment for icov=2
c

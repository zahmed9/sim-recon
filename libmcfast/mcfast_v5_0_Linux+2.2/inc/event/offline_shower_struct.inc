#ifndef OFFLINE_SHOWER_STRUCT
#define OFFLINE_SHOWER_STRUCT

c    Reconstructed showers. We adopt a standard parametrization of a
c    4-momentum and a 3-position.

#include "const.inc"
#include "wtrack_struct.inc"

      structure /offline_shower_s/
        record /wtrack_struct/ w  !Track parameters
        DFLOAT cov(7,7)           !Covariance matrix
        integer origin            !0 = no track, 1 = gamma, 2 = charged track
        integer pos               !Pos. of track in gamma or offline list
        integer emcal             !EM cal device #
        integer hep               !Pos. of corresp. track in HEPEVT list
        integer icov              !0 ==> covariance matrix not defined
c                                 !1 ==> covariance matrix defined
	integer dummy             !pad to align structure			  
      end structure
#endif

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:38  eugenio
c Initial revision
c
c Revision 1.4  2000/01/19 19:38:20  garren
c fix some ! comments which can cause problems for Linux user code
c
c Revision 1.3  1999/11/17  16:54:06  mcbride
c added pad to align structure
c

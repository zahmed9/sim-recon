#ifndef OFFLINE_TRACK_STRUCT
#define OFFLINE_TRACK_STRUCT

c    Reconstructed charged tracks. Since there are two representations
c    (central and forward tracks) we adopt a standard parametrization of
c    a 4-momentum and a 3-position.

#include "const.inc"
#include "wtrack_struct.inc"

      integer OFFLINE_TRACK_WORD
      parameter ( OFFLINE_TRACK_WORD =
     +            WTRACK_WORD+51*FLOAT_WORD+5*INT_WORD )

      structure /offline_track_struct/
        record /wtrack_struct/ w  !Track parameters
        DFLOAT mass         !Mass
        DFLOAT cov(7,7)     !Covariance matrix
        DFLOAT chisq        !Chisquare of fit - see note 1.
        integer nhit        !Number of hits in fit - see note 1.
        integer nhit_sil    !Number of silicon hits - see note 1.
        integer nhit_stereo !Number of hits with stereo info
        integer icov        !0 ==> covariance matrix not defined
c                            !1 ==> covariance matrix defined
c                            !2 ==> defined, but no momentum information
        integer hep         !Pos. of corresp. track in HEPEVT list
	integer dummy       !pad to align structure
      end structure

c
c Notes:
c 1) In the original mcfast, nhit counted the number of hits in the
c    fit, even if some hits added more than 1 term to the chisq.
c    If the Kalman filter is selected, either by default or with the
c    command line "use_kalman T" , then nhit and nhit_sil
c    are incremented by 2 for every pixel hit added to the track.
c    All other types of hits increment these counters by 1.
c    That is, nhit is the number of terms in the chisq and the
c    distribution of prob(chisq,nhit-5) should be flat.
c    If the Kalman filter is not selected, then nhit and nhit_sil
c    are incremented by 1 for all types of hits; also, in this case
c    chisq = 0 by definition.  If the Kalman filter is selected,
c    then fit_lkalman in fit_params.inc will be .TRUE. .
c
c

#endif
c
c$Id$
c
c$Log$
cRevision 1.1  2000/06/19 19:58:38  eugenio
cInitial revision
c
cRevision 1.6  2000/01/19 19:38:21  garren
cfix some ! comments which can cause problems for Linux user code
c
c Revision 1.5  1999/11/17  16:54:07  mcbride
c added pad to align structure
c
c Revision 1.4  1999/03/16  23:42:08  kutschke
c Update some comments.
c
c Revision 1.3  1998/09/15  04:27:19  kutschke
c Bug fix OFFLINE_TRACK_WORD.
c
c Revision 1.2  1997/03/24  17:37:09  kutschke
c Add comment for icov=2
c

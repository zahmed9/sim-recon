      integer function ksub_overwrite(ik)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   "Override" the unconstrained track parameters by the current ones for
C   track IK, i.e. trk_kine.w0 = trk_kine.w. It is assumed that the covariance 
C   matrix has been updated to reflect the new values.
C
C  IK        integer array (read)
C            Track ID in trk_kine list
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Created 10/10/94 A. Boehnlein from P. Avery KN routines
C
      IMPLICIT NONE
#include "const.inc"
#include "track_kine.inc"
C     Calling arguments
      integer ik

C     Local variables
      DFLOAT mass
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(ik.le.0 .or. ik.gt.trk_num) goto 9999

      call ucopy(trk_kine(ik).w, trk_kine(ik).w0, wtrack_word)
      mass = trk_kine(ik).w.e**2 - trk_kine(ik).w.p**2
      trk_kine(ik).mass = sign(sqrt(abs(mass)), mass)

      ksub_overwrite = 0
9999  return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:47  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:32:08  garren
c add rcs log line
c

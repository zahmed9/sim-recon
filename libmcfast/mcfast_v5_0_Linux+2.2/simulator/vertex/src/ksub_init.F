      subroutine ksub_init

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C    Initializes KN info at beginning of job
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
C  10/6/94 A. Boehnlein modefied for MCFAST from CLEO code
C  6/20/95 A. Boehnlein Added call to kfil_bfield_rotation
C  5/06/95 A. Boehnlein moved call to kfil_bfield_rotation to ksub_set_bfld
C
      IMPLICIT NONE
#include "const.inc"
#include "kine_chi.inc"
#include "track_kine.inc"

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      trk_num = 0
      max_iter = 4
      max_del_chisq = 0.01

C     Read in particle properties
C      call ksub_wpart

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:47  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:32:07  garren
c add rcs log line
c

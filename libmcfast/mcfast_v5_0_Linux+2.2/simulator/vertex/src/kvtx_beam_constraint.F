      integer function kvtx_beam_constraint(ntrk, 
     *           itrk, update, 
     *           lusez, zi, vzi, z, vz, chisq)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Performs a vertex fit to several tracks in the KN list using the
C  beam position and size to constrain the fit.
C
C  NTRK    integer variable (read)
C          # of tracks to fit (length of ITRK)
C
C  ITRK    integer  array (read)
C          list of tracks in KN list to fit (length = NTRK)
C
C  UPDATE  integer variable (read)
C          0 ==> do not update input track parameters (just calculate chisq)
C          1 ==> update input track parameters only
C          2 ==> update input track parameters & covariance matrices and
C                replace the original unconstrainted parameters by the
C                new ones. ****** This is a dangerous option. ******
C
C  LUSEZ   logical variable (read)
C          TRUE  ==> use the value of Z as the starting value
C          FALSE ==> use the value of ZI as the starting value
C
C  ZI      real array (read)
C          Position of known vertex
C
C  VZI     real array (read)
C          3x3 covariance matrix of known matrix ZI
C
C *Z       real array (read/write)
C          On input,  initial values of (x,y,z)
C          On output, updated values of (x,y,z)
C
C *VZ      real array (write)
C          3x3 covariance matrix of z(1-3)
C
C *CHISQ   real variable (write)
C          Chisquare of fit
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
c created 06/11/96 A. Boehnlein from P. Avery CLEO routine KVTXBM
      implicit none
#include "const.inc"     

C     Calling arguments
      integer ntrk, itrk(*), update
      logical lusez, lerror
      DFLOAT chisq, zi(3), vzi(3,3), z(3), vz(3,3)
C
      integer status
      integer kvtx_3d_prior
      external kvtx_3d_prior
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        status = kvtx_3d_prior(ntrk,itrk,update,
     &                         lusez,zi,vzi,z,vz,chisq)
        if (status .ne. 0) goto 9999

c     normal exit
1000  continue
      kvtx_beam_constraint = 0
      return

C     Error exit
9999  continue
      kvtx_beam_constraint = 1
      lerror = .true.
      chisq = -1.
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:48  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:32:12  garren
c add rcs log line
c

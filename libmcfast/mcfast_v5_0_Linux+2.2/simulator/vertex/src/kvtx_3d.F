      integer function kvtx_3d(ntrk, itrk, update, lusez, z, vz, chisq)
      
c     Created 9/6/95 Amber Boehnlein  -- renamed old version of kvtx_3d
C     kvtx_3d_do.  This routine rotates the vertex and calls kvtx_3d_do and
C     rerotates the vertex at the end.
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Calls routine to perform a vertex fit to several tracks in the KN list.
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
C          FALSE ==> compute the starting value with a straight line approx.
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
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#include "const.inc"
C     Calling arguments
      integer ntrk, itrk(*), update
      logical lusez
      DFLOAT chisq, z(3), vz(3,3)
      
      integer status
      integer ksub_vtx_rotate, kvtx_3d_do
      external ksub_vtx_rotate, kvtx_3d_do
      
C     Quit if illegal argument
      if(ntrk .lt. 2) goto 9999

C     Use input Z if requested, otherwise compute it with straight line approx.
      if(.not.lusez) then
        status = kvtx_line_3d(ntrk, itrk, z)
      endif
C     The field is defined to be along the "Z" axis--rotate coordinate
C     system for dipole field
      status = ksub_vtx_rotate(z,vz,0)
      
      status = kvtx_3d_do(ntrk, itrk, update, z, vz, chisq)
      if (status.ne.0) goto 9999
      
C     Normal exit
1000  kvtx_3d = 0
      status = ksub_vtx_rotate(z,vz,1)
      return

C     Error exit
9999  kvtx_3d = 1
      return
      end
      
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:47  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:32:10  garren
c add rcs log line
c

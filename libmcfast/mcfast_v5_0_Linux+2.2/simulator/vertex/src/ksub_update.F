      integer function ksub_update(itk, dx, lbase)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     Updates the trk_kine track parameters after a constrained fit with "W"
C     parametrization.
C
C  ITK     integer variable (read)
C          Track to update
C
C  DX      
C          Parameters to add to existing parameters (w format). The updated
C          parameters are put into TRKWFT.
C
C  LBASE   logical variable (read)
C          TRUE  if DX should be added to unconstrained parameters
C          FALSE if DX should be added to current parameters
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Created 10/6/94 A. Boehnlein from P. Avery's KN code
C
      IMPLICIT NONE
      
#include "const.inc"
#include "track_kine.inc"
#include "wtrack_struct.inc"
C
C     Calling argument
      integer itk
      record /wtrack_struct/ dx
      logical lbase

C     Local variables
      integer i
      DFLOAT ptsq, psq
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        if(itk.gt.trk_num) goto 9999
   
        if(lbase) then
          trk_kine(itk).w.px = trk_kine(itk).w0.px + dx.px
          trk_kine(itk).w.py = trk_kine(itk).w0.py + dx.py
          trk_kine(itk).w.pz = trk_kine(itk).w0.pz + dx.pz
          trk_kine(itk).w.e  = trk_kine(itk).w0.e  + dx.e
          trk_kine(itk).w.x  = trk_kine(itk).w0.x  + dx.x
          trk_kine(itk).w.y  = trk_kine(itk).w0.y  + dx.y
          trk_kine(itk).w.z  = trk_kine(itk).w0.z  + dx.z
        else
          trk_kine(itk).w.px = trk_kine(itk).w.px  + dx.px
          trk_kine(itk).w.py = trk_kine(itk).w.py  + dx.py
          trk_kine(itk).w.pz = trk_kine(itk).w.pz  + dx.pz
          trk_kine(itk).w.e  = trk_kine(itk).w.e   + dx.e
          trk_kine(itk).w.x  = trk_kine(itk).w.x   + dx.x
          trk_kine(itk).w.y  = trk_kine(itk).w.y   + dx.y
          trk_kine(itk).w.z  = trk_kine(itk).w.z   + dx.z
        endif

      ptsq = trk_kine(itk).w.px**2 + trk_kine(itk).w.py**2
      psq = ptsq + trk_kine(itk).w.pz**2

C     Don't update energy independently for fixed mass tracks
      if(trk_kine(itk).fixed_mass.eq.1)
     &   trk_kine(itk).w.e = sqrt(psq + trk_kine(itk).mass**2)

C     Calculate pt, p
      trk_kine(itk).w.pt = sqrt(ptsq)
      trk_kine(itk).w.p = sqrt(psq)

C     normal exit
      ksub_update = 0
      return
      
c     error
 9999 ksub_update = 1
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:47  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:32:09  garren
c add rcs log line
c

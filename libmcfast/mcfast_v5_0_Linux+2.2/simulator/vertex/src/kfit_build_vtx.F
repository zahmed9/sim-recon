      integer function kfit_build_vtx(ntrk, itrk, ivopt, update, 
     *                 vtx,vz,lcovar,chisq, pw, vp, mvp)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Build a new particle from several particles with a vertex constraint.
C  The covariance matrix of the new track is calculated.
C
C  Note: If there are fewer than 2 tracks with IVOPT = 2, then ZI is
C        treated as a fixed vertex and all tracks with IVOPT > 0 are
C        required to go through it.
C
C  NTRK      Integer variable (read)
C            # of input tracks
C
C  ITRK      Integer array (read)
C            List of KN tracks.
C
C  IVOPT     Integer array (read)
C            IVOPT(IL) = 0  => Track ITRK(IL) has no position info at all
C            IVOPT(IL) = 1  => Track ITRK(IL) is not used to determine vertex
C                              but is constrained to pass through vertex
C            IVOPT(IL) = 2  => Track ITRK(IL) is used to determine vertex
C
C *VTX       real array (read)
C            Initial (x,y,z) vertex (it is updated)
C
C *VZ        real array (read)
C            3x3 covariance matrix of VTX
C
C  UPDATE    integer variable (read)
C            0 ==> do not update input track parameters (just calculate chisq)
C            1 ==> update input track parameters only
C            2 ==> update input track parameters & covariance matrices and
C                  replace the original unconstrainted parameters by the
C                  new ones. ****** This is a dangerous option. ******
C
C  LCOVAR    logical variable (read)
C            TRUE  ==> compute PW covariance matrix
C            FALSE ==> do not compute PW covariance matrix
C
C *CHISQ     real variable (write)
C            Chisq of fit.
C
C *PW        real array (write)
C            Fitted particle in W format (Px,Py,Pz,E,X,Y,Z)
C
C *VP        real array (write)
C            Covariance matrix of PW
C
C  MVP       integer variable (read)
C            First dimension of VP (must be at least 7)
C  Created 10/17/94 A. Boehnlein from P. Avery KN KNBVX
C  Modified 9/6/95 ASB -- added rotation calls to accommodate dipole field
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      implicit none
#include "const.inc"
#include "wtrack_struct.inc"
#include "track_kine.inc"

C     Calling arguments
      integer ntrk, itrk(*), ivopt(*), update, mvp
      logical lcovar
      DFLOAT vtx(3), vz(3,3), chisq, vp(mvp,mvp)
      record /wtrack_struct/pw
      
C     Local variables
      logical lerror
      integer il, it, i, nlist, list(max_trk), status
      integer  kvtx_3d_do, kfit_build_do, ksub_vtx_rotate,ksub_p1_rotate
      external kvtx_3d_do, kfit_build_do, ksub_vtx_rotate,ksub_p1_rotate
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     The field is defined to be along the "Z" axis--rotate coordinate
C     system for dipole field
      status = ksub_vtx_rotate(vtx,vz,0)
      
C     Make list of tracks to be used in calculating vertex
      nlist = 0
      do 10 il=1,ntrk
        it = itrk(il)
        if(ivopt(il).eq.2 .and. trk_kine(it).pos_info.eq.1) then
          nlist = nlist + 1
          list(nlist) = it
        endif
10    continue

C     Calculate vertex if there are enough tracks
      if(nlist .ge. 2) then
        status = kvtx_3d_do(nlist, list, update, vtx, vz, chisq)
        if(status.ne.0) goto 9999
      endif

      status = kfit_build_do(ntrk, itrk, ivopt, 
     *            update, vtx, vz, lcovar, .true.,
     *            chisq, pw, vp, mvp)
      if(status.ne. 0) goto 9999

C     Normal exit
      kfit_build_vtx = 0
      status = ksub_vtx_rotate(vtx,vz,1)
      status = ksub_p1_rotate(pw,vp,mvp)
1000  return

c     error exit
9999  chisq = -1.
      kfit_build_vtx = 1
      call vzero(pw, wtrack_word)
      call vzero(vp, mvp*mvp*float_word)
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

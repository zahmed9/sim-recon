      integer function kfil_off_track(itrk, ityp, ik)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Fill track_kine track from specified trk_off track
C
C   Note: trk_num is incremented after every call. It is the user's
C         responsibility to clear it at the start of the event.
C
C
C  ITRK      Integer variable (read)
C            Number of trk_off track.
C
C  ITYP      Integer variable (read)
C            0   ==> use HEP particle ID
C            1-5 ==> use e/mu/pi/K/p hypothesis
C
C *ik        Integer variable (write)
C            ik = position in track_kine track list
C
C Created 10/11/94 A.Boehlein from P.Avery KN routines
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none
#include "const.inc"
#include "track_kine.inc"
#include "offline_track.inc"
#include "wtrack_struct.inc"
#include "stdhep.inc"

C     Calling arguments
      integer itrk, ityp, ik

C     Local variables
      record /wtrack_struct/ w

      integer id(5)
      data id/11, 13, 211, 321, 2212/
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(ityp.lt.0 .or. ityp.gt.5) goto 9999
c
c     select track and add to trk_kine list
        if(trk_num .eq. max_trk) goto 9999
        trk_num = trk_num + 1
        ik = trk_num
                
          
c     particle type
      if(ityp .eq. 0) then
        trk_kine(ik).id = idhep(trk_off(itrk).hep)
      else
          trk_kine(ik).id = id(ityp) * trk_off(itrk).w.q
      endif

      trk_kine(ik).origin     = jtrk_offline
      trk_kine(ik).mass       = trk_off(itrk).mass
      trk_kine(ik).nom_mass   = trk_off(itrk).mass
      trk_kine(ik).pos        = itrk
      trk_kine(ik).hep        = trk_off(itrk).hep
      trk_kine(ik).status     = 2
      trk_kine(ik).pos_info   = 1
      trk_kine(ik).icov       = trk_off(itrk).icov
      trk_kine(ik).fixed_mass = 0
      trk_kine(ik).class      = 0

c     fill the "w" parameters (px, py, pz, e, x, y, z, pt, p, q)
        
      call ucopy(trk_off(itrk).w, trk_kine(ik).w, WTRACK_WORD)
      call ucopy(trk_kine(ik).w, trk_kine(ik).w0, WTRACK_WORD)
      call ucopy(trk_off(itrk).cov,trk_kine(ik).cov,7*7*FLOAT_WORD)        
c     normal exit
1000  kfil_off_track = 0
      return

c     error exit
9999  kfil_off_track = 1
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:47  eugenio
c Initial revision
c
c Revision 1.3  1998/03/19 02:57:52  mcbride
c transfer icov value from trk_off to trk_kine
c
c Revision 1.2  1997/04/04  20:32:06  garren
c add rcs log line
c

      integer function kfil_hep(itrk, ityp, ik)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Fill track_kine track from specified HEP track
C
C   Note: trk_num is incremented after every call. It is the user's
C         responsibility to clear it at the start of the event.
C
C
C  ITRK      Integer variable (read)
C            Number of hep track.
C
C  ITYP      Integer variable (read)
C            0   ==> use HEP particle ID
C            1-5 ==> use e/mu/pi/K/p hypothesis
C
C *ik        Integer variable (write)
C            ik = position in track_kine track list
C
C Created 10/7/94 A.Boehlein from P.Avery KN routines
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none
#include "const.inc"
#include "track_kine.inc"
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
                
        call hep_to_w(itrk,w)
          
c     particle type
      if(ityp .eq. 0) then
        trk_kine(ik).id = idhep(itrk)
      else
        if(w.q .gt. 0.) then
          trk_kine(ik).id = id(ityp) * w.q
        endif
      endif

      trk_kine(ik).origin     = jtrk_hep
      trk_kine(ik).mass       = phep(5,itrk)
      trk_kine(ik).nom_mass   = phep(5,itrk)
      trk_kine(ik).pos        = itrk
      trk_kine(ik).hep        = itrk
      trk_kine(ik).status     = 2
      trk_kine(ik).pos_info   = 1
      trk_kine(ik).icov       = 0
      trk_kine(ik).fixed_mass = 1
      trk_kine(ik).class      = 0

c     fill the "w" parameters (px, py, pz, e, x, y, z, pt, p, q)

      trk_kine(ik).w.px = w.px
      trk_kine(ik).w.py = w.py
      trk_kine(ik).w.pz = w.pz
      trk_kine(ik).w.e  = w.e
      trk_kine(ik).w.x  = w.x
      trk_kine(ik).w.y  = w.y
      trk_kine(ik).w.z  = w.z
      trk_kine(ik).w.pt = w.pt
      trk_kine(ik).w.p  = w.p
      trk_kine(ik).w.q  = w.q
        
      call ucopy(trk_kine(ik).w, trk_kine(ik).w0, WTRACK_WORD)
        
c     normal exit
1000  kfil_hep = 0
      return

c     error exit
9999  kfil_hep = 1
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:47  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:32:06  garren
c add rcs log line
c

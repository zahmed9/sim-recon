      subroutine hep_to_kine(hep)

c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "stdhep.inc"
#include "track_kine.inc"

c     Local Variables
      integer hep, itype, ntrk
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      itype = idhep(hep)
      ntrk = trk_num+1
      if(ntrk .gt. max_trk) then
        write(6,1000) max_trk
 1000   format(' Maximum number of tracks (',i5,') exceeded:  TRK_KINE')
        goto 999
      endif

      call hep_to_w(hep, trk_kine(ntrk).w)
      call ucopy(trk_kine(ntrk).w, trk_kine(ntrk).w0, WTRACK_WORD)

      trk_kine(ntrk).mass= phep(5,hep)   !Mass
      trk_kine(ntrk).icov= 0             !covariance matrix not defined
c
      trk_kine(ntrk).hep   = hep         !Position of track in HEPEVT list
      trk_kine(ntrk).origin= jtrk_hep    !Origin of track is HEP list
      trk_kine(ntrk).pos   = 0           !generator track			
      trk_kine(ntrk).nom_mass=	phep(5,hep) !Nominal mass
c      
      trk_kine(ntrk).status  =  2
      trk_kine(ntrk).class   =  0
      trk_kine(ntrk).pos_info = 1
      trk_kine(ntrk).fixed_mass = 1
      trk_kine(ntrk).id      = idhep(hep)
      
      trk_num = ntrk
        
 999  return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:33  garren
c add rcs log line
c

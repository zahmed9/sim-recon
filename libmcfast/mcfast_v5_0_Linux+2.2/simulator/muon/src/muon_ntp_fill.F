      subroutine muon_ntp_fill
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c    make plots...
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "stdhep.inc"
#include "gen_muon.inc"
#include "offline_muon.inc"
#include "offline_track.inc"
#include "wtrack_struct.inc"

       integer hep 
       integer i, itrk, imuon
       
       record /wtrack_struct/ w,w_gen
       
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

       do i = 1, muon_gen_num
          hep = muon_gen(i).hep
          call hep_to_w(hep,w_gen)

          do imuon = 1,muon_off_num
            if(hep.eq.muon_off(imuon).hep) goto 100
          enddo
          
          imuon = 0

                   
 100      continue
 
          do itrk = 1, trk_off_num
            if(hep.eq.trk_off(itrk).hep) then
              call ucopy(trk_off(itrk),w,WTRACK_WORD)
              goto 200
            endif
          enddo
          
          itrk = 0
          call vzero(w,WTRACK_WORD)
          
 200      continue
          
          call muon_ntp(w,w_gen,hep,imuon) 
                           
       enddo
       return
       end                  

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:26  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:04  garren
c add rcs log line
c

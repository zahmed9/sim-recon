      subroutine muon_offline
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    from gen_track find if particle will hit muon detector
c    require an offline track for an offline muon id
c    make plots...
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "mcp_summary.inc"
#include "mcp_debug.inc"
#include "stdhep.inc"
#include "offline_track.inc"
#include "offline_muon.inc"
#include "muon.inc"
#include "wtrack_struct.inc"


c    Local variables
      integer imuon_det, itrk, hep, id
      integer nevent,keep,i,hits
      integer muhits(max_muon)

      integer error
      real e, energy(max_muon)

      record /wtrack_struct/ w, w_gen

      logical init
      data init/.TRUE./
      save init 


c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      if(init) then
        init = .FALSE.
        call muon_init
      endif

      nevent = mcp_all.event_file    ! event number for this file
      muon_off_num = 0

      if (dbg_trace(jdbg_muon).ne.0 .or. dbg_hist(jdbg_muon).ne.0)then
         call muon_gener
      endif

c     loop over all offline tracks

      if (dbg_hist(jdbg_muon).ne.0) then
        call hcdir('//PAWC',' ')
        call hcdir('Offline muons',' ')
      endif

      do itrk = 1, trk_off_num           ! muon must have an offline track

        hep = trk_off(itrk).hep
        id  = abs(idhep(hep))

        if (id .eq. 13) then       ! muon found

          call hep_to_w(hep,w_gen)
          call ucopy(trk_off(itrk),w,WTRACK_WORD)

c         loop over all defined muon detectors

          keep = 0
          do imuon_det=1,muon_num
            muhits(imuon_det) = 0
            energy(imuon_det) = -1.            
            call muon_cuts(imuon_det,w,hits,e,error)
            if (error .eq. 0 .and. hits .ge. 1) then
                muhits(imuon_det) = hits
                energy(imuon_det) = e   ! energy of muon at detector
                keep = 1
            endif
          enddo  

***         simple muon cuts...  Does it hit any detector???

          if (keep .eq. 1) then
              muon_off_num=muon_off_num+1
              muon_off(muon_off_num).track = itrk 
              muon_off(muon_off_num).hep   = hep 
              muon_off(muon_off_num).prob  =   1
              do i= 1, muon_num
                muon_off(muon_off_num).hits(i)   = muhits(i)
                muon_off(muon_off_num).energy(i) = energy(i)
              enddo
          endif

 200      continue

          if (dbg_hist(jdbg_muon).ne.0) then
            call muon_plots(w_gen,keep)
          endif

        endif

      enddo
      if (dbg_hist(jdbg_muon).ne.0) then
            call muon_ntp_fill
      endif   
      call hcdir('//PAWC',' ')
 
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:26  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:05  garren
c add rcs log line
c







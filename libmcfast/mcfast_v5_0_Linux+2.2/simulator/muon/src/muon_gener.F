      subroutine muon_gener
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    from gen_track find if particle will hit muon detector
c
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "mcp_luns.inc"
#include "mcp_summary.inc"
#include "mcp_debug.inc"

#include "gen_muon.inc"
#include "muon.inc"
#include "wtrack_struct.inc"

c    Local variables
      integer imuon_det, imu, hep
      integer nevent, keep, hits

      integer error

      integer muhits(max_muon)
      integer muhits_min(max_muon)
      real e, energy(max_muon)

      record /wtrack_struct/ w1


c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c
      call hcdir('//PAWC',' ')
      call hcdir('Generated muons',' ')
      nevent = mcp_all.event_file    ! event number for this file

c     loop over all generated muons

      do imu = 1, muon_gen_num

        hep = muon_gen(imu).hep

        call hep_to_w(hep,w1)

c       loop over all defined muon detectors
        keep = 0
        do imuon_det=1,muon_num
           call muon_cuts(imuon_det,w1,hits,e,error)
           if (error .eq. 0.and. hits .ge. 1) keep = 1
        enddo

        if (dbg_hist(jdbg_muon).ne.0) then        
           call muon_plots(w1,keep)
        endif

      enddo

      call hcdir('//PAWC',' ')  
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:26  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:03  garren
c add rcs log line
c


      subroutine fctl_offline(ntrk, list)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Reconstruct charged tracks.
c
c  Inputs:
c  ntrk       integer variable
c             # of tracks to fit
c             ntrk = -1 ==> Reconstruct all charged tracks
C
c  list(*)    integer array
c             List of tracks to fit. Ignored if ntrk = -1
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

      save

#include "const.inc"      
#include "detector_general.inc"
#include "track_central.inc"
#include "track_forward.inc"
#include "offline_track.inc"
#include "hep_point.inc"
#include "gen_track.inc"
#include "stdhep.inc"
#include "fit_params.inc"

c     Externals
      external stdchg, pfit_fit_wtk, pfit_fit_ctk, pfit_fit_ftk
      external klm_fit_ftk, klm_fit_ctk
      real     stdchg
      integer  pfit_fit_wtk, pfit_fit_ctk, pfit_fit_ftk
      integer  klm_fit_ftk, klm_fit_ctk

c     Calling arguments
      integer ntrk, list(*)

c     Local variables
      integer it, id, status, num, hep
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 
      trk_off_num = 0                   !# total reconstructed tracks
      trc_num = 0
      trf_num = 0
      call vzero (hep_off, 3*max_point) ! Clears hep_off, hep_cen, hep_for

      if(ntrk .ge. 0) then
        num = ntrk
      else
        num = trk_gen_num
      endif
      do it=1,num

        if(ntrk .ge. 0) then
          hep = list(it)
        else
          hep = trk_gen(it).hep
        endif

c       Require particle be final state or intermediate particle. This
c       gets rid of isthep = 3 particles which are p, pbar in some generators.
        if( isthep(hep) .eq.              1 .or. 
     +      isthep(hep) .eq.              2 .or.
     +      isthep(hep) .eq. ISTHEP_SEC_INT .or.
     +      isthep(hep) .eq.    ISTHEP_BREM      ) then

          id = idhep(hep)
          
c     Version 2.0 -- select globally forward or central tracking          
          
          if (det_general.geom_id(1:7) .eq. 'CENTRAL') then
             if ( fit_lkalman ) then
                status = klm_fit_ctk(hep)
             else
                status = pfit_fit_ctk(hep)
             endif
          elseif (det_general.geom_id(1:7) .eq. 'FORWARD') then
             if ( fit_lkalman ) then
                status = klm_fit_ftk(hep)
             else
                status = pfit_fit_ftk(hep)
             endif
          else
             status = pfit_fit_wtk(hep)   ! SLOW
          endif

        endif

c     Jump here if error
500     continue

      enddo

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:15  eugenio
c Initial revision
c
c Revision 1.8  1999/05/12 20:21:32  kutschke
c 21 files changed/added to implement ctk Kalman filter.
c
c Revision 1.7  1999/04/02  01:12:12  kutschke
c Include tracks which interacted with detector material.
c
c Revision 1.6  1998/06/23  23:47:37  bphyslib
c fix references to renamed routines
c
c Revision 1.5  1998/06/23  22:41:48  bphyslib
c rename routines moved from track to fitters library
c
c Revision 1.4  1998/02/13  23:08:47  kutschke
c Call kalman as requested.
c
c Revision 1.3  1997/04/04  20:30:30  garren
c add rcs log line
c

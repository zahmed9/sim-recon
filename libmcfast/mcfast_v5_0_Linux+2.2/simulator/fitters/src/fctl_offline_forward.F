      subroutine fctl_offline_forward(ntrk, list)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Reconstruct charged tracks in the forward direction.
c
c   NOTE:  This is not necessarily compatible with fctl_offline.
c          This routine is for TESTING PURPOSES.  If the forward
c          scheme is determined to work, this routine should
c          either be merged with fctl_offline OR it should be given
c          its own common blocks.  --KLS, 1/6/95
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
#include "track_central.inc"
#include "track_forward.inc"
#include "offline_track.inc"
#include "gen_track.inc"
#include "stdhep.inc"

c     Externals
      external stdchg, pfit_fit_wtk, pfit_fit_ftk
      real     stdchg
      integer  pfit_fit_wtk, pfit_fit_ftk

c     Calling arguments
      integer ntrk, list(*)

c     Local variables
      integer it, id, status, num, hep
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      trk_off_num = 0                   !# total reconstructed tracks
      trf_num = 0
      trc_num = 0

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

c     Require particle be final state or intermediate particle. This
c     gets rid of isthep = 3 particles which are p, pbar in some generators.
        if( isthep(hep) .eq.              1 .or. 
     +      isthep(hep) .eq.              2 .or.
     +      isthep(hep) .eq. ISTHEP_SEC_INT .or.
     +      isthep(hep) .eq.    ISTHEP_BREM      ) then

          id = idhep(hep)
          status = pfit_fit_ftk(hep)

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
c Revision 1.5  1999/04/02 01:12:13  kutschke
c Include tracks which interacted with detector material.
c
c Revision 1.4  1998/06/23  23:47:38  bphyslib
c fix references to renamed routines
c
c Revision 1.3  1998/06/23  22:41:49  bphyslib
c rename routines moved from track to fitters library
c
c Revision 1.2  1997/04/04  20:30:30  garren
c add rcs log line
c

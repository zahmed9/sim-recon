      subroutine fctl_offline_gen(ntrk, list)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Copies the specified generated tracks into offline reconstructed list.
c
c   ntrk = -1 ==> Reconstruct all charged tracks
c             
c   Paul Avery 6-9-94
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "detector_general.inc"
#include "wtrack_struct.inc"
#include "ctrack_struct.inc"
#include "ftrack_struct.inc"
#include "track_central.inc"
#include "track_forward.inc"
#include "offline_track.inc"
#include "gen_track.inc"
#include "stdhep.inc"
#include "bfield_struct.inc"

c     Externals
      integer  cvt_wtk_ctk, cvt_wtk_ftk
      real     stdchg
      external stdchg, cvt_wtk_ctk, cvt_wtk_ftk

c     Calling arguments
      integer ntrk, list(*)

c     Local variables
      integer itrk, i, j, it, id, status, num, hep
      DFLOAT mass, chrg, eta, costh, pmom
      record /wtrack_struct/ w
      record /ctrack_struct/ c_in
      record /ftrack_struct/ f_in
      record /bfield_struct/ bf
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 
      trc_num = 0                       !# tracks in central region
      trf_num = 0                       !# tracks in forward region
      trk_off_num = 0                   !# total reconstructed tracks

      if(ntrk .ge. 0) then
        num = ntrk
      else
        num = trk_gen_num
      endif
      do it=1,num

        if(ntrk .ge. 0) then
          itrk = list(it)
        else
          itrk = it
        endif

        hep = trk_gen(itrk).hep

c     Require particle be final state or intermediate particle. This
c     gets rid of isthep = 3 particles which are p, pbar in some generators.
        if(isthep(hep) .le. 2) then

          id = idhep(hep)

          mass = phep(5,hep)
          chrg = stdchg(id)
          call hep_to_w(hep, w)


c     Check for overflows
          if(trk_off_num .ge. trk_off_max) goto 9998

          if (det_general.geom_id(1:7) .eq. 'CENTRAL') then
           if(trc_num .ge. max_trc) goto 9998          
c     Store in central track list
           call get_bfield(w.x, bf)
           status = cvt_wtk_ctk(w, w.x, bf, c_in)
           trc_num = trc_num + 1
           call ucopy(c_in, trc_par(trc_num).c, CTRACK_WORD)
           trc_par(trc_num).mass = mass
           trc_par(trc_num).ihep = itrk
           trc_par(trc_num).icov = 0     !No covariance matrix
          
          elseif (det_general.geom_id(1:7) .eq. 'FORWARD') then
           if(trf_num .ge. max_trf) goto 9998          
c     Store in central track list
           status = cvt_wtk_ftk(w, f_in)
           trf_num = trf_num + 1
           call ucopy(f_in, trf_par(trf_num).f, FTRACK_WORD)
           trf_par(trf_num).mass = mass
           trf_par(trf_num).ihep = itrk
           trf_par(trf_num).icov = 0     !No covariance matrix
          endif  

c     Store in offline list
          trk_off_num = trk_off_num + 1
          call ucopy(w, trk_off(trk_off_num).w, WTRACK_WORD)
          trk_off(trk_off_num).mass = mass
          trk_off(trk_off_num).hep = itrk
          trk_off(trk_off_num).icov = 0
          trk_off(trk_off_num).nhit = 0
          trk_off(trk_off_num).nhit_sil = 0
          trk_off(trk_off_num).nhit_stereo = 0

        endif

c     Jump here if error
500     continue

      enddo

c     Normal exit
      return

c     Overflow
 9998 continue
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:15  eugenio
c Initial revision
c
c Revision 1.4  1998/06/23 22:41:49  bphyslib
c rename routines moved from track to fitters library
c
c Revision 1.3  1997/04/04  20:30:31  garren
c add rcs log line
c

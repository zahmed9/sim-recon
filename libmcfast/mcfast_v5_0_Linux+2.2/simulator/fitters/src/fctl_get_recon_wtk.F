      integer function fctl_get_recon_wtk(itrk, w)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Return the w track parameters of reconstructed track "itrk".
c
c  itrk     integer variable (read)
c           Track number in recon list
c
c *w        w track structure (write)
c           Track parameters returned to caller
c
c return    
c           0 ==> all OK
c           1 ==> track does not exist
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

      save

#include "offline_track.inc"
#include "wtrack_struct.inc"

c     Calling arguments
      integer itrk
      record /wtrack_struct/ w

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(itrk.le.0 .or. itrk.gt.trk_off_num) goto 9999

      call ucopy(trk_off(itrk).w, w, WTRACK_WORD)

      fctl_get_recon_wtk = 0
      return

c     Error ... track does not exist
 9999 fctl_get_recon_wtk = 1
      call vzero(w, WTRACK_WORD)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:15  eugenio
c Initial revision
c
c Revision 1.3  1998/06/23 22:41:48  bphyslib
c rename routines moved from track to fitters library
c
c Revision 1.2  1997/04/04  20:30:25  garren
c add rcs log line
c

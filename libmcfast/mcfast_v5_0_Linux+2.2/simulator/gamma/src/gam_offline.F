      subroutine gam_offline(ngam, list)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Reconstruct gammas from the shower list
c
c   ngam = -1 ==> Reconstruct all showers
c             
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

      save

#include "gamma_central.inc"
#include "gamma_forward.inc"
#include "offline_shower.inc"
#include "offline_gamma.inc"
#include "stdhep.inc"

c     Calling arguments
      integer ngam, list(*)

c     Local variables
      integer id, ish, hep, num, is
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 
      gmc_num = 0                       !# tracks in central region
      gmf_num = 0                       !# tracks in forward region
      gam_off_num = 0                   !# total reconstructed tracks

c     For now, look for showers caused by gammas and build the gamma.
c     This is crude, but OK for now.
      if(ngam .ge. 0) then
        num = ngam
      else
        num = shw_off_num
      endif
      do is=1,num

        if(ngam .ge. 0) then
          ish = list(is)
        else
          ish = is
        endif

        hep = shw_off(ish).hep
        id = idhep(hep)
        if(id .ne. 22) goto 500

        gam_off_num = gam_off_num + 1
        gam_off(gam_off_num).shower = ish
        gam_off(gam_off_num).prob = 1

c     Jump here if error
500     continue

      enddo

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:19  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:31  garren
c add rcs log line
c

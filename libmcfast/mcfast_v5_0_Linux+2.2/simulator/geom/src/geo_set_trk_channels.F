      subroutine geo_set_trk_channels

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Make a list of tracking channel numbers and offsets for each tracking
c  device.The offsets are needed to aid the later calculation of
c  channel numbers from layer and wire info.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "drift.inc"
#include "si_barrel.inc"
#include "sicir_disk.inc"

c     local variables
      integer i, j, k, nchan
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      
c     Silicon barrels. Compute
c       1. Number of channels per layer
c       2. Channel # corresponding to 1st strip per layer
c       3. Channel # corresponding to 1st strip per plane
      do i=1,sib_num
        nchan = 0

        do j=1,sib_par(i).numlyr
          sib_par(i).lyr(j).chan0 = nchan
          sib_par(i).lyr(j).nchan = 0
          do k=1,sib_par(i).lyr(j).numplane
            sib_par(i).lyr(j).plane(k).chan0 = nchan
            nchan = nchan + sib_par(i).lyr(j).plane(k).nchan
            sib_par(i).lyr(j).nchan = sib_par(i).lyr(j).nchan
     *            + sib_par(i).lyr(j).plane(k).nchan
          enddo
        enddo
        sib_par(i).nchan = nchan
      enddo

c     Drift chambers. Compute
c       1. Number of channels per layer
c       2. Channel # corresponding to wire 0 per layer

      do i=1,drf_num

c     Anodes
        do j=1,drf_par(i).num_anode
          drf_par(i).an(j).chan0 = nchan
          drf_par(i).an(j).nchan = drf_par(i).an(j).nwire
         nchan = nchan + drf_par(i).an(j).nchan
        enddo
        drf_par(i).nchan = nchan
      enddo

c     normal exit
1000  continue
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:23  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:45  garren
c add rcs log line
c

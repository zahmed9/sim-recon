      subroutine geo_trklayer

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Make single list of all tracking layers here.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "drift.inc"
#include "si_barrel.inc"
#include "sicir_disk.inc"
#include "trk_layer.inc"
#include "devtype.inc"

c     local variables
      integer i, j
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      trk_layer_num = 0

c     Silicon barrels
      do i=1,sib_num
        do j=1,sib_par(i).numlyr
          trk_layer_num = trk_layer_num + 1
          trk_layer(trk_layer_num).devtype = jdev_silbarrel
          trk_layer(trk_layer_num).devnum = i
          trk_layer(trk_layer_num).devlayer = j
          write(trk_layer(trk_layer_num).name,5002) i, j
 5002     format('Silicon barrel ',i1,' layer ',i2)
        enddo
      enddo

c     Drift chambers
      do i=1,drf_num

c     Anodes
        do j=1,drf_par(i).num_anode
          trk_layer_num = trk_layer_num + 1
          trk_layer(trk_layer_num).devtype = jdev_driftbarrel
          trk_layer(trk_layer_num).devnum = i
          trk_layer(trk_layer_num).devlayer = j
          write(trk_layer(trk_layer_num).name,5003) i, j
 5003     format('Barrel drift chamber ',i1,' anode layer ',i3)
        enddo
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

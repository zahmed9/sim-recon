      subroutine geo_set_trkchan(chan)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Compute channel number of a hit given a device type, device number,
c   device layer, and other info (wire, plane, strip, etc)
c
c  Input
c  chan       channel structure
c             Containts device type, device #, layer # and other info
c
c  Output
c  chan       channel structure
c             chan.channel is computed and stored using the rest of the info
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

      save

#include "const.inc"
#include "trk_channel_struct.inc"
#include "devtype.inc"
#include "drift.inc"
#include "si_barrel.inc"

c     externals

c     Calling arguments
      record /trk_channel_struct/ chan

c     Local variables
      integer dev, lay, pln, strip, wire
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      dev = chan.devnum
      lay = chan.devlayer

c     Silicon barrel ... need device, layer, plane, strip
      if(chan.devtype .eq. jdev_silbarrel) then
        pln = chan.devwid(1)
        strip = chan.devwid(2)
        chan.channel = sib_par(dev).lyr(lay).plane(pln).chan0 + strip

c     Drift chamber ... need device, layer, wire
      else if(chan.devtype .eq. jdev_driftbarrel) then
        wire = chan.devwid(1)
        chan.channel = drf_par(dev).an(lay).chan0 + wire

c     Could not find it
      else
        chan.channel = 0
      endif

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

      integer function cvt_ctk_ftk(c, f)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a track expressed in helix form and converts it into forward form
c  at the point of closest approach to the reference point in a solenoidal
c  B field.
c
c  c        c track structure (read)
c           c track parameters
c
c *f        Forward track structure (write)
c           f track parameters
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be computed
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ftrack_struct.inc"
#include "ctrack_struct.inc"

c     calling arguments
      record /ftrack_struct/ f
      record /ctrack_struct/ c

c     local variables
      DFLOAT pz, x0, y0, z0, ptoverpz
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(c.p .eq. 0. .or. c.ct .eq. 0.) goto 9999
      pz = c.pt * c.ct

      f.alpha = 1. / pz
      x0 = -c.da * c.v0 + c.xref
      y0 =  c.da * c.u0 + c.yref
      z0 =  c.z0 + c.zref
      ptoverpz = c.pt * f.alpha

      f.xslp = ptoverpz * c.u0
      f.yslp = ptoverpz * c.v0
      f.xp = x0
      f.yp = y0
      f.zp = z0
      f.pt = c.pt
      f.p = c.p
      f.q = c.q

      cvt_ctk_ftk = 0
      return

c     error return
9999  cvt_ctk_ftk = 1
      call vzero(f, FTRACK_WORD)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:42  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:58  garren
c add rcs log line
c

      function trk_lifetime(type)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Returns the lifetime of a particle according to exp(-t/tau).
c
c   Note: This routine uses the qq particle information.
c
c  Inputs:
c  type      integer variable
c            HEPEVT particle type
c
c  Returns:
c            Lifetime of particle
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

      save

#include "const.inc"
#include "qqpars.inc"
#include "qqprop.inc"

      DFLOAT trk_lifetime

c     Externals
      external rann, qqtran
      real     rann
      integer  qqtran

c     Calling arguments
      integer type

c     Local variables
      integer qqtype
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     See if we have this particle in qq particle list
      qqtype = qqtran(type, 2)
      if(qqtype .le. 0) goto 9999

c     Be careful because QQ lifetimes are in meters
      if(ctau(qqtype) .eq. 0.) then
        trk_lifetime = 0.
      else if(ctau(qqtype) .lt. 0.) then
        trk_lifetime = 1.e20
      else
        trk_lifetime = -ctau(qqtype) * log(rann(0)) * unit_meter/clight
      endif

c     Normal exit
      return

c     Error exit
 9999 trk_lifetime = 1.e20
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:36  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:26  garren
c add rcs log line
c


      subroutine hep_to_w(hep, w)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c     Convert an HEPEVT track to w format
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none


#include "const.inc"
#include "stdhep.inc"
#include "wtrack_struct.inc"

c     Local Variables

      integer hep,itype
      DFLOAT conv
      real stdchg
      record /wtrack_struct/ w
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (hep .le. 0) goto 999
      itype = idhep(hep)

      conv = 0.001 * unit_meter      !Convert to our length units

      w.px = phep(1,hep)         !Px
      w.py = phep(2,hep)         !Py
      w.pz = phep(3,hep)         !Pz
      w.E  = phep(4,hep)         !E
      w.x  = vhep(1,hep)*conv    !x
      w.y  = vhep(2,hep)*conv    !y
      w.z  = vhep(3,hep)*conv    !z
      w.pt = sqrt(w.px**2 + w.py**2) !Pt = sqrt(px**2 + py**2)
      w.p  = sqrt(w.pt**2 + w.pz**2) !Momentum
      w.q  = stdchg(itype)       !Charge
        
 999  return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:34  garren
c add rcs log line
c

      subroutine wtk_cov_Econstr(w, wcov)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Change w covariance matrix to reflect the constraint E^2 = p^2 + m^2,
c  for fixed m.
c
c  Inputs:
c  w          w track structure
c             Track parameters
c
c  Outputs:
c
c  wcov       DFLOAT 7x7 matrix
c             Input covariance matrix
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  
      implicit none

#include "const.inc"
#include "wtrack_struct.inc"

c     Calling arguments
      record /wtrack_struct/ w
      DFLOAT wcov(7,7)

c     Local variables
      DFLOAT den
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      den = 1. / w.E

      wcov(1,4) = den * (w.px*wcov(1,1) + w.py*wcov(1,2)
     *                 + w.pz*wcov(1,3))
      wcov(2,4) = den * (w.px*wcov(2,1) + w.py*wcov(2,2)
     *                 + w.pz*wcov(2,3))
      wcov(3,4) = den * (w.px*wcov(3,1) + w.py*wcov(3,2)
     *                 + w.pz*wcov(3,3))
      wcov(5,4) = den * (w.px*wcov(5,1) + w.py*wcov(5,2)
     *                 + w.pz*wcov(5,3))
      wcov(6,4) = den * (w.px*wcov(6,1) + w.py*wcov(6,2)
     *                 + w.pz*wcov(6,3))
      wcov(7,4) = den * (w.px*wcov(7,1) + w.py*wcov(7,2)
     *                 + w.pz*wcov(7,3))
      wcov(4,1) = wcov(1,4)
      wcov(4,2) = wcov(2,4)
      wcov(4,3) = wcov(3,4)
      wcov(4,5) = wcov(5,4)
      wcov(4,6) = wcov(6,4)
      wcov(4,7) = wcov(7,4)
      wcov(4,4) = (den*w.px)**2 * wcov(1,1)
     *          + (den*w.py)**2 * wcov(2,2)
     *          + (den*w.pz)**2 * wcov(3,3)
     *          + 2.*den**2*w.px * (w.py*wcov(1,2) + w.pz*wcov(1,3))
     *          + 2.*den**2*w.py * (w.pz*wcov(2,3))

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:32:01  garren
c add rcs log line
c

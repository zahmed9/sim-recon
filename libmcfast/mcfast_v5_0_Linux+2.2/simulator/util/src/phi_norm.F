      function phi_norm(arg)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Force argument to be in the range [0, 2*pi]
c
c  arg      DFLOAT variable (read)
c           Angle
c
c  return   arg modified to be in the range [0, 2*pi]
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"

      DFLOAT   phi_norm

c     calling arguments
      DFLOAT arg
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      phi_norm = arg
      if(phi_norm .gt. tpi) phi_norm = phi_norm - tpi
      if(phi_norm .lt. 0. ) phi_norm = phi_norm + tpi

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:56  garren
c add rcs log line
c

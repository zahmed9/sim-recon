      integer function deriv_ftk_zplane_b0(f1, f2, bf, R)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Calculate the derivatives of the forward helix parameters at a new
c  plane wrt parameters at the old plane in zero B field.
c
c  f1       f track structure (read)
c           Track parameters at the old plane
c
c  f2       f track structure (read)
c           Track parameters at the new plane
c
c  bf       B field structure (read)
c           B field information
c
c *R        DFLOAT array (write)
c           5x5 derivative matrix of d(f2) / d(f1)
c
c return    
c           0 ==> all OK
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ftrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     Externals

c     calling arguments
      record /ftrack_struct/ f1, f2
      record /bfield_struct/ bf
      DFLOAT R(5,5)

c     local variables
      DFLOAT dz
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      dz = f2.zp - f1.zp

      call vzero(R, 5*5*FLOAT_WORD)

c     No field
      R(jfalpha,jfalpha) = 1.
      R(jfxslp,jfxslp) = 1.
      R(jfyslp,jfyslp) = 1.
      R(jfxp,jfxslp) = dz
      R(jfxp,jfxp) = 1.
      R(jfyp,jfyp) = 1.
      R(jfyp,jfyslp) = dz

      deriv_ftk_zplane_b0 = 0

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:20  garren
c add rcs log line
c

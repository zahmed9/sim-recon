      integer function deriv_ftk_zplane(f1, f2, bf, R)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Calculate the derivatives of the forward helix parameters at a new
c  plane wrt parameters at the old plane in an arbitrary B field.
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
      integer  deriv_ftk_zplane_b0
      integer  deriv_ftk_zplane_bx
      integer  deriv_ftk_zplane_by
      integer  deriv_ftk_zplane_bz

      external deriv_ftk_zplane_b0
      external deriv_ftk_zplane_bx
      external deriv_ftk_zplane_by
      external deriv_ftk_zplane_bz

c     calling arguments
      record /ftrack_struct/ f1, f2
      record /bfield_struct/ bf
      DFLOAT R(5,5)

c     local variables
      integer status
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (f1.q .eq. 0.0) goto 100

      goto (100, 110, 120, 9999, 140, 9999, 9999, 9999), bf.type + 1

 100  status = deriv_ftk_zplane_b0(f1, f2, bf, R)
      goto 500

 110  status = deriv_ftk_zplane_bx(f1, f2, bf, R)
      goto 500

 120  status = deriv_ftk_zplane_by(f1, f2, bf, R)
      goto 500

c 130  status = deriv_ftk_zplane_bxy(f1, f2, bf, R)

 140  status = deriv_ftk_zplane_bz(f1, f2, bf, R)
      goto 500

c 150  status = deriv_ftk_zplane_bzx(f1, f2, bf, R)

c 160  status = deriv_ftk_zplane_byz(f1, f2, bf, R)

c 170  status = deriv_ftk_zplane_bxyz(f1, f2, bf, R)

 500  deriv_ftk_zplane = status

      return

c     Error return
9999  write(6,5000) bf.type
5000  format('deriv_ftk_zplane: Does not support bfield type ',i1)
      deriv_ftk_zplane = -bf.type
      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:31:20  garren
c add rcs log line
c

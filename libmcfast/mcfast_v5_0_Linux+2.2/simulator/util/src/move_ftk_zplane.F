      integer function move_ftk_zplane(f1, zs, bf, f2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a forward track and calculates the new parameters at the
c  plane z = zs in an arbitrary B field.
c
c  f1       forward track structure (read)
c           Initial track parameters
c
c  zs       DFLOAT variable (read)
c           z position to which the track should be projected
c
c  bf       B field structure (read)
c           B field information
c
c *f2       forward track structure (write)
c           Track parameters at z = zs
c
c *s3d      DFLOAT variable (write)
c           3-D arc length the track moved between points
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ftrack_struct.inc"
#include "bfield_struct.inc"

c     Externals
      integer  move_ftk_zplane_b0
      integer  move_ftk_zplane_bx
      integer  move_ftk_zplane_by
      integer  move_ftk_zplane_bz
      external move_ftk_zplane_b0
      external move_ftk_zplane_bx
      external move_ftk_zplane_by
      external move_ftk_zplane_bz

c     calling arguments
      DFLOAT zs
      record /ftrack_struct/ f1, f2
      record /bfield_struct/ bf
      DFLOAT s3d

c     local variables
      integer status
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(f1.q .eq. 0.) goto 100

      goto (100, 110, 120, 130, 140, 150, 160, 170), bf.type + 1

 100  status = move_ftk_zplane_b0(f1, zs, bf, f2, s3d)
      goto 500

 110  status = move_ftk_zplane_bx(f1, zs, bf, f2, s3d)
      goto 500

 120  status = move_ftk_zplane_by(f1, zs, bf, f2, s3d)
      goto 500

c 130  status = move_ftk_zplane_bxy(f1, zs, bf, f2, s3d)
c      goto 500
 130  goto 600

 140  status = move_ftk_zplane_bz(f1, zs, bf, f2, s3d)
      goto 500

c 150  status = move_ftk_zplane_bzx(f1, zs, bf, f2, s3d)
c      goto 500
 150  goto 600

c 160  status = move_ftk_zplane_byz(f1, zs, bf, f2, s3d)
c      goto 500
 160  goto 600

c 170  status = move_ftk_zplane_bxyz(f1, zs, bf, f2, s3d)
c      goto 500
 170  goto 600

 500  move_ftk_zplane = status
      return
      
 600  move_ftk_zplane = bf.type
      write(6,5000) bf.type
 5000 format('MOVE_FTK_ZPLANE has not been implemented for field type ',
     &        i3) 

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:37  garren
c add rcs log line
c

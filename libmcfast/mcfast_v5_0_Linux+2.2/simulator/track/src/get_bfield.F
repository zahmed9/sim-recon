      subroutine get_bfield(x, bf)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Return the magnitude and direction cosines of magnetic field at
c   the indicated position.
c
c  x(3)     DFLOAT array (read)
c           (x,y,z) of position
c
c *bf       bfield structure (write)
c           B field information
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

      save

#include "dipole.inc"
#include "solenoid.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     Calling arguments
      DFLOAT x(3)
      record /bfield_struct/ bf

c     Local variables
      integer i
      DFLOAT rsq
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Loop over all solenoids
      rsq = x(1)**2 + x(2)**2
      do i=1,sol_num
        if(x(3).ge.sol_par(i).zmin .and. x(3).le.sol_par(i).zmax .and.
     *     rsq .ge.sol_par(i).rmin**2 .and.
     *     rsq .le.sol_par(i).rmax**2) then
           bf.bmag = sol_par(i).bfield
           bf.bdir(1) = 0.
           bf.bdir(2) = 0.
           bf.bdir(3) = 1.
           bf.type = 4
           bf.devtype = 1
           bf.devnum = i
           return
         endif
      enddo

c     Loop over all dipoles
      do i=1,dip_num
        if(x(1).ge.dip_par(i).xmin .and. x(1).le.dip_par(i).xmax .and.
     *     x(2).ge.dip_par(i).ymin .and. x(2).le.dip_par(i).ymax .and.
     *     x(3).ge.dip_par(i).zmin .and. x(3).le.dip_par(i).zmax) then
           bf.bmag = dip_par(i).bfield

c     If b field non-zero, set it correctly
           if(bf.bmag .ne. 0.) then
             bf.type = 0
             bf.bdir(1) = dip_par(i).dircos(1)
             bf.bdir(2) = dip_par(i).dircos(2)
             bf.bdir(3) = dip_par(i).dircos(3)
             if(bf.bdir(1) .ne. 0.) bf.type = 1
             if(bf.bdir(2) .ne. 0.) bf.type = bf.type + 2
             if(bf.bdir(3) .ne. 0.) bf.type = bf.type + 4
             bf.devtype = 2
             bf.devnum =  i

c     If B field 0, set the direction cosines and type correctly
           else
             bf.bdir(1) = 0.
             bf.bdir(2) = 0.
             bf.bdir(3) = 1.
             bf.type = 0
             bf.devtype = 2
             bf.devnum =  i
           endif

           return

         endif
      enddo

c     Outside of all magnets
      bf.bmag = 0
      bf.bdir(1) = 0.
      bf.bdir(2) = 0.
      bf.bdir(3) = 1.
      bf.type = 0
      bf.devtype = 0
      bf.devnum = 0

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:35  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:13  garren
c add rcs log line
c

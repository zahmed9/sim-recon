      subroutine load_dip
      implicit none
#include "mcfast_db.inc"
#include "mcp_luns.inc"
#include "dipole.inc"
      integer i,j
*
      dip_num = min(max_dip,n_obj_dipole)
      if (dip_num.gt.0) then
        write(mcp_llpt,*) 'Loading dipoles'
      endif

      do i=1,dip_num
        dip_par(i).xmin = dipole(i).xmin
        dip_par(i).xmax = dipole(i).xmax
        dip_par(i).ymin = dipole(i).ymin
        dip_par(i).ymax = dipole(i).ymax
        dip_par(i).zmin = dipole(i).z0-dipole(i).zlen/2.
        dip_par(i).zmax = dipole(i).z0+dipole(i).zlen/2.
        dip_par(i).bfield = dipole(i).bfield
        dip_par(i).ptkick = 0.3*dipole(i).bfield*dipole(i).zlen
        do j=1,3
          dip_par(i).dircos(j) = dipole(i).dircos(j)
        enddo
        call getmat(dipole(i).mat_fill,dip_par(i).mat_fill)
        do j=1,6
          dip_par(i).thick_boun(j) = dipole(i).thick_boun(j)
          call getmat(dipole(i).mat_boun(j),dip_par(i).mat_boun(j))
        enddo
        write(mcp_llpt,'(a,3f9.3)') '   Dipole zmin,zmax,bfield',
     +    dip_par(i).zmin,dip_par(i).zmax,dip_par(i).bfield
      enddo
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:24  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:49  garren
c add rcs log line
c

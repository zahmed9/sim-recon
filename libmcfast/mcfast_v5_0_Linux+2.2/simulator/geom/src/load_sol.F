      subroutine load_sol
      implicit none
      integer i, j, lenocc
      external lenocc
#include "mcfast_db.inc"
#include "mcp_luns.inc"
#include "solenoid.inc"

      sol_num = min(max_sol,n_obj_solenoid)
      if (sol_num.gt.0) then
        write(mcp_llpt,*) 'Loading solenoids'
      endif

      do i=1,sol_num
        sol_par(i).name = solenoid(i).name(:lenocc(solenoid(i).name))
        call getmat(solenoid(i).mat_fill,sol_par(i).mat_fill)
        do j=1,4
          sol_par(i).thick_boun(j) = solenoid(i).thick_boun(j)
          call getmat(solenoid(i).mat_boun(j),sol_par(i).mat_boun(j))
        enddo
        sol_par(i).bfield = solenoid(i).bfield
        sol_par(i).rmin = solenoid(i).rmin
        sol_par(i).rmax = solenoid(i).rmax
        sol_par(i).zmin = solenoid(i).z0 - solenoid(i).zlen/2.
        sol_par(i).zmax = solenoid(i).z0 + solenoid(i).zlen/2.
        write(mcp_llpt,'(a,5f9.3)') '   Sol '//
     +    sol_par(i).name(:lenocc(sol_par(i).name))//
     +    ' rmin,rmax,zmin,zmax,B ',
     +    sol_par(i).rmin,sol_par(i).rmax,sol_par(i).zmin,
     +    sol_par(i).zmax,sol_par(i).bfield
      enddo
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:24  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:29:54  garren
c add rcs log line
c

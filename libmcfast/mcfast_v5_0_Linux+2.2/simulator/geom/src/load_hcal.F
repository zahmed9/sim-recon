      subroutine load_hcal
      implicit none
      integer i, j, lenocc
      external lenocc
#include "mcfast_db.inc"
#include "mcp_luns.inc"
#include "hadcal.inc"

      hcal_num = min(max_hcal,n_obj_hadcal)
      if (hcal_num.gt.0) then
        write(mcp_llpt,*) 'Loading hadron calorimeters'
      endif

      do i=1,hcal_num
        hcal_par(i).name = hadcal(i).name(:lenocc(hadcal(i).name))
        hcal_par(i).shape = hadcal(i).shape(:lenocc(hadcal(i).shape))
        call getmat(hadcal(i).material,hcal_par(i).material)
        hcal_par(i).type = hadcal(i).type
        do j=1,2
          hcal_par(i).rmin(j) = hadcal(i).rmin(j)
          hcal_par(i).rmax(j) = hadcal(i).rmax(j)
        enddo
        hcal_par(i).zmin = hadcal(i).z0-hadcal(i).zlen/2.
        hcal_par(i).zmax = hadcal(i).z0+hadcal(i).zlen/2.
        hcal_par(i).nphi = hadcal(i).nphi
        hcal_par(i).neta = hadcal(i).neta
        hcal_par(i).siga = hadcal(i).siga
        hcal_par(i).sigb = hadcal(i).sigb
        call geteta(hcal_par(i).type,hcal_par(i).rmin,
     +    hcal_par(i).rmax,hcal_par(i).zmin,hcal_par(i).zmax,
     +    hcal_par(i).eta_min,hcal_par(i).eta_max)
        write(mcp_llpt,'(a,4f9.3)')
     +    '   Hcal '//hcal_par(i).name(:lenocc(hcal_par(i).name))//
     +    '  zmin, zmax, etamin, etamax',
     +    hcal_par(i).zmin,hcal_par(i).zmax,
     +    hcal_par(i).eta_min,hcal_par(i).eta_max
 6000   format(' HAD Cal. GEOM: hcal_num,zmin,zmax,eta_min,eta_max', 
     +         i3,4f10.4) 
      enddo
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:24  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:29:51  garren
c add rcs log line
c

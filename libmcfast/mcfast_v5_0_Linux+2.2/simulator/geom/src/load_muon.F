      subroutine load_muon
      implicit none
      integer i, j, lenocc
      external lenocc
#include "mcfast_db.inc"
#include "mcp_luns.inc"
#include "muon.inc"

      muon_num = min(max_muon,n_obj_muon)
      if (muon_num.gt.0) then
        write(mcp_llpt,*) 'Loading muon chambers'
      endif

      do i=1,muon_num
        muon_par(i).name = muon(i).name(:lenocc(muon(i).name))
        muon_par(i).shape = muon(i).shape(:lenocc(muon(i).shape))
        call getmat(muon(i).material,muon_par(i).material)
        muon_par(i).type = muon(i).type
        do j=1,2
          muon_par(i).rmin(j) = muon(i).rmin(j)
          muon_par(i).rmax(j) = muon(i).rmax(j)
        enddo
        muon_par(i).zmin = muon(i).z0 - muon(i).zlen/2.
        muon_par(i).zmax = muon(i).z0 + muon(i).zlen/2.
        muon_par(i).nlyr = muon(i).nlayer
        call geteta(muon_par(i).type,muon_par(i).rmin,
     +    muon_par(i).rmax,muon_par(i).zmin,muon_par(i).zmax,
     +    muon_par(i).eta_min,muon_par(i).eta_max)
        write(mcp_llpt,'(a,4f9.3)') '   Muon '//
     +    muon_par(i).name(:lenocc(muon_par(i).name))//
     +    ' zmin, zmax, etamin, etamax',
     +    muon_par(i).zmin,muon_par(i).zmax,
     +    muon_par(i).eta_min,muon_par(i).eta_max
      enddo
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:24  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:29:52  garren
c add rcs log line
c

      subroutine get_ceta_cphi(ical, ieta, iphi, eta, phi)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Returns which calorimeter, and the center of the eta, phi bin
c   5/15/96  A.  Boehnlein 
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "mcfast_db.inc"
c     Input variables
      integer ical, ieta, iphi
      
c     Output variables
      real eta, phi
      
c     Local variables
      integer nphi, neta, ietaphi
      real  delphi, deleta, eta_min, eta_max, zmin, zmax
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


c
      if (n_obj_emcal.eq.0) then
	print *, "There is no calorimeter geometry information!"
	return
      endif
c
      neta = emcal(ical).neta
      nphi = emcal(ical).nphi

      zmin = emcal(ical).z0 - (emcal(ical).zlen/2.)
      zmax = emcal(ical).z0 + (emcal(ical).zlen/2.)
      call geteta(emcal(ical).type, emcal(ical).rmin, emcal(ical).rmax,
     &            zmin, zmax, eta_min, eta_max)
      deleta = (eta_max-eta_min)/float(neta)
      delphi = (2. * pi)/ float(nphi) 

      eta = deleta*(float(ieta) + 0.5) + eta_min
      phi = delphi*(float(iphi) + 0.5)

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:28  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:11  garren
c add rcs log line
c

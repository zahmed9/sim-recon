      subroutine muon_ntp(w,w_gen,hep,muon)
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c    make plots...
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "mcp_hbook.inc"
#include "stdhep.inc"
#include "muon.inc"
#include "offline_muon.inc"
#include "wtrack_struct.inc"
#include "muon_ntuple.inc"


c    Local variables
      integer hep, muon
      integer i, hits, ihits, nmudet
      integer mom, id_mom, grand_mom, id_grand
      integer error

      DFLOAT eta,phi,theta
      DFLOAT eta_gen,phi_gen,theta_gen
      real E, Energy1, Energy0

      record /wtrack_struct/ w,w_gen


c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

       hits = 0
       nmudet = 0
       Energy1= -1.
       
       if (muon .gt. 0) then                
         do i = 1, muon_num
           ihits  = muon_off(muon).hits(i)
           E = muon_off(muon).Energy(i)
           if (ihits .gt. 1) then
              Energy1=amax1(Energy1,E)
              hits = hits + ihits
              nmudet = nmudet + 1
           endif
         enddo
       endif
          
 
       if (w.E .gt. 0.) then            ! muon with track
         call wtoeta(w,eta,phi,theta,error)
         if (error .ne. 0) return
         Energy0 = real(w.E)
       else
         eta = 0.
         phi = 0.
         theta = 0.
         Energy0= real(w_gen.E)
       endif    
       
       call wtoeta(w_gen,eta_gen,phi_gen,theta_gen,error)
       if (error .ne. 0) return

       mom = jmohep(1,hep)
       id_mom = idhep(mom)
       grand_mom = jmohep(1,mom)
       id_grand  = idhep(grand_mom)
    
       mu_ntpl(1)  =  real(w.pt)
       mu_ntpl(2)  =  real(eta)
       mu_ntpl(3)  =  real(phi)             
       mu_ntpl(4)  =  real(w_gen.pt)
       mu_ntpl(5)  =  real(eta_gen)
       mu_ntpl(6)  =  real(hits)
       mu_ntpl(7)  =  real(nmudet)
       mu_ntpl(8)  =  real(Energy0)
       mu_ntpl(9)  =  real(Energy1)
       mu_ntpl(10) =  real(w.p)           
       mu_ntpl(11) =  real(w.x)
       mu_ntpl(12) =  real(w.y)
       mu_ntpl(13) =  real(w.z)
       mu_ntpl(14) =  real(id_mom)
       mu_ntpl(15) =  real(id_grand)
       
       call hcdir('//PAWC',' ')
       call hcdir(hbk_topdir,' ')
       
       call hfn(1000,mu_ntpl)
       call hcdir('//PAWC',' ')  
       
       return
       end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:26  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:04  garren
c add rcs log line
c









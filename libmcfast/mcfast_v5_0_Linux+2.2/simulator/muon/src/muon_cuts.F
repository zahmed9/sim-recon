      subroutine muon_cuts(imuon_det,w1,hits,E,error) 
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    from track info: find if particle will hit muon detector
c    
c    from efficiency per layer--will change to function of
c    momentum
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "muon.inc"
#include "wtrack_struct.inc"
#include "volume.inc"
#include "bfield_struct.inc"
     
c     Local variables
      integer nlayer,i,i_abs,hits
      integer imuon_det
      integer error

      real thickness
      real dedx_zmin,dedx_zmax, dedx_rmin, dedx_rmax
      real dedx,E,E0
      real eta_min, eta_max
      DFLOAT layer
      DFLOAT eta,phi,theta
      DFLOAT zmin,zmax,rmin,rmax
      DFLOAT r,z,s

      record /wtrack_struct/ w1, w2
      record /muon_struct/ mudet
      record /bfield_struct/ bf0

      integer move_wtk_radius, move_wtk_zplane
      logical between
      
      integer lenocc
      external lenocc

cc     real eff_layer
c      data eff_layer/ 0.98 /

c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
       error = 0    
       hits = 0
       E=0.

       if(w1.p .le. 0.0 .or. w1.pt .le. 0.0) then
           error = 1
           return
       endif

       call ucopy(muon_par(imuon_det),mudet,15)
       
       bf0.type = 0              ! set bfield to zero for tracing
       E0 = real(w1.E) 

c      trace to muon detector... does it hit?

       nlayer     = mudet.nlyr
       if( nlayer .le. 0) goto 999   ! no layers ==> no hits


       if (mudet.shape(1:4) .eq. 'TUBE') then

         rmin       = mudet.rmin(1)
         rmax       = mudet.rmax(1)

         if (mudet.type .eq. 1) then                 ! CENTRAL 
           error= move_wtk_radius(w1,rmin,1,bf0,w2,s)  
           if (error .ne. 0 .or. s .lt. 0.) goto 999
           if(between(real(w2.z),mudet.zmin,mudet.zmax)) then
              call muon_dedx(w1,s,bf0,dedx) 
              E = E0 - dedx             ! dedx in front of mu_det
              if (E .gt. 0.) then 
                 thickness  = (rmax - rmin)/nlayer
                 layer      = rmin + (thickness/2)
                 do i = 1, nlayer
                    error= move_wtk_radius(w1,layer,1,bf0,w2,s)
                    if (error .ne. 0 .or. s .lt. 0.) goto 999
                    z = w2.z
                    if(between(real(z),mudet.zmin,mudet.zmax)) then 
                      hits = hits + 1
                    endif
                 enddo
              endif     
           endif

         elseif (mudet.type .eq. 2 ) then   ! FORWARD
           if (abs(mudet.zmin) .lt. abs(mudet.zmax)) then
               zmin = mudet.zmin
           else
               zmin = mudet.zmax
           endif
           error= move_wtk_zplane(w1,zmin,bf0,w2,s)
           if (error .ne. 0 .or. s .lt. 0.) goto 999
           r = sqrt(w2.x**2 + w2.y**2)
           if(between(real(r),real(rmin),real(rmax))) then
              call muon_dedx(w1,s,bf0,dedx) 
              E = E0 - dedx             ! for all absorbers...
              if (E .gt. 0.) then 
                 thickness  = abs(mudet.zmax - mudet.zmin)/nlayer
                 layer      = zmin + (thickness/2)*sign(ONE,zmin)
                 do i = 1, nlayer
                    error= move_wtk_zplane(w1,layer,bf0,w2,s)
                    if (error .ne. 0 .or. s .lt. 0.) goto 999
                       r = sqrt(w2.x**2 + w2.y**2)           
                       if(between(real(r),real(rmin),real(rmax))) then 
                          hits = hits + 1
                       endif
                 enddo
              endif
           endif
         endif

       elseif (mudet.shape(1:4) .eq. 'CONE') then  ! use eta for conical shapes
           eta_min = mudet.eta_min
           eta_max = mudet.eta_max
           call wtoeta(w1,eta,phi,theta,error)
           if (error .ne. 0) goto 999
           if(between(real(eta),eta_min,eta_max)) then
              if (abs(mudet.zmin) .lt. abs(mudet.zmax)) then
                 zmin = mudet.zmin
              else
                 zmin = mudet.zmax
              endif
              error = move_wtk_zplane(w1,zmin,bf0,w2,s)
              call muon_dedx(w1,s,bf0,dedx) 
              E = E0 - dedx
              if (E .gt. 0.) hits = hits+ nlayer
           endif
       else                             ! not defined
           error = 1000
       endif

 999   if (E .le. 0.) E = 0.
       return
       end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:26  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:02  garren
c add rcs log line
c



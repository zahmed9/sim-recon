      subroutine muon_absorb(w,s,bf,absorb,dedx)
c
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    find the material in front of the muon detector
c
c
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "absorber_struct.inc"
#include "material.inc"
#include "bfield_struct.inc"
#include "wtrack_struct.inc"
 
      record /wtrack_struct/ w
      record /bfield_struct/ bf
      DFLOAT s                                 ! path length to mu-det
      real dedx   
      record /absorber_struct/ absorb

c     Local variables 
      record /wtrack_struct/ w2

      integer error, material
      DFLOAT eta,phi,theta
      DFLOAT rmin,rmax,zmin,zmax
      DFLOAT lmin, lmax
      DFLOAT r
      real r1,r2,thick
      real eta_min, eta_max

      integer move_wtk_radius, move_wtk_zplane
      integer lenocc
      logical between
      
      external move_wtk_radius, move_wtk_zplane
      external lenocc
      external between

c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      call wtoeta(w,eta,phi,theta,error)  !  not exactly correct...
      if (error .ne. 0 ) return
      
      material = absorb.material
      lmin = 0.   ! distance to front of detector
      lmax = 0.   ! distance to back of detector
      
      if (absorb.shape(1:4) .eq. 'TUBE' )then
         if (absorb.type .eq. 1) then
            rmin=min(absorb.rmin(1),absorb.rmin(2))
            rmax=max(absorb.rmax(1),absorb.rmax(2))
            error= move_wtk_radius(w,rmin,1,bf,w2,lmin)
            if (between(real(w2.z),absorb.zmin,
     +                             absorb.zmax)) then
                error= move_wtk_radius(w,rmax,1,bf,w2,lmax)
            endif

         elseif (absorb.type .eq. 2) then
            if (abs(absorb.zmin) .lt. abs(absorb.zmax)) then
               r1=absorb.rmin(1)
               r2=absorb.rmax(1)
               zmin=absorb.zmin
               zmax=absorb.zmax
            else
               r1=absorb.rmin(2)
               r2=absorb.rmax(2)
               zmin=absorb.zmax
               zmax=absorb.zmin
            endif
            error= move_wtk_zplane(w,zmin,bf,w2,lmin)
            r = sqrt(w2.x**2 + w2.y**2)
            if (between(real(r),r1,r2)) then
               error= move_wtk_zplane(w,zmax,bf,w2,lmax) 
            endif            
         endif
       elseif (absorb.shape(1:4) .eq. 'CONE' )then
         eta_min = absorb.eta_min
         eta_max = absorb.eta_max
         if(between(real(eta),eta_min,eta_max)) then
             if (abs(absorb.zmin) .lt. abs(absorb.zmax)) then
                zmin = absorb.zmin
                zmax = absorb.zmax
             else
                zmin = absorb.zmax
                zmax = absorb.zmin
             endif
             error= move_wtk_zplane(w,zmin,bf,w2,lmin)
             if (absorb.type .eq. 1) then
                rmax = absorb.rmax(1)
                error= move_wtk_radius(w,rmax,1,bf,w2,lmax)
             elseif (absorb.type.eq.2) then 
                error= move_wtk_zplane(w,zmax,bf,w2,lmax)  
             endif   
         endif   
       endif
        
       if (lmax .gt. 0. .and. lmin .gt. 0.) then 
         if (lmax .lt. s) then
              thick= real(lmax - lmin)
         elseif (lmin .lt. s) then
              thick= real(s - lmin)  
         else       
              thick= 0.
         endif
         if (thick .gt. 0.) then
           dedx =  dedx + mtl_par(material).dedx * thick
         endif  
       endif
          
       return
       end
        
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:26  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:30:02  garren
c add rcs log line
c


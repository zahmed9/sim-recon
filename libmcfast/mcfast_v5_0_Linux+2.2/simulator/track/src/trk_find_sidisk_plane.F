      subroutine trk_find_sidisk_plane(w,dev,lyr,iw,wedge,lstrike,eta)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Find which silicon DISK plane a track went through
c
c   Approximates a disk plane as cylindrical with full acceptance
c   between rmin and rmax, not as a N-agon composed of wedges.
c   More refined acceptance calculated at hit stage.
c   Does take into account the phi coverage (may be incomplete; a 'fan').
c
c  Inputs:
c
c  w          w track structure
c             Track parameters
c
c  dev        integer variable
c             Silicon plane array device number
c
c  lyr        integer variable
c             Number of plane that was hit
c
c  iw         integer. Wedge number of 1st wedge at this z location.
c
c  Outputs:
c
c  wedge      integer variable
c             Wedge that is hit
c
c  lstrike    logical variable
c             TRUE if track falls within a wedge boundary
c
c  eta(3)     DFLOAT variable
c             Direction cosines normal to plane
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Corrections and Comments added by plm 7/16/96
c
c      Coverage for each layer extends from phi(1) to phi(2)
c      There can be gaps between wedges
c
c      assumes the minimum and maximum radii are the same for all
c       wedges in a layer 
c
c      All adjacent wedges at one z location are in one zplane
c      The first wedge at this particular z location is iw
c                   --> see routine geo_trkorder
c
c      Wedges in phi are described by 
c             nwedge:  total number of wedges
c             iwedge:    ith wedge (1..nwedge)
c
c             beta(iwedge):  phi angle from the x axis to the 
c                          center of each wedge
c
c             phi(2)-phi(1): phi coverage of layer  --> coverage
c                  is calculated from phi(1) = beta(1)- dbeta/2 to
c                  to phi(2) = beta(nwedge) + dbeta/2
c
c             dphi:  phi coverage of each wedge  --
c                 overlapping wedges should be at different z locations
c                 ie in different layers
c
c             dbeta: angle between adjacent wedge centers
c                         dbeta = (phi(2)-phi(1)) / nwedge  
c                    dbeta = dphi for full coverage 
c
c             beta = phi(1) + dbeta/2 + (iwedge-1)*dbeta
c 
c     currently the z position is the same for all wedges in a layer
c     this is the way the geometry template is constructed
c     this cannot be true if there are overlapping wedges in a "layer"
c
c     silicon disk detectors:
c
c     type = 1:  r measuring--- not implemented yet
c          = 2:  phi measuring
c          = 3:  stereo
c          = 4:  flat edges at rmin and rmax for each wedge
c
c 
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "sicir_disk.inc"
#include "wtrack_struct.inc"

c     Calling arguments
      integer dev, lyr, iw, wedge
      logical lstrike
      DFLOAT eta(3)
      record /wtrack_struct/ w

      external phi_norm
      DFLOAT phi_norm

      integer nwedge,iwedge, type
      DFLOAT tkr2, phi
      DFLOAT dot, dot_max, cos_beta, sin_beta, x ,rmin, rmax
      DFLOAT dphi, beta, phi0, phi1, phi_lyr(2), tmp
      real zlyr 
      
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      tkr2 =  w.x**2 + w.y**2
      phi  =  phi_norm(atan2(w.y,w.x))     ! phi of hit at z plane
      type = sicir_par(dev).lyr(lyr).wedge(iw).type
      phi_lyr(1) = sicir_par(dev).lyr(lyr).phi(1)
      phi_lyr(2) = sicir_par(dev).lyr(lyr).phi(2)
      nwedge = sicir_par(dev).lyr(lyr).numwedge

      rmax = sicir_par(dev).lyr(lyr).wedge(iw).rmax
      rmin = sicir_par(dev).lyr(lyr).wedge(iw).rmin

      if (type.ne.4) then
        lstrike = tkr2 .le. rmax**2 .and. tkr2.ge. rmin**2 ! radial limits 
      else
        tmp = cos((phi_lyr(2)-phi_lyr(1))/nwedge/2)
	if (tmp .ne. 0) then
          lstrike = tkr2 .le. rmax**2/tmp**2 .and. tkr2 .ge. rmin**2    ! trapezoidal wedges
        else
	  lstrike = .false.                ! trapezoidal wedge can't cover pi radians
        end if
      end if

      if(lstrike) then       
        phi_lyr(1) = sicir_par(dev).lyr(lyr).phi(1)
        phi_lyr(2) = sicir_par(dev).lyr(lyr).phi(2)
        dphi = abs(phi_lyr(2) - phi_lyr(1))
        if ( dphi .lt. tpi) then
         phi_lyr(1) = phi_norm(phi_lyr(1))
         phi_lyr(2) = phi_norm(phi_lyr(2))
         if (phi_lyr(1) .le. phi_lyr(2)) then
           lstrike = phi .ge. phi_lyr(1)             ! phi coverage               
     *          .and. phi .le. phi_lyr(2)
         else
           lstrike = phi .ge. phi_lyr(1) .or. phi .le. phi_lyr(2)
         endif
        endif
     
        if(lstrike) then
          nwedge = sicir_par(dev).lyr(lyr).numwedge
          zlyr   = sicir_par(dev).lyr(lyr).wedge(iw).z
          
c         Compute which wedges were hit based on phi position of hit
          wedge =  0
          dot_max   = -2.
          do iwedge=iw,nwedge
            if(sicir_par(dev).lyr(lyr).wedge(iwedge).z .ne. zlyr) 
     *                goto 50    ! end of this z plane -- for the future
            cos_beta = sicir_par(dev).lyr(lyr).wedge(iwedge).cos_beta
            sin_beta = sicir_par(dev).lyr(lyr).wedge(iwedge).sin_beta
            dot = (w.x*cos_beta + w.y*sin_beta)/sqrt(tkr2)
            if(dot .gt. dot_max) then
               dot_max = dot
               wedge = iwedge
            endif
          enddo
          if (wedge .gt. 0) then
            dphi =  sicir_par(dev).lyr(lyr).wedge(wedge).d_phi
            beta =  sicir_par(dev).lyr(lyr).wedge(wedge).beta
            phi0  =  phi_norm(beta -  dphi/2) 
            phi1  =  phi_norm(beta +  dphi/2)
            if ( phi0 .gt. phi1 ) then
              lstrike = phi .ge. phi0  .or. phi .le. phi1
            else 
              lstrike = phi .ge. phi0 .and. phi .le. phi1
            endif
          else
            lstrike = .false.       ! no maximum found --error
          endif
        endif
      endif
      
50    eta(1) = 0.    ! return normal to the plane
      eta(2) = 0.
      eta(3) = 1.

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:36  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:23  garren
c add rcs log line
c

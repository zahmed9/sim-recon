      subroutine trk_make_sidisk_hit(hep, trace, w, dev, lyr, iw,
     +  lstrike, bf, hit, error)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Make a hit in a silicon disk plane.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Modified 06/27/96 ASB, corrected hit filling for layers


c Notes.
c
c For all types.
c   a) All wedges are presumed to be perfectly aligned - that is,
c   b) they are perpendicular to the z axis
c   c) the edges of the wafer are radial lines ( ie no (x,y) displacement).
c
c type 3:
c  a) The sides of the sensitive region are radial lines.  The inner
c     and outer boundaries are arcs of a circle.
c
c types 4:
c  a) The sensitive area has the shape of a trapezoid - ie the inner
c     and outer boundaries are straight lines, not arcs of a circle.
c  b) The dead periphery of the wafer is a phi slice - ie it is not 
c     a constant width as one goes out along a radius.

      implicit none

      save

#include "const.inc"
#include "hit_track.inc"
#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "trk_channel_struct.inc"
#include "trace.inc"
#include "hep_trace.inc"
#include "devtype.inc"
#include "sicir_disk.inc"

c     Externals
      external phi_norm, get_gauss, rann
      DFLOAT   phi_norm
      real     get_gauss, rann

c     Calling arguments
      integer hep, trace, dev, lyr, iw, idpos(3), hit, error
      logical lstrike
      record /wtrack_struct/ w
      record /bfield_struct/ bf

c     Local variables
      DFLOAT phi, eta(3), xpos(3), deadphi, deadr
      DFLOAT dphi, phi0, pitch, philoc, rloc
      DFLOAT dcalc(2), rr, sigma, dmeas, psi
      DFLOAT phicl, rwid, rc, xphi, yphi, xnew, ynew, phis
      DFLOAT siga, sigb, phi_pitch, sigphi
      DFLOAT ynew_cent, xposphi(2)
      DFLOAT rmin, rmax, coord0_r, coord0_phi
      DFLOAT xposnew, yposnew
      integer nwedge, nstrip, type

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      hit = 0

      if (.not.lstrike) goto 9997

***     Check efficiency
      if (rann(0) .gt. sicir_par(dev).lyr(lyr).wedge(iw).eff_hit)
     +  goto 2000

      eta(1) = 0.0
      eta(2) = 0.0
      eta(3) = 1.0
      xpos(1) = 0.
      xpos(2) = 0.
      xpos(3) = sicir_par(dev).z

c  phi is the angle in the xy plane relative to the x-axis, in 
c      global coordinates
c  rr is the distance to the beam axis
      phi = phi_norm(atan2(w.y,w.x))
      rr = sqrt(w.x**2+w.y**2)
      type = sicir_par(dev).lyr(lyr).wedge(iw).type
      pitch = sicir_par(dev).lyr(lyr).wedge(iw).pitch

c  coord0_r and coord0_phi are in local coordinates
      coord0_r = sicir_par(dev).lyr(lyr).wedge(iw).coord0_r
      coord0_phi = sicir_par(dev).lyr(lyr).wedge(iw).coord0_phi

c  dphi is the width of the wedge in phi
c  phi0 is the low-phi edge of the wedge in global coords.
      dphi = sicir_par(dev).lyr(lyr).wedge(iw).d_phi
      phi0 = sicir_par(dev).lyr(lyr).wedge(iw).beta - dphi/2.

c  deadphi is the width of the insensitive phi region on each side
c  of the wedge
      if (coord0_phi.gt.0.0) then
        deadphi = coord0_phi
      else
        deadphi = 0.0                   !disregard negative coord0_phi
      end if

c  local phi. Low-phi edge = 0.0
      philoc = phi - phi0
      if (philoc .ge. 2.*pi) then
        philoc = philoc - 2.*pi
      else if (philoc .lt. 0.0) then
        philoc = philoc + 2.*pi
      end if

c  phi of wedge center line in global coordinates
      phicl = sicir_par(dev).lyr(lyr).wedge(iw).beta

c  width of insensitive region in r at top and bottom of wedge
      if (coord0_r.gt.0.0) then
        deadr = coord0_r
      else
        deadr = 0.0                     !disregard negative coor0_r
      end if

c  inner and outer edges of wedge material
      rmin = sicir_par(dev).lyr(lyr).wedge(iw).rmin
      rmax = sicir_par(dev).lyr(lyr).wedge(iw).rmax
      rwid = rmax - rmin

c  local r. Inner edge = 0.0
      rloc = rr - rmin

      if (type.eq.1) then       ! r-measuring
        if (rloc.lt.deadr.or.rloc.gt.rwid-deadr)  goto 9997
        if (philoc.lt.deadphi.or.philoc.gt.dphi-deadphi) goto 9997

        dmeas = rloc - deadr

c  measurement direction, i.e. vector pointing from xpos that is
c  perpendicular to the strips, in the direction of increasing strip number
        eta(1) = w.x/rr
        eta(2) = w.y/rr
        eta(3) = 0.0

c  xpos is the global position from which dmeas measures in the 
c  direction of eta
        xpos(1) = eta(1)*(rmin+deadr)
        xpos(2) = eta(2)*(rmin+deadr)

        sigma = sicir_par(dev).lyr(lyr).wedge(iw).siga
        nstrip = (rloc-deadr)/pitch

      else if (type.eq.2 .or. type .eq. 5) then  ! phi-measuring
        if (rloc.lt.deadr.or.rloc.gt.rwid-deadr)  goto 9997
        if (philoc.lt.deadphi.or.philoc.gt.dphi-deadphi) goto 9997
        sigphi = sicir_par(dev).lyr(lyr).wedge(iw).siga
        if (type .eq. 2) then
          sigma = sigphi * rr
        else
          sigma = sicir_par(dev).lyr(lyr).wedge(iw).siga
        endif
        
c  xpos is the global position from which dmeas measures in the 
c  direction of eta
        xpos(1) = rmax*cos(phicl-dphi/2.)
        xpos(2) = rmax*sin(phicl-dphi/2.)

c  local coords in wedge frame, taking center line as x axis
        xphi =  w.x*cos(phicl) + w.y*sin(phicl)  ! coord along center line
        yphi = -w.x*sin(phicl) + w.y*cos(phicl)  ! coord perp to center line
        xposphi(1) = xpos(1)*cos(phicl) + xpos(2)*sin(phicl)
        xposphi(2) = -xpos(1)*sin(phicl) + xpos(2)*cos(phicl)

c  now transform these coordinates by local stereo angle
        phis = philoc - dphi/2.
        xposnew  = xposphi(1)*cos(phis) + xposphi(2)*sin(phis)  !"radial" dir.
        yposnew = -xposphi(1)*sin(phis) + xposphi(2)*cos(phis)  !"phi" dir.
        xnew  = xphi*cos(phis) + yphi*sin(phis)          ! "radial" dir.
        ynew = -xphi*sin(phis) + yphi*cos(phis)          ! "phi" dir.

c  but watch: we want dmeas=0 to pass through xpos, so we have to shift
c  the coordinate system by yposnew:
        dmeas = ynew - yposnew

c  we want to define the strip numbering so that the center of the wedge
c  has a positive strip number, so flip ynew if the center is at a
c  negative value of ynew:
        ynew_cent = -(rmin+rwid/2.)*sin(phis) - yposnew
        if (ynew_cent .lt. 0.0) dmeas = -dmeas

c  pitch is the strip width at coord0_r in units of radians
ccc        phi_pitch = pitch/(2*PI*(rmin+deadr))
        nstrip = int((philoc-deadphi)/pitch)

c  psi is the angle the strip makes with respect to the x axis in the
c  x,y plane
c  in this case, the strips always point radially outwards
        psi = phi

c  measurement direction, i.e. vector pointing from xpos that is
c  perpendicular to the strips, in the direction of increasing strip number
        eta(1) = -sin(psi)
        eta(2) = cos(psi)
        eta(3) = 0.0

      else if (type.eq.3) then                  !U,V circular wedge
        if (rloc.lt.deadr.or.rloc.gt.rwid-deadr)  goto 9997
        if (philoc.lt.deadphi.or.philoc.gt.dphi-deadphi) goto 9997

c  xpos is the global position from which dmeas measures in the 
c  direction of eta.  we choose whichever of the outer corners
c  will give positive dmeas values
        if (sicir_par(dev).lyr(lyr).wedge(iw).stereo .ge. 0.0 .and.
     &      sicir_par(dev).lyr(lyr).wedge(iw).stereo .lt. pi) then
          xpos(1) = rmax*cos(phicl-dphi/2.)
          xpos(2) = rmax*sin(phicl-dphi/2.)
        else
          xpos(1) = rmax*cos(phicl+dphi/2.)
          xpos(2) = rmax*sin(phicl+dphi/2.)
        end if

c  local coords in wedge frame, taking center line as x axis
        xphi =  w.x*cos(phicl) + w.y*sin(phicl)  ! coord along center line
        yphi = -w.x*sin(phicl) + w.y*cos(phicl)  ! coord perp to center line
        xposphi(1) = xpos(1)*cos(phicl) + xpos(2)*sin(phicl)
        xposphi(2) = -xpos(1)*sin(phicl) + xpos(2)*cos(phicl)

c  now transform these coordinates by local stereo angle
        phis = sicir_par(dev).lyr(lyr).wedge(iw).stereo
        xposnew  = xposphi(1)*cos(phis) + xposphi(2)*sin(phis)  !"radial" dir.
        yposnew = -xposphi(1)*sin(phis) + xposphi(2)*cos(phis)  !"phi" dir.
        xnew  = xphi*cos(phis) + yphi*sin(phis)          ! "radial" dir.
        ynew = -xphi*sin(phis) + yphi*cos(phis)          ! "phi" dir.

c  but watch: we want dmeas=0 to pass through xpos, so we have to shift
c  the coordinate system by yposnew:
        dmeas = ynew - yposnew

c  we want to define the strip numbering so that the center of the wedge
c  has a positive strip number, so flip ynew if the center is at a
c  negative value of ynew:
        ynew_cent = -(rmin+rwid/2.)*sin(phis) - yposnew
        if (ynew_cent .lt. 0.0) dmeas = -dmeas
        nstrip = int(dmeas/pitch)

c  strip resolution
        sigma = sicir_par(dev).lyr(lyr).wedge(iw).siga

c  strip angle relative to x axis
        psi = phicl + phis

c  measurement direction, i.e. vector pointing from xpos that is
c  perpendicular to the strips, in the direction of increasing strip number
        eta(1) = -sin(psi)
        eta(2) = cos(psi)
        eta(3) = 0.0

      else if (type.eq.4) then                  !U,V trapezoidal wedge

        ! Are we inside the active region in phi?
        if (philoc.lt.deadphi.or.philoc.gt.dphi-deadphi) goto 9997

        ! Component of w track position along a radial line
        ! through the center of the wedge.
        xphi =  w.x*cos(phicl) + w.y*sin(phicl)

        ! Are we inside the active region in radius?
        xphi = xphi - rmin
        if (xphi.lt.deadr.or.xphi.gt.rwid-deadr) goto 9997

        phis = sicir_par(dev).lyr(lyr).wedge(iw).stereo

        ! Origin of wafer local coordinate system.
        if (phis .ge. 0.0 .and. phis .lt. pi ) then
           xpos(1) = rmax/cos(dphi/2.) * cos(phicl-dphi/2.)
           xpos(2) = rmax/cos(dphi/2.) * sin(phicl-dphi/2.)
           psi = phicl+phis+pi/2.
        else
           xpos(1) = rmax/cos(dphi/2.) * cos(phicl+dphi/2.)
           xpos(2) = rmax/cos(dphi/2.) * sin(phicl+dphi/2.)
           psi = phicl+phis-pi/2.
        end if

        ! Unit vector along measurement direction.
        eta(1) = cos(psi)
        eta(2) = sin(psi)
        eta(3) = 0.0

        dmeas  = (w.x-xpos(1))*eta(1) + (w.y-xpos(2))*eta(2)
        nstrip = int(dmeas/pitch)
        sigma  = sicir_par(dev).lyr(lyr).wedge(iw).siga

        ! This is probably needed in other places too.
        xpos(3) = w.z

      else
        print *,'ERROR unknown Si disk type ',type
        stop

      endif
      
      if(hit_trk_num .ge. hit_trk_max) goto 9998

      hit_trk_num = hit_trk_num + 1

      hit_trk(hit_trk_num).hep   = hep
      hit_trk(hit_trk_num).trace = trace

***     Store device, layer, plane, strip info
      hit_trk(hit_trk_num).chan.devtype   = jdev_sildisk
      hit_trk(hit_trk_num).chan.devnum    = dev
      hit_trk(hit_trk_num).chan.devlayer  = lyr
      hit_trk(hit_trk_num).chan.devwid(1) = iw
      hit_trk(hit_trk_num).chan.devwid(2) = nstrip
      hit_trk(hit_trk_num).chan.devwid(3) = type
      call geo_set_trkchan(hit_trk(hit_trk_num).chan)

***     Position, orientation of plane
      hit_trk(hit_trk_num).pos(1)        = xpos(1)
      hit_trk(hit_trk_num).pos(2)        = xpos(2)
      hit_trk(hit_trk_num).pos(3)        = xpos(3)
      hit_trk(hit_trk_num).dircos(1)     = eta(1)
      hit_trk(hit_trk_num).dircos(2)     = eta(2)
      hit_trk(hit_trk_num).dircos(3)     = eta(3)

      hit_trk(hit_trk_num).dtime_exact   = 0.
      hit_trk(hit_trk_num).dtime         = 0.
      hit_trk(hit_trk_num).dtime_sigma   = 0
      hit_trk(hit_trk_num).dpix_exact(1) = 0.0
      hit_trk(hit_trk_num).dpix_exact(2) = 0.0

      hit_trk(hit_trk_num).dmeas_sigma   = sigma
      hit_trk(hit_trk_num).dmeas_exact   = dmeas
      hit_trk(hit_trk_num).dmeas         = dmeas + sigma*get_gauss(0)

      hit_trk(hit_trk_num).dpix(1)       = 0.
      hit_trk(hit_trk_num).dpix(2)       = 0.
      hit_trk(hit_trk_num).dpix_cov(1,2) = 0.
      hit_trk(hit_trk_num).dpix_cov(2,1) = 
     &      hit_trk(hit_trk_num).dpix_cov(1,2)
      hit_trk(hit_trk_num).dpix_cov(1,1) = 0.
      hit_trk(hit_trk_num).dpix_cov(2,2) = 0.

***     Normal exit
 1000 hit = hit_trk_num
      if(hep_trace(hep).nhit .eq. 0) then
        hep_trace(hep).first_hit = hit_trk_num
      endif
      hep_trace(hep).nhit = hep_trace(hep).nhit + 1

 2000 error = 0
      return

***     Outside active area
 9997 error = 0
      return

***     Too many hits
 9998 error = 1
      return
      end

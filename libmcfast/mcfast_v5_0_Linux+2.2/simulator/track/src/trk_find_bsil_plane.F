      subroutine trk_find_bsil_plane(w, arc, bf, dev, lyr, plns, 
     *                               lstrikes, etas)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Find which silicon planes a track went through. The routine determines
c   if the track went through two overlapping planes. The planes are
c   returned in the order in which they are struck.
c
c  Inputs:
c
c  w          w track structure
c             Track parameters
c
c  arc        DFLOAT variable
c             Arc length from creation point to the point w.
c
c  bf         B field structure
c             B field info
c
c  dev        integer variable
c             Silicon barrel device number
c
c  lyr        integer variable
c             Layer number
c
c  Outputs:
c
c  plns(2)    integer variable
c             Planes which were hit
c
c  lstrikes(2) logical variable
c              TRUE if track falls within plane boundaries
c
c  eta3(3,2)  DFLOAT variable
c             Direction cosines normal to planes
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "si_barrel.inc"
#include "wtrack_struct.inc"
#include "bfield_struct.inc"

c     externals
      external phi_norm
      DFLOAT   phi_norm

      external move_wtk_xyplane
      integer  move_wtk_xyplane


c     Calling arguments
      record /wtrack_struct/ w
      record /bfield_struct/ bf
      integer dev, lyr, plns(2)
      logical lstrikes(2)
      DFLOAT etas(3,2), xpos(3,2)

c     Functions
      logical trk_check_back_step

c     Local variables
      integer nplane, itemp, ipl, i, stat1, stat2, plane_max
      logical ltemp
      DFLOAT temps(3), s3d(2), dcalc, width
      DFLOAT dot, dot_max, sine
      DFLOAT arc
      DFLOAT dmin, dmax, zmin, zmax
      record /wtrack_struct/ w2, w3
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      nplane = sib_par(dev).lyr(lyr).numplane

c     Compute which planes were hit based on phi position of hit.
c     Return two planes for overlap.
c     The algorithm looks for the plane with the maximum dot product
c     (in r-phi plane) of 2 vectors:
c        1. Line from origin to track position
c        2. Line from origin to plane center
      dot_max = -2.
      plane_max = 0
      sine = 0.
      do ipl=1,nplane
        xpos(1,1) = sib_par(dev).lyr(lyr).plane(ipl).xpos(1)
        xpos(2,1) = sib_par(dev).lyr(lyr).plane(ipl).xpos(2)
        dot = (w.x*xpos(1,1) + w.y*xpos(2,1))
     *      / sqrt( (w.x**2 + w.y**2) * (xpos(1,1)**2 + xpos(2,1)**2) )
        if(dot .gt. dot_max) then
          dot_max = dot
          plane_max = ipl
          sine = w.y*xpos(1,1) - w.x*xpos(2,1)    !Proportional to sine
        endif

      enddo

c     Find adjacent plane based on the sign of the sine of angle between
c     track and center of plane
      plns(1) = plane_max
      if(sine .ge. 0.) then
        plns(2) = plns(1) + 1
        if(plns(2) .gt. nplane) plns(2) = 1
      else
        plns(2) = plns(1) - 1
        if(plns(2) .eq. 0) plns(2) = nplane
      endif

      xpos(1,1) = sib_par(dev).lyr(lyr).plane(plns(1)).xpos(1)
      xpos(2,1) = sib_par(dev).lyr(lyr).plane(plns(1)).xpos(2)
      xpos(3,1) = sib_par(dev).lyr(lyr).plane(plns(1)).xpos(3)
      etas(1,1) = sib_par(dev).lyr(lyr).plane(plns(1)).eta(1)
      etas(2,1) = sib_par(dev).lyr(lyr).plane(plns(1)).eta(2)
      etas(3,1) = sib_par(dev).lyr(lyr).plane(plns(1)).eta(3)

      xpos(1,2) = sib_par(dev).lyr(lyr).plane(plns(2)).xpos(1)
      xpos(2,2) = sib_par(dev).lyr(lyr).plane(plns(2)).xpos(2)
      xpos(3,2) = sib_par(dev).lyr(lyr).plane(plns(2)).xpos(3)
      etas(1,2) = sib_par(dev).lyr(lyr).plane(plns(2)).eta(1)
      etas(2,2) = sib_par(dev).lyr(lyr).plane(plns(2)).eta(2)
      etas(3,2) = sib_par(dev).lyr(lyr).plane(plns(2)).eta(3)


c     Sort the planes in order of increasing arc length
      stat1 = move_wtk_xyplane(w, xpos(1,1), etas(1,1), bf, w2, s3d(1))
      stat2 = move_wtk_xyplane(w, xpos(1,2), etas(1,2), bf, w3, s3d(2))


c     Does it hit the first plane?
c     Calculate distance along plane in local coordinates.
c     Assume eta(3,1) = 0
      zmin = sib_par(dev).lyr(lyr).plane(plns(1)).zmin
      zmax = sib_par(dev).lyr(lyr).plane(plns(1)).zmax
      dmin = sib_par(dev).lyr(lyr).plane(plns(1)).dmin
      dmax = sib_par(dev).lyr(lyr).plane(plns(1)).dmax
      dcalc = (w2.y - xpos(2,1))*etas(1,1)
     *      - (w2.x - xpos(1,1))*etas(2,1)
      lstrikes(1) = w2.z .ge.zmin    .and. w2.z .le.zmax .and.
     *              dcalc.ge.dmin    .and. dcalc.le.dmax .and.
     *              arc+s3d(1).ge.0. .and. stat1.eq.0

c     Does it hit the second plane?
c     Calculate distance along plane in local coordinates.
c     Assume eta(3,2) = 0
      zmin = sib_par(dev).lyr(lyr).plane(plns(2)).zmin
      zmax = sib_par(dev).lyr(lyr).plane(plns(2)).zmax
      dmin = sib_par(dev).lyr(lyr).plane(plns(2)).dmin
      dmax = sib_par(dev).lyr(lyr).plane(plns(2)).dmax
      dcalc = (w3.y - xpos(2,2))*etas(1,2)
     *      - (w3.x - xpos(1,2))*etas(2,2)
      lstrikes(2) = w3.z .ge.zmin    .and. w3.z .le.zmax .and.
     *              dcalc.ge.dmin    .and. dcalc.le.dmax .and.
     *              arc+s3d(2).ge.0. .and. stat2.eq.0

c     Last chance to catch silly mistakes.
      if ( lstrikes(1) ) 
     *     lstrikes(1) = trk_check_back_step ( w2, s3d(1), dev, lyr )
      if ( lstrikes(2) ) 
     *     lstrikes(2) = trk_check_back_step ( w3, s3d(2), dev, lyr )

c     Make sure planes are returned in the order they were struck
      if(s3d(2) .lt. s3d(1)) then
        itemp = plns(1)
        plns(1) = plns(2)
        plns(2) = itemp

        ltemp = lstrikes(1)
        lstrikes(1) = lstrikes(2)
        lstrikes(2) = ltemp

        do i=1,3
          temps(i) = etas(i,1)
          etas(i,1) = etas(i,2)
          etas(i,2) = temps(i)
        enddo
      endif

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:35  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:30:22  garren
c add rcs log line
c

      subroutine trk_find_dipole_exit(w, bf, mass, path, lifetime,
     &                                  tauyoke, lyoke)
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Determine whether a track will a track will enter or leave a
c   dipole magnet through the yoke.
c 
c  Inputs:
c  w         w track structure variable
c            track parameters in the w-representation
c 
c  bf        b field structure variable
c            magnetic field at current location
c 
c  mass      DFLOAT variable
c            mass of particle
c 
c  path      path structure variable
c            describes elapsed proper time, etc.
c 
c  lifetime  DFLOAT variable
c            specific proper time at which particle will decay
c 
c  tauyoke   DFLOAT variable
c            proper time at which particle crosses yoke
c
c  lyoke     logical variable
c            TRUE if particle will cross yoke of current dipole
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "path_struct.inc"
#include "bfield_struct.inc"
#include "trace_params.inc"
#include "zplane.inc"
#include "dipole.inc"

c     Calling arguments
      record /wtrack_struct/ w
      record /path_struct/ path
      record /bfield_struct/ bf
      DFLOAT mass, lifetime, tauyoke
      logical lyoke

c     Externals
      external move_wtk_xyplane
      integer move_wtk_xyplane

c     Local variables
      DFLOAT xpl(3), xeta(3), ypl(3), yeta(3)
      DFLOAT s3dxp, s3dxm, s3dyp, s3dym
      DFLOAT tautemp, xmin, xmax, ymin, ymax, zmin, zmax
      integer idip, i, j, statxp, statxm, statyp, statym
      record /wtrack_struct/wnewxp, wnewxm, wnewyp, wnewym

c-----------------------------------------------------------------------
c
c  First, we have to make sure that charged particles pass through the
c  aperture at the faces of the dipole magnets.  Second, we have to
c  make sure that the particle does not pass through the side of the
c  dipole.  In either case we assume that the particle gets absorbed,
c  and an absorption trace is created at that point.
c
c  We assume that if the user has not turned on decays in flight, that
c  the lifetime will be set to some large value.
c
c-----------------------------------------------------------------------

      lyoke = .false.
      tauyoke = 0.0
      s3dxp = -1.0
      s3dxm = -1.0
      s3dyp = -1.0
      s3dym = -1.0

      if (bf.devtype.ne.2) return

      idip = bf.devnum

      xmin = dip_par(idip).xmin
      xmax = dip_par(idip).xmax
      ymin = dip_par(idip).ymin
      ymax = dip_par(idip).ymax
      zmin = dip_par(idip).zmin
      zmax = dip_par(idip).zmax
      if (w.x.le.xmin.or.w.x.ge.xmax.or.w.y.le.ymin.or.w.y.ge.ymax)
     &    then
        tautemp = (path.arc + 1.E-4 * unit_meter) * mass / 
     &      (w.p * clight)
        if (tautemp.lt.lifetime.or..not.trk_ldecays) then
          tauyoke = tautemp
          lyoke = .true.
        end if
        goto 1000
      end if

      if (idip.ne.0.and.bf.bmag.ne.0.0) then

        do j=1,3
          xpl(j) = 0.0
          ypl(j) = 0.0
          xeta(j) = 0.0
          yeta(j) = 0.0
        end do

        xpl(2) = (ymax+ymin)/2.0
        xpl(3) = (zmax+zmin)/2.0
        if (bf.bdir(2).eq.0.0 .and. bf.bdir(3).eq.0.0 .and. 
     &       w.px.eq.0.0) then
          s3dxp = -1.0
          s3dxm = -1.0
        else
          xpl(1) = xmax
          xeta(1) = 1.0
          statxp = move_wtk_xyplane(w,xpl,xeta,bf,wnewxp,s3dxp)
          xpl(1) = xmin
          xeta(1) = -1.0
          statxm = move_wtk_xyplane(w,xpl,xeta,bf,wnewxm,s3dxm)
        end if

        ypl(1) = (xmax+xmin)/2.0
        ypl(3) = (zmax+zmin)/2.0
        if (bf.bdir(1).eq.0.0 .and. bf.bdir(3).eq.0.0 .and.
     &       w.py.eq.0.0) then
          s3dyp = -1.0
          s3dym = -1.0
        else
          ypl(2) = ymax
          yeta(2) = 1.0
          statyp = move_wtk_xyplane(w,ypl,yeta,bf,wnewyp,s3dyp)
          ypl(2) = ymin
          yeta(2) = -1.0
          statym = move_wtk_xyplane(w,ypl,yeta,bf,wnewym,s3dym)
        end if

        if (s3dyp.gt.0.0.and.(s3dyp.lt.s3dym.or.s3dym.lt.0.0.or.statym
     &   .ne.0).and.(s3dyp.lt.s3dxp.or.s3dxp.lt.0.0.or.statxp.ne.0)
     &   .and.(s3dyp.lt.s3dxm.or.s3dxm.lt.0.0.or.statxm.ne.0).and.
     &   wnewyp.z.ge.zmin.and.wnewyp.z.le.zmax) then
          tautemp = path.tau + s3dyp * mass / (w.p * clight)
          if (tautemp.lt.lifetime.or..not.trk_ldecays) then
            tauyoke = tautemp
            lyoke = .true.
          end if
        else if (s3dym.gt.0.0.and.(s3dym.lt.s3dyp.or.s3dyp.lt.0.0.or.
     &   statyp.ne.0).and.(s3dym.lt.s3dxp.or.s3dxp.lt.0.0.or.statxp
     &   .ne.0).and.(s3dym.lt.s3dxm.or.s3dxm.lt.0.0.or.statxm.ne.0).and.
     &   wnewym.z.ge.zmin.and.wnewym.z.le.zmax) then
          tautemp = path.tau + s3dym * mass / (w.p * clight)
          if (tautemp.lt.lifetime.or..not.trk_ldecays) then
            tauyoke = tautemp
            lyoke = .true.
          end if
        else if (s3dxm.gt.0.0.and.(s3dxm.lt.s3dyp.or.s3dyp.lt.0.0.or.
     &   statyp.ne.0).and.(s3dxm.lt.s3dxp.or.s3dxp.lt.0.0.or.statxp
     &   .ne.0).and.(s3dxm.lt.s3dym.or.s3dym.lt.0.0.or.statym.ne.0).and.
     &   wnewxm.z.ge.zmin.and.wnewxm.z.le.zmax) then
          tautemp = path.tau + s3dxm * mass / (w.p * clight)
          if (tautemp.lt.lifetime.or..not.trk_ldecays) then
            tauyoke = tautemp
            lyoke = .true.
          end if
        else if (s3dxp.gt.0.0.and.(s3dxp.lt.s3dyp.or.s3dyp.lt.0.0.or.
     &   statyp.ne.0).and.(s3dxp.lt.s3dxm.or.s3dxm.lt.0.0.or.statxm
     &   .ne.0).and.(s3dxp.lt.s3dym.or.s3dym.lt.0.0.or.statym.ne.0).and.
     &   wnewxp.z.ge.zmin.and.wnewxp.z.le.zmax) then
          tautemp = path.tau + s3dxp * mass / (w.p * clight)
          if (tautemp.lt.lifetime.or..not.trk_ldecays) then
            tauyoke = tautemp
            lyoke = .true.
          end if
        end if

      end if

1000  continue

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:36  eugenio
c Initial revision
c
c Revision 1.5  1997/04/04 20:30:22  garren
c add rcs log line
c

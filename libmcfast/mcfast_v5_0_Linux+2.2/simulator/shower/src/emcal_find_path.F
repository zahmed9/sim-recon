c
      subroutine emcal_find_path(w1,ical,ifld,w2,length)
c
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c     Finds length of track or showers pass in calorimeter #ICAL
c
c     6-10-96  Julia Yarba
c
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
      implicit none
c
#include "const.inc"
#include "emcal.inc"
#include "cone_struct.inc"
#include "cylinder_struct.inc"
#include "wtrack_struct.inc"
#include "bfield_struct.inc"
c
c     Calling arguments 
c
c     Input :
c
      record /wtrack_struct/ w1 ! input track/shower representation in W-form
      integer ical              ! calorimeter number
      integer ifld              ! flag to turn magnetic field ON (1) or OFF (0)
c
c     Output :
c
      record /wtrack_struct/ w2 ! same as above at the exit from calorimeter 
      DFLOAT length               ! length of path in a given calorimeter
c
c     Externals
c
      external move_wtk_cone, move_wtk_cylinder, move_wtk_zplane
      external move_wtk_xplane_bx, move_wtk_yplane_bx
      external move_wtk_xplane_by, move_wtk_yplane_by
      integer move_wtk_cone, move_wtk_cylinder, move_wtk_zplane
      integer move_wtk_xplane_bx, move_wtk_yplane_bx
      integer move_wtk_xplane_by, move_wtk_yplane_by
c
c     Local variables
c
      integer status_inner, status_outer, 
     *        status_box,    
     *        status_zmin, status_zmax
      logical lstrike
      record /cone_struct/ cone_inner, cone_outer
      record /cylinder_struct/ cyl_inner, cyl_outer
      record /bfield_struct/ bf
      record /wtrack_struct/ w_in, w_out, w_zmin, w_zmax, w_plane
      DFLOAT s3d_in, s3d_out, s3d_box, s3d_zmin, s3d_zmax
      DFLOAT zmin, zmax
      DFLOAT x_move, y_move
      DFLOAT SHIFT_PROPAGATION
      parameter (SHIFT_PROPAGATION=0.1D-4)
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
      length = 0.
      call ucopy(w1,w2,WTRACK_WORD)

c   Do nothing for zero-momentum or zero-energy particles !
      if (w1.e .le. 0. .or. w1.p .le. 0.) return

      if (ifld .eq. 0) then
c     Magnetic field OFF
       bf.bmag    = 0.
       call vzero(bf.bdir,3*FLOAT_WORD)
       bf.type    = 0
       bf.devtype = 0
       bf.devnum  = 0
      else
c     Magnetic field ON
       call trk_next_bfield(w1, bf)
      end if

      s3d_in   = 0.
      s3d_out  = 0.
      s3d_zmin = 0.
      s3d_zmax = 0.

      x_move = 0.      
      y_move = 0.

      if (emcal_par(ical).shape .ne. 'BOX') then

c     Conical/Cylinrical Calorimeter
c
c     Find intersection of track / shower axis with cone/cylinder surface(s)
c
c     Find out cone/cylinder parameters
c
       status_inner = 0
       if (emcal_par(ical).rmin(1) .eq. emcal_par(ical).rmin(2)) then
c     Cylindrical inner surface
        cyl_inner.xc(1) = 0.
        cyl_inner.xc(2) = 0.
        cyl_inner.xc(3) = (emcal_par(ical).zmax 
     *                  +  emcal_par(ical).zmin) / 2.
        cyl_inner.radius = emcal_par(ical).rmin(1)
        cyl_inner.zmin = emcal_par(ical).zmin
        cyl_inner.zmax = emcal_par(ical).zmax
        cyl_inner.eta(1) = 0.
        cyl_inner.eta(2) = 0.
        cyl_inner.eta(3) = 1.
        status_inner =
     *  move_wtk_cylinder(w1,cyl_inner,1,bf,w_in,s3d_in)
       else
c     Conical inner surface
        cone_inner.tana = 
     *       (emcal_par(ical).rmin(2)-emcal_par(ical).rmin(1))
     *     / (emcal_par(ical).zmax - emcal_par(ical).zmin)
        cone_inner.xc(1) = 0.
        cone_inner.xc(2) = 0.
        cone_inner.xc(3) = - emcal_par(ical).rmin(1) / cone_inner.tana
     *                   +   emcal_par(ical).zmin
        cone_inner.eta(1) = 0.
        cone_inner.eta(2) = 0.
        cone_inner.eta(3) = 1.
        cone_inner.zmin = emcal_par(ical).zmin
        cone_inner.zmax = emcal_par(ical).zmax
        status_inner = 
     *  move_wtk_cone(w1,cone_inner,1,bf,w_in,s3d_in)
       end if
c
       if (status_inner .eq. 4) then
c    Particle's trajectory curls inside volume ! Set path=1.e+20 and give up !
        length = 1.e+20
        call ucopy(w1,w2,WTRACK_WORD)
        goto 500
       end if
c
       if (w_in.z .le. emcal_par(ical).zmin .or.
     *     w_in.z .ge. emcal_par(ical).zmax .or.
     *     s3d_in .le. 0.0000000001) then
        status_inner = 1
       end if
c
       status_outer = 0
       if (emcal_par(ical).rmax(1) .eq. emcal_par(ical).rmax(2)) then
c     Cylindrical inner surface
        cyl_outer.xc(1) = 0.
        cyl_outer.xc(2) = 0.
        cyl_outer.xc(3) = (emcal_par(ical).zmax 
     *                  +  emcal_par(ical).zmin) / 2.
        cyl_outer.radius = emcal_par(ical).rmax(1)
        cyl_outer.zmin = emcal_par(ical).zmin
        cyl_outer.zmax = emcal_par(ical).zmax
        cyl_outer.eta(1) = 0.
        cyl_outer.eta(2) = 0.
        cyl_outer.eta(3) = 1.
        status_outer =
     *  move_wtk_cylinder(w1,cyl_outer,1,bf,w_out,s3d_out)
       else
        cone_outer.tana = 
     *       (emcal_par(ical).rmax(2)-emcal_par(ical).rmax(1))
     *     / (emcal_par(ical).zmax - emcal_par(ical).zmin)
        cone_outer.xc(1) = 0.
        cone_outer.xc(2) = 0.
        cone_outer.xc(3) = - emcal_par(ical).rmax(1) / cone_outer.tana
     *                   +   emcal_par(ical).zmin
        cone_outer.eta(1) = 0.
        cone_outer.eta(2) = 0.
        cone_outer.eta(3) = 1.
        cone_outer.zmin = emcal_par(ical).zmin
        cone_outer.zmax = emcal_par(ical).zmax
        status_outer = 
     *  move_wtk_cone(w1,cone_outer,1,bf,w_out,s3d_out)
       end if
c
       if (status_outer .eq. 4) then
c    Particle's trajectory curls inside volume ! Set path=1.e+20 and give up !
        length = 1.e+20
        call ucopy(w1,w2,WTRACK_WORD)
        goto 500
       end if
c
       if (w_out.z .le. emcal_par(ical).zmin .or.
     *     w_out.z .ge. emcal_par(ical).zmax .or.
     *     s3d_out .le. 0.0000000001) then
        status_outer = 1
       end if

      else

c     BOX-shaped calorimeters implementation is on its way !

       status_box = 0

c     Define x- and y-planes to move particle to
       if (w1.px .lt. 0.) then
        x_move = dble(emcal_par(ical).xlimit(1)) 
     *         - SHIFT_PROPAGATION * unit_meter * (w1.px/w1.p)
       else
        x_move = dble(emcal_par(ical).xlimit(2))
     *         - SHIFT_PROPAGATION * unit_meter * (w1.px/w1.p)
       end if
       if (w1.py .lt. 0.) then
        y_move = dble(emcal_par(ical).ylimit(1))
     *         - SHIFT_PROPAGATION * unit_meter * (w1.py/w1.p)
       else
        y_move = dble(emcal_par(ical).ylimit(2))
     *         - SHIFT_PROPAGATION * unit_meter * (w1.py/w1.p)
       end if

       goto (100, 110, 120) bf.type + 1

c     Linear transport if NO magnetic field
  100  call ucopy(w1,w_plane,WTRACK_WORD)
       if (w1.px .ne. 0.) then
        s3d_box = (x_move - w1.x) * (w1.p / w1.px)
        w_plane.x = x_move
        w_plane.y = w1.y + s3d_box * (w1.py / w1.p) 
        w_plane.z = w1.z + s3d_box * (w1.pz / w1.p) 
        call emcal_find_ical(w_plane,ical,lstrike)
        if (lstrike) then
         w2.x = w_plane.x
         w2.y = w_plane.y
         w2.z = w_plane.z
         length = s3d_box + SHIFT_PROPAGATION * unit_meter
         goto 500
        end if
       end if
       if (w1.py .ne. 0.) then
        s3d_box = (y_move - w1.y) * (w1.p / w1.py)
        w_plane.x = w1.x + s3d_box * (w1.px / w1.p)       
        w_plane.y = y_move
        w_plane.z = w1.z + s3d_box *(w1.pz / w1.p)
        call emcal_find_ical(w_plane,ical,lstrike)
        if (lstrike) then
         w2.x = w_plane.x
         w2.y = w_plane.y
         w2.z = w_plane.z
         length = s3d_box + SHIFT_PROPAGATION * unit_meter
         goto 500
        end if
       end if
       status_box = 1
       call ucopy(w1,w2,WTRACK_WORD)
       length = 0.
       goto 400
c     Magnetic field type=bx
  110  status_box = move_wtk_xplane_bx(w1,x_move,bf,w_plane,s3d_box)
       if (status_box .eq. 0) then
        call emcal_find_ical(w_plane,ical,lstrike)
        if (lstrike) then
         w2.x = w_plane.x
         w2.y = w_plane.y
         w2.z = w_plane.z
         length = s3d_box + SHIFT_PROPAGATION * unit_meter
         goto 500
        end if
       end if
       status_box = move_wtk_yplane_bx(w1,y_move,bf,w_plane,s3d_box)
       if (status_box .eq. 0) then
        call emcal_find_ical(w_plane,ical,lstrike)
        if (lstrike) then
         w2.x = w_plane.x
         w2.y = w_plane.y
         w2.z = w_plane.z
         length = s3d_box + SHIFT_PROPAGATION * unit_meter
         goto 500
        end if
       end if
       status_box = 1
       call ucopy(w1,w2,WTRACK_WORD)
       length = 0.
       goto 400
c     Magnetic field type=by
  120  status_box = move_wtk_xplane_by(w1,x_move,bf,w_plane,s3d_box)
       if (status_box .eq. 0) then
        call emcal_find_ical(w_plane,ical,lstrike)
        if (lstrike) then
         w2.x = w_plane.x
         w2.y = w_plane.y
         w2.z = w_plane.z
         length = s3d_box + SHIFT_PROPAGATION * unit_meter
         goto 500
        end if
       end if
       status_box = move_wtk_yplane_by(w1,y_move,bf,w2,s3d_box)
       if (status_box .eq. 0) then
        call emcal_find_ical(w_plane,ical,lstrike)
        if (lstrike) then
         w2.x = w_plane.x
         w2.y = w_plane.y
         w2.z = w_plane.z
         length = s3d_box + SHIFT_PROPAGATION * unit_meter
         goto 500
        end if
       end if
       status_box = 1
       call ucopy(w1,w2,WTRACK_WORD)
       length = 0.
       goto 400
      end if

c
c     Find out which intersection if two or more possible for Cyl/Cone CALs
c
      if (emcal_par(ical).shape .ne. 'BOX') then
       if (status_inner .eq. 0 .and. status_outer .eq. 0) then
c     Both inner/outer intersection possible
        length = min(s3d_in,s3d_out)
        if (s3d_in .lt. s3d_out) then
         w2.x = w_in.x
         w2.y = w_in.y
         w2.z = w_in.z
        else
         w2.x = w_out.x
         w2.y = w_out.y
         w2.z = w_out.z
        end if
        goto 500
       else if (status_inner .eq. 0) then
c     Only inner intersection possible
        length = s3d_in
        w2.x = w_in.x
        w2.y = w_in.y
        w2.z = w_in.z
        goto 500
       else if (status_outer .eq. 0) then
c     Only outer intersection possible
        length = s3d_out
        w2.x = w_out.x
        w2.y = w_out.y
        w2.z = w_out.z
        goto 500
       end if
      end if

c     We come here if no intersection with inner/outer or x/y
c     surfaces possible, at least, inside the actual Calorimeter volume;
c     try out intersections with zmin/zmax
  400 zmin = emcal_par(ical).zmin
      zmax = emcal_par(ical).zmax
      status_zmin = 0
      status_zmax = 0
      status_zmin = move_wtk_zplane(w1,zmin,bf,w_zmin,s3d_zmin)
      if (s3d_zmin .le. 0.0000000001) then
         status_zmin = 1
      end if
      status_zmax = move_wtk_zplane(w1,zmax,bf,w_zmax,s3d_zmax)
      if (s3d_zmax .le. 0.0000000001) then
         status_zmax = 1
      end if
c
      if (status_zmin .eq. 0 .and. status_zmax .eq. 0) then
c     Both zmin/zmax intersection possible
         length = min(s3d_zmin,s3d_zmax)
         if (s3d_zmin .le. s3d_zmax) then
          w2.x = w_zmin.x
          w2.y = w_zmin.y
          w2.z = w_zmin.z
         else
          w2.x = w_zmax.x
          w2.y = w_zmax.y
          w2.z = w_zmax.z
         end if
      else if (status_zmin .eq. 0) then
c     Only zmin intersection possible
         length = s3d_zmin
         w2.x = w_zmin.x
         w2.y = w_zmin.y
         w2.z = w_zmin.z
      else if (status_zmax .eq. 0) then
c     Only zmin intersection possible
         length = s3d_zmax
         w2.x = w_zmax.x
         w2.y = w_zmax.y
         w2.z = w_zmax.z
      else
c     No intersection possible at all !
         length = 0.
         call ucopy(w1,w2,WTRACK_WORD)
      end if

  500 return

      end

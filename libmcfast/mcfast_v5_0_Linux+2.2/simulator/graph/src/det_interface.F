      subroutine det_interface

      implicit none

#include "const.inc"
#include "solenoid.inc"
#include "si_barrel.inc"
#include "sicir_disk.inc"
#include "sixy_disk.inc"
#include "drift.inc"
#include "emcal.inc"
#include "for_trk.inc"
#include "rich.inc"
#include "hadcal.inc"
#include "volume.inc"
#include "volxy.inc"
#include "muon.inc"
#include "geom_struct.inc"
#include "absorber.inc"
#include "dipole.inc"

      record /geom_struct/ obj

      integer i, ilyr, ipl, nlyr, nplane, color_num
      real rmin, rmax, zmin, zmax, zlen, center(3), radius
      real rmin_lowz, rmax_lowz, rmin_hiz, rmax_hiz
      real rthick, xlen, ylen, xmin, ymin, xmax, ymax
      real axis(3), rbase, rstem, arrow_len, alpha
      character*50 name
      real xlen_out(0:1), ylen_out(0:1), zlen_out(0:1)
      real xlen_inn(0:1), ylen_inn(0:1), zlen_inn(0:1)      

C    Number  Color       Detector Type
c      1      Red            Muon
c      2      orange
c      3      peach          Silcon
c      4      yellow         Dipole
c      5      lightgreen
c      6      green          EM calorimeter
c      7      bluegreen      Cerenkov
c      8      cyan
c      9      bluegreen
c     10      blue           drift detector, forward tracking
c     11      magenta
c     12      indigo         absorber
c     13      violet         Had calorimeter
c     14      white
c     15      grey           volumes
c     16      black
  
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      obj.type = 0
      obj.id_number = 0
      obj.iname = 0
      obj.id_parent = 0
      obj.num_child = 0
      obj.children = 0

c     default orientation is along the Z axis
      obj.rotation(1) = 0.
      obj.rotation(2) = 0.
      obj.rotation(3) = 1.
      call vzero(xlen_inn,2)
      call vzero(ylen_inn,2)
      call vzero(zlen_inn,2)

c      call color_register(color_num, color_list)

c     Muon detector
      do i=1,muon_num
        if (muon_par(i).shape .eq. 'TUBE'.OR.
     &      muon_par(i).shape .eq. 'CONE') then
          obj.xpos = 0.
          obj.ypos = 0.
          obj.zpos = 0.5 * (muon_par(i).zmin + muon_par(i).zmax)
          obj.rotation(1) = 0.
          obj.rotation(2) = 0.
          obj.rotation(3) = 1.

          call get_rgb_values(1, obj.color)
          obj.transparency = 0.7
          obj.visibility = 1
          zlen = (muon_par(i).zmax - muon_par(i).zmin) * 0.5
          call define_conetube_f(obj, muon_par(i).name, zlen, 
     &       muon_par(i).rmin(1), muon_par(i).rmax(1), 
     +       muon_par(i).rmin(2), muon_par(i).rmax(2),
     &       muon_par(i).shape)
        else 
          print *, 'Muon detector shape not defined', muon_par(i).name
        endif
      enddo

c     Absorber
      do i=1,absorber_num
        if (absorber_par(i).shape .eq. 'TUBE'.OR.
     &      absorber_par(i).shape .eq. 'CONE') then
          obj.xpos = 0.
          obj.ypos = 0.
          obj.zpos = 0.5 * (absorber_par(i).zmin + absorber_par(i).zmax)
          call get_rgb_values(12, obj.color)
          obj.transparency = 0.5
          obj.visibility = 1
          obj.rotation(1) = 0.
          obj.rotation(2) = 0.
          obj.rotation(3) = 1.
          zlen = (absorber_par(i).zmax - absorber_par(i).zmin) * 0.5
          call define_conetube_f(obj, absorber_par(i).name, zlen, 
     &    absorber_par(i).rmin(1), absorber_par(i).rmax(1), 
     +    absorber_par(i).rmin(2), absorber_par(i).rmax(2),
     &    absorber_par(i).shape)
        else
          print *, 'Absorber shape not defined', absorber_par(i).name
        endif
      enddo

C   Rich counters
        print *, certh_num
       do i=1,certh_num
        if (certh_par(i).shape .eq. 'TUBE'.OR.
     &      certh_par(i).shape .eq. 'CONE') then
          obj.xpos = 0.
          obj.ypos = 0.
          obj.zpos = 0.5 * (certh_par(i).zmin + certh_par(i).zmax)
          call get_rgb_values(7, obj.color)
          obj.transparency = 0.7
          obj.visibility = 1
          obj.rotation(1) = 0.
          obj.rotation(2) = 0.
          obj.rotation(3) = 1.
          zlen = (certh_par(i).zmax - certh_par(i).zmin) * 0.5
          call define_conetube_f(obj, certh_par(i).name, zlen, 
     &       certh_par(i).rmin(1), certh_par(i).rmax(1), 
     +       certh_par(i).rmin(2), certh_par(i).rmax(2),
     &       certh_par(i).shape)
        else 
          print *, 'Rich shape not defined', certh_par(i).name
        endif
      enddo

c     Emcal detector
      do i=1,emcal_num
        if (emcal_par(i).shape .eq. 'TUBE'.OR.
     &      emcal_par(i).shape .eq. 'CONE') then
          obj.xpos = 0.
          obj.ypos = 0.
          obj.zpos = 0.5 * (emcal_par(i).zmin + emcal_par(i).zmax)
          call get_rgb_values(6, obj.color)
          obj.transparency = 0.5
          obj.visibility = 1
          obj.rotation(1) = 0.
          obj.rotation(2) = 0.
          obj.rotation(3) = 1.
          zlen = (emcal_par(i).zmax - emcal_par(i).zmin) * 0.5
          call define_conetube_f(obj, emcal_par(i).name, zlen, 
     &     emcal_par(i).rmin(1), emcal_par(i).rmax(1), 
     +     emcal_par(i).rmin(2), emcal_par(i).rmax(2),
     &    emcal_par(i).shape)
        else
          print *, 'EM calorimeter shape not defined', emcal_par(i).name         
        endif
      enddo

c     Hadcal detector
      do i=1,hcal_num
        if (hcal_par(i).shape .eq. 'TUBE'.OR.
     &      hcal_par(i).shape .eq. 'CONE') then
          obj.xpos = 0.
          obj.ypos = 0.
          obj.zpos = 0.5 * (hcal_par(i).zmin + hcal_par(i).zmax)
          call get_rgb_values(13, obj.color)
          obj.transparency = 0.5
          obj.visibility = 1
          obj.rotation(1) = 0.
          obj.rotation(2) = 0.
          obj.rotation(3) = 1.
          zlen = (hcal_par(i).zmax - hcal_par(i).zmin) * 0.5          
          call define_conetube_f(obj, hcal_par(i).name, zlen, 
     &           hcal_par(i).rmin(1), hcal_par(i).rmax(1), 
     +           hcal_par(i).rmin(2), hcal_par(i).rmax(2),
     &           hcal_par(i).shape)
        endif
      enddo

c     Drift detector   - draw volume only
c      do i=1,drf_num
c        rmin = drf_par(i).rmin
c        rmax = drf_par(i).rmax
c        zmin = drf_par(i).zmin
c        zmax = drf_par(i).zmax
c        center(1) = 0.
c        center(2) = 0.
c        center(3) = 0.5 * (zmin + zmax)
c        obj.xpos = center(1)
c        obj.ypos = center(2)
c        obj.zpos = center(3)
c        call get_rgb_values(10, obj.color)
c        obj.transparency = .1
c        obj.visibility = 1
c        zlen = (zmax - zmin) * 0.5
c        name = drf_par(i).name
        
c       Draw boundaries only        
c        rthick = rmin - drf_par(i).thick_boun(1)
c        call define_tube_f(obj, name, rmin, rthick, zlen)
c        rthick = rmax + drf_par(i).thick_boun(2)
c        call define_tube_f(obj, name, rthick, rmax, zlen)
        
c        zlen     =  0.5 * drf_par(i).thick_boun(3)
c        obj.zpos =  zmin - zlen 
c        call define_tube_f(obj, name, rmin, rmax, zlen)
c        zlen     =  0.5 * drf_par(i).thick_boun(4)
c        obj.zpos =  zmax + zlen 
c        call define_tube_f(obj, name, rmax, rthick, zlen)
c      enddo

c Forward Tracking
      do i=1,ftrk_num
        print *, "number of forward trackers", ftrk_num
        nlyr = ftrk_par(i).nlyr
        name = ftrk_par(i).name
c       Draw box for detector  -- done in volume part
c       Draw each layer in the detector 
c       Draw as two boxes, inner hole, outer box       
        do ilyr=1,nlyr
          obj.xpos = 0.
          obj.ypos = 0.
          obj.zpos = ftrk_par(i).lyr(ilyr).z
          call get_rgb_values(10, obj.color)
          obj.transparency = 0.1
          obj.visibility = 1
          obj.rotation(1) = 0.
          obj.rotation(2) = 0.
          obj.rotation(3) = 1.
          
c   assume that that x and y are referenced from (x,y) = (0,0)
          xlen_out(0) = ftrk_par(i).lyr(ilyr).xmin
          xlen_out(1) = ftrk_par(i).lyr(ilyr).xmax
          xlen_inn(0) = ftrk_par(i).lyr(ilyr).xmin_gap
          xlen_inn(1) = ftrk_par(i).lyr(ilyr).xmax_gap

          ylen_out(0) = ftrk_par(i).lyr(ilyr).ymin
          ylen_out(1) = ftrk_par(i).lyr(ilyr).ymax
          ylen_inn(0) = ftrk_par(i).lyr(ilyr).ymin_gap
          ylen_inn(1) = ftrk_par(i).lyr(ilyr).ymax_gap
          
          zlen_out(0) = -0.5*ftrk_par(i).lyr(ilyr).thickness
          zlen_out(1) =  0.5*ftrk_par(i).lyr(ilyr).thickness
          zlen_inn(0) = -0.5*ftrk_par(i).lyr(ilyr).thickness
          zlen_inn(1) =  0.5*ftrk_par(i).lyr(ilyr).thickness

          
          call define_box2_f(obj, name, xlen_out, ylen_out,
     &               zlen_out, xlen_inn, ylen_inn, zlen_inn)
        enddo
      enddo
      
c     Volumes
      do i=1,vol_num
        rmin = vol_par(i).rmin
        rmax = vol_par(i).rmax
        zmin = vol_par(i).zmin
        zmax = vol_par(i).zmax
        obj.xpos = 0.
        obj.ypos = 0.
        obj.zpos = 0.5 * (vol_par(i).zmin + vol_par(i).zmax) 
        call get_rgb_values(15, obj.color)
        obj.visibility = 2
        obj.transparency = 0.5
        zlen = (vol_par(i).zmax - vol_par(i).zmin) * 0.5
         
c       Draw boundaries only
        rthick = vol_par(i).rmin - vol_par(i).thick_rmin
        if (rthick .gt.0.)       
     >     call define_tube_f(obj, vol_par(i).name, vol_par(i).rmin,
     >                        rthick, zlen)
        rthick = vol_par(i).rmax + vol_par(i).thick_rmax
        if (rthick .gt.0.)       
     >     call define_tube_f(obj, vol_par(i).name, rthick, 
     >                        vol_par(i).rmax, zlen)
        zlen     =  0.5 * vol_par(i).thick_zmin
        if (abs(zlen) .gt. 0.) then 
          obj.zpos =  zmin + sign(zlen,zmin) 
          call define_tube_f(obj, vol_par(i).name, 
     >                       vol_par(i).rmin, vol_par(i).rmax, zlen)
        endif
        zlen     =  0.5 * vol_par(i).thick_zmax
        if (abs(zlen) .gt. 0.) then
          obj.zpos =  zmax - sign(zlen,zmax) 
          call define_tube_f(obj, vol_par(i).name, vol_par(i).rmax,
     >                       rthick, zlen)
        endif
      enddo
      
      print *, "number of xy volumes", volxy_num
      do i=1,volxy_num
          print *, "volume z", volxy_par(i).zmin, volxy_par(i).zmax
          call get_rgb_values(15, obj.color)
          obj.transparency = 0.1
          obj.visibility = 2
          obj.rotation(1) = 0.
          obj.rotation(2) = 0.
          obj.rotation(3) = 1.          
          name = volxy_par(i).name
          obj.xpos = 0.5 * (volxy_par(i).xmin + volxy_par(i).xmax)
          obj.ypos = 0.5 * (volxy_par(i).ymin + volxy_par(i).ymax)
          obj.zpos = 0.5 * (volxy_par(i).zmin + volxy_par(i).zmax)
          
          xlen = 0.5 * (volxy_par(i).xmax - volxy_par(i).xmin)       
          xlen_out(0) =  -xlen - volxy_par(i).thick_boun(1)
          xlen_out(1) =   xlen + volxy_par(i).thick_boun(2)
          xlen_inn(0) =  -xlen
          xlen_inn(1) =   xlen


          ylen = 0.5 * (volxy_par(i).ymax - volxy_par(i).ymin)
          ylen_out(0) = -ylen - volxy_par(i).thick_boun(3)
          ylen_out(1) =  ylen + volxy_par(i).thick_boun(4)
          ylen_inn(0) = -ylen
          ylen_inn(1) =  ylen
          

          zlen = 0.5 * (volxy_par(i).zmax - volxy_par(i).zmin)
          zlen_out(0) = -zlen - volxy_par(i).thick_boun(5)
          zlen_out(1) =  zlen + volxy_par(i).thick_boun(6)
          zlen_inn(0) = -zlen
          zlen_inn(1) =  zlen 

          call define_box2_f(obj, name, xlen_out, ylen_out,
     &        zlen_out, xlen_inn, ylen_inn, zlen_inn)                
      enddo
      
      do i=1, dip_num
c     for now handle fields along x or y plane only (x or y direction..)
c     make arrow in z direction and rotate to field direction
          rstem = dip_par(i).Bfield  ! (1 Tesla = 1 cm)
          rbase = 10. * rstem
c         cross product of field direction and z axis
          obj.rotation(1) = dip_par(i).dircos(1)
          obj.rotation(2) = dip_par(i).dircos(2)
          obj.rotation(3) = dip_par(i).dircos(3)                              
          axis(1) =  dip_par(i).dircos(2)
          axis(2) =  -dip_par(i).dircos(1)
          axis(3) =  0.
          alpha   =  pi/2.
          name = dip_par(i).name
c          if (dip_par(i).dircos(1).eq. 1.) then
            arrow_len = 0.5*sqrt(((dip_par(i).xmax - dip_par(i).xmin)
     >                           *dip_par(i).dircos(1))**2 +    
     >                           ((dip_par(i).ymax - dip_par(i).ymin)
     >                           *dip_par(i).dircos(2))**2 +
     >                           ((dip_par(i).zmax - dip_par(i).zmin)
     >                           *dip_par(i).dircos(3))**2)
     
c          endif
          obj.xpos = 0.5 * (dip_par(i).xmin + dip_par(i).xmax)
          obj.ypos = 0.5 * (dip_par(i).ymin + dip_par(i).ymax)
          obj.zpos = 0.5 * (dip_par(i).zmin + dip_par(i).zmax)
          print *, "arrow z", name, dip_par(i).zmin, dip_par(i).zmax                
          call get_rgb_values(4, obj.color)
          obj.transparency = 0.5
          obj.visibility = 1
          print *, "arrow", arrow_len, rstem, rbase
          call define_arrow_f(obj, name, axis(1), alpha, rstem,
     >                        rbase, arrow_len)
      enddo


c     Barrel silicon
c     Treat as an array of tubes for now
      do i=1,sib_num
        nlyr = sib_par(i).numlyr
        name = sib_par(i).name
        do ilyr=1,nlyr
          rmin = sib_par(i).lyr(ilyr).plane(1).delta_min
          rmax = rmin + sib_par(i).lyr(ilyr).plane(1).thick
          zmin = sib_par(i).lyr(ilyr).plane(1).zmin
          zmax = sib_par(i).lyr(ilyr).plane(1).zmax
          obj.xpos = 0.
          obj.ypos = 0.
          obj.zpos = 0.5 * (zmin + zmax)
          call get_rgb_values(3, obj.color)
          obj.transparency = 0.1
          obj.visibility = 1
          obj.rotation(1) = 0.
          obj.rotation(2) = 0.
          obj.rotation(3) = 1.
          zlen = (zmax - zmin) * 0.5
          call define_tube_f(obj, name, rmin, rmax, zlen)
c          nplane = sib_par(i).lyr(ilyr).numplane
c          do ipl=1,nplane
c            delta = sib_par(i).lyr(ilyr).plane(ipl).delta
c            zmin = sib_par(i).lyr(ilyr).plane(ipl).zmin
c            zmax = sib_par(i).lyr(ilyr).plane(ipl).zmax
c            zlen = zmax - zmin
c            call define_polyline_f(obj, name, rmin, rmax, zlen)
c          enddo
        enddo
      enddo


      do i=1,sicir_num
        nlyr = sicir_par(i).numlyr
        name = sicir_par(i).name
        do ilyr=1,nlyr
          rmin = sicir_par(i).lyr(ilyr).wedge(1).rmin
          rmax = sicir_par(i).lyr(ilyr).wedge(1).rmax
          obj.xpos = 0.
          obj.ypos = 0.
          obj.zpos = sicir_par(i).lyr(ilyr).wedge(1).z
          call get_rgb_values(3, obj.color)
          obj.transparency = 0.1
          obj.visibility = 1
          obj.rotation(1) = 0.
          obj.rotation(2) = 0.
          obj.rotation(3) = 1.          
          zlen = 0.5 * sicir_par(i).lyr(ilyr).wedge(1).thick
          call define_tube_f(obj, name, rmin, rmax, zlen)
        enddo
      enddo


      do i=1,sixy_num
        nlyr = sixy_par(i).numlyr
        name = sixy_par(i).name
        do ilyr=1,nlyr
          obj.xpos = 0.5 * (sixy_par(i).lyr(ilyr).xmin + 
     &                      sixy_par(i).lyr(ilyr).xmax)
          obj.ypos = 0.5 * (sixy_par(i).lyr(ilyr).ymin + 
     &                      sixy_par(i).lyr(ilyr).ymax)
          obj.zpos = sixy_par(i).lyr(ilyr).z
          call get_rgb_values(3, obj.color)
          obj.transparency = 0.1
          obj.visibility = 1
          obj.rotation(1) = 0.
          obj.rotation(2) = 0.
          obj.rotation(3) = 1.
          xlen_out(0) = sixy_par(i).lyr(ilyr).xmin
          xlen_out(1) = sixy_par(i).lyr(ilyr).xmax
          xlen_inn(0) = sixy_par(i).lyr(ilyr).xmin_gap
          xlen_inn(1) = sixy_par(i).lyr(ilyr).xmax_gap

          ylen_out(0) = sixy_par(i).lyr(ilyr).ymin
          ylen_out(1) = sixy_par(i).lyr(ilyr).ymax
          ylen_inn(0) = sixy_par(i).lyr(ilyr).ymin_gap
          ylen_inn(1) = sixy_par(i).lyr(ilyr).ymax_gap
          
          zlen_out(0) = -0.5*sixy_par(i).lyr(ilyr).thick
          zlen_out(1) =  0.5*sixy_par(i).lyr(ilyr).thick
          zlen_inn(0) = -0.5*sixy_par(i).lyr(ilyr).thick
          zlen_inn(1) =  0.5*sixy_par(i).lyr(ilyr).thick

          call define_box2_f(obj, name, xlen_out, ylen_out,
     &        zlen_out, xlen_inn, ylen_inn, zlen_inn)
          
        enddo
      enddo
     
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:25  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:56  garren
c add rcs log line
c

      subroutine clear_detector
c
c     3/6/95 A. Boehnlein, clears geometry structures for Explorer
c
c     3/9/95 J. Yarba : this routine now used to clear parameters
c                       before the geometry is read in
c     modified 05/25/96 ASB -- adapted to modified cal structure
c     modified 02/06/97 LAG -- phi, eta become coor1, coor2
      implicit none

#include "const.inc"
#include "material.inc"
#include "beampipe.inc"
#include "si_barrel.inc"
#include "sicir_disk.inc"
#include "siz_rect.inc"
#include "drift.inc"
#include "for_trk.inc"
#include "solenoid.inc"
#include "dipole.inc"
#include "rich.inc"
#include "emcal.inc"
#include "muon.inc"
#include "absorber.inc"
#include "volume.inc"
#include "volxy.inc"
c
      integer i, j, i_det, i_lyr, i_wfr, i_sublyr, 
     *        ieta, iphi, ihep, idetm1
c
c     Clear Material List
c
      mtl_num = 0
c
      do i = 1,max_mtl
       mtl_par(i).a         = 0.
       mtl_par(i).z         = 0.
       mtl_par(i).density   = 0.
       mtl_par(i).coll_len  = 0.
       mtl_par(i).abs_len   = 0.
       mtl_par(i).rad_len   = 0.
       mtl_par(i).dedx      = 0.
       mtl_par(i).coll_inv  = 0.
       mtl_par(i).abs_inv   = 0.
       mtl_par(i).rad_inv   = 0.
       mtl_par(i).name      = ' ' 
       do j = 1,max_mat_mix
        mtl_par(i).id(j)    = 0
        mtl_par(i).ratio(j) = 0.
       end do
      end do
c
c     Clear Beampipe
c
      do i = 1, max_beampipe
       beampipe_par(i).zmin = 0.
       beampipe_par(i).zmax = 0.
       beampipe_par(i).rmin = 0.
       beampipe_par(i).rmax = 0.
       beampipe_par(i).material = 0
       do j = 1,4
        beampipe_par(i).thick_boun(j) = 0.
        beampipe_par(i).mat_boun(j)   = 0
       end do
      end do
c
c     Clear Barrel SVX
c
      sib_num      = 0
c
      do i_det = 1,max_sib
c
       sib_par(i_det).name   = ' '
       sib_par(i_det).z      = 0.
       sib_par(i_det).numlyr = 0
       sib_par(i_det).nchan  = 0
       do i_lyr = 1,max_sib_lyr       
        sib_par(i_det).lyr(i_lyr).numplane = 0        
        sib_par(i_det).lyr(i_lyr).nchan    = 0
        sib_par(i_det).lyr(i_lyr).chan0    = 0
        do i_sublyr = 1,max_sib_plane
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).type = 0
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).dmin = 0.
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).dmax = 0.
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).zmin = 0.
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).zmax = 0.
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).beta = 0.
         do i = 1,3
          sib_par(i_det).lyr(i_lyr).plane(i_sublyr).xpos(i) = 0.
          sib_par(i_det).lyr(i_lyr).plane(i_sublyr).eta(i)  = 0.
         end do
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).delta_min = 0.
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).delta_max = 0.
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).thick = 0.
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).tilt  = 0.
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).eff_hit = 0.
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).siga  = 0.
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).sigb  = 0.
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).sigc  = 0.
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).material = 0
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).coord0_x = 0.
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).coord0_y = 0.
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).pitch    = 0.
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).nstrip   = 0
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).nchan    = 0
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).chan0    = 0
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).stereo   = 0.
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).cos_stereo  = 0.
         sib_par(i_det).lyr(i_lyr).plane(i_sublyr).sin_stereo  = 0.
        end do
       end do
c
      end do
c
c     Clear Circular Disk SVX
c
      sicir_num    = 0
c
      do i_det = 1,max_sicir
c       
       sicir_par(i_det).name   = ' '
       sicir_par(i_det).z      = 0.
       sicir_par(i_det).numlyr = 0
       sicir_par(i_det).nchan  = 0
       do i_lyr = 1,max_sicir_lyr       
        sicir_par(i_det).lyr(i_lyr).phi(1) = 0.
        sicir_par(i_det).lyr(i_lyr).phi(2) = 0.
        sicir_par(i_det).lyr(i_lyr).numwedge = 0
        sicir_par(i_det).lyr(i_lyr).nchan  = 0
        do i_sublyr = 1,max_sicir_wedge
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).type = 0
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).rmin = 0.
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).rmax = 0.
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).z    = 0.
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).beta = 0.
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).cos_beta = 0.
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).sin_beta = 0.
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).d_phi = 0.
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).thick = 0.
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).stereo = 0.
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).cos_stereo = 0.
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).sin_stereo = 0.
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).nstrip = 0
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).nchan  = 0
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).chan0  = 0
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).pitch  = 0.
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).coord0_r = 0.
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).coord0_phi = 0.
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).eff_hit = 0.
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).siga = 0.
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).sigb = 0.
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).sigc = 0.
         sicir_par(i_det).lyr(i_lyr).wedge(i_sublyr).material = 0
        end do
       end do
c
      end do
c
c     Clear rectangular pixel z planes
c
      siz_rect_num     = 0
c
      do i_det = 1,max_siz_rect
       siz_rect_par(i_det).nlayer = 0
       siz_rect_par(i_det).nwafer = 0
       siz_rect_par(i_det).nchan  = 0
       siz_rect_par(i_det).x      = 0.
       siz_rect_par(i_det).y      = 0.
       siz_rect_par(i_det).z      = 0.
       siz_rect_par(i_det).name   = ' '
       do i_lyr = 1,max_siz_rect_lyr
         siz_rect_par(i_det).lyr(i_lyr).nwafer  = 0
         siz_rect_par(i_det).lyr(i_lyr).nchan  = 0
         siz_rect_par(i_det).lyr(i_lyr).name  = ' '
         siz_rect_par(i_det).lyr(i_lyr).xCenter = 0.
         siz_rect_par(i_det).lyr(i_lyr).yCenter = 0.
         siz_rect_par(i_det).lyr(i_lyr).zCenter = 0.
         siz_rect_par(i_det).lyr(i_lyr).rotate = 0.
         do i_wfr = 1,max_siz_rect_wafer
           siz_rect_par(i_det).lyr(i_lyr).wfr(i_wfr).type  = 0
           siz_rect_par(i_det).lyr(i_lyr).wfr(i_wfr).xLocal = 0.
           siz_rect_par(i_det).lyr(i_lyr).wfr(i_wfr).yLocal = 0.
           siz_rect_par(i_det).lyr(i_lyr).wfr(i_wfr).z  = 0.
           siz_rect_par(i_det).lyr(i_lyr).wfr(i_wfr).xlen  = 0.
           siz_rect_par(i_det).lyr(i_lyr).wfr(i_wfr).ylen  = 0.
           siz_rect_par(i_det).lyr(i_lyr).wfr(i_wfr).zlen  = 0.
           siz_rect_par(i_det).lyr(i_lyr).wfr(i_wfr).nsegm_x = 0
           siz_rect_par(i_det).lyr(i_lyr).wfr(i_wfr).nsegm_y = 0
           siz_rect_par(i_det).lyr(i_lyr).wfr(i_wfr).nchan   = 0
           siz_rect_par(i_det).lyr(i_lyr).wfr(i_wfr).pitch_x = 0.
           siz_rect_par(i_det).lyr(i_lyr).wfr(i_wfr).pitch_y = 0.
           siz_rect_par(i_det).lyr(i_lyr).wfr(i_wfr).coord0_x = 0.
           siz_rect_par(i_det).lyr(i_lyr).wfr(i_wfr).coord0_y = 0.
           siz_rect_par(i_det).lyr(i_lyr).wfr(i_wfr).stereo   = 0.
           siz_rect_par(i_det).lyr(i_lyr).wfr(i_wfr).eff_hit  = 0.
           siz_rect_par(i_det).lyr(i_lyr).wfr(i_wfr).siga_x   = 0.
           siz_rect_par(i_det).lyr(i_lyr).wfr(i_wfr).siga_y   = 0.
           siz_rect_par(i_det).lyr(i_lyr).wfr(i_wfr).material = 0
         end do
       end do
      end do
c
c     Clear Drift Chambers
c
      drf_num      = 0
c
      do i_det = 1,max_drf
c
       drf_par(i_det).name = ' '
       drf_par(i_det).rmin = 0.
       drf_par(i_det).rmax = 0.
       drf_par(i_det).zmin = 0.
       drf_par(i_det).zmax = 0.
       drf_par(i_det).material = 0
       do i =1,4
        drf_par(i_det).thick_boun(i) = 0.
        drf_par(i_det).mat_boun(i)   = 0
       end do
       drf_par(i_det).num_anode   = 0
       drf_par(i_det).num_cathode = 0
       drf_par(i_det).nchan       = 0
       do i_lyr = 1,max_drf_anode
        drf_par(i_det).an(i_lyr).nwire    = 0
        drf_par(i_det).an(i_lyr).lstereo  = .false.
        drf_par(i_det).an(i_lyr).readout  = 0
        drf_par(i_det).an(i_lyr).cathode = 0
        drf_par(i_det).an(i_lyr).radius   = 0.
        drf_par(i_det).an(i_lyr).rcenter  = 0.
        drf_par(i_det).an(i_lyr).phi0     = 0.
        drf_par(i_det).an(i_lyr).cell_offset   = 0.
        drf_par(i_det).an(i_lyr).stereo_offset = 0.
        do i = 1,3
         drf_par(i_det).an(i_lyr).offset(i)  = 0.
         drf_par(i_det).an(i_lyr).dircos(i)  = 0.
        end do
        drf_par(i_det).an(i_lyr).zmin        = 0.
        drf_par(i_det).an(i_lyr).zmax        = 0.
        drf_par(i_det).an(i_lyr).cell_height = 0.
        drf_par(i_det).an(i_lyr).cell_width  = 0.
        drf_par(i_det).an(i_lyr).cell_phi    = 0.
        drf_par(i_det).an(i_lyr).sag         = 0.
        drf_par(i_det).an(i_lyr).tau         = 0.
        drf_par(i_det).an(i_lyr).tant        = 0.
        drf_par(i_det).an(i_lyr).eff_hit     = 0.
        drf_par(i_det).an(i_lyr).eff_dedx    = 0.
        drf_par(i_det).an(i_lyr).siga        = 0.
        drf_par(i_det).an(i_lyr).sigb        = 0.
        drf_par(i_det).an(i_lyr).sigc        = 0.
        drf_par(i_det).an(i_lyr).nchan       = 0
        drf_par(i_det).an(i_lyr).chan0       = 0
       end do
       do i_lyr = 1,max_drf_cathode
        drf_par(i_det).cath(i_lyr).nwir_z   = 0
        drf_par(i_det).cath(i_lyr).nwir_phi = 0
        drf_par(i_det).cath(i_lyr).anode    = 0
        drf_par(i_det).cath(i_lyr).delta_r  = 0.
        drf_par(i_det).cath(i_lyr).zmin      = 0.
        drf_par(i_det).cath(i_lyr).zmax      = 0.
        drf_par(i_det).cath(i_lyr).cell_offset  = 0.
        drf_par(i_det).cath(i_lyr).eff_hit   = 0.
        drf_par(i_det).cath(i_lyr).resa      = 0.
        drf_par(i_det).cath(i_lyr).resb      = 0.
        drf_par(i_det).cath(i_lyr).resc      = 0.
        drf_par(i_det).cath(i_lyr).nchan     = 0
        drf_par(i_det).cath(i_lyr).chan0     = 0
       end do
c
      end do
c
c     Clear Forward Tracking System
c
      ftrk_num     = 0
c
      do i_det = 1,max_ftrk
c
       ftrk_par(i_det).name = ' '
       ftrk_par(i_det).xmin = 0.
       ftrk_par(i_det).xmax = 0.
       ftrk_par(i_det).ymin = 0.
       ftrk_par(i_det).ymax = 0.
       ftrk_par(i_det).zmin = 0.
       ftrk_par(i_det).zmax = 0.
       ftrk_par(i_det).nlyr = 0
       ftrk_par(i_det).material = 0
       do i = 1,6
        ftrk_par(i_det).thick_boun(i) = 0.
        ftrk_par(i_det).mat_boun(i)   = 0
       end do
       ftrk_par(i_det).nchan = 0
       do i_lyr = 1,max_ftrk_lyr
        ftrk_par(i_det).lyr(i_lyr).type = 0
        ftrk_par(i_det).lyr(i_lyr).xmin = 0.
        ftrk_par(i_det).lyr(i_lyr).xmax = 0.
        ftrk_par(i_det).lyr(i_lyr).ymin = 0.
        ftrk_par(i_det).lyr(i_lyr).ymax = 0.
        ftrk_par(i_det).lyr(i_lyr).xmin_gap = 0.
        ftrk_par(i_det).lyr(i_lyr).xmax_gap = 0.
        ftrk_par(i_det).lyr(i_lyr).ymin_gap = 0.
        ftrk_par(i_det).lyr(i_lyr).ymax_gap = 0.
        ftrk_par(i_det).lyr(i_lyr).z        = 0.
        ftrk_par(i_det).lyr(i_lyr).thickness= 0.
        ftrk_par(i_det).lyr(i_lyr).stereo   = 0.
        ftrk_par(i_det).lyr(i_lyr).cos_stereo   = 0.
        ftrk_par(i_det).lyr(i_lyr).sin_stereo   = 0.
        ftrk_par(i_det).lyr(i_lyr).ncell    = 0
        ftrk_par(i_det).lyr(i_lyr).cell_size  = 0.
        ftrk_par(i_det).lyr(i_lyr).coord0_x   = 0.
        ftrk_par(i_det).lyr(i_lyr).coord0_y   = 0.
        ftrk_par(i_det).lyr(i_lyr).eff_hit    = 0.
        ftrk_par(i_det).lyr(i_lyr).siga       = 0.
        ftrk_par(i_det).lyr(i_lyr).sigb       = 0.
        ftrk_par(i_det).lyr(i_lyr).sigc       = 0.
       end do
c
      end do
c
c     Clear Solenoids
c
      sol_num      = 0
c
      do i_det = 1,max_sol
c
       sol_par(i_det).name = ' '
       sol_par(i_det).rmin = 0.
       sol_par(i_det).rmax = 0.
       sol_par(i_det).zmin = 0.
       sol_par(i_det).zmax = 0.
       sol_par(i_det).Bfield   = 0.
       sol_par(i_det).mat_fill = 0
       do i = 1,4
        sol_par(i_det).thick_boun(i) = 0.
        sol_par(i_det).mat_boun(i)   = 0
       end do
c
      end do
c
c     Clear Dipoles
c
      dip_num      = 0
c
      do i_det = 1,max_dip
c
       dip_par(i_det).name = ' '
       dip_par(i_det).xmin = 0.
       dip_par(i_det).xmax = 0.
       dip_par(i_det).ymin = 0.
       dip_par(i_det).ymax = 0.
       dip_par(i_det).zmin = 0.
       dip_par(i_det).zmax = 0.
       dip_par(i_det).bfield = 0.
       do i =1,3
        dip_par(i_det).dircos(i) = 0.
       end do
       dip_par(i_det).ptkick = 0.
       dip_par(i_det).mat_fill = 0
       do i = 1,6
        dip_par(i_det).thick_boun(i) = 0.
        dip_par(i_det).mat_boun(i)   = 0
       end do
c
      end do
c
c     Clear Cherenkov counters
c
      certh_num    = 0
c
      do i_det = 1,max_certh
c
       certh_par(i_det).name  = ' '
       certh_par(i_det).shape = ' '
       do i =1,2
        certh_par(i_det).rmin(i) = 0.
        certh_par(i_det).rmax(i) = 0.
       end do
       certh_par(i_det).zmin = 0.
       certh_par(i_det).zmax = 0.
       certh_par(i_det).mat_rad   = 0
       certh_par(i_det).thick_rad = 0.
       certh_par(i_det).eta_min   = 0.
       certh_par(i_det).eta_max   = 0.
       certh_par(i_det).material  = 0.
c
      end do
c
c     Clear EM Calorimeters
c
      emcal_num    = 0
c
      do i_det = 1,max_emcal
c
       emcal_par(i_det).name  = ' '
       emcal_par(i_det).shape = ' '
       emcal_par(i_det).type  = 0
       do i = 1,2
        emcal_par(i_det).rmin(i) = 0.
        emcal_par(i_det).rmax(i) = 0.
       end do
       emcal_par(i_det).zmin = 0.
       emcal_par(i_det).zmax = 0.
       emcal_par(i_det).eta_min = 0.
       emcal_par(i_det).eta_max = 0.
       emcal_par(i_det).material = 0
       emcal_par(i_det).active_material = 0
       emcal_par(i_det).ncoor1 = 0
       emcal_par(i_det).ncoor2 = 0
       emcal_par(i_det).c_coor1_size = 0.
       emcal_par(i_det).c_coor2_size = 0.
       emcal_par(i_det).siga_em  = 0.
       emcal_par(i_det).sigb_em  = 0.
       emcal_par(i_det).sigc_em  = 0.
       emcal_par(i_det).siga_had = 0.
       emcal_par(i_det).sigb_had = 0.
       emcal_par(i_det).sigc_had = 0.
       emcal_par(i_det).em_had_ratio = 0.
       emcal_par(i_det).nlayers = 0
c
      end do
c
c     Clear Muon System
c
      muon_num     = 0
c
      do i_det = 1,max_muon
c
       muon_par(i_det).name  = ' '
       muon_par(i_det).shape = ' '
       muon_par(i_det).type  = 0
       do i = 1,2
        muon_par(i_det).rmin(i) = 0.
        muon_par(i_det).rmax(i) = 0.
       end do
       muon_par(i_det).zmin = 0.
       muon_par(i_det).zmax = 0.
       muon_par(i_det).eta_min = 0.
       muon_par(i_det).eta_max = 0.
       muon_par(i_det).material = 0
       muon_par(i_det).nlyr = 0
c
      end do
c
c     Clear Absorbers
c
      absorber_num = 0
c
      do i_det = 1,max_absorber
c
       absorber_par(i_det).name  = ' '
       absorber_par(i_det).shape = ' '
       absorber_par(i_det).type  = 0
       do i = 1,2
        absorber_par(i_det).rmin(i) = 0.
        absorber_par(i_det).rmax(i) = 0.
       end do
       absorber_par(i_det).zmin = 0.
       absorber_par(i_det).zmax = 0.
       absorber_par(i_det).eta_min = 0.
       absorber_par(i_det).eta_max = 0.
       absorber_par(i_det).material = 0
c
      end do
c
c     Clear Volumes
c
      vol_num      = 0
c
      do i_det = 1,max_vol
c
       vol_par(i_det).name = ' '
       vol_par(i_det).rmin = 0.
       vol_par(i_det).rmax = 0.
       vol_par(i_det).zmin = 0.
       vol_par(i_det).zmax = 0.
       vol_par(i_det).mat_fill   = 0
       vol_par(i_det).thick_rmin = 0.
       vol_par(i_det).thick_rmax = 0.
       vol_par(i_det).thick_zmin = 0.
       vol_par(i_det).thick_zmax = 0.
       vol_par(i_det).mat_rmin = 0.
       vol_par(i_det).mat_rmax = 0.
       vol_par(i_det).mat_zmin = 0.
       vol_par(i_det).mat_zmax = 0.
c
      end do
c
      volxy_num    = 0
c
      do i_det = 1,max_volxy
c
       volxy_par(i_det).name = ' '
       volxy_par(i_det).xmin = 0.
       volxy_par(i_det).xmax = 0.
       volxy_par(i_det).ymin = 0.
       volxy_par(i_det).ymax = 0.
       volxy_par(i_det).zmin = 0.
       volxy_par(i_det).zmax = 0.
       volxy_par(i_det).mat_fill = 0
       do i = 1,6
        volxy_par(i_det).thick_boun(i) = 0.
        volxy_par(i_det).mat_boun(i)   = 0
       end do
c
      end do
c
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:21  eugenio
c Initial revision
c
c Revision 1.14  1999/04/24 22:39:19  mcbride
c update to allow multiple beampipes
c
c Revision 1.13  1997/10/24  19:54:43  bphyslib
c fix bug
c
c Revision 1.12  1997/10/24  17:09:10  yarba_j
c fixed minor problems related to new pixel geometry
c
c Revision 1.11  1997/10/08  21:25:13  yarba_j
c updated to account for new pixels geometry
c
c Revision 1.10  1997/04/04  20:29:32  garren
c add rcs log line
c

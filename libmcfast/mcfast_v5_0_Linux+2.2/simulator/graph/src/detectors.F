      subroutine detectors
************************************************************************
*
*       detectors
*
*       Load generic detector structure from geom DB info
*
*
************************************************************************
      implicit none
*
#include "mcfast_db.inc"
#include "det_structure.inc"
      integer i, j
*
*-----------------------------------------------------------------------
*
      ndetst = 0
      ndet_id = 0
      do i=1,n_obj_bpipe
        ndet_id = ndet_id +1
        idet_id(ndet_id) = it_bpipe
        ndetst = min(nmx_detst,ndetst +1)
        detst(ndetst).sensitive = .false.
        detst(ndetst).ishape = it_cylinder
        detst(ndetst).itype = it_bpipe
        detst(ndetst).name = bpipe(i).name
        detst(ndetst).rmin = bpipe(i).rmin
        detst(ndetst).rmax = bpipe(i).rmax
        detst(ndetst).z0 = bpipe(i).z0
        detst(ndetst).zlen = bpipe(i).zlen
        detst(ndetst).mat = bpipe(i).mat_fill
      enddo
      do i=1,n_obj_absorber
        ndet_id = ndet_id +1
        idet_id(ndet_id) = it_absorber
        ndetst = min(nmx_detst,ndetst +1)
        detst(ndetst).sensitive = .false.
        detst(ndetst).itype = it_absorber
        if (absorber(i).shape.eq.'TUBE') then
          detst(ndetst).ishape = it_cylinder
        else
          detst(ndetst).ishape = it_cone
        endif
        detst(ndetst).name = absorber(i).name
        detst(ndetst).rmin = absorber(i).rmin(1)
        detst(ndetst).rmax = absorber(i).rmax(1)
        detst(ndetst).z0 = absorber(i).z0
        detst(ndetst).zlen = absorber(i).zlen
        detst(ndetst).mat = absorber(i).material
        detst(ndetst).rminf = absorber(i).rmin(2)
        detst(ndetst).rmaxf = absorber(i).rmax(2)
      enddo
      do i=1,n_obj_dipole
        ndet_id = ndet_id +1
        idet_id(ndet_id) = it_dipole
        ndetst = min(nmx_detst,ndetst +1)
        detst(ndetst).itype = it_dipole
        detst(ndetst).sensitive = .false.
        detst(ndetst).ishape = it_box
        detst(ndetst).name = dipole(i).name
        detst(ndetst).z0 = dipole(i).z0
        detst(ndetst).zlen = dipole(i).zlen
        detst(ndetst).mat = dipole(i).mat_fill
        do j=1,3
          detst(ndetst).dircos(j) = dipole(i).dircos(j)
        enddo
        detst(ndetst).xmin = dipole(i).xmin
        detst(ndetst).xmax = dipole(i).xmax
        detst(ndetst).ymin = dipole(i).ymin
        detst(ndetst).ymax = dipole(i).ymax
      enddo
      do i=1,n_obj_solenoid
        ndet_id = ndet_id +1
        idet_id(ndet_id) = it_solenoid
        ndetst = min(nmx_detst,ndetst +1)
        detst(ndetst).itype = it_solenoid
        detst(ndetst).sensitive = .false.
        detst(ndetst).ishape = it_cylinder
        detst(ndetst).name = solenoid(i).name
        detst(ndetst).rmin = solenoid(i).rmin
        detst(ndetst).rmax = solenoid(i).rmax
        detst(ndetst).z0 = solenoid(i).z0
        detst(ndetst).zlen = solenoid(i).zlen
        detst(ndetst).mat = solenoid(i).mat_fill
      enddo
      do i=1,n_obj_drift
        ndet_id = ndet_id +1
        idet_id(ndet_id) = it_drift
        ndetst = min(nmx_detst,ndetst +1)
        detst(ndetst).itype = it_drift
        detst(ndetst).sensitive = .true.
        detst(ndetst).ishape = it_cylinder
        detst(ndetst).name = drift(i).name
        detst(ndetst).rmin = drift(i).rmin
        detst(ndetst).rmax = drift(i).rmax
        detst(ndetst).z0 = drift(i).z0
        detst(ndetst).zlen = drift(i).zlen
        detst(ndetst).mat = drift(i).material
        detst(ndetst).ipt = i
      enddo
      do i=1,n_obj_sibarrel
        ndet_id = ndet_id +1
        idet_id(ndet_id) = it_sibarrel
        ndetst = min(nmx_detst,ndetst +1)
        detst(ndetst).itype = it_sibarrel
        detst(ndetst).sensitive = .true.
        detst(ndetst).ishape = it_sibarrel
        detst(ndetst).name = sibarrel(i).name
        detst(ndetst).z0 = sibarrel(i).z0_global
        detst(ndetst).ipt = i
      enddo
      do i=1,n_obj_sixy
        ndet_id = ndet_id +1
        idet_id(ndet_id) = it_sixy
        ndetst = min(nmx_detst,ndetst +1)
        detst(ndetst).itype = it_sixy
        detst(ndetst).sensitive = .true.
        detst(ndetst).ishape = it_sixy
        detst(ndetst).name = sixy(i).name
        detst(ndetst).z0 = sixy(i).zpos
        detst(ndetst).ipt = i
      enddo
      do i=1,n_obj_sidisk
        ndet_id = ndet_id +1
        idet_id(ndet_id) = it_sidisk
        ndetst = min(nmx_detst,ndetst +1)
        detst(ndetst).itype = it_sidisk
        detst(ndetst).sensitive = .true.
        detst(ndetst).ishape = it_sidisk
        detst(ndetst).name = sidisk(i).name
        detst(ndetst).z0 = sidisk(i).zpos
        detst(ndetst).ipt = i
      enddo
      do i=1,n_obj_ftrk
        ndet_id = ndet_id +1
        idet_id(ndet_id) = it_ftrk
        ndetst = min(nmx_detst,ndetst +1)
        detst(ndetst).itype = it_ftrk
        detst(ndetst).sensitive = .true.
        detst(ndetst).ishape = it_box
        detst(ndetst).name = ftrk(i).name
        detst(ndetst).z0 = ftrk(i).z0
        detst(ndetst).zlen = ftrk(i).zlen
        detst(ndetst).mat = ftrk(i).mat_fill
        detst(ndetst).xmin = ftrk(i).xmin
        detst(ndetst).xmax = ftrk(i).xmax
        detst(ndetst).ymin = ftrk(i).ymin
        detst(ndetst).ymax = ftrk(i).ymax
        detst(ndetst).ipt = i
      enddo
      do i=1,n_obj_emcal
        ndet_id = ndet_id +1
        idet_id(ndet_id) = it_emcal
        ndetst = min(nmx_detst,ndetst +1)
        detst(ndetst).itype = it_emcal
        detst(ndetst).sensitive = .true.
        detst(ndetst).ishape = it_cone   ! $$$ review adequacy of cone
        detst(ndetst).name = emcal(i).name
        detst(ndetst).rmin = emcal(i).rmin(1)
        detst(ndetst).rmax = emcal(i).rmax(1)
        detst(ndetst).z0 = emcal(i).z0
        detst(ndetst).zlen = emcal(i).zlen
        detst(ndetst).mat = emcal(i).material
        detst(ndetst).rminf = emcal(i).rmin(2)
        detst(ndetst).rmaxf = emcal(i).rmax(2)
      enddo
      do i=1,n_obj_hadcal
        ndet_id = ndet_id +1
        idet_id(ndet_id) = it_hadcal
        ndetst = min(nmx_detst,ndetst +1)
        detst(ndetst).itype = it_hadcal
        detst(ndetst).sensitive = .true.
        detst(ndetst).ishape = it_cone
        detst(ndetst).name = hadcal(i).name
        detst(ndetst).rmin = hadcal(i).rmin(1)
        detst(ndetst).rmax = hadcal(i).rmax(1)
        detst(ndetst).z0 = hadcal(i).z0
        detst(ndetst).zlen = hadcal(i).zlen
        detst(ndetst).mat = hadcal(i).material
        detst(ndetst).rminf = hadcal(i).rmin(2)
        detst(ndetst).rmaxf = hadcal(i).rmax(2)
      enddo
      do i=1,n_obj_muon
        ndet_id = ndet_id +1
        idet_id(ndet_id) = it_muon
        ndetst = min(nmx_detst,ndetst +1)
        detst(ndetst).itype = it_muon
        detst(ndetst).sensitive = .true.
        detst(ndetst).ishape = it_cone
        detst(ndetst).name = muon(i).name
        detst(ndetst).rmin = muon(i).rmin(1)
        detst(ndetst).rmax = muon(i).rmax(1)
        detst(ndetst).z0 = muon(i).z0
        detst(ndetst).zlen = muon(i).zlen
        detst(ndetst).mat = muon(i).material
        detst(ndetst).rminf = muon(i).rmin(2)
        detst(ndetst).rmaxf = muon(i).rmax(2)
      enddo
*
***     initialize detector attributes
      call det_att_init
*
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:25  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:57  garren
c add rcs log line
c

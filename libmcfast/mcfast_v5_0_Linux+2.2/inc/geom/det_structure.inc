#include "const.inc"
*
***     generic detector structure used for master detector list
      structure /det_structure_s/
        DFLOAT rmin, rminf, rmax, rmaxf           ! geometry parameters
        DFLOAT xmin, xmax, ymin, ymax, z0, zlen
        DFLOAT dircos(3)
        integer iresponse       ! detector response model code
        integer ishape          ! shape (it_obox, it_cyl, it_cone,)
        integer itype           ! detector type (it_det_muon, etc.)
        logical sensitive       ! is detector element sensitive
        integer ipt             ! pointer to specialized detector structure
	integer dummy           ! pad to align structure
        character*40 name
        character*40 mat        ! fill material
      end structure
*
***     master detector list
      integer ndetst, nmx_detst
      parameter (nmx_detst=200)
      record /det_structure_s/ detst(nmx_detst)
*
      integer nmxdet_id
      parameter (nmxdet_id=100)
      integer idet_id(nmxdet_id), ndet_id    ! list of existing detector types
      common /det_structure_c/ detst, ndetst, idet_id, ndet_id

***     geometric types
      integer it_cylinder, it_cone, it_box, it_obox, it_proj_cylinder
      parameter (it_cylinder=101, it_cone=102, it_box=103, it_obox=104,
     +  it_proj_cylinder=105)

***     detector types
      integer it_bpipe,it_absorber,it_dipole,it_solenoid,it_drift
      integer it_sibarrel,it_sixy,it_sidisk,it_ftrk,it_emcal,
     +  it_hadcal,it_muon
***     definitions, in accord with jdev_xxxx definitions
      parameter(it_sibarrel=1,it_sidisk=2,it_drift=3,it_ftrk=5,
     +  it_sixy=7,it_emcal=8,it_hadcal=9,it_muon=10,it_bpipe=1,
     +  it_absorber=12,it_dipole=13,it_solenoid=14)

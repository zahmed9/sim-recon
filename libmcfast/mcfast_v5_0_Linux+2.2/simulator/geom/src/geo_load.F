      subroutine geo_load(fname)
#define _OUTLIB_ 
*
      implicit none
      character*(*) fname
*
      call mcfast_read(fname)   ! read the database
*
      call load_detector
      call load_mat
      call load_hits_trk
      call load_beam_vrtx
      call load_beampipe
      call load_dip
      call load_drift
      call load_fordisk
      call load_ftrk
      call load_emcal
      call load_absorber
      call load_muon
      call load_sol
      call load_sibarrel
      call load_sidisk
      call load_siz_rect
      call load_sixy
*
      call geo_fill_volume

      call geo_mother_volume
      call geo_trkorder
      call geo_trklayer
      call geo_set_trk_channels
*
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:23  eugenio
c Initial revision
c
c Revision 1.7  1999/03/26 17:33:28  mcbride
c change order of load routines for si planes
c
c Revision 1.6  1997/04/04  20:29:43  garren
c add rcs log line
c

C -*- Fortran -*-
C
C Package:     Tracing
C Module:      getFortranUserSettings
C 
C Description: fortran interface: get user settings from fortran common block
C
C Implimentation:
C     <Notes on implimentation>
C
C Author:      Martin Lohner
C Created:     Feb 23, 1997
C              Julia Yarba, 7-23-1997 : 
C              added control of showering and hit generation in calorimeters

C -----------------------------------------------------------------------

      subroutine get_fortran_userSettings( 
     * ostep_max_distance, 
     * ostep_max_angle, 
     * ostep_max_dedx, 
     * ostep_max_mscat,
     * otrk_max_turns, 
     * otrk_min_kinetic, 
     * otrk_min_brem,
     * 
     * otrk_ldecays, 
     * otrk_lpair, 
     * otrk_lhits, 
     * otrk_lscat, 
     * otrk_ldedx,
     * otrk_lint,
     * oshw_trans,
     * othresh,
     * oe_vis_min,
     * omax_ndep,
     * ohit_generation
     * )

C -----------------------------------------------------------------------
C   return fortran user settings
C -----------------------------------------------------------------------

#include "trace_params.inc"
#include "control_shower.inc"

c --------------- calling parameters ---------------------------

c ---------------- input ---------------------------------------

c ---------------- output --------------------------------------
      DFLOAT ostep_max_distance, 
     * ostep_max_angle, 
     * ostep_max_dedx, 
     * ostep_max_mscat,
     * otrk_max_turns, 
     * otrk_min_kinetic, 
     * otrk_min_brem

      logical otrk_ldecays, 
     * otrk_lpair, 
     * otrk_lhits, 
     * otrk_lscat, 
     * otrk_ldedx,
     * otrk_lint

      logical  oshw_trans,
     * ohit_generation
      real othresh,
     * oe_vis_min
      integer omax_ndep

c ---------------- local variables -----------------------------

c -------------------- code ------------------------------------

c      print *, 'Here in getFortranUserSettings'

c fill variables
      ostep_max_distance = step_max_distance
      ostep_max_angle    = step_max_angle
      ostep_max_dedx     = step_max_dedx
      ostep_max_mscat    = step_max_mscat
      otrk_max_turns     = trk_max_turns
      otrk_min_kinetic   = trk_min_kinetic
      otrk_min_brem      = 1.e6 * unit_ev !trk_min_brem

      otrk_ldecays = trk_ldecays
      otrk_lpair   = trk_lpair
      otrk_lhits   = trk_lhits
      otrk_lscat   = trk_lscat
      otrk_ldedx   = trk_ldedx
      otrk_lint    = trk_lint

c   Showering (and hit generation in calorimeters) control
      oshw_trans      = shw_trans
      othresh         = thresh
      oe_vis_min      = e_vis_min
      omax_ndep       = max_ndep
      ohit_generation = hit_generation

c report success
      return

      end


c ======================================================================
c Questions, suggestions -- get on line 1!
c
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:34  eugenio
c Initial revision
c
c Revision 1.3  1998/02/16 00:45:09  mkl
c new 2ndary interaction user flag
c
c Revision 1.2  1997/07/24  22:06:46  yarba_j
c added control for showering and hit generation in calorimeters
c
c Revision 1.1  1997/07/03  03:34:01  mkl
c new approach: surfaces vs volumes; box tracing
c
c


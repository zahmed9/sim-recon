
      subroutine ctl_shw_init

c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c     Author :   Julia Yarba, FNAL/CD
c     Creation : 10-11-96
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "control_shower.inc"

      shw_trans = .true.
      thresh = 0.05 
      e_vis_min = 0.002
      max_ndep = 25
      hit_generation = .true.

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:19  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 18:07:47  garren
c add hooks to initialize user trigger code
c

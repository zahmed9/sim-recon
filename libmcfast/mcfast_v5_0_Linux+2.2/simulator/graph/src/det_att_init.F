      subroutine det_att_init
************************************************************************
*
*       det_att_init
*
*
************************************************************************
      implicit none
#include "const.inc"
#include "mcfast_db.inc"
#include "det_structure.inc"
#include "det_att_structure.inc"
      integer itype
*
*-----------------------------------------------------------------------
*
***     colors, from Hans Drevermann, FNAL vis conf. 8/95
      white.r = 1.
      white.g = 1.
      white.b = 1.

      green.r = 0
      green.g = 1.
      green.b = 0
*
      yellow.r = 1.
      yellow.g = 1.
      yellow.b = 0.
*
      orange.r = 1.
      orange.g = .45
      orange.b = 0.
*
      red.r = 1.
      red.g = 0.
      red.b = 0.
*
      magenta.r = 1.
      magenta.g = 0.
      magenta.b = 1.
*
      cyan.r = 0.
      cyan.g = .8
      cyan.b = 1.
*
      blue.r = .4
      blue.g = .5
      blue.b = 1.
*
      call colorlevel(green,ltgreen,1.5)
      call colorlevel(green,dkgreen,0.8)

      call colorlevel(yellow,ltyellow,1.5)
      call colorlevel(yellow,dkyellow,0.8)

      call colorlevel(orange,ltorange,1.5)
      call colorlevel(orange,dkorange,0.8)

      call colorlevel(red,ltred,1.5)
      call colorlevel(red,dkred,0.8)

      call colorlevel(magenta,ltmagenta,1.5)
      call colorlevel(magenta,dkmagenta,0.8)

      call colorlevel(cyan,ltcyan,1.5)
      call colorlevel(cyan,dkcyan,0.8)

      call colorlevel(blue,ltblue,1.5)
      call colorlevel(blue,dkblue,0.8)
*
***     assign detector attributes. Should be in db.
      do itype=1,ndet_id
        att(itype).visible = it_cutaway
        att(itype).trans = 1.0
      enddo
*
      att(it_bpipe).color = yellow
      att(it_absorber).color = red
      att(it_dipole).color = green
      att(it_solenoid).color = green
      att(it_drift).color = dkblue
      att(it_sibarrel).color = magenta
      att(it_sixy).color = magenta
      att(it_sidisk).color = magenta
      att(it_ftrk).color = orange
      att(it_emcal).color = cyan
      att(it_hadcal).color = magenta
      att(it_muon).color = blue
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:25  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:56  garren
c add rcs log line
c

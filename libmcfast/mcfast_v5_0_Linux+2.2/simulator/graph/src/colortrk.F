      subroutine colortrk(itype,ihep,col)
************************************************************************
*
*       colortrk
*
*       MCFAST Geomview graphics
*
*       Set track color based on track type
*
************************************************************************
      implicit none
#include "stdhep.inc"
#include "trace_types.inc"
#include "det_structure.inc"
#include "det_att_structure.inc"
      integer itype, ihep, ipid
      record /color_s/ col
*
*-----------------------------------------------------------------------
*
      ipid = abs(idhep(ihep))
      if (ipid.eq.11) then      ! e
        col = dkyellow
      else if (ipid.eq.13) then ! mu
        col = dkgreen
      else if (ipid.eq.22) then ! gam
        col = ltblue
      else
        col = white
      endif
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:25  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:55  garren
c add rcs log line
c

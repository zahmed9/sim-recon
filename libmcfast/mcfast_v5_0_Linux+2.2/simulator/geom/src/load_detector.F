      subroutine load_detector
      implicit none
#include "mcfast_db.inc"
#include "mcp_luns.inc"
#include "detector_general.inc"
      integer lenocc
      external lenocc
*
      det_general.geom_id =
     +  detector(1).geom_id(:lenocc(detector(1).geom_id))
      det_general.name = detector(1).name(:lenocc(detector(1).name))

      write(mcp_llpt,1000) det_general.name(:lenocc(det_general.name)),
     +  det_general.geom_id(:lenocc(det_general.geom_id))
 1000 format(' Detector: "',a,'", geom ID: "',a,'"')
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:24  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:29:48  garren
c add rcs log line
c

      subroutine load_hits_trk
      implicit none
      integer i, j
#include "mcfast_db.inc"
#include "mcp_luns.inc"
#include "track_minhit.inc"
*
      trk_minhit.all = hitsontrack(1).all
      trk_minhit.z = hitsontrack(1).z
      trk_minhit.svx = hitsontrack(1).svx
*
      write(mcp_llpt,*) 'Hits on track: all, z, svx:',trk_minhit.all,
     +  trk_minhit.z,trk_minhit.svx
*
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:24  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:51  garren
c add rcs log line
c

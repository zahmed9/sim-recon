      subroutine mcp_track_fill

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Fill generated charged particle list.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "gen_stable.inc"
#include "gen_track.inc"

c     Local variables
      integer id, istb, ida
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      trk_gen_num = 0
      do 500 istb=1,stb_gen_num
        id = stb_gen(istb).pdgtype
        ida = abs(id)
        if(ida.eq. 11 .or. ida.eq.  13 .or. ida.eq.211 .or.
     *     ida.eq.321 .or. ida.eq.2212) then
          if(trk_gen_num .lt. trk_gen_max) then
            trk_gen_num = trk_gen_num + 1
            trk_gen(trk_gen_num).q = stb_gen(istb).q
            trk_gen(trk_gen_num).status = stb_gen(istb).status
            trk_gen(trk_gen_num).pdgtype = id
            trk_gen(trk_gen_num).stbtype = stb_gen(istb).stbtype
            trk_gen(trk_gen_num).hep = stb_gen(istb).hep
          endif
        endif
500   continue

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:20  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 18:07:59  garren
c add hooks to initialize user trigger code
c

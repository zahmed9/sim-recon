      subroutine mcp_ks_fill

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Fill generated Ks list.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "gen_stable.inc"
#include "gen_ks.inc"

c     Local variables
      integer id, istb
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      ks_gen_num = 0
      do 500 istb=1,stb_gen_num
        id = stb_gen(istb).pdgtype
        if(id .eq. 310) then
          if(ks_gen_num .lt. ks_gen_max) then
            ks_gen_num = ks_gen_num + 1
            ks_gen(ks_gen_num).q = stb_gen(istb).q
            ks_gen(ks_gen_num).status = stb_gen(istb).status
            ks_gen(ks_gen_num).pdgtype = id
            ks_gen(ks_gen_num).hep = stb_gen(istb).hep
          endif
        endif
500   continue

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:19  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 18:07:52  garren
c add hooks to initialize user trigger code
c

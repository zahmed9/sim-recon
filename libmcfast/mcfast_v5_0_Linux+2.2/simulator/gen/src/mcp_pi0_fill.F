      subroutine mcp_pi0_fill

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Fill generated pi0 list
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "gen_stable.inc"
#include "gen_pi0.inc"

c     Local variables
      integer id, istb
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      pi0_gen_num = 0
      do 500 istb=1,stb_gen_num
        id = stb_gen(istb).pdgtype
        if(abs(id) .eq. 111) then
          if(pi0_gen_num .lt. pi0_gen_max) then
            pi0_gen_num = pi0_gen_num + 1
            pi0_gen(pi0_gen_num).q = 0
            pi0_gen(pi0_gen_num).status = stb_gen(istb).status
            pi0_gen(pi0_gen_num).pdgtype = id
            pi0_gen(pi0_gen_num).hep = stb_gen(istb).hep
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
c Revision 1.2  1997/04/04 18:07:54  garren
c add hooks to initialize user trigger code
c

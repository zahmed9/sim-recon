      subroutine mcp_lambda_fill

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Fill generated lambda list.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "gen_stable.inc"
#include "gen_lam.inc"

c     Local variables
      integer id, istb
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      lam_gen_num = 0
      do 500 istb=1,stb_gen_num
        id = stb_gen(istb).pdgtype
        if(abs(id) .eq. 3122) then
          if(lam_gen_num .lt. lam_gen_max) then
            lam_gen_num = lam_gen_num + 1
            lam_gen(lam_gen_num).q = stb_gen(istb).q
            lam_gen(lam_gen_num).status = stb_gen(istb).status
            lam_gen(lam_gen_num).pdgtype = id
            lam_gen(lam_gen_num).hep = stb_gen(istb).hep
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
c Revision 1.2  1997/04/04 18:07:52  garren
c add hooks to initialize user trigger code
c

      subroutine mcp_elec_fill

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Fill generated electron list
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "gen_stable.inc"
#include "gen_elec.inc"

c     Local variables
      integer id, istb
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      elec_gen_num = 0
      do 500 istb=1,stb_gen_num
        id = stb_gen(istb).pdgtype
        if(abs(id) .eq. 11) then
          if(elec_gen_num .lt. elec_gen_max) then
            elec_gen_num = elec_gen_num + 1
            elec_gen(elec_gen_num).q = stb_gen(istb).q
            elec_gen(elec_gen_num).status = stb_gen(istb).status
            elec_gen(elec_gen_num).pdgtype = id
            elec_gen(elec_gen_num).hep = stb_gen(istb).hep
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
c Revision 1.2  1997/04/04 18:07:50  garren
c add hooks to initialize user trigger code
c

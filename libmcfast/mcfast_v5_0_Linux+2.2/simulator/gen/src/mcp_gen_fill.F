      subroutine mcp_gen_fill

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Fill generated particle lists
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      call mcp_stable_fill
      call mcp_track_fill
      call mcp_muon_fill
      call mcp_elec_fill
      call mcp_gamma_fill
      call mcp_pi0_fill
      call mcp_ks_fill
      call mcp_lambda_fill

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:19  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 18:07:51  garren
c add hooks to initialize user trigger code
c

      subroutine usr_analysis

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Default user analysis routine. You need to change this to suit
c   your analysis. Default is to reconstruct all tracks.
c   This is very slow.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_luns.inc"
#include "gen_track.inc"

c     Local variables
      integer mtrk, mgam
      parameter(mtrk = 500)
      parameter(mgam = 500)

      integer ntrk, list_trk(mtrk), ngam, list_gam(mgam)
      integer i
      logical init

      data init/.TRUE./
      save init
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(init) then
        init = .FALSE.     ! NOTE: routine usr_init already called 
        write(6,5000) 
        write(mcp_llpt,5000)
5000    format('usr_analysis: default routine ')
      endif


c     Reconstruct all charged tracks by default
      ntrk = trk_gen_num
      do i=1,trk_gen_num
        list_trk(i) = trk_gen(i).hep
      enddo
      
      call fctl_offline(ntrk, list_trk)
         
c     histoscope update
c     call hs_update

*
***   include McFio output (controlled by mcfio_out data card)
      call usr_mcfio_out

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:40  eugenio
c Initial revision
c
c Revision 1.7  1998/06/23 23:47:42  bphyslib
c fix references to renamed routines
c
c Revision 1.6  1997/04/04  18:08:01  garren
c add hooks to initialize user trigger code
c

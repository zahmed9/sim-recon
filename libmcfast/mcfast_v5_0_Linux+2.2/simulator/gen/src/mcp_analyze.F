      subroutine mcp_analyze

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   This handles the bulk of the work event by event.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_ranseeds.inc"
#include "mcp_params.inc"
#include "mcp_summary.inc"
#include "stdhep.inc"
#include "stdlun.inc"

#include "trace_params.inc"

c     Externals
      integer  cmd_lenstr
      external cmd_lenstr

c     Local variables
      integer i, leng, error, key, status, keep, num
      logical done, level1, level2
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Event loop
 100  call get_ranseeds(mcp_ranseeds, 1)   !Get random seeds
      if (.not. mcp_batch) then
        call mcp_checktypein              !Check user's terminal typein
      endif

c     Are we finished?
      done = mcp_all.event.ge.mcp_maxevent .and. mcp_maxevent.gt.0
      done = done .or. mcp_exit
      if(done) goto 8000

      call mcp_nextevent(status)   !Get event from file or internal gen.
      if(status .ne. 0) goto 8000  !End of data
      num = mcp_collisions(1) + mcp_collisions(2)
      call vtx_gen(num)            !Generate primary vertices
      call vtx_add                 !Add vertex to particles in HEPEVT list
      call vtx_fill                !Fill HEP vertex info

      call usr_filter(keep)        !Check event filter
      if(keep .eq. 0) goto 100
      mcp_fltr.event = mcp_fltr.event + 1
      mcp_fltr.event_file = mcp_fltr.event_file + 1

      call trk_clear_hits         !Clear hits for new event
      call emcal_clear_hits       !Clear EMC hits for new events

      if ( trk_lintegrated ) then
         call fill_mcparticle_list 
      endif
      
      call usr_before_trigger     !Make hits and other stuff

      call calor_consolidate      !Consolidate calorimetry hits, if necessary

      if(mcp_fltr.event .le. mcp_maxprint) call heplst(1)

      call mcp_gen_fill           !Fill stable particle lists

c     Check trigger
      call trig_sim_event(level1, level2)
      if(.not.level1 .or. .not.level2) goto 100
      mcp_trig.event = mcp_trig.event + 1
      mcp_trig.event_file = mcp_trig.event_file + 1

      call usr_analysis          !User analysis routine

      goto 100                   !Event loop


c     Come here when finished reading data
8000  continue
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:19  eugenio
c Initial revision
c
c Revision 1.6  1999/06/07 22:32:23  yarba_j
c first step toward c++ event representation: fill up list of MCParticle objects (by calling fill_mcparticle_list_) if integrated tracing is selected; list of particles is updated on the event by event basis
c
c Revision 1.5  1997/04/04  18:07:49  garren
c add hooks to initialize user trigger code
c

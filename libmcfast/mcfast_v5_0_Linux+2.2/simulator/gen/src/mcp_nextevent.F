      subroutine mcp_nextevent(status)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Get the next event. The events may be stored in StdHep format or be
c   generated internally.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_summary.inc"
#include "mcp_params.inc"
#include "mcp_beams.inc"
#include "mcp_luns.inc"
#include "stdhep.inc"
#include "stdlun.inc"

c     Externals
      integer  cmd_lenstr
      logical  dtf_open
      external cmd_lenstr, dtf_open

c     Argument list
      integer status

c     Local variables
      integer leng, key, error, nsig, nback
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      mcp_collisions(1) = 0
      mcp_collisions(2) = 0

c     If internally generated event, get it and return.
      if(.not.mcp_read_data) then
        call gnr_generate_event
        status = 0
        mcp_collisions(1) = 1
        goto 8000
      endif

c     Otherwise, get it from a StdHep file

c     Pick number of signal and background events to read.
c     We could improve this by allowing the number of signal events
c     to be Poisson distributed and by allowing several different
c     background files.
      nsig = 1
      if(mcp_int_crossing .gt. 0.) then
        call poissn(sngl(mcp_int_crossing), nback, error)
      else
        nback = 0
      endif

      nhep = 0
      nmulti = 0

c     Signal file
 100  if(mcp_collisions(1) .ge. nsig) goto 200
      if(.not.mcp_openfile(1)) then
        call mcp_nextfile(1, status)
        if(status .ne. 0) goto 200
      endif
      call mcp_readevent(1, status)
      if(status .ne. 0) goto 100
      mcp_collisions(1) = mcp_collisions(1) + 1
      goto 100

c     Background file
 200  if(mcp_collisions(2) .ge. nback) goto 8000
      if(.not.mcp_openfile(2)) then
        call mcp_nextfile(2, status)
        if(status .ne. 0) goto 8000
      endif
      call mcp_readevent(2, status)
      if(status .ne. 0) goto 200
      mcp_collisions(2) = mcp_collisions(2) + 1
      goto 200

c     Exit here
 8000 mcp_collisions_tot(1) = mcp_collisions_tot(1) + mcp_collisions(1)
      mcp_collisions_tot(2) = mcp_collisions_tot(2) + mcp_collisions(2)
      if(status .eq. 0) then
        mcp_all.event = mcp_all.event + 1
        mcp_all.event_file = mcp_all.event_file + 1
      endif
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:20  eugenio
c Initial revision
c
c Revision 1.5  1999/12/21 21:25:49  kutschke
c Restore correct distribution of BG events.
c
c Revision 1.4  1999/03/26  17:00:39  procario
c Total number of interactions is now poisson with at least 1 interaction being signal and the rest background
c
c Revision 1.3  1997/04/09  19:02:37  bphyslib
c merge change from v2_5_2
c
c Revision 1.2  1997/04/04  18:07:53  garren
c add hooks to initialize user trigger code
c

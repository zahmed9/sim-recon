      subroutine usr_before_trigger

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Does a bunch of user defined stuff before the trigger is called.
c
c   This version calls the combined tracing routines 
c                
c
c  Input:
c  None
c
c  Output:
c  None
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_luns.inc"
#include "mcp_summary.inc"
#include "trace_params.inc"
#include "trace.inc"
#include "trace_types.inc"
#include "stdhep.inc"
#include "detector_general.inc"

c     Externals
      external trk_trace_param, trk_trace_scat 
      integer  trk_trace_param, trk_trace_scat

      external trace_particle
      integer  trace_particle

c     Calling arguments

c     Local variables
      integer hep, aid, status
      logical init

      data init/.TRUE./
      save init
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(init) then

        init = .FALSE.
        write(6,5000)
        write(mcp_llpt,5000)
5000    format('usr_before_trigger: COMBINED trace routine')

        if(.not.trk_lintegrated) then
cc veto mscat and dedx in combined geometry ONLY for OLD tracing
         if(det_general.geom_id .ne. 'FORWARD' .AND.
     *      det_general.geom_id .ne. 'CENTRAL') then
           trk_ldedx = .FALSE.
           trk_lscat = .FALSE.
           write(mcp_llpt,5001)
           write(6,5001)
 5001      format(/
     *     'usr_before_trigger: Detector geometry is neither FORWARD ',
     *     'nor CENTRAL.'/
     *     'Setting trk_ldedx and trk_lscat to FALSE. No multiple',/
     *     'scattering or energy loss will be performed'/)
         endif
        endif
      endif

c     Trace all stable tracks except neutrinos through the detector and
c     make hits.
      hep = 0
      do while (hep .lt. nhep)
        hep = hep + 1
c     Only trace tracks with understood status
        if(isthep(hep) .ne. 1) goto 500
        aid = abs(idhep(hep))
        if(aid.eq.12 .or. aid.eq.14 .or. aid.eq.16) goto 500
        if (trk_lintegrated) then
cc  since the new tracing routine is in C++, indexing starts at 0, not at 1
	   status = trace_particle( hep-1 ) 
	else
           status = trk_trace_param(hep)   !trace particles through detectors
        endif
cc  unsuccessful tracing, give up !
        if(status .ne. 0) goto 9999
500     continue
      enddo

c     Normal exit
 1000 continue
      return
c
c     Error exit
c
 9999 continue
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:40  eugenio
c Initial revision
c
c Revision 1.6  1998/07/07 16:39:06  yarba_j
c added call for integrated (C++) tracing routine
c
c Revision 1.5  1998/06/29  22:05:27  yarba_j
c added switch/outlet for integrated tracing algorithm (the algorithm itself will be pluged in shortly
c
c Revision 1.4  1997/04/04  18:08:02  garren
c add hooks to initialize user trigger code
c

      subroutine trk_clear_hits

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Clear track hits
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

      save

#include "const.inc"
#include "trace_params.inc"
#include "hit_track.inc"
#include "trace.inc"
#include "trace_central.inc"
#include "trace_forward.inc"
#include "stdhep.inc"
#include "hep_trace.inc"

c     externals

c     Calling arguments

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      hit_trk_num = 0                    !# of track hits
      trace_num = 0                      !# entries in trace list
      trace_for_num = 0
      trace_cent_num = 0

c     Points from HEPEVT tracks to track hit list and trace list
      call vzero(hep_trace, nmxhep*HEP_TRACE_WORD)

      if (trk_lintegrated) then
         call clear_hits
      endif

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:35  eugenio
c Initial revision
c
c Revision 1.3  1998/07/07 16:36:44  yarba_j
c added clearing out of global hit list for integrated (C++) tracing
c
c Revision 1.2  1997/04/04  20:30:19  garren
c add rcs log line
c

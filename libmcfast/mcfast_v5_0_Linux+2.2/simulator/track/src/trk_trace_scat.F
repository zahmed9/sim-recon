      integer function trk_trace_scat(hep)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Trace a track through the detector for the parametrized version
c   of the Monte Carlo. The work is passed to other routines.
c
c  Inputs:
c  hep       integer variable
c            Position of track in HEPEVT list
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_luns.inc"

c     Externals
      external trk_trace_param
      integer trk_trace_param

c     Calling arguments
      integer hep

c     Local variables
      integer status
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      write(mcp_llpt,1000)
1000  format('trk_trace_scat:  This routine not implemented yet, using
     & trk_trace_param')

      status = trk_trace_param(hep)

      trk_trace_scat = status

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:39  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:36  garren
c add rcs log line
c

      subroutine mcp_dbginit

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Initialize debug trace and histogram features
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_debug.inc"

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      dbg_trace(jdbg_general) = 0
      dbg_trace(jdbg_track) = 0
      dbg_trace(jdbg_shower) = 0
      dbg_trace(jdbg_gamma) = 0
      dbg_trace(jdbg_hcal) = 0
      dbg_trace(jdbg_emcal) = 0
      dbg_trace(jdbg_muon) = 0
      dbg_trace(jdbg_trig) = 0
      dbg_trace(jdbg_geom) = 0
      dbg_trace(jdbg_hits) = 0
      
      dbg_hist(jdbg_general) = 0
      dbg_hist(jdbg_track) = 0
      dbg_hist(jdbg_shower) = 0
      dbg_hist(jdbg_gamma) = 0
      dbg_hist(jdbg_hcal) = 0
      dbg_hist(jdbg_emcal) = 0
      dbg_hist(jdbg_muon) = 0
      dbg_hist(jdbg_trig) = 0
      dbg_hist(jdbg_geom) = 0
      dbg_hist(jdbg_hits) = 0
      
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

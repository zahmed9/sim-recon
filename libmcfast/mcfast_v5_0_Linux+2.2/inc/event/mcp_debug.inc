****************************************************************************
*  Information about debug and trace conditions
****************************************************************************

      integer jdbg_general, jdbg_track, jdbg_shower, jdbg_gamma
      integer jdbg_hcal, jdbg_emcal, jdbg_muon
      integer jdbg_trig, jdbg_geom, jdbg_hits, jdbg_trace, jdbg_fit
      parameter (jdbg_general = 1)
      parameter (jdbg_track = 2)
      parameter (jdbg_shower = 3)
      parameter (jdbg_gamma = 4)
      parameter (jdbg_hcal = 5)
      parameter (jdbg_emcal = 6)
      parameter (jdbg_muon = 7)
      parameter (jdbg_trig = 8)
      parameter (jdbg_geom = 9)
      parameter (jdbg_hits = 10)
      parameter (jdbg_trace = 11)
      parameter (jdbg_fit = 12)

      integer dbg_max
      parameter (dbg_max = 12)

      integer dbg_trace         !1 ==> turn on tracing for subsystem
      integer dbg_hist          !1 ==> turn on histogramming per subsystem
      common/mcp_debug1/
     *  dbg_trace(dbg_max),
     *  dbg_hist(dbg_max)

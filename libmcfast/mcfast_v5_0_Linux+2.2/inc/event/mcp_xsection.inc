****************************************************************************
*  Cross section information for the current job. Cross section information
*  must be handled very carefully if all events are not processed. The
*  important information is listed below:
*
*  1. The Begin Run record of the StdHep file (first record) contains the
*     total cross section (xsec_gen) and the number of events generated
*     (nevt_gen).
*
*  2. mcfast then calculates the cross section per event as
*
*               xsec_event = xsec_gen / nevt_gen
*
*     xsec_event is stored in mcp_xsection.inc
*
*  3. The accumulated events and cross sections passing various mcfast
*     criteria (all, filter, trigger) are stored in the structures
*     mcp_all, mcp_filter, mcp_trig.
*
*  4. There is trouble only if all events are not read in because the
*     
*  processed because of user filters or triggers, then the cross section
****************************************************************************

#include "const.inc"

      DFLOAT mcp_xsec_tot   !Total cross section read in
      DFLOAT mcp_xsec_gen   !xsection of this file (in BR header)
      DFLOAT mcp_nevt_gen   !# events in this file (in BR header)
      DFLOAT mcp_xsec_event !xsection of this event
      DFLOAT mcp_xsec_corr  !Multiplicative correction needed
c                            !to bring cross section for
c                            !partially read data up to data

      common/mcp_xsection1/
     *  mcp_xsec_tot,
     *  mcp_xsec_gen,
     *  mcp_nevt_tot,
     *  mcp_xsec_event,
     *  mcp_xsec_corr

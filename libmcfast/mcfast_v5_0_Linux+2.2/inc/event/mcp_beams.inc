****************************************************************************
*  Information about beam and run conditions
****************************************************************************

#include "const.inc"

      DFLOAT mcp_luminst      !Instantaneous luminosity in cm**2/sec
      DFLOAT mcp_runtime      !Run time in seconds
      DFLOAT mcp_lumtot       !Inst. luminosity x runtime
      DFLOAT mcp_bunchtime    !Bunch separation in seconds
      DFLOAT mcp_int_crossing !# interactions per crossing
      common/mcp_beams1/
     *  mcp_luminst,
     *  mcp_runtime,
     *  mcp_lumtot,
     *  mcp_bunchtime,
     *  mcp_int_crossing

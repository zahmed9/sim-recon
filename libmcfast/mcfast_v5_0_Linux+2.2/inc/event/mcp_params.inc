****************************************************************************
*  Parameters used to control mcfast job flow
****************************************************************************

      logical mcp_lwrite            !TRUE ==> write events to disk/tape
      logical mcp_exit              !TRUE ==> finish processing
      logical mcp_pause             !TRUE ==> pause before next event
      logical mcp_read_data         !TRUE ==> read data from file
c                                    !FALSE==> generate data internally
      integer mcp_maxevent          !Max number of events to process
      integer mcp_maxprint          !Max number of events to print
      logical mcp_batch             !TRUE ==> batch
c                                    !FALSE==> interactive (default)

      common/mcp_params1/
     *  mcp_lwrite,
     *  mcp_exit,
     *  mcp_pause,
     *  mcp_read_data,
     *  mcp_maxevent,
     *  mcp_maxprint,
     *  mcp_batch

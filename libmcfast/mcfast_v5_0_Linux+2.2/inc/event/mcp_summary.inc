****************************************************************************
*  Summary of events passed through mcfast
****************************************************************************
c  Modified 11/21/94 ASB added mcp_filetype for reading MCFIO output
      structure /event_status/
        integer event               !events total
        integer event_file          !events in this file
        integer sigma               !Total cross section read
      end structure

      record /event_status/ mcp_all   !All events
      record /event_status/ mcp_fltr  !Events passing filter
      record /event_status/ mcp_trig  !Events passing trigger
      integer mcp_infiles             !# sig/back input files processed
      integer mcp_filetype            ! format of file 
      logical mcp_openfile            !TRUE if sig/back file is open
      integer mcp_collisions          !# of collisions in event (sig, back)
      integer mcp_collisions_tot      !# of collisions total (sig, back)
      common/mcp_summary1/
     *  mcp_all,
     *  mcp_fltr,
     *  mcp_trig,
     *  mcp_infiles(2),
     *  mcp_filetype(2),
     *  mcp_openfile(2),
     *  mcp_collisions(2),
     *  mcp_collisions_tot(2)

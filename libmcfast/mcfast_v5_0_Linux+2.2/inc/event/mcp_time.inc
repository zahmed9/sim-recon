c   Time used by the program

      structure /time_s/
        double precision t0    !Seconds from epoch when program started
        double precision curr  !Seconds from epoch of current time
      end structure

      structure /ctime_s/
        character date*13      !Time when program started
        character time*10      !Current time
      end structure

      record /time_s/ mcp_time
      record /time_s/ mcp_cpu
      record /ctime_s/ mcp_cinit
      record /ctime_s/ mcp_ccurr

      common/mcp_time1_c/
     *  mcp_time,
     *  mcp_cpu

      common/mcp_time2_c/
     *  mcp_cinit,
     *  mcp_ccurr

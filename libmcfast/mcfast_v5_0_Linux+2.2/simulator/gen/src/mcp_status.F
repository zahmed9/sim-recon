      subroutine mcp_status(lun)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Prints status to Fortran unit lun.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_summary.inc"
#include "mcp_time.inc"
#include "dataset.inc"

c     Externals
      integer  cmd_lenstr
      external cmd_lenstr

c     Calling argument
      integer lun

c     Local variables
      integer i, leng
      real eltime, cputime, cpu_evt
      record /dataset/ new
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(lun .eq. 0) return

      call dtf_getcurrent(new, 1)     !Current dataset
      call mcp_time_set               !Set current times

      eltime  = mcp_time.curr - mcp_time.t0
      cputime = mcp_cpu.curr - mcp_cpu.t0
      if(mcp_all.event .eq. 0) then
        cpu_evt = 0.
      else
        cpu_evt = cputime / mcp_all.event
      endif

      write(lun,5000) mcp_cinit.date, mcp_cinit.time,
     *                mcp_ccurr.date, mcp_ccurr.time,
     *                eltime, cputime, cpu_evt
5000  format(/72('*')/,
     *       ' Starting time: ',2a,/
     *       ' Current time:  ',2a,/
     *       ' Elapsed time:  ',f10.1,' seconds',/
     *       ' CPU time:      ',f10.1,' seconds',/
     *       ' CPU time/evt:  ',f10.4,' seconds/evt')

      write(lun,5001) mcp_all.event, mcp_fltr.event, mcp_trig.event,
     *                mcp_all.sigma, mcp_fltr.sigma, mcp_trig.sigma
5001  format(/
     *       i15,t20,'Events total',/
     *       i15,t20,'Events passing filter',/
     *       i15,t20,'Events passing trigger',/
     *       1pg15.5,t20,'Cross section total',/
     *       1pg15.5,t20,'Cross section passing filter',/
     *       1pg15.5,t20,'Cross section passing trigger',/)

      leng = max(cmd_lenstr(new.file), 1)
      write(lun,5002) mcp_infiles(1), new.file(:leng),
     *                mcp_all.event_file, mcp_fltr.event_file,
     *                mcp_trig.event_file
5002  format(
     *       i15,t20,'Total signal files read',/
     *          t2,'Current file: ',a,//
     *       i15,t20,'Current file: Events total',/
     *       i15,t20,'Current file: Events passing filter',/
     *       i15,t20,'Current file: Events passing trigger')

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:20  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 18:07:57  garren
c add hooks to initialize user trigger code
c

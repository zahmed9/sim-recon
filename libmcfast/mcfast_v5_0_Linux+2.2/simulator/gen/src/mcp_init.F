      subroutine mcp_init

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Initialize mcfast variables.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_version.inc"
#include "mcp_files.inc"
#include "mcp_luns.inc"
#include "mcp_beams.inc"
#include "mcp_hbook.inc"
#include "mcp_ranseeds.inc"
#include "mcp_summary.inc"
#include "mcp_params.inc"
#include "stdlun.inc"

c     Local variables
      integer i
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      mcp_version = 'v5_0'

      call dtf_init       !Initialize the dataset list
      call gnr_init       !Initialize internal generation parameters
      call mcp_dbginit    !Degug and trace facility in mcfast
      call mcf_init       !Initialize MCfio commons
      call ctl_shw_init   !Initialize shower development control

      mcp_lout = 22        !Data out Fortran unit
      mcp_llpt = 23        !lpt Fortran unit

c     Stdhep unit numbers
      lnhrd = 24
      lnhwrt = 25
      lnhout = mcp_llpt
      lnhrdm(1) = 24
      lnhrdm(2) = 26

      mcp_fileout = ' '
      mcp_filegeo = ' '

      mcp_maxevent = 0
      mcp_maxprint = 0

      mcp_lwrite = .FALSE.
      mcp_exit = .FALSE.
      mcp_pause = .FALSE.
      mcp_read_data = .TRUE.      !TRUE  ==> Read data from file
                                  !FALSE ==> generate data internally
      mcp_batch = .FALSE.         !default is interactive                             

c     Default luminosity and run time
      mcp_luminst = 1.E32
      mcp_runtime = 1.E7
      mcp_lumtot = mcp_luminst * mcp_runtime
      
c     Default random seeds ... 0 means use time of day
      mcp_ranseeds(1) = 0
      mcp_ranseeds(2) = 0

      mcp_all.event = 0
      mcp_all.event_file = 0
      mcp_all.sigma = 0.

      mcp_fltr.event = 0
      mcp_fltr.event_file = 0
      mcp_fltr.sigma = 0.

      mcp_trig.event = 0
      mcp_trig.event_file = 0
      mcp_trig.sigma = 0.

      call vzero(mcp_infiles, 2)
      call vzero(mcp_collisions_tot, 2)

      call vfill(mcp_openfile, 2, .FALSE.)

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:19  eugenio
c Initial revision
c
c Revision 1.12  2000/02/24 22:15:10  bphyslib
c set version number
c
c Revision 1.11  1999/10/07  17:06:51  garren
c mcfast version v4_4
c
c Revision 1.10  1999/07/30  15:05:56  garren
c set version to v4_3
c
c Revision 1.9  1999/04/01  16:53:47  garren
c merging changes from v4_2
c
c Revision 1.8.2.1  1999/03/26  17:44:22  garren
c set version to v4_2
c
c Revision 1.8  1998/07/20  08:00:01  mcbride
c update version number in printout
c
c Revision 1.7  1997/04/11  03:47:55  mcbride
c update version number
c
c Revision 1.6  1997/04/04  18:07:52  garren
c add hooks to initialize user trigger code
c

      subroutine fctl_init

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Initialize fitting variables.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "fit_params.inc"

      save

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      fit_lkalman  = .FALSE.
      fit_ctk_diag = .FALSE.
      fit_ftk_diag = .FALSE.

      return
      end

c $ID$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:15  eugenio
c Initial revision
c
c Revision 1.3  1999/05/12 20:21:32  kutschke
c 21 files changed/added to implement ctk Kalman filter.
c
c Revision 1.2  1998/06/23  22:41:48  bphyslib
c rename routines moved from track to fitters library
c
c Revision 1.1  1998/02/13  23:08:45  kutschke
c New routine.
c
c

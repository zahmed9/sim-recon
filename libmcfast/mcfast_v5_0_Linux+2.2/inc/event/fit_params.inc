#ifndef FIT_PARAMS
#define FIT_PARAMS

c
c   -------------------------------------------------------------------
c
c   WARNING: if you change this file, also change fit_params.h
c
c   -------------------------------------------------------------------
c
c   Rob Kutschke, Jan. 10, 2000.
c
c   Parameters used to control the way tracks are fitted.
c
c

#include "const.inc"

c     If true, use the kalman filter, 
c     if false use the TRKERR style fitter.
      logical fit_lkalman

c     If true, run the ctk kalman filter diagnostics.
      logical fit_ctk_diag

c     If true, run the ftk kalman filter diagnostics.
      logical fit_ftk_diag

      common /fit_params_l/ fit_lkalman, fit_ctk_diag, fit_ftk_diag

#endif

c $ID$
c
c $Log$
c Revision 1.1  2000/06/19 19:58:36  eugenio
c Initial revision
c
c Revision 1.3  2000/01/13 04:11:41  kutschke
c Update comments.
c
c Revision 1.2  1999/05/12  20:23:59  kutschke
c 21 files changed/added to implement ctk Kalman filter.
c
c Revision 1.1  1998/02/13  23:08:55  kutschke
c New include file.
c
c

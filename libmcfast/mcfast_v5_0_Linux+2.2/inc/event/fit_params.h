#ifndef FIT_PARAMS_H
#define FIT_PARAMS_H

/*

   -------------------------------------------------------------------

   WARNING: if you change this file, also change fit_params.inc

   -------------------------------------------------------------------

   Rob Kutschke, Jan. 10, 2000.

   Parameters used to control the way tracks are fitted.

 */

#include "const.h"

extern struct fit_params_l {
  int fit_lkalman;    /* If true, use the kalman filter; else old fitter. */
  int fit_ctk_diag;   /* If true, run the ctk kalman filter diagnostics.  */
  int fit_ftk_diag;   /* If true, run the ftk kalman filter diagnostics.  */
} fit_params_l_; 

#endif

/*
 *   $Id$
 *
 *   $Log$
 *   Revision 1.1  2000/06/19 19:58:36  eugenio
 *   Initial revision
 *
 *   Revision 1.1  2000/01/13 04:11:51  kutschke
 *   New file.
 *
 *
 */

/*

   Rob Kutschke,  Oct 23, 1998.

   Control the multi-pass aspects of the ftk kalman filter.

   In      klm_control_ptr control,
   In      DFLOAT          mass,
   In      ftrack_ptr      seed_in,
   In      track_ptr       seed_out,
   Out     ftrack_ptr      f,
   Out(*)  DFLOAT          fcov[FTRACK_NPAR][FTRACK_NPAR],
   Out(*)  int             hit_out[3],
   Out(*)  DFLOAT         *chisq,
   Out     int            *icov

   (*) See note 4.

   Return values: 0     - success
                  5     - no starting values for the first pass
                  6     - automatic computation of starting values for
                          the second pass failed.  See note 5.
                  other - returned from lower level code

   Notes:   
   (1) Most of the arguments are simply passed through - see
       klm_fit_ftk_one_pass.c for their detailed description.

       The two extra arguments are both input arguments:
       seed_in  - Pointer to the starting parameters for the inwards fit.
       seed_out - pointer to the starting parameters for the outwards fit.

       If a one pass fit is requested, then the corresponding seed pointer
       must be non-NULL; the other one is ignored and may be NULL.

       In a two pass fit, the pointer to the starting parameters for the
       first pass, either inwards or outwards, must be non-NULL.  The
       pointer to the starting parameters for the second pass may be
       either NULL or non-NULL;  if they are non-NULL they will be used.
       If they are NULL then the starting parameters for the second
       pass will be the fitted track parameters from the first pass, 
       evaluated at the starting point for the second pass.

   (2) The returned arguments f, fcov and chisq are from the last pass to be
       executed.  That is, in a two pass fit, f, fcov and chisq are the 
       results of the second pass; for a one pass fit, their interpretation 
       is unambiguous.  The returned arguments icov and hits have the same
       value for both passes.

   (3) If the first pass fails then the second pass is not executed
       and the fitter returns the failure code from the first pass.

   (4) For fits which are continuations of earlier fits, the arguments
       marked with a (*) are also input arguments.

   (5) If the starting node for the second pass is not included in the
       first pass fit, then the automatic calculation of the starting
       parameters for the second pass will fail.

 */

#include <sys/types.h>
#include <stdio.h>
#include <math.h>

#include "const.h"
#include "wtrack_struct.h"
#include "ftrack_struct.h"
#include "bfield_struct.h"
#include "klm_node_struct.h"
#include "klm_control_struct.h"
#include "klm_control_internal_struct.h"

#include "util_prototypes.h"
#include "cern_prototypes.h"
#include "fitters_prototypes.h"

int klm_fit_ftk_do ( klm_control_ptr control,
                     DFLOAT          mass,
                     ftrack_ptr      seed_in,
                     ftrack_ptr      seed_out,
                     ftrack_ptr      f,
                     DFLOAT          fcov[FTRACK_NPAR][FTRACK_NPAR],
                     int             hit_out[3],
                     DFLOAT         *chisq,
                     int            *icov  ){

  /*  Internal control information; not under user control. */
  static klm_control_internal_s internal;

  /* Starting parameters for the second pass: 
   * f_restart    - the starting parameters
   * node_restart - the address of the node at which klm_fit_ftk_one_pass.c
   *                should fill f_restart.
   * set_restart  - Flag for klm_fit_ftk_one_pass.c to say if it
   *                filled f_restart; 
   *                0 = not filled
   *                1 = filled.
   */
  static ftrack_s f_restart;
  Kptr            node_restart;
  int             set_restart=0;

  int  status;

  /* Set up for and execute the first pass. */
  internal.pass = 1;
  node_restart  = NULL;

  if ( control->direction == INWARDS ||
       control->direction == IN_THEN_OUT ){

    if ( !seed_in ) return 5;
    internal.direction = INWARDS;
    ucopy_ ( seed_in, f, &FTRACK_WORD );
    if ( control->direction == IN_THEN_OUT ) 
       node_restart = control->Kp_start_out;

  }
  else{

    if ( !seed_out ) return 5;
    internal.direction = OUTWARDS;
    ucopy_ ( seed_out, f, &FTRACK_WORD );
    if ( control->direction == OUT_THEN_IN ) 
       node_restart = control->Kp_start_in;

  }

  status = klm_fit_ftk_one_pass (  control,
                                  &internal,
                                   mass,
                                   node_restart,
                                   f,
                                   fcov,
                                   hit_out,
                                   chisq,
                                   icov,
                                   &f_restart,
                                   &set_restart);

  /* Check if there needs to be a second pass. */
  if ( control->direction == INWARDS  ||
       control->direction == OUTWARDS ||
       status   ) return status;

  /* Set up for and exectute the second pass. */
  internal.pass = 2;
  if ( control->direction == IN_THEN_OUT ){
    internal.direction = OUTWARDS;
    if ( seed_out ){
      ucopy_ ( seed_out, f, &FTRACK_WORD );
    }else{
      if ( set_restart == 0 ) return 6;
      ucopy_ ( &f_restart, f, &FTRACK_WORD );
    }
  }
  else{
    internal.direction = INWARDS;
    if ( seed_in ){
      ucopy_ ( seed_in, f, &FTRACK_WORD );
    }else{
      if ( set_restart == 0 ) return 6;
      ucopy_ ( &f_restart, f, &FTRACK_WORD );
    }
  }
  node_restart = NULL;

  status = klm_fit_ftk_one_pass (  control,
                                  &internal,
                                   mass,
                                   node_restart,
                                   f,
                                   fcov,
                                   hit_out,
                                   chisq,
                                   icov,
                                  &f_restart,
                                  &set_restart);

  return status;

}


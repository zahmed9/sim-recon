/*

   Rob Kutschke,  Oct 23, 1998.

   Execute one pass of the Kalman filter on the information pointed to by
   the user control control block and by the internal control block.

   If requested, do the setup for computation of residuals on pass1
   and compute residuals on pass2.

   There are also two additional entry points, which get and set the 
   starting values of the parameter errors.

   Among other things the control blocks point to a doubly linked
   list of nodes, which in turn point to the descriptions of the
   scattering material and measurements.  The content of a node is
   described in:
   $MCFAST_DIR/inc/event/klm_node_struct.h


   Arguments:

   In       klm_control_ptr          control          - User control block.
   In       klm_control_internal_ptr internal         - Internal controls.
   In       DFLOAT                   mass             - Mass.
   In       Kptr                     node_restart     - See note (5).
   In/Out   ftrack_ptr               f                - See notes (1) and (2).
   In/Out   DFLOAT                   fcov[MPAR][MPAR] - See note(2).
   In/Out   int                      hit_out[3]       - See note(2).
   In/Out   DFLOAT                  *chisq            - See note(2).
   Out      int                      icov             - See note(3).
   Out      ftrack_ptr               f_restart        - See note(5).
   Out      int                     *set_restart      - See note(5).

   Return:
              0 ==> all OK
              1 ==> fit failed

   Notes:
   (1) The starting value of the track parameters is
       input via the argument f.  On output this contains the final
       values of the track parameters.

   (2) This routine can either add hits onto a pre-existing fit or perform
       a fit from scratch.
       (a) Fit from scratch:
           The covariance matrix is initialized and the hit counts and
           chisq are zeroed.
       (b) Add to existing fit:
           The covariance matrix, hit counts and chisq are not cleared
           at the start of the fit.  The are modified as the fit
           proceeds.

   (3) This variable tells whether or not the momentum of the track
       was measured. ( It does not say how well the momentum was measured. )
       It is computed as follows:
       (a) Assume that the caller as specified a minimum number
           of hits which is greater than or equal to the number of
           degrees of freedom in the fit.
       (b) If there is at least one hit inside a magnetic field,
           then the momentum has been measured.
       (c) If there are hits only in field free regions but there
           are regions of field between the hits, then the momentum
           has been measured.
       If the caller is continuing a previous fit, then this algorithm
       may fail - it only knows about each subset of the hits independently,
       not as a whole.

   (4) There are some subtleties about how to look up the magnetic field.
       Properly speaking the magnetic field is a property of the step
       between two nodes; it is not a property of either node.
       However the "node" representation of the trajectory does not
       explicitly represent the steps, just the end points of the steps.
       So the following convention is used.  When stepping between two
       points, A and B, find out which of A and B is the closer to the
       beginning of the track.  Then use the magnetic field associated
       with the point which is nearer the beginning.  This will duplicate 
       the trajectory followed by the tracing step of MCfast.

   (5) If the current node is the node pointed to by node_restart, then
       the value of the fit at this point will be saved into the 
       ftrack pointed to by f_restart.  This allows the caller to
       automagically get the starting parameters for the second pass
       of a 2 pass fit.  If the code fills f_restart, then
       set_restart is set to 1.

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

/* Starting value of the covariance matrix. */
#define SIG_INIT 1.
#define BIG SIG_INIT*SIG_INIT
#define SMALL  1.e-15
static DFLOAT fcov_init[FTRACK_NPAR][FTRACK_NPAR] = 
                                     { BIG,  0.,  0.,  0.,  0.,
					0., BIG,  0.,  0.,  0.,
					0.,  0., BIG,  0.,  0.,
					0.,  0.,  0., BIG,  0.,
					0.,  0.,  0.,  0., BIG };

int klm_fit_ftk_one_pass ( klm_control_ptr    control,
                           klm_control_internal_ptr internal,
                           DFLOAT             mass,
			   Kptr               node_restart,
                           ftrack_ptr         f,
                           DFLOAT             fcov[FTRACK_NPAR][FTRACK_NPAR],
                           int                hit_out[3],
                           DFLOAT            *chisq,
                           int               *icov,
			   ftrack_ptr         f_restart,
                           int               *set_restart ){


  /* Some of the variables used to compute icov.  See note (3), above. */
#define max_b_zone 20
  static int hits_in_b_zone[max_b_zone] ={0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
					0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

  /*  Linearized correction to track parameters. 
      The main job of this function is to compute df and to then
      add it to f.
   */
  DFLOAT df[FTRACK_NPAR] = {0., 0., 0., 0., 0.};
  static const int df_size = FTRACK_NPAR * FLOAT_WORD;

  /* Pointer to trace point information for the current node. */
  trace_s   *Tp;

  /* Pointer to hit information for the current node. */
  hit_trk_s *Hp;

  /* Pointer to the smoothed information.*/
  Sptr Sp;

  /* Point at which to stop the fit, if not the end of the list. */
  Kptr Kp_stop;

  /* Magnetic field at the current node. */
  bFieldStruct *bf;

  /* Some hit accounting at this trace point. */
  static int hit_list[3];

  /* Skip the energy loss and scattering on the first point.  This useful
     for debugging and does not make any real difference to the output.
 */
  int first_point = TRUE;

  /* The chi-squared contribution of this hit. */
  DFLOAT dchisq;

  /* Should we update the seed track. */
  int update = FALSE;

  /* Criteria for starting the update:
     We require a minimum number of hits and that the
     relative error on alpha is better than 10%.
     The quantity defined below is the threshold for the square of the
     relative error.
  */
#define alpha_stable_update    0.01

  /*#define min_hits_update       20 */
#define min_hits_update       20

  /*  Sign of energy loss correction. */
  DFLOAT gain_loss;

  /* More variables used to compute icov.  See note (3), above. */
  int b_zone   = -1;
  int dev_last = -1;
  int n_zone   =  0;

  /* Arc length moved during transport. */
  DFLOAT s3d;

  /* Loop dummies, temporaries etc. */
  Kptr   Kp;
  int    i, status;
  ftrack_s f_tmp;

  /* Initialize if requested. */
  if ( control->fresh_start){
    ucopy_ ( fcov_init, fcov, &FTRACK_COV_SIZE);
    *chisq     = 0.;
    hit_out[0] = 0;
    hit_out[1] = 0;
    hit_out[2] = 0;
    *icov      = 2;
  }
  *set_restart = 0;

  /* Set starting and stopping points.  */
  if ( internal->direction == INWARDS ){
    Kp      = control->Kp_start_in;
    Kp_stop = control->Kp_stop_in;
  }
  else{
    Kp      = control->Kp_start_out;
    Kp_stop = control->Kp_stop_out;
  }

  /* Loop over all hits. */
  for ( ; Kp; Kp = (internal->direction == INWARDS) ? Kp->prev : Kp->next ){

    Tp = Kp->tp;
    Hp = Kp->hp;
    Sp = Kp->sp;

    /* Find the B field for this step.  See note (4).*/
    if ( internal->direction == INWARDS ){
      bf = Kp->bf;
    }
    else{
      if ( Kp->prev ){
        bf = Kp->prev->bf;
      }
      else{
	bf = Kp->bf;
      }
    }

    /* Keep track of different bfield regions for icov computation. */
    if ( bf->devnum != dev_last ){
       b_zone++;
       if ( b_zone >= max_b_zone ) b_zone = max_b_zone - 1;
       dev_last = bf->devnum;
    }

    /* Transport to the next intersection. */
    status = move_ftk_df_zplane_cov_( f, df, fcov, 
                                     &Tp->w.z, bf, f, df, fcov, &s3d);
    if ( status != 0 ) return 1;

    /* On second pass, smooth the fit. */
    if ( internal->pass == 2 && Sp ){
      ftk_add_delta_ ( f, df, &f_tmp );
      Sp->error = klm_ftk_smooth ( &Sp->f, Sp->fcov, &f_tmp, fcov, 
                                   &Sp->f, Sp->fcov);

      if ( Hp && Sp->error == 0 ) Sp->error = klm_ftk_residual ( control, Kp );
    }

    /* If material, look after multiple scattering and energy loss. */
    if ( !first_point ){
      if( Tp->radl != 0. && control->scat ){
	ftk_mscat_cov_ ( f, fcov, &mass, &Tp->radl, Tp->eta, fcov);
      }

      if ( fabs(Tp->dedx) != 0. && control->dedx){
        gain_loss = ( internal->direction == INWARDS ) ? -1. : 1.;
	status    = ftk_dedx_cov_( f, fcov, &mass, &Tp->dedx, Tp->eta, 
                                   &gain_loss );
        if ( status ) return 1;
      }
    }

    /* On first pass, save fit status with hit not in fit. */
    if ( internal->pass == 1 && Sp && !control->hit_in_fit){
       ftk_add_delta_ ( f, df, &Sp->f );
       ucopy_ ( fcov, Sp->fcov, &(FTRACK_COV_SIZE)); 
    }

    /* Add information from the measurement. */
    if ( Hp && !Kp->exclude_hit ) {
      status = klm_addhit_ftk_cov_( f, df, fcov, Hp, bf, 
                                    hit_list, df, fcov, &dchisq);
      if(status) return 1;

      *chisq      += dchisq;
      hit_out[0]  += hit_list[0];
      hit_out[1]  += hit_list[1];
      hit_out[2]  += hit_list[2];

      if( *icov == 2 ){
	if( bf->bmag != 0. ) *icov = 1;
        hits_in_b_zone[b_zone]++;
      }

    }

    /* Test to start update. */
    if ( !update && 
         hit_out[0] >= min_hits_update &&
         fcov[0][0] >  0. ) {

      if ( fcov[0][0] < alpha_stable_update*f->alpha*f->alpha )
	 update = TRUE;

    }

    /* Update seed parameters. */
    if ( update ){
       status = ftk_add_delta_( f, df, f );
       vzero_ ( df, &df_size );
    }

    /* On first pass, save fit status with hit in fit. */
    if ( internal->pass == 1 && Sp && control->hit_in_fit){
       ftk_add_delta_ ( f, df, &Sp->f );
       ucopy_ ( fcov, Sp->fcov, &FTRACK_COV_SIZE);
    }

    /* If this is the restart point, then save the restart parameters. */
    if ( Kp == node_restart && f_restart ){
      ftk_add_delta_ ( f, df, f_restart );
      *set_restart = 1;
    }

    /* Check for early exit. */
    if ( Kp == Kp_stop ) break;

    /* Enable transport etc */
    first_point = FALSE;

  }

  /* Final update. */
  if ( !update ) status = ftk_add_delta_ ( f, df, f );

  /* Check for case 3(c). */
  if ( *icov == 2 ){
    for (i=0; i<=b_zone; i++){
      if ( hits_in_b_zone[i] > 0 ) n_zone++;
    }
    if ( n_zone > 1 ) *icov = 1;
  }

  return 0;

}

/* 
   Entry point to return the starting values of the parameter
   errors.
*/
void klm_get_start_param_errors_ ( double v[5] ){

  v[0] = sqrt(fcov_init[0][0]);
  v[1] = sqrt(fcov_init[1][1]);
  v[2] = sqrt(fcov_init[2][2]);
  v[3] = sqrt(fcov_init[3][3]);
  v[4] = sqrt(fcov_init[4][4]);

}

void klm_set_start_param_errors_ ( double v[5] ){
  fcov_init[0][0] = v[0]*v[0];
  fcov_init[1][1] = v[1]*v[1];
  fcov_init[2][2] = v[2]*v[2];
  fcov_init[3][3] = v[3]*v[3];
  fcov_init[4][4] = v[4]*v[4];
}

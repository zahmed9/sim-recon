/*

   This is the routine which communicates between the MCFast fortran
   commons and the Kalman filter.   This routine takes the
   trace information for track number "hep" and formats the information
   for the Kalman filter; it then fits the track using the ftrack
   parameterization.  The output is stored back into the fortran commons.

   Inputs:
   hep        integer variable
              Hep track number

   Outputs:   Fills a slot in each of the common blocks
              offline_track.h and track_forward.h.

   Return:
              0 ==> all OK.
              1 ==> one or both of the output track lists overflowed.
              2 ==> fit failed.
              3 ==> not enough hits to do the fit.
              4 ==> No trace points on the track.

   Some details:
   The job of this routine is to build all of the inputs to 
   klm_fit_ftk_do_ and then to call that routine.  See the
   comments in that routine for details.  The only serious trick
   to watch for is that the f argument is both input and output.
   On input it contains the starting values of the track parameters
   and on output it contains the final values of the track parameters
   from the second pass of the fit.

   None of the routines below this one use any of the MCFast commons.  
   Therefore the routines below this one can be used as a standalone
   Kalman filter.

   This routine does all of the work necessary to set up the fitter
   to run with any of the four possible direction flags.  The extra
   time spent in this work is rather small - the loop which computes
   first_hit and the if blocks which set up the starting parameters
   for the two directions.  So I have kept everything in place rather
   to serve as a complete example.
   
   The fitter nodes a doubly-linked list; they are allocated as a 
   contiguous array simply because we happen to know the correct length
   in advance and because it is convenient.  Feel free to write
   a good list handler with insert/delete functions.

   There is some crude memory management to ensure that the various arrys 
   are long enough to hold the longest track so far encountered.  The
   arrays never shrink in an attempt to reclaim space.

 */

#include <sys/types.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

#include "const.h"
#include "stdhep.h"

#include "fit_params.h"

#include "bfield_struct.h"
#include "klm_node_struct.h"
#include "klm_control_struct.h"

#include "vtxhep.h"
#include "hep_point.h"
#include "hep_trace.h"
#include "prim_vertex.h"
#include "trace_types.h"
#include "track_minhit.h"
#include "trace_params.h"

#include "trace.h"
#include "hit_track.h"
#include "offline_track.h"
#include "track_forward.h"

#include "util_prototypes.h"
#include "cern_prototypes.h"
#include "fitters_prototypes.h"
#include "general_prototypes.h"

int klm_fit_ftk_ ( int *hep){

  /* Number of trace points on the track. */
  int num_trace;

  /* Number of hits on the track. */
  int nhit = 0;

  /* Control block for the fitter. */
  static klm_control_s control;

  /* Pointer to the start of an array to hold the fitter nodes. */
  static Kptr Kp_first = NULL;

  /* Number of entries currently allocated in the Kptr array.*/
  static int nodes_allocated = 0;

  /* The next three arrays also have the size of nodes_allocated. */
  
  /* Pointer to an array to hold the magnetic field for the
     outward step from each point.  */
  static bFieldStruct *Bf = NULL;

  /* Used for sorting trace points by path length. */
  static float *paths      = NULL;
  static int   *index_path = NULL;

  /* When space is allocated for the node list and other arrays, some 
     extra space is allocated. This is done to minimize the amount of 
     free/malloc thrashing. */
#define ALLOC_EXTRA 50

  /* Pointer to start of an array to hold the output of the smoother. */
  static Sptr Sp_first = NULL;

  /* Number of entries currently allocated in this array. */
  static int smooth_allocated = 0;

  /* Indices in index_path for the first and last hits on the track. */
  int first_hit = 0;
  int last_hit  = 0;

  /* Adjust hep index for c vs fortran numbering. */
  int hepm1 = *hep-1;

  /* Pointer to first entry in the trace list for this track. */
  trace_s *Tp_first_trace;

  /* Pointer to first entry in the hit list for this track. */
  hit_trk_s *Hp_first_hit;

  /* Pointer to hit information for this trace point. */
  hit_trk_s *Hp;

  /* Pointer to the smoothed information block for this point. */
  Sptr Sp;

  /* Pointers to output for f and w representations. */
  Track_forward_p Fp;
  Offline_track_p Wp;

  /* Seed values of track parameters for the two passes. */
  static ftrack_s seed_in, seed_out;

  /* Generated track parameters; used in diagnostics only. */
  static wtrack_s w_gen;

  /* Should we fill the diagnostic histograms for the residuals. */
  int fill_res;

  /* Loop dummies etc. */
  trace_s *Tp;
  Kptr     Kp;
  Kptr     prev = NULL;
  int      i, first_trace, error;

  /*-----------------------------------------------------------------------*/

  /* Is there room for the output? */
  if ( trk_off_c_.trk_off_num >= TRK_OFF_MAX ) return 1;
  if ( trf_par_c_.trf_num     >= MAX_TRF     ) return 1;

  /* Pointers to next free slots in the ouptut lists. */
  Wp = &trk_off_c_.trk_off[trk_off_c_.trk_off_num];
  Fp = &trf_par_c_.trf_par[trf_par_c_.trf_num];

  /* Get # of trace points and pointer to the first one. */
  num_trace       = hep_trace_c_.hep_trace[hepm1].ntrace;
  first_trace     = hep_trace_c_.hep_trace[hepm1].first_trace-1;

  if ( first_trace > -1 && num_trace > 0 ){
    Tp_first_trace  = &(trace_par_c_.trace_par[first_trace]);
  }
  else{
    return 4;
  }

  /* Pointer to the first hit in the hit list. */
  i = hep_trace_c_.hep_trace[hepm1].first_hit-1;
  if ( i > -1 ){
    Hp_first_hit = &hit_trk_c_.hit_trk[i];
  }

  /* Allocate space for node list etc. */
  if ( num_trace > nodes_allocated ){

    nodes_allocated = num_trace + ALLOC_EXTRA;

    if ( Kp_first ) free(Kp_first);
    Kp_first   = (Kptr) malloc (sizeof(klm_node_s)*nodes_allocated);

    if ( Bf ) free(Bf);
    Bf  = ( bFieldStruct* ) malloc (sizeof(bFieldStruct)*nodes_allocated);

    if ( paths ) free(paths);
    paths = ( float * ) malloc ( sizeof(float)*nodes_allocated);

    if ( index_path ) free(index_path);
    index_path = ( int * ) malloc ( sizeof(int)*nodes_allocated);

  }

  /* Check min number of hits. */
  Tp = Tp_first_trace;
  for (i=0; i<num_trace; i++){
    paths[i] = Tp->path;
    if ( Tp->hit > 0 ) nhit++;
    Tp++;
  }
  if( nhit < trk_minhit1_.trk_minhit.all || nhit == 0) return 3;

  /* Sort trace points by path length. */
  sortup_float_(paths, index_path, &num_trace);

  /* Find last hit. */
  for (i=num_trace-1; i >= 0; i--){
      Tp = Tp_first_trace + index_path[i]-1;
      if ( Tp->hit > 0 ){
          last_hit = i;
          break;
      }
  }
  if ( last_hit == 0 ) return 3;

  /* Find first hit. */
  for (i=0; i <num_trace ; i++){
      Tp = Tp_first_trace + index_path[i]-1;
      if ( Tp->hit > 0 ){
          first_hit = i;
          break;
      }
  }
  if ( first_hit == 0 ) return 3;

  /* Setup the fitter control structure; part 1. */
  control.num_nodes    = num_trace;
  control.nhit         = nhit;
  control.direction    = INWARDS;
  control.smooth       = FALSE;
  control.residuals    = FALSE; 
  control.hit_in_fit   = FALSE;
  control.fresh_start  = TRUE;
  control.hep          = *hep;
  control.scat         = (trace_params1_.trk_lscat == FTN_TRUE);
  control.dedx         = (trace_params1_.trk_ldedx == FTN_TRUE);

  /* If diagnostics are requested, then compute extra info. */
  if ( fit_params_l_.fit_ftk_diag == FTN_TRUE ){
    control.direction    = OUT_THEN_IN;
    control.smooth       = TRUE;
    control.residuals    = TRUE; 
  }

  /* Allocate space for smoothed information and residuals. */
  if ( control.smooth ){
    if ( nhit > smooth_allocated ) {
      smooth_allocated = nhit + ALLOC_EXTRA;

      if ( Sp_first ) free(Sp_first);
      Sp_first = (Sptr) malloc (sizeof(klm_smooth_s)*(smooth_allocated));   
    }
  }
  
  /* Build the list of nodes. */
  Kp = Kp_first;
  Sp = Sp_first;
  for ( i=0; i <= last_hit; i++){

      Tp = Tp_first_trace + index_path[i]-1;
      if ( Tp->hit > 0 ){
	Hp = &hit_trk_c_.hit_trk[Tp->hit-1];
      }
      else{
        Hp = NULL;
      }

      trk_next_bfield_ ( &Tp->w, &Bf[i]);

      Kp[i].tp          = Tp;
      Kp[i].hp          = Hp;
      Kp[i].sp          = (Hp && control.smooth ) ? Sp++: NULL;
      Kp[i].bf          = &Bf[i];
      Kp[i].num         = i;
      Kp[i].origin      = KF_ORIGIN_MCFAST;
      Kp[i].exclude_hit = FALSE;

      if ( i < last_hit ) Kp[i].next = &Kp[i+1];
      if ( i >    0     ) Kp[i].prev = &Kp[i-1];

  }
  Kp[last_hit].next = NULL;
  Kp[0].prev        = NULL;

  /* Finish setup of the fitter control structure. */
  control.Kp_start_in  = &Kp[last_hit];
  control.Kp_stop_in   = &Kp[0];
  control.Kp_start_out = &Kp[first_hit];
  control.Kp_stop_out  = &Kp[last_hit];

  /* Get starting parameters for the inwards pass. */
  if ( control.direction != OUTWARDS ) {
    error = cvt_wtk_ftk_(&control.Kp_start_in->tp->w,  &seed_in);
    if ( error ) return 2;
  }

  /* Get the starting parameters for the second pass. */
  if ( control.direction != INWARDS ){
    error = cvt_wtk_ftk_(&control.Kp_start_out->tp->w, &seed_out);
    if ( error ) return 2;
  }

  /* Do the fit. */
  Wp->mass = hepevt_.phep[hepm1][4];
  error = klm_fit_ftk_do ( &control,
                            Wp->mass,
                           &seed_in,
                           &seed_out, 
			   &Fp->f,
                            Fp->cov,
                           &Wp->nhit, 
                           &Wp->chisq, 
                           &Wp->icov  );

  /* Fitter diagnostics. */
  if ( fit_params_l_.fit_ftk_diag == FTN_TRUE ) {
    hep_to_w_(hep, &w_gen);
    fill_res = ( control.smooth && control.residuals ) ? 1 : 0;
    klm_ftk_diag_ ( &error,
                    &w_gen,
                    &Fp->f,
                     Fp->cov,
                    &Wp->chisq,
		    &Wp->nhit,
                    &Wp->icov,
		    &fill_res,
                     control.Kp_stop_in );
  }

  /* Return if the fitter failed. */
  if ( error ) return 2;

  /* Abort on bad covariance matrix.*/
  if ( Fp->cov[0][0] <= 0. ) return 2;
  if ( Fp->cov[1][1] <= 0. ) return 2;
  if ( Fp->cov[2][2] <= 0. ) return 2;
  if ( Fp->cov[3][3] <= 0. ) return 2;
  if ( Fp->cov[4][4] <= 0. ) return 2;

  /* Fill the wtrack version of the output. */
  error = cvt_ftk_wtk_  ( &Fp->f, &Wp->mass, &Wp->w );
  if ( error ) return 2;
  error = fcov_to_wcov_ ( &Fp->f, Fp->cov, &Wp->w, Wp->cov );
  if ( error ) return 2;

  /* Abort on bad covariance matrix.*/
  if ( Wp->cov[0][0] <= 0. ) return 2;
  if ( Wp->cov[1][1] <= 0. ) return 2;
  if ( Wp->cov[2][2] <= 0. ) return 2;
  if ( Wp->cov[3][3] <= 0. ) return 2;
  if ( Wp->cov[4][4] <= 0. ) return 2;
  if ( Wp->cov[5][5] <= 0. ) return 2;

  /* Increment track counters in output arrays. */
  trk_off_c_.trk_off_num++;
  trf_par_c_.trf_num++;

  /* Fill in the remaining output information. */
  Wp->hep  = *hep;
  Fp->icov = Wp->icov;
  Fp->mass = Wp->mass;
  Fp->ihep = *hep;
  hep_point_.hep_off[hepm1] = trk_off_c_.trk_off_num;
  hep_point_.hep_for[hepm1] = trf_par_c_.trf_num;

  /* Normal return. */
  return 0;

}

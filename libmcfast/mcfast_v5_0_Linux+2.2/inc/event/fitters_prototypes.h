#ifndef FITTERS_PROTOTYPES_H
#define FITTERS_PROTOTYPES_H

/* 
 * Prototypes for some of the functions $MCFAST_DIR/simulator/fitters/src.
 *
*/

#include "const.h"
#include "ftrack_struct.h"
#include "klm_node_struct.h"
#include "klm_control_struct.h"
#include "klm_control_internal_struct.h"

void klm_ftk_diag_ (  int             *fit_status,
		      wtrack_ptr       w_gen,
		      ftrack_ptr       f,
                      DFLOAT           fcov[FTRACK_NPAR][FTRACK_NPAR],
                      DFLOAT          *chisq,
		      int              hits[3],
		      int             *icov,
		      int             *fill_res,
                      Kptr             Kp );

void klm_ftk_res_diag_ ( int  *id_err, 
                         int  *id, 
                         Kptr  Kp  );


int klm_ftk_residual ( klm_control_ptr control,
                       Kptr            Kp );


int klm_addhit_ftk_cov_ ( ftrack_ptr    f, 
                          DFLOAT       *df1, 
                          DFLOAT        fcov1[FTRACK_NPAR][FTRACK_NPAR],
                          hit_trk_s    *hit,
                          bFieldStruct *bf,
                          int           hit_types[3],
                          DFLOAT       *df2, 
                          DFLOAT        fcov2[FTRACK_NPAR][FTRACK_NPAR],
                          DFLOAT       *chisq);

int trk_next_bfield_ ( wtrack_s *w, bFieldStruct *bf);

int klm_fit_ftk_do ( klm_control_ptr control,
                     DFLOAT          mass,
                     ftrack_ptr      seed_in,
                     ftrack_ptr      seed_out,
                     ftrack_ptr      f,
                     DFLOAT          fcov[FTRACK_NPAR][FTRACK_NPAR],
                     int             hit_out[3],
                     DFLOAT         *chisq,
                     int            *icov );

int klm_fit_ftk_one_pass ( klm_control_ptr          control,
                           klm_control_internal_ptr internal,
                           DFLOAT                   mass,
			   Kptr                     node_restart,
                           ftrack_ptr               f,
                           DFLOAT             fcov[FTRACK_NPAR][FTRACK_NPAR],
                           int                      hit_out[3],
                           DFLOAT                  *chisq,
                           int                     *icov,
                           ftrack_ptr               f_restart,
                           int                     *set_restart);

void klm_set_start_param_errors_ ( double v[5] );

void klm_get_start_param_errors_ ( double v[5] );

int klm_ftk_smooth ( ftrack_ptr  f1,                          
                     DFLOAT      v1[FTRACK_NPAR][FTRACK_NPAR],
                     ftrack_ptr  f2,
                     DFLOAT      v2[FTRACK_NPAR][FTRACK_NPAR],
                     ftrack_ptr  f,
                     DFLOAT      v[FTRACK_NPAR][FTRACK_NPAR]);


#endif

#ifndef UTIL_PROTOTYPES_H
#define UTIL_PROTOTYPES_H

#include "wtrack_struct.h"
#include "ftrack_struct.h"
#include "bfield_struct.h"

/* 
 * Prototypes for some of the  functions in $MCFAST_DIR/simulator/util/src.
 *
 * Section 1: Simple kinematics functions and error propagation functions.
 * 
*/

double beta_d_  ( double p[4] );

double beta_gamma_d_ ( double p[4] );

double cos_d_( double p[3] );

double eta_d_(double p[3] );

double pt_d_( double p[3] );

double v3mag_d_ ( double p[3] );

double v4mag_d_ ( double p[4] );

double proper_decay_time_ ( double p[4], double *d );

/* Section 2:  moves, representation conversions, derivatives etc */

logical check_cov_ ( DFLOAT fcov[FTRACK_NPAR][FTRACK_NPAR] );

int cvt_wtk_ftk_ (wtrack_ptr w, ftrack_ptr f);

int cvt_ftk_wtk_ (ftrack_ptr f, double *mass, wtrack_ptr w);


DFLOAT dedx_loss_ ( DFLOAT *p,
                    DFLOAT *xmas,
                    DFLOAT *dedxmn );

int fcov_to_wcov_ (ftrack_ptr f, 
                   double     fcov[FTRACK_NPAR][FTRACK_NPAR],
                   wtrack_ptr w, 
                   double     wcov[7][7]);
			    		          
int ftk_add_delta_ ( ftrack_ptr f_in,
                     DFLOAT     df[FTRACK_NPAR],
                     ftrack_ptr f_out );

int ftk_dedx_cov_  ( ftrack_ptr f,
                     DFLOAT     fcov[FTRACK_NPAR][FTRACK_NPAR],
                     DFLOAT    *mass,
                     DFLOAT    *dedx,
                     DFLOAT     eta[3],
                     DFLOAT    *direction);

void ftk_mscat_cov_ ( ftrack_ptr f, 
                      DFLOAT     fcov1[FTRACK_NPAR][FTRACK_NPAR], 
                      DFLOAT    *mass,
                      DFLOAT    *radl, 
                      DFLOAT     eta[3], 
                      DFLOAT     fcov2[FTRACK_NPAR][FTRACK_NPAR]);

int dcalc_ftk_zpixel_( ftrack_ptr f,
                       DFLOAT    *z,
                       DFLOAT     dcalc[2],
                       DFLOAT    *s3d);

int dcalc_ftk_zpixel_drv_( ftrack_ptr f,
                           DFLOAT     derv[2][FTRACK_NPAR]);

int dcalc_ftk_zplane_drv_( ftrack_ptr f, 
                          DFLOAT      eta[3],
                          DFLOAT      derv[FTRACK_NPAR]);

int invert_sym_d_ ( DFLOAT  in[FTRACK_NPAR][FTRACK_NPAR],
                    DFLOAT out[FTRACK_NPAR][FTRACK_NPAR] );

int move_ftk_df_zplane_cov_(ftrack_ptr    f1, 
                            double       *df1, 
                            double       cov1[FTRACK_NPAR][FTRACK_NPAR],
                            double       *z, 
                            bFieldStruct *bf,
			    ftrack_ptr    f2, 
                            double       *df2, 
                            double       cov2[FTRACK_NPAR][FTRACK_NPAR],
			    double       *s3d);

int move_wtk_zplane_ (wtrack_ptr    w1, 
                      double       *zs, 
                      bFieldStruct *bf,
                      wtrack_ptr    w2, 
                      double       *s3d);

int wcov_to_fcov_ (wtrack_ptr w, 
                   double     wcov[7][7], 
                   ftrack_ptr f, 
                   double     fcov[FTRACK_NPAR][FTRACK_NPAR]);

int wtk_zca_line_(int       *mode, 
                  double    *v, 
                  double     vcov[3][3], 
                  wtrack_ptr w, 
                  double     wcov[7][7], 
                  double    *z_closest, 
                  double    *err_z_closest);
     		     
#endif

/*
 *  $Id$
 *
 *  $Log$
 *  Revision 1.1  2000/06/19 19:58:38  eugenio
 *  Initial revision
 *
 *  Revision 1.3  1998/11/11 03:57:51  kutschke
 *  Declare many new functions.
 *
 * Revision 1.2  1998/09/25  03:03:35  kutschke
 * Include structure typedefs.
 *
 * Revision 1.1  1998/09/15  04:22:34  kutschke
 * New file.
 *
 *
 */

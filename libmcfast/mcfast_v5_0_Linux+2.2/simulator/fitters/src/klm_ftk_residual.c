/*

   Rob Kutschke,  Oct 23, 1998.

   Compute the residual at a given hit.

   Notes:
   (1) Not all devices are implemented.  Only those needed for experiments
       which we are currently modelling.

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
#include "devtype.h"

#include "util_prototypes.h"
#include "cern_prototypes.h"
#include "fitters_prototypes.h"

int klm_ftk_residual ( klm_control_ptr control,
                       Kptr            Kp ){

  /* Pointer to trace point information. */
  trace_s   *Tp;

  /* Pointer to hit information. */
  hit_trk_s *Hp;

  /* Pointer to per node output information. */
  Sptr Sp;

  /* The computation of the error on the residuals differs by a sign
     depending on whether or not the local hit was included in the fit. */
  DFLOAT sign;

  /* Derivatives of the measured quantity wrt track parameters. */
  static DFLOAT derv    [FTRACK_NPAR];
  static DFLOAT derv2[2][FTRACK_NPAR];

  /* Stuff. */
  int i, j, error;
  DFLOAT s3d;

  Tp = Kp->tp;
  Hp = Kp->hp;
  Sp = Kp->sp;

  /* Default status of the residual. */
  Sp->error      = TRUE;
  Sp->hit_in_fit = control->hit_in_fit;

  sign = control->hit_in_fit ? -1.0 : 1.0;

  if (  Hp->chan.devtype == jdev_pixelplane){

    error = dcalc_ftk_zpixel_(&Sp->f, &Hp->pos[2], Sp->m2, &s3d);
    if ( error ) return error;

    error = dcalc_ftk_zpixel_drv_(&Sp->f, derv2);
    if ( error ) return error;

    Sp->sm2[0][0] = 0.;
    Sp->sm2[1][0] = 0.;
    Sp->sm2[0][1] = 0.;
    Sp->sm2[1][1] = 0.;
    for ( i = 0; i<5; i++){
      for (j=0; j<5; j++){
        Sp->sm2[0][0] += derv2[0][i]*Sp->fcov[i][j]*derv2[0][j];
        Sp->sm2[1][0] += derv2[1][i]*Sp->fcov[i][j]*derv2[0][j];
        Sp->sm2[0][1] += derv2[0][i]*Sp->fcov[i][j]*derv2[1][j]; 
        Sp->sm2[1][1] += derv2[1][i]*Sp->fcov[i][j]*derv2[1][j];
      }
    }

    Sp->r2[0] = Sp->m2[0] - Hp->dpix[0];
    Sp->r2[1] = Sp->m2[1] - Hp->dpix[1];

    Sp->sr2[0][0] = Hp->dpix_cov[0][0] + sign*Sp->sm2[0][0];
    Sp->sr2[1][0] = Hp->dpix_cov[1][0] + sign*Sp->sm2[1][0];
    Sp->sr2[0][1] = Hp->dpix_cov[0][1] + sign*Sp->sm2[0][1];
    Sp->sr2[1][1] = Hp->dpix_cov[1][1] + sign*Sp->sm2[1][1];

    Sp->error     = FALSE;

  }
  else if ( Hp->chan.devtype == jdev_driftplane ||
            Hp->chan.devtype == jdev_silplane       ){

    Sp->m1 = ( Sp->f.xp-Hp->pos[0] ) * Hp->dircos[0] +
             ( Sp->f.yp-Hp->pos[1] ) * Hp->dircos[1];

    error  = dcalc_ftk_zplane_drv_(&Sp->f, Hp->dircos, derv);
    if ( error ) return error;

    Sp->sm1 = 0.;
    for ( i=0; i<5; i++){
      for (j=0; j<5; j++){
        Sp->sm1 += derv[i]*Sp->fcov[i][j]*derv[j];
      }
    }

    Sp->r1    = Sp->m1 - Hp->dmeas;
    Sp->sr1   = Hp->dmeas_sigma*Hp->dmeas_sigma + sign*Sp->sm1;

    Sp->error = FALSE;

  }

  return 0;
}

/*******************************************************************************
*									       *
* mcf_Trk_Off.c -- XDR Utility routines for the McFast Monte-Carlo	       *
*				Xdr filters for Block			       *
*									       *
* Copyright (c) 1994 Universities Research Association, Inc.		       *
* All rights reserved.							       *
* 									       *
* This material resulted from work developed under a Government Contract and   *
* is subject to the following license:  The Government retains a paid-up,      *
* nonexclusive, irrevocable worldwide license to reproduce, prepare derivative *
* works, perform publicly and display publicly by or for the Government,       *
* including the right to distribute to other Government contractors.  Neither  *
* the United States nor the United States Department of Energy, nor any of     *
* their employees, makes any warranty, express or implied, or assumes any      *
* legal liability or responsibility for the accuracy, completeness, or         *
* usefulness of any information, apparatus, product, or process disclosed, or  *
* represents that its use would not infringe privately owned rights.           *
*                                        				       *
*									       *
* Written by Paul Lebrun						       *
*									       *
*									       *
*******************************************************************************/
#include <stdio.h>
#include <string.h>
#include <sys/param.h>
#include <rpc/types.h>
#include <sys/types.h>
#include <rpc/xdr.h>
#include <limits.h>
#ifdef SUNOS
#include <floatingpoint.h>
#else /* SUNOS */
#include <float.h>
#endif /* SUNOS */
#include  <math.h>
#include <stdlib.h>
#include <time.h>
#include "mcfio_Dict.h"
#include "mcf_xdr.h"
#include "offline_track.h"
#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif


bool_t xdr_mcfast_track_offline_(XDR *xdrs, int *blockid,
 				 int *ntot, char** version)

{
/* 
** Translate the Offline track structure ( TRK1 and TRK2 COMMON blocks
**    from the MC-Fast  package to/froman XDR stream. Note that we first/last
**    translate the structure to quantities that are a bit more compact,
**    saving more than a factor of two storage. We alsa pack the stuff 
**	into arrays, to speed up the XDR filtering (at least we think we do!).
*/
    
    unsigned int nn, nnt, nntcov;
    int i,j,k;
    bool_t iret;
    float *pxv, *pyv, *pzv, *qv;
    float *massv, *covv, *xv, *yv, *zv, *jcovv, *chisq;
    int  *icvv, *ihepv, *nhit, *nhit_sil, *nhit_stereo;
    double aa, bb;

    if (xdrs->x_op == XDR_ENCODE) { 
       if (*blockid != MCFIO_OFFTRACKARRAYS) {
          fprintf (stderr, "mcf_Stdhep_xdr: Inconsistent Blockid %d \n ", 
           (*blockid));
          return FALSE;
       }
       *ntot = sizeof(int) +  40 * sizeof(float) * trk_off_c_.trk_off_num +
                              5 * sizeof(int) * trk_off_c_.trk_off_num;
       strcpy(*version, "2.00");
       } 
   iret =  ( xdr_int(xdrs, blockid) &&
     	      xdr_int(xdrs, ntot) &&
     	      xdr_string(xdrs, version, MCF_XDR_VERSION_LENGTH) &&
     	      xdr_int(xdrs, &(trk_off_c_.trk_off_num)));
   if (!iret) return iret;
   if ((xdrs->x_op == XDR_DECODE) && ( *blockid != MCFIO_OFFTRACKARRAYS) ) {
          fprintf (stderr, "mcf_Stdhep_xdr: Inconsistent Blockid %d \n ", 
           (*blockid));
          return FALSE;
     }

    nn = trk_off_c_.trk_off_num;
    pxv = (float *) malloc(sizeof(float) * nn);
    pyv = (float *) malloc(sizeof(float) * nn);
    pzv = (float *) malloc(sizeof(float) * nn);
    qv = (float *) malloc(sizeof(float) * nn);
    xv = (float *) malloc(sizeof(float) * nn);
    yv = (float *) malloc(sizeof(float) * nn);
    zv = (float *) malloc(sizeof(float) * nn);
    massv = (float *) malloc(sizeof(float) * nn);
/*
** Assume the covariance matrix is symetric. cov[i][j] = cov[j][i]
*/
    covv = (float *) malloc(sizeof(float) * nn * 28);
    chisq = (float *) malloc(sizeof(int) * nn);
    icvv = (int *) malloc(sizeof(int) * nn);
    ihepv = (int *) malloc(sizeof(int) * nn);
    nhit = (int *) malloc(sizeof(int) * nn);
    nhit_sil = (int *) malloc(sizeof(int) * nn);
    nhit_stereo = (int *) malloc(sizeof(int) * nn);
	
    if (xdrs->x_op == XDR_ENCODE) { 
	for (i=0,jcovv=covv; i<nn; i++) {
           pxv[i] = (float) trk_off_c_.trk_off[i].w.px;    
           pyv[i] =(float) trk_off_c_.trk_off[i].w.py;    
           pzv[i] =(float) trk_off_c_.trk_off[i].w.pz;    
           xv[i] = (float) trk_off_c_.trk_off[i].w.x;    
           yv[i] = (float) trk_off_c_.trk_off[i].w.y;    
           zv[i] =(float) trk_off_c_.trk_off[i].w.z;
           qv[i] = (float) trk_off_c_.trk_off[i].w.q;    
           massv[i] =(float) trk_off_c_.trk_off[i].mass;
           for (j=0; j<7; j++) {
             for(k=j; k<7; k++, jcovv++) 
               *jcovv =(float) trk_off_c_.trk_off[i].cov[j][k];
           }
           chisq[i] = (float) trk_off_c_.trk_off[i].chisq;
           nhit[i] = trk_off_c_.trk_off[i].nhit;
           nhit_sil[i] = trk_off_c_.trk_off[i].nhit_sil;
           nhit_stereo[i] = trk_off_c_.trk_off[i].nhit_stereo;
           icvv[i] = trk_off_c_.trk_off[i].icov;
           ihepv[i] = trk_off_c_.trk_off[i].hep;
      }
      nnt = nn;
      nntcov = 28 * nn;
    }         
    
    iret =  (xdr_array(xdrs,(char **)&(pxv),
                &nnt, nn , sizeof(float), xdr_float) &&
             xdr_array(xdrs,(char **)&(pyv),
                &nnt, nn , sizeof(float), xdr_float) &&
             xdr_array(xdrs,(char **)&(pzv),
                &nnt, nn , sizeof(float), xdr_float) &&
             xdr_array(xdrs,(char **)&(xv),
                &nnt, nn , sizeof(float), xdr_float) &&
             xdr_array(xdrs,(char **)&(yv),
                &nnt, nn , sizeof(float), xdr_float) &&
             xdr_array(xdrs,(char **)&(zv),
                &nnt, nn , sizeof(float), xdr_float) &&
             xdr_array(xdrs,(char **)&(qv),
                &nnt, nn , sizeof(float), xdr_float) &&
             xdr_array(xdrs,(char **)&(massv),
                &nnt, nn , sizeof(float), xdr_float) &&
             xdr_array(xdrs,(char **)&(covv),
                &nntcov, (nn*28) , sizeof(float), xdr_float) &&
             xdr_array(xdrs,(char **)&(chisq),
                &nnt, nn , sizeof(float), xdr_float) &&
             xdr_array(xdrs,(char **)&(nhit),
                &nnt, nn , sizeof(float), xdr_int) &&
             xdr_array(xdrs,(char **)&(nhit_sil),
                &nnt, nn , sizeof(float), xdr_int) &&
             xdr_array(xdrs,(char **)&(nhit_stereo),
                &nnt, nn , sizeof(float), xdr_int) &&
             xdr_array(xdrs,(char **)&(icvv),
                &nnt, nn , sizeof(float), xdr_int) &&
             xdr_array(xdrs,(char **)&(ihepv),
                &nnt, nn , sizeof(float), xdr_int) );
                
    if ((xdrs->x_op == XDR_DECODE) && (iret)) { 
	for (i=0,jcovv=covv; i<nn; i++) {
           trk_off_c_.trk_off[i].w.px = (double) pxv[i];    
           trk_off_c_.trk_off[i].w.py = (double) pyv[i];    
           trk_off_c_.trk_off[i].w.pz = (double) pzv[i];
           aa = 0.;
           aa += trk_off_c_.trk_off[i].w.px * trk_off_c_.trk_off[i].w.px;
           aa += trk_off_c_.trk_off[i].w.py * trk_off_c_.trk_off[i].w.py;
           trk_off_c_.trk_off[i].w.pt = sqrt(aa);
           aa += trk_off_c_.trk_off[i].w.pz * trk_off_c_.trk_off[i].w.pz;
           trk_off_c_.trk_off[i].w.p = sqrt(aa);
           trk_off_c_.trk_off[i].mass = massv[i];
           aa +=  trk_off_c_.trk_off[i].mass * trk_off_c_.trk_off[i].mass;
           trk_off_c_.trk_off[i].w.e = sqrt(aa);
           trk_off_c_.trk_off[i].w.q = (double) qv[i];    
           trk_off_c_.trk_off[i].w.x = (double) xv[i];    
           trk_off_c_.trk_off[i].w.y = (double) yv[i];    
           trk_off_c_.trk_off[i].w.z = (double) zv[i];    
           for (j=0; j<7; j++) {
             for(k=j; k<7; k++, jcovv++) 
              trk_off_c_.trk_off[i].cov[j][k] = (double) *jcovv;
           }
           for (j=0; j<7; j++) {
             for(k=j; k<7; k++) {
              trk_off_c_.trk_off[i].cov[k][j] = 
               trk_off_c_.trk_off[i].cov[j][k];
             }
           }
           trk_off_c_.trk_off[i].chisq = chisq[i];
           trk_off_c_.trk_off[i].nhit = nhit[i];
           trk_off_c_.trk_off[i].nhit_sil = nhit_sil[i];
           trk_off_c_.trk_off[i].nhit_stereo = nhit_stereo[i]; 
           trk_off_c_.trk_off[i].icov  = icvv[i];
           trk_off_c_.trk_off[i].hep  = ihepv[i];
      }
    }         
            	 
            	 
      free(pxv); free(pyv); free(pzv); free(qv); free(massv);
      free(xv); free(covv); free(icvv); free(nhit); free(ihepv);
      free(yv); free(zv); free(nhit_sil); free(nhit_stereo);
      free(chisq);
      return iret;
            	 
}   

bool_t xdr_mcfast_track_offlslow_(XDR *xdrs, int *blockid,
 				 int *ntot, char** version)

{
/* 
** Translate the Offline track structure ( TRK1 and TRK2 COMMON blocks
**    from the MC-Fast  package to/froman XDR stream. Note that we first/last
**    translate the structure to quantities that are a bit more compact,
**    saving more than a factor of two storage.
*/
    
    unsigned int nn, nnt;
    int i,j,k,l;
    bool_t iret;
    double aa, bb;
    float val, covv[28];
    float *jcovv;

    if (xdrs->x_op == XDR_ENCODE) { 
       if (*blockid != MCFIO_OFFTRACKSTRUCT) {
          fprintf (stderr, "mcf_Stdhep_xdr: Inconsistent Blockid %d \n ", 
           (*blockid));
          return FALSE;
       }
       *ntot = sizeof(int) +  40 * sizeof(float) * trk_off_c_.trk_off_num +
                              5 * sizeof(int) * trk_off_c_.trk_off_num;
       strcpy(*version, "2.00");
       } 
   iret =  ( xdr_int(xdrs, blockid) &&
     	      xdr_int(xdrs, ntot) &&
     	      xdr_string(xdrs, version, MCF_XDR_VERSION_LENGTH) &&
     	      xdr_int(xdrs, &(trk_off_c_.trk_off_num)));
   if (!iret) return iret;

   if ((xdrs->x_op == XDR_DECODE) && ( *blockid != MCFIO_OFFTRACKSTRUCT) ) {
          fprintf (stderr, "mcf_Stdhep_xdr: Inconsistent Blockid %d \n ", 
           (*blockid));
          return FALSE;
     }
    if (xdrs->x_op == XDR_ENCODE)    nnt = 28;
    for (i=0; i<trk_off_c_.trk_off_num; i++) {
         if (xdrs->x_op == XDR_ENCODE) {
           for(j=0,l=0; j<7; j++) {
             for(k=j; k<7; k++,l++) covv[l] = trk_off_c_.trk_off[i].cov[j][k];  
          }
         }
         if(xdrs->x_op == XDR_ENCODE) val = (float) trk_off_c_.trk_off[i].w.px;
         if (!xdr_float(xdrs,&val)) return FALSE;
         if(xdrs->x_op == XDR_DECODE) trk_off_c_.trk_off[i].w.px = (double) val;
         if(xdrs->x_op == XDR_ENCODE) val = (float) trk_off_c_.trk_off[i].w.py;
         if (!xdr_float(xdrs,&val)) return FALSE;
         if(xdrs->x_op == XDR_DECODE) trk_off_c_.trk_off[i].w.py = (double) val;
         if(xdrs->x_op == XDR_ENCODE) val = (float) trk_off_c_.trk_off[i].w.pz;
         if (!xdr_float(xdrs,&val)) return FALSE;
         if(xdrs->x_op == XDR_DECODE) trk_off_c_.trk_off[i].w.pz = (double) val;
         if(xdrs->x_op == XDR_ENCODE) val = (float) trk_off_c_.trk_off[i].w.x;
         if (!xdr_float(xdrs,&val)) return FALSE;
         if(xdrs->x_op == XDR_DECODE) trk_off_c_.trk_off[i].w.x = (double) val;
         if(xdrs->x_op == XDR_ENCODE) val = (float) trk_off_c_.trk_off[i].w.y;
         if (!xdr_float(xdrs,&val)) return FALSE;
         if(xdrs->x_op == XDR_DECODE) trk_off_c_.trk_off[i].w.y = (double) val;
         if(xdrs->x_op == XDR_ENCODE) val = (float) trk_off_c_.trk_off[i].w.z;
         if (!xdr_float(xdrs,&val)) return FALSE;
         if(xdrs->x_op == XDR_DECODE) trk_off_c_.trk_off[i].w.z = (double) val;
         if(xdrs->x_op == XDR_ENCODE) val = (float) trk_off_c_.trk_off[i].w.q;
         if (!xdr_float(xdrs,&val)) return FALSE;
         if(xdrs->x_op == XDR_DECODE) trk_off_c_.trk_off[i].w.q = (double) val;
         if(xdrs->x_op == XDR_ENCODE) val = (float) trk_off_c_.trk_off[i].mass;
         if (!xdr_float(xdrs,&val)) return FALSE;
         if(xdrs->x_op == XDR_DECODE) trk_off_c_.trk_off[i].mass = (double) val;
         jcovv = &(covv[0]);
         if (!xdr_array(xdrs,(char **) &jcovv,
                &nnt, 28 , sizeof(float), xdr_float)) return FALSE;
         if(xdrs->x_op == XDR_DECODE) trk_off_c_.trk_off[i].chisq = (double) val;
         if (!xdr_float(xdrs,&val)) return FALSE;
         if(xdrs->x_op == XDR_ENCODE) val = (float) trk_off_c_.trk_off[i].chisq;

         if(xdrs->x_op == XDR_DECODE) trk_off_c_.trk_off[i].chisq = (double) val;
         if (!xdr_float(xdrs,&val)) return FALSE;
         if(xdrs->x_op == XDR_ENCODE) val = (float) trk_off_c_.trk_off[i].chisq;
         if (!xdr_int(xdrs,&(trk_off_c_.trk_off[i].nhit))) return FALSE;
         if (!xdr_int(xdrs,&(trk_off_c_.trk_off[i].nhit_sil))) return FALSE;
         if (!xdr_int(xdrs,&(trk_off_c_.trk_off[i].nhit_stereo))) return FALSE;
         if (!xdr_int(xdrs,&(trk_off_c_.trk_off[i].icov))) return FALSE;
         if (!xdr_int(xdrs,&(trk_off_c_.trk_off[i].hep))) return FALSE;
         if (xdrs->x_op == XDR_DECODE) { 
            for(j=0,l=0; j<7; j++) {
             for(k=j; k<7; k++,l++) trk_off_c_.trk_off[i].cov[j][k] = covv[l];
             }
           aa = 0.;
           aa += trk_off_c_.trk_off[i].w.px * trk_off_c_.trk_off[i].w.px;
           aa += trk_off_c_.trk_off[i].w.py * trk_off_c_.trk_off[i].w.py;
           trk_off_c_.trk_off[i].w.pt = sqrt(aa);
           aa += trk_off_c_.trk_off[i].w.pz * trk_off_c_.trk_off[i].w.pz;
           trk_off_c_.trk_off[i].w.p = sqrt(aa);
           aa +=  trk_off_c_.trk_off[i].mass * trk_off_c_.trk_off[i].mass;
           trk_off_c_.trk_off[i].w.e = sqrt(aa);
     }
    }            
    return TRUE;              	 
}   

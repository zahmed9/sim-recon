/*******************************************************************************
*									       *
* mcf_Trace.c -- XDR Utility routines for the McFast Monte-Carlo	       *
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
* Written by Paul Lebrun for mcf_TrkOff_xdr.c                                  *
* Adapted by A. Boehnlein 						               *
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
#include "trace.h"
#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif


bool_t xdr_mcfast_trace_(XDR *xdrs, int *blockid,
 				 int *ntot, char** version)

{
/* 
** Translate the track trace structure ( trace_par_c COMMON block )
**    from the MC-Fast package to/from XDR stream. Note that we first/last
**    translate the structure to quantities that are a bit more compact,
**    saving more than a factor of two storage. We alsa pack the stuff 
**	into arrays, to speed up the XDR filtering (at least we think we do!).
*/
    
    unsigned int nn, nnt, nnteta;
    int i,j,k;
    bool_t iret;
    int *hepv, *type, *plane, *hit;
    float *pxv, *pyv, *pzv, *ev, *xv, *yv, *zv, *qv; 
    float *eta, *jeta, *path, *time, *tau;
    int *material;
    float *radl, *dedx;
    double aa, bb;

    if ((xdrs->x_op == XDR_ENCODE)|| (xdrs->x_op == XDR_MCFIOCODE)) { 
       if (*blockid != MCFIO_TRACEARRAYS) {
          fprintf (stderr, "mcf_Trace_xdr: Inconsistent Blockid %d \n ", 
           (*blockid));
          return FALSE;
       }
       *ntot = 4 * sizeof(int) + sizeof(trace_s) * trace_par_c_.trace_num;
       if (xdrs->x_op == XDR_MCFIOCODE) return TRUE;
       strcpy(*version, "2.00");
       } 
   iret =  ( xdr_int(xdrs, blockid) &&
     	      xdr_int(xdrs, ntot) &&
     	      xdr_string(xdrs, version, MCF_XDR_VERSION_LENGTH) &&
     	      xdr_int(xdrs, &(trace_par_c_.trace_num)));
   if (!iret) return iret;
   if ((xdrs->x_op == XDR_DECODE) && ( *blockid != MCFIO_TRACEARRAYS) ) {
          fprintf (stderr, "mcf_Trace_xdr: Inconsistent Blockid %d \n ", 
           (*blockid));
          return FALSE;
     }

    nn = trace_par_c_.trace_num;
    hepv = (int *) malloc(sizeof(int) * nn);
    type = (int *) malloc(sizeof(int) * nn);
    plane = (int *) malloc(sizeof(int) * nn);
    hit = (int *) malloc(sizeof(int) * nn);
    pxv = (float *) malloc(sizeof(float) * nn);
    pyv = (float *) malloc(sizeof(float) * nn);
    pzv = (float *) malloc(sizeof(float) * nn);
    ev = (float *) malloc(sizeof(float) * nn);
    xv = (float *) malloc(sizeof(float) * nn);
    yv = (float *) malloc(sizeof(float) * nn);
    zv = (float *) malloc(sizeof(float) * nn);
    qv = (float *) malloc(sizeof(float) * nn);
    eta = (float *) malloc(sizeof(int) * 3 * nn);
    path = (float *) malloc(sizeof(int) * nn);
    time = (float *) malloc(sizeof(int) * nn);
    tau = (float *) malloc(sizeof(int) * nn);
    material = (int *) malloc(sizeof(int) * nn);
    radl = (float *) malloc(sizeof(int) * nn);
    dedx = (float *) malloc(sizeof(int) * nn);
	
    if (xdrs->x_op == XDR_ENCODE) { 
	for (i=0,jeta = eta; i<nn; i++) {
	   hepv[i]  = trace_par_c_.trace_par[i].hep;
	   type[i]  = trace_par_c_.trace_par[i].type;
	   plane[i] = trace_par_c_.trace_par[i].plane;
	   hit[i]   = trace_par_c_.trace_par[i].hit;
           pxv[i]   = (float) trace_par_c_.trace_par[i].w.px;    
           pyv[i]   = (float) trace_par_c_.trace_par[i].w.py;    
           pzv[i]   = (float) trace_par_c_.trace_par[i].w.pz;    
           ev[i]    = (float) trace_par_c_.trace_par[i].w.e;    
           xv[i]    = (float) trace_par_c_.trace_par[i].w.x;    
           yv[i]    = (float) trace_par_c_.trace_par[i].w.y;    
           zv[i]    = (float) trace_par_c_.trace_par[i].w.z;
           qv[i]    = (float) trace_par_c_.trace_par[i].w.q;
           for(j=0; j<3; j++, jeta++){
              *jeta = (float) trace_par_c_.trace_par[i].eta[j];
           }    
           path[i]  =(float) trace_par_c_.trace_par[i].path;
           time[i]  = (float) trace_par_c_.trace_par[i].time;
           tau[i]   = (float) trace_par_c_.trace_par[i].tau;
           material[i] = trace_par_c_.trace_par[i].material;
           radl[i]  = (float) trace_par_c_.trace_par[i].radl;
           dedx[i]  = (float) trace_par_c_.trace_par[i].dedx;
      }
      nnt = nn;
      nnteta = 3 * nn;
    }         
    
    iret =  (xdr_array(xdrs,(char **)&(hepv),
                &nnt, nn , sizeof(float), xdr_int) &&
             xdr_array(xdrs,(char **)&(type),
                &nnt, nn , sizeof(float), xdr_int) &&
             xdr_array(xdrs,(char **)&(plane),
                &nnt, nn , sizeof(float), xdr_int) &&
             xdr_array(xdrs,(char **)&(hit),
                &nnt, nn , sizeof(float), xdr_int) &&
             xdr_array(xdrs,(char **)&(pxv),
                &nnt, nn , sizeof(float), xdr_float) &&
             xdr_array(xdrs,(char **)&(pyv),
                &nnt, nn , sizeof(float), xdr_float) &&
             xdr_array(xdrs,(char **)&(pzv),
                &nnt, nn , sizeof(float), xdr_float) &&
             xdr_array(xdrs,(char **)&(ev),
                &nnt, nn , sizeof(float), xdr_float) &&                
             xdr_array(xdrs,(char **)&(xv),
                &nnt, nn , sizeof(float), xdr_float) &&
             xdr_array(xdrs,(char **)&(yv),
                &nnt, nn , sizeof(float), xdr_float) &&
             xdr_array(xdrs,(char **)&(zv),
                &nnt, nn , sizeof(float), xdr_float) &&
             xdr_array(xdrs,(char **)&(qv),
                &nnt, nn , sizeof(float), xdr_float) &&
             xdr_array(xdrs,(char **)&(eta),
                &nnteta, (nn*3) , sizeof(float), xdr_float) &&
             xdr_array(xdrs,(char **)&(path),
                &nnt, nn , sizeof(float), xdr_float) &&             
             xdr_array(xdrs,(char **)&(time),
                &nnt, nn , sizeof(float), xdr_float) &&
             xdr_array(xdrs,(char **)&(tau),
                &nnt, nn , sizeof(float), xdr_float) &&
             xdr_array(xdrs,(char **)&(material),
                &nnt, nn , sizeof(float), xdr_int) &&
             xdr_array(xdrs,(char **)&(radl),
                &nnt, nn , sizeof(float), xdr_float) &&
             xdr_array(xdrs,(char **)&(dedx),
                &nnt, nn , sizeof(float), xdr_float)); 
                
    if ((xdrs->x_op == XDR_DECODE) && (iret)) { 
	for (i=0,jeta=eta; i<nn; i++) {
           trace_par_c_.trace_par[i].hep   = hepv[i];
           trace_par_c_.trace_par[i].type  = type[i];
           trace_par_c_.trace_par[i].plane = plane[i];
           trace_par_c_.trace_par[i].hit   = hit[i];
           trace_par_c_.trace_par[i].w.px = (double) pxv[i];    
           trace_par_c_.trace_par[i].w.py = (double) pyv[i];    
           trace_par_c_.trace_par[i].w.pz = (double) pzv[i];
           trace_par_c_.trace_par[i].w.e = (double) ev[i];
           trace_par_c_.trace_par[i].w.q = (double) qv[i];    
           trace_par_c_.trace_par[i].w.x = (double) xv[i];    
           trace_par_c_.trace_par[i].w.y = (double) yv[i];    
           trace_par_c_.trace_par[i].w.z = (double) zv[i];    
           trace_par_c_.trace_par[i].w.q = (double) qv[i];    
           for (j=0; j<3; j++,jeta++) {
              trace_par_c_.trace_par[i].eta[j] = (double) *jeta;
           }
           trace_par_c_.trace_par[i].path = (double) path[i];
           trace_par_c_.trace_par[i].time = (double) time[i];
           trace_par_c_.trace_par[i].tau  = (double) tau[i];
           trace_par_c_.trace_par[i].material= material[i];
           trace_par_c_.trace_par[i].radl = (double) radl[i];
           trace_par_c_.trace_par[i].dedx = (double) dedx[i];           
/*Fill P and Pt from stored variables*/
           aa = 0.;
           aa += trace_par_c_.trace_par[i].w.px * trace_par_c_.trace_par[i].w.px;
           aa += trace_par_c_.trace_par[i].w.py * trace_par_c_.trace_par[i].w.py;
           trace_par_c_.trace_par[i].w.pt = sqrt(aa);
           aa += trace_par_c_.trace_par[i].w.pz * trace_par_c_.trace_par[i].w.pz;
           trace_par_c_.trace_par[i].w.p = sqrt(aa);
      }
    }         
            	 
            	 
      free(hepv); free(type); free(plane); free(hit);
      free(pxv); free(pyv); free(pzv); free(qv); free(ev);
      free(xv); free(yv); free(zv);
      free(eta); free(path); free(time); free(tau);
      free(material); free(radl); free(dedx);
      return iret;
            	 
}   

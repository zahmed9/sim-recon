/*
** Module to read/write  the calorimetry hits in McFast. 
**
**	Paul Lebrun. July 1996.
*/
#include <stdio.h>
#include <string.h>
#include <sys/param.h>
#include <rpc/types.h>
#include <sys/types.h>
#include <rpc/xdr.h>
#include <errno.h>
#include <math.h>
#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif
#ifndef MCF_XDR_VERSION_LENGTH
#define MCF_XDR_VERSION_LENGTH 4 /* This is not a clean thing to do,  to 
						be corrected in mcfio.h */ 
#endif                             
#include "cal_hit.h"
#include "mcfio.h"
#define MCFIO_CALHIT 701 /* Negotiable, I am just placing something */
bool_t xdr_cal_hits_(XDR *xdrs, int *blockid,
                                 int *ntot, char** version);
void xdrDestroy_cal_hit(cal_hit *hit);

bool_t xdr_cal_hits_(XDR *xdrs, int *blockid,
                                 int *ntot, char** version)
{
/*
** It is assumed that we encode after the showering process is 
** completed. e.g., we loop over the cal_hit array pointer up to the
** final declared number of hit has been correctly see. See Collect_shower_hits
** and/or Consolidate_cal_hits
*/
    int i,j, ical;
    u_int ui;
    cal_hit *hit;
    cal_hit_tracks *tr;
/* 
** XDR filter for Geant traces into McFast/Explorer
*/
     if ((xdrs->x_op == XDR_ENCODE))  {
       if (*blockid != MCFIO_CALHIT) {
          fprintf (stderr, ": xdr_cal_hits Inconsistent Blockid %d \n ", 
           (*blockid));
          return FALSE;
       }
       *ntot = 24 + MCFNUMCALORIMETERS*sizeof(int);
       for(ical=0; ical< MCFNUMCALORIMETERS; ical++) {
         *ntot += MCFNumHitCal[ical]* sizeof(cal_hit);
         for (i=0; i<MCFNumHitCal[ical]; i++) { 
             *ntot -= sizeof(cal_hit_tracks *);
             *ntot += MCFCalHits[ical][i]->n_tracks * sizeof(cal_hit_tracks);
         }
        }
       strcpy(*version, "1.00");
       }
       
     if      ((xdr_int(xdrs, blockid) &&
     	       xdr_int(xdrs, ntot) &&
     	       xdr_string(xdrs, version, MCF_XDR_VERSION_LENGTH)) == FALSE)
                         return FALSE;
              
     if ((xdrs->x_op == XDR_DECODE) && ( *blockid != MCFIO_CALHIT) ) {
          fprintf (stderr, "xdr_cal_hits: Inconsistent Blockid %d \n ", 
           (*blockid));
          return FALSE;
     }
     for (ical=0; ical<MCFNUMCALORIMETERS; ical++) { 
      if (!xdr_int(xdrs, &(MCFNumHitCal[ical]))) return FALSE;
      if (xdrs->x_op == XDR_DECODE) {
        /*
        ** Start by cleaning stuff from previous event, if need be 
        */
           if (MCFCalHits[ical] != NULL) {
           for(i=0; i<MCFNumHitCalAlloc[ical]; i++) 
              if( MCFCalHits[ical][i] != NULL) 
                   xdrDestroy_cal_hit(MCFCalHits[ical][i]);
                   free(MCFCalHits[ical]);
                   MCFCalHits[ical] = NULL;
           }
           if (MCFNumHitCal[ical] > 0) {        
             MCFCalHits[ical] =
              (cal_hit **) malloc(sizeof (cal_hit *) * MCFNumHitCal[ical] );
             if (MCFCalHits[ical] == NULL) return FALSE;
             MCFNumHitCalAlloc[ical]  = MCFNumHitCal[ical] ;
             for(i=0; i<MCFNumHitCal[ical]; i++) {
               MCFCalHits[ical][i] = (cal_hit *) malloc(sizeof(cal_hit));
               if (MCFCalHits[ical][i] == NULL) return FALSE;
             }
          }
      }
      for (i=0; i<MCFNumHitCal[ical]; i++) {           
         hit = MCFCalHits[ical][i];
         if (!xdr_int(xdrs,&(hit->icr2))) return FALSE;
         if (!xdr_int(xdrs,&(hit->icr1))) return FALSE;
         if (!xdr_int(xdrs,&(hit->status))) return FALSE;
         if (!xdr_int(xdrs,&(hit->n_tracks))) return FALSE;
         if (!xdr_float(xdrs,&(hit->e_mip))) return FALSE;
         if (!xdr_float(xdrs,&(hit->e_em))) return FALSE;
         if (!xdr_float(xdrs,&(hit->e_had))) return FALSE;
         if (xdrs->x_op == XDR_DECODE) 
            hit->info_tr =
              (cal_hit_tracks *) malloc(sizeof(cal_hit_tracks)*hit->n_tracks);
            if (hit->info_tr == NULL) return FALSE;
	 for (j=0, tr=hit->info_tr; j<hit->n_tracks; j++, tr++) {
	       if (!xdr_int(xdrs,&(tr->tr_num))) return FALSE;
               if (!xdr_float(xdrs,&(tr->percent_e_tot))) return FALSE;
         }
        }
       }
       return TRUE;
}
      
void xdrDestroy_cal_hit(cal_hit *hit)
{
    if (hit == NULL) return;
    if (hit->info_tr != NULL) free(hit->info_tr);
    free(hit);
} 

  

/*
** Module to define and  store  the calorimetry hits in McFast. 
**
**	Paul Lebrun. July 1996.
*/
#include <stdio.h>
#include <string.h>
#include <sys/param.h>
#include <rpc/types.h>
#include <sys/types.h>
#include <errno.h>
#include <math.h>
#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif
#include "cal_hit.h"
#define MCFNUMCALHITPREALLOC 100 
      /* the number of hits preallocated at initialization phase */
      
#define MCFMAXNUMTRACKPERCELL 500
     /* The maximum number of tracks allowing to contribut to the same 
     	cell */
     	
/*  External used, from F77 package  */

extern float get_gauss_(int *dum);
     	
 /* Global definitions */

int MCFNumHitCal[MCFNUMCALORIMETERS]; 
                   /* the total number of hit defined in the event */
int MCFNumHitCalAlloc[MCFNUMCALORIMETERS]; 
		  /* The current number of cal_hit pointers allocated below*/
cal_hit **MCFCalHits[MCFNUMCALORIMETERS];
		 /* An array of pointers to the hits for each calorimeters */
int MCFCurrentIcal; /* The current calorimeter index, defined to 
		       improve performance */
int MCFCurrentIcr1;
                /* The current coordinate-1 (x or phi) cell number 
                   in calorimeter MCFCurrentIcal */
int MCFCurrentIcr2; 
                /* The current coordinate-2 (y or eta) cell number 
                   in calorimeter MCFCurrentIcal */
 
static int extend_cal_hits(int ical);
static void compact_cal_hitlist(int ical, int iFirstStart);
static float sum_energy(cal_hit *hit);
/*
** To be called at the beginning of each McFast job. Will preallocate 
** a bunch of pointers for the calorimetry hits. Do that for all the 
** calorimeters defined for the job. (Numcal, known after geometry 
** has been initialized).  Assume that the first allocation of memory 
** will work
*/
void init_all_cal_hits_(int numCal)
{
    int i, ical;
    cal_hit *ch;
    
    for (ical=0; ical<numCal; ical++) {
       MCFCalHits[ical] =
           (cal_hit **) malloc(sizeof (cal_hit *) * MCFNUMCALHITPREALLOC);
       MCFNumHitCalAlloc[ical]  =  MCFNUMCALHITPREALLOC;
       for(i=0; i<MCFNUMCALHITPREALLOC; i++)  MCFCalHits[ical][i] = NULL;
       MCFNumHitCal[ical] = 0;
    } 
}  
/*
** To be called at the beginning of each McFast event. The routine 
** Init_all_cal_hits must have been called at least one time prior to this 
** call.  Initialization mean loosing all previous hits for this calorimeter.
*/
void init_cal_hits_(int ical)
{
    int i;

    Destroy_all_cal_hits (ical);
    if (MCFNumHitCalAlloc[ical] != MCFNUMCALHITPREALLOC) {
/*
** Clean up probably unused memory.
*/    
    free(MCFCalHits[ical]);
    MCFCalHits[ical] =
           (cal_hit **) malloc(sizeof (cal_hit *) * MCFNUMCALHITPREALLOC);
    if(MCFCalHits[ical] == NULL) {
        fprintf(stderr, 
        " From init_cal_hits, memory allocation problem! \n ");
        return;
    }
    MCFNumHitCalAlloc[ical]  =  MCFNUMCALHITPREALLOC;
    for(i=0; i<MCFNUMCALHITPREALLOC; i++)  MCFCalHits[ical][i] = NULL;
    }
    MCFCurrentIcal = -1; MCFCurrentIcr1 = -1; MCFCurrentIcr2 = -1;
}

void Destroy_cal_hit(cal_hit *hit)
{
    if (hit == NULL) return;
    if (hit->info_tr != NULL) free(hit->info_tr);
    free(hit);
} 

void Destroy_all_cal_hits(int ical)
{
   int i;
   
   for(i=0; i< MCFNumHitCal[ical]; i++) {
      if (MCFCalHits[ical][i] != NULL) 
         Destroy_cal_hit(MCFCalHits[ical][i]);
         MCFCalHits[ical][i] = NULL;
    }
    MCFNumHitCal[ical] = 0;
}

cal_hit *Create_cal_hit(int ical)
{
    if (MCFNumHitCal[ical] == MCFNumHitCalAlloc[ical]) extend_cal_hits(ical);
    MCFCalHits[ical][MCFNumHitCal[ical]] = 
       (cal_hit *) malloc(sizeof(cal_hit));
    if (MCFCalHits[ical][MCFNumHitCal[ical]] == NULL) {
        fprintf(stderr, " From Create_cal_hit, running out of memory \n");
        return NULL;
    } 
    MCFCalHits[ical][MCFNumHitCal[ical]]->status = EMPTY;
    MCFCalHits[ical][MCFNumHitCal[ical]]->n_tracks = 0;
    MCFCalHits[ical][MCFNumHitCal[ical]]->e_mip = 0.;
    MCFCalHits[ical][MCFNumHitCal[ical]]->e_em = 0.;
    MCFCalHits[ical][MCFNumHitCal[ical]]->e_had = 0.;
    MCFCalHits[ical][MCFNumHitCal[ical]]->info_tr = NULL;
    MCFNumHitCal[ical]++;
    return MCFCalHits[ical][(MCFNumHitCal[ical]-1)];
}


void Print_cal_hit( int n, cal_hit *hit)
{
/* 
** n is some kind of hit number, for mnemonic purpose 
*/
   int i;
   cal_hit_tracks *hit_tr;
   float e_tot;
   
   switch (hit->status) {
      case EMPTY:
	printf(" Dump for hit # %d, hit is created but empty:\n", n);
	return;
      case SHOWERING:
        printf(" Dump for hit # %d, State: received Shower info:\n",n);
        break;
      case NOISE:
	printf(" Dump for hit # %d, NOISE hit \n", n);
	break;
      case SINGLE_TRACK:
        printf(" Dump for hit # %d, State: Originated by Track HEP # = %d\n",
                      n, hit->info_tr->tr_num);
        break;
      case CONSOLIDATED:
        printf(" Dump for hit # %d, State: Consolidated \n", n);
        if( hit->n_tracks == 0)
           printf ("   No HEP track contributed to this hit \n");
         else if (hit->n_tracks == 1) 
           printf ("   Only 1 track contribute, HEP number = %d \n",
                   hit->info_tr->tr_num);
         else {
           printf
   ("     %d tracks contributed to this hit,  \n", 
               hit->n_tracks);
           for (i=0, hit_tr = hit->info_tr; i<hit->n_tracks; i++, hit_tr++) 
             printf 
    ("         Hep # = %d, contrib. to  %g  of total energy \n", 
                   hit_tr->tr_num, hit_tr->percent_e_tot);
          }
          break;    
      default:
        printf(" Dump for hit # %d, State: unknow, code = %d \n",
                     n, hit->status );
                     
        break;
    }
    printf("       Coor1 Cell number = %d , Coor2 Cell Number %d \n",
          hit->icr1, hit->icr2);
    printf("      Total energy = %g \n", sum_energy(hit)); 
	if (hit->e_mip > 0.) 
	printf ("           Minimum Ionisation energy = %g \n" , hit->e_mip); 
	if (hit->e_em > 0.) 
	printf ("          energy due E.M. shower= %g \n" , hit->e_em); 
	if (hit->e_had > 0.) 
	printf ("          energy due Hadronic shower= %g \n" , hit->e_had); 
}	   

void print_all_cal_hits_(int ical )
{
   int i;
   printf(" \n Dump of the Calorimeter Hits for calorimter # %d \n", ical);
   printf ("     Number of hits found %d \n ", MCFNumHitCal[ical]);
   for (i=0; i<MCFNumHitCal[ical]; i++) 
      Print_cal_hit(i, MCFCalHits[ical][i]);
}

int collect_shower_hits_(int ical, int num_start_hit, int tr_num)
/*
** Called from cal_make_hit. 
** At the end of the showering process, collect all the hits associated to a 
** given trace (or HEP particle) into a single hit, in order
** to move from SHOWERING stage to SINGLE_TRACK phase. 
** This is done on a calorimeter basis, if a shower extends over multiple 
** calorimeter, this routine must be called multiple times.
** The heap is reused, Hist are deleted, but the pointer array 
** MCFCalHits[ical] does not shrinks.
** This routine takes all the hits with a status = SHOWERING, indiscriminatly.
** Thus, if omissions occurs in make_cal_hit (such as forgetting to call this 
** routine in some cases, the unphysical hit confusion will occur.

** Synopsis :
**
** Returns the number of SHOWERING hits that collapsed into one SINGLE_TRACK
** hit.  All arguments are input:
**
** int ical: The calorimeter number. 

** int num_start_hit: index in the MCFCalHits[ical][] array. Can be <0, 
** at which point we start frm the beginning in the array. Note : C 
**  convention !
**
** int tr_num: The HEP track number associated with the hit. 
**
*/
{
     cal_hit *hit, *firstHit;
     int notDone;
     int i, nCoalesced, iFirstStart, nDeleted, iStart=0;
/*
** We start by resetting the Current cell indices, as we presumably 
** stopped generating shower droplets (if not, that's o.K., we'll use 
** a bit more more memory to keep tracks of the droplets going into 
** the same cell.)
*/     
      MCFCurrentIcal = -1; MCFCurrentIcr1 = -1; MCFCurrentIcr2 = -1;
      
     if (num_start_hit >= MCFNumHitCal[ical]) return 0;
     if (num_start_hit > 0) iStart = num_start_hit;
/*
** Assume that all hits from previous tracks have been assigned 
** a different status
*/     
      while((iStart <  MCFNumHitCal[ical]) &&
              (MCFCalHits[ical][iStart] != NULL) &&
               (MCFCalHits[ical][iStart]->status != SHOWERING)) iStart++;
/*
** Nothing to do, we reached the end of the list and hit in the showering 
** stage.
*/               
     if (iStart  == MCFNumHitCal[ical]) return 0;
     firstHit = MCFCalHits[ical][iStart];
     if (firstHit->status != SHOWERING) return 0;
     notDone = TRUE;
     nCoalesced = 0;
     iFirstStart = iStart;
     nDeleted = 0;
     while (notDone) {
        nCoalesced++;
        firstHit->status = SINGLE_TRACK;
        firstHit->n_tracks = 1;
        if (firstHit->info_tr != NULL) free(firstHit->info_tr);
        firstHit->info_tr = (cal_hit_tracks *) malloc(sizeof(cal_hit_tracks));
        if (firstHit -> info_tr == NULL) {
            fprintf(stderr, 
  "Fail to allocate memory in Collect_shower \n, Bailing out !  \n");
            return -1;
        }
        firstHit->info_tr->tr_num = tr_num;
        firstHit->info_tr->percent_e_tot = 1.0;
        for (i = iStart+1; i<MCFNumHitCal[ical]; i++) {
           hit = MCFCalHits[ical][i];
           if ((hit != NULL) && (hit->icr1 == firstHit->icr1) 
                             && (hit->icr2 == firstHit->icr2)) {
              firstHit->e_mip += hit->e_mip;         
              firstHit->e_em += hit->e_em;
              firstHit->e_had += hit->e_had;
              Destroy_cal_hit(hit); MCFCalHits[ical][i] = NULL;
              nCoalesced++;
              nDeleted++;
            }
       } 
       i = iStart +1;
       /*
       ** Scan the array for the next hit that needs to be coaleasced 
       **   with others. 
       */
       notDone = FALSE;
       while (i < MCFNumHitCal[ical]) {
          if ((MCFCalHits[ical][i] != NULL) 
       		&& (MCFCalHits[ical][i]->status == SHOWERING)) {
       		   iStart = i;
       		   firstHit = MCFCalHits[ical][iStart];
       		   i = MCFNumHitCal[ical];
       		   notDone = TRUE;
       	       }
       	       i++;
       	   }
     }
     compact_cal_hitlist(ical, iFirstStart);
     MCFNumHitCal[ical] -= nDeleted;  
     return nCoalesced;
} 
int consolidate_cal_hits_(int ical)
{
/*
** Usually called from at the end of the tracing., e.g. from emcal_fill,
** which is called from mcp_analyze.
** At the end of the tracing process, collect all the hits sharing the same 
** cell, and build the  track information subarray. As in 
** Collect_shower_hits, we sum all energies linearly, without fudge factor
** nor smearing.  This is done emcal_fill (or call_fill_smear, after we 
** decide on correct names.. )
**
** This routine can be called more then once in the same event, for the 
** same calorimter, in case further tracks are added, or for heap management
** efficiency, one needs to coalesce hits sooner.
** 
** Synopsis :
**
** Returns the final number of hits in that calorimeter.
**
** int ical: The calorimeter number. 
**
*/
     cal_hit *hit, *firstHit;
     int notDone;
     int i, nCoalesced, nDeleted;
     int ntr, ntr2, oldTr, iStart=0;
     cal_hit_tracks htr[MCFMAXNUMTRACKPERCELL];
     float e_tot, e_tmp;
     
    if (MCFNumHitCal[ical] == 0) return;
    iStart = 0;
    notDone = TRUE;
    nCoalesced = 0;
    nDeleted = 0;
    while (notDone) {
      firstHit = MCFCalHits[ical][iStart];
      if ((firstHit != NULL) && (firstHit->status == SINGLE_TRACK)) {
        nCoalesced++;
        firstHit->status = CONSOLIDATED;
        htr[0].tr_num = firstHit->info_tr->tr_num;
        e_tot = sum_energy(firstHit);
        htr[0].percent_e_tot = e_tot;
        /*
        ** We temporarely redefine the meaning of this variable, 
        ** We compute the percentage after scanning throughout 
        ** all the cells.
        */
        ntr = 1;
        for (i = iStart+1; i<MCFNumHitCal[ical]; i++) {
           hit = MCFCalHits[ical][i];
           if ((hit != NULL) && (hit->status == SINGLE_TRACK) 
                             && (hit->icr1 == firstHit->icr1) 
                             && (hit->icr2 == firstHit->icr2)) {
              e_tmp = sum_energy(hit);
              /*
              ** Before declaring this a new contributing track, 
              ** we first have to check again that this trck is not 
              ** already defined. This was supposed to be done in 
              ** Collect, caled from emcal_make_hits. However, 
              ** a particle can re-shower, as energy can go from 
              ** calorimeter to the next. Hopefully, a better
              ** (e.g. less time consuming ) algorithm will be setup 
              ** when the tracing and hit calorimetry making will be 
              ** redesigned. 
              */
              oldTr = -1;
              for (ntr2=0; ntr2<ntr; ntr2++) {
                   if (htr[ntr2].tr_num == hit->info_tr->tr_num) 
                            oldTr = ntr2;
              }
              if (oldTr == -1) {    
                if (ntr < MCFMAXNUMTRACKPERCELL) { 
                   htr[ntr].tr_num = hit->info_tr->tr_num;
                   htr[ntr].percent_e_tot = e_tmp;
                   ntr++;
                } else {
                   fprintf (stderr,
  " From Integrate_cal_hits, too many tracks pointing to same cell \n");
  	           fprintf (stderr, 
   "  Calorimter is %d,  Cell coor1/coor2 index = %d, %d, \n", ical, 
                                       hit->icr1, hit->icr2);
                } 
              } else {
                   htr[oldTr].percent_e_tot += e_tmp;
              }     
              firstHit->e_mip += hit->e_mip;         
              firstHit->e_em += hit->e_em;
              firstHit->e_had += hit->e_had;
              e_tot += e_tmp;
              Destroy_cal_hit(hit); MCFCalHits[ical][i] = NULL;
              nCoalesced++;
              nDeleted++;
            }
         }
         for (i=0; i<ntr; i++ ) 
             htr[i].percent_e_tot =  htr[i].percent_e_tot/ e_tot;
        if (firstHit->info_tr != NULL) free(firstHit->info_tr);     
        firstHit->info_tr =
            (cal_hit_tracks *) malloc(sizeof(cal_hit_tracks)*ntr);
        if (firstHit -> info_tr == NULL) {
            fprintf(stderr, 
  "Fail to allocate memory in Consolidate_shower \n, Bailing out !  \n");
            return -1;
        }
        memcpy ((void *)firstHit->info_tr, (void *) htr,
                     (sizeof(cal_hit_tracks)*ntr));
        firstHit->n_tracks = ntr;            
       } 
       i = iStart +1;
       notDone = FALSE;
       while (i < MCFNumHitCal[ical]) {
          if ((MCFCalHits[ical][i] != NULL) 
       		&& (MCFCalHits[ical][i]->status == SINGLE_TRACK)) {
       		   iStart = i;
       		   firstHit = MCFCalHits[ical][iStart];
       		   i = MCFNumHitCal[ical];
       		   notDone = TRUE;
       	       }
       	       i++;
       	   }
    }
     compact_cal_hitlist(ical, 0);
     MCFNumHitCal[ical] -= nDeleted;  
     return nCoalesced;
}   

int num_cal_hits_(int ical)
/*
** Returns the number of hits for a given calorimeter.
*/
{
    return MCFNumHitCal[ical];
}

float energy_cal_hit_(int ical, int n_hit)
/*
** Returns the total energy for a given hit
*/
{
     float e_tot=0.;
     
     if (n_hit >= MCFNumHitCal[ical]) return e_tot;
     return ((MCFCalHits[ical][n_hit]->e_mip + 
             MCFCalHits[ical][n_hit]->e_em + 
             MCFCalHits[ical][n_hit]->e_had));

}
void info_cal_hit_(int ical, int n_hit, int *icr1, int *icr2, float *e_mip, 
                   float *e_em, float * e_had, int *ntr)
/*
** Return infomation about a particular hit. Returns icr1 = -1, icr2 = -1 
** if invalid hit.
*/
{
    cal_hit *hit;
    
    if (n_hit >= MCFNumHitCal[ical]) {
       *icr1 = -1; *icr2 = -1;  
       return;
    }
    hit = MCFCalHits[ical][n_hit];
    if (hit == NULL) {
       *icr1 = -1; *icr2 = -1;  
       return;
    }
    *icr1 = hit->icr1;
    *icr2 = hit->icr2;
    *e_mip = hit->e_mip;
    *e_em = hit->e_em;
    *e_had = hit->e_had;
    *ntr = hit->n_tracks;
    return;
}
int hit_cal_addr_(int ical, int icr1, int icr2)
/*
** Return infomation about a particular address (ical, icr1, icr1).
    returns hit number for valid hit , 
   -1 for invalid hit  
*/
{
    cal_hit *hit;
    int i, n_hit = NOHIT;
    for (i = 0; i < MCFNumHitCal[ical]; i++ )
    {
        hit = MCFCalHits[ical][i];
        if (icr1 == hit->icr1 &&
            icr2 == hit->icr2) 
        { 
           n_hit = i;
           break;
        }
    }
    
    return (n_hit);
    
}                   
float sum_e_tot_cal_hits_(int ical, int tr_num)
/*
** Summ the energy for a given track and a given calorimeter.
** If tr_num = 0, all energy is summed up.
*/
{
   int i,j;
   cal_hit *hit;
   cal_hit_tracks *tr;
   float e=0.;
   
   for(i=0; i< MCFNumHitCal[ical]; i++) {
      hit = MCFCalHits[ical][i];
      if (hit == NULL) continue;
      if (tr_num == 0) e += sum_energy(hit);
      else  {
         for (j=0, tr=hit->info_tr; j<hit->n_tracks; j++, tr++) 
           if (tr_num == tr->tr_num) e += sum_energy(hit) * tr->percent_e_tot ;
     }
   }
   return e;
}

float sum_energy_cal_hit_(int ical, int icr1, int icr2)
/*
** return the total energy in a given (coor1,coor2) cell for a given calorimeter. 
*/
{
   int i,j;
   cal_hit *hit;
   float e=0.;
   
   for(i=0; i< MCFNumHitCal[ical]; i++) {
      hit = MCFCalHits[ical][i];
      if (hit == NULL) continue;
      if ((hit->icr1 == icr1) && (hit->icr2 == icr2)) e += sum_energy(hit);
   }
   return e;
}

void smear_cal_hits_(int ical, float a_em, float b_em, float rweight, 
                    float a_had, float b_had, float em_had_ratio)
/* 
**    Smudge the hits according to formulas found in the previous 
**    emcal_fill routine.  The arguments a_em, b_em and so forth are 
**    phenomenlogical factor I don't pretend to understand, but they 
**    will have to be documented. The algorith is  strict translation 
**    from Fortran to c, except the calculation are done in double precision.
*/
{
   int i,j;
   cal_hit *hit;
   double e_dep_em, e_dep_mip, e_dep_had, eres_em, eres_had, x;
   int dummy;
   
   dummy = 0;
   for(i=0; i< MCFNumHitCal[ical]; i++) {
      hit = MCFCalHits[ical][i];
      if (hit == NULL) continue;
      e_dep_em = (double) hit->e_em;
      e_dep_had = (double) hit->e_had;
      e_dep_mip = (double) hit->e_mip;
      if (e_dep_em > 1.e-10) {
          x = (double) get_gauss_(&dummy);
          eres_em = sqrt(e_dep_em * pow(a_em,2)+ pow((b_em*e_dep_em),2));
          e_dep_em = rweight * (e_dep_em + eres_em * x);
          hit->e_em = (float) e_dep_em;
      }
      if (e_dep_had > 1.e-10) {
          x = (double) get_gauss_(&dummy);
          eres_had = sqrt(e_dep_had * pow(a_had,2) + pow((b_had*e_dep_had),2));
          e_dep_had = (e_dep_had + eres_had * x) * rweight/em_had_ratio;
          hit->e_had = (float) e_dep_had;
      }  
      if (e_dep_mip > 1.e-10) {
          e_dep_mip = rweight * e_dep_mip;
          hit->e_mip = (float) e_dep_mip;
      }
   }
}

void add_cal_hit_( int ical, int icr1, int icr2, 
                   float e, int mode, int tr_num, int istart )
/* 
** int ical : Calorimeter index. 
** int icr1 : coor1 cell index
** int icr2 : coor2 cell index
** int mode : the mode, 0 = Minimum ionizing, 1 = E.M., 2 = Hadronic;
** float e The energy increment. 
*/
{
   cal_hit *hit;
   int ihit ;
   if ((ical == MCFCurrentIcal) && 
       (icr1 == MCFCurrentIcr1) && (icr2 == MCFCurrentIcr2)) {
       hit = MCFCalHits[ical][(MCFNumHitCal[ical]-1)];
       if ( hit->info_tr->tr_num == tr_num )
       {
          if ( mode == 0 ) hit->e_mip += e ;
	  else if ( mode == 1 ) hit->e_em += e ;
	  else if ( mode == 2 ) hit->e_had += e ;
	  return ; 
       }
    } 

/* we come here if need to find a matching hit */
    if ( istart < 0 ) istart = 0 ;
    for ( ihit = istart; ihit < MCFNumHitCal[ical]; ihit++ )
    {
       if ( MCFCalHits[ical][ihit]->icr1 == icr1 &&
	    MCFCalHits[ical][ihit]->icr2 == icr2 &&
	    MCFCalHits[ical][ihit]->info_tr->tr_num == tr_num )
       {
	  hit = MCFCalHits[ical][ihit] ;
          if (mode == 0) hit->e_mip += e;
          else if (mode == 1)  hit->e_em += e;
          else if (mode == 2)  hit->e_had += e;
	  return ;
       }
    }

/* we come here if need to create a new hit */
    hit = Create_cal_hit(ical);
    if (hit == NULL) return;
    hit->status = SINGLE_TRACK;
    if ( hit->info_tr == NULL ) 
    {
          hit->info_tr = (cal_hit_tracks *) malloc(sizeof(cal_hit_tracks)) ;
          if ( hit->info_tr == NULL ) return ;
          hit->n_tracks = 1 ;
          hit->info_tr->tr_num = tr_num ;
          hit->info_tr->percent_e_tot = 1.0 ;
    } 
    hit->icr1 = icr1;
    hit->icr2 = icr2;
    MCFCurrentIcal = ical; 
    MCFCurrentIcr1 = icr1;
    MCFCurrentIcr2 = icr2;
    if (mode == 0) hit->e_mip += e;
    else if (mode == 1)  hit->e_em += e;
    else if (mode == 2)  hit->e_had += e;
    return ;
}


void set_cal_hit_showering_(int ical, int icr1, int icr2, 
                            float e, int mode)
/* 
** Convenience routine to hook up the old emcal_find_cell.
** Presumably will be deprecated when we move the entire package to C, 
** as this routine has little intelligence and consume CPU to trasnfer 
** all the following arguments:
** int ical : Calorimeter index. 
** int icr1 : coor1 cell index
** int icr2 : coor2 cell index
** int mode : the mode, 0 = Minimum ionizing, 1 = E.M., 2 = Hadronic;
** float e The energy increment. 
**
** Note: If the current calorimeter, and cell number are identical 
** to the previous call, we simply increment the previous hit..
**
*/
{
   cal_hit *hit;
   if ( (ical == MCFCurrentIcal) && 
        (icr1 == MCFCurrentIcr1) && (icr2 == MCFCurrentIcr2) &&
        MCFCalHits[ical][(MCFNumHitCal[ical]-1)]->status == SHOWERING ) 
    {
       hit = MCFCalHits[ical][(MCFNumHitCal[ical]-1)];
    } 
    else 
    {   
       hit = Create_cal_hit(ical);
       if (hit == NULL) return;
       hit->status = SHOWERING;
       hit->icr1 = icr1;
       hit->icr2 = icr2;
       MCFCurrentIcal = ical; 
       MCFCurrentIcr1 = icr1;
       MCFCurrentIcr2 = icr2;
    }
    if (mode == 0) hit->e_mip += e;
    else if (mode == 1)  hit->e_em += e;
    else if (mode == 2)  hit->e_had += e;
}

  
/*
** static functions used exclusively in this module 
*/
static int extend_cal_hits(int ical)
{
/*
** We simply increment the heap by the fixed amount MCFNUMCALHITPREALLOC 
*/

    int i;
    cal_hit **tmp = MCFCalHits[ical];
  
    MCFCalHits[ical] =
       (cal_hit **) malloc(sizeof (cal_hit *) * ( MCFNumHitCalAlloc[ical] +
                                     MCFNUMCALHITPREALLOC)   );
    if (MCFCalHits[ical] == NULL) {
       fprintf(stderr, "Running out of memory in extend_cal_hits \n");
       return -1;
    }
    MCFNumHitCalAlloc[ical]  += MCFNUMCALHITPREALLOC; 
    for(i=0; i<MCFNumHitCalAlloc[ical]; i++)  MCFCalHits[ical][i] = NULL;
    memcpy((void *) MCFCalHits[ical], (void *) tmp, 
            (MCFNumHitCal[ical]*sizeof(cal_hit **)));
    free(tmp);
}
static void compact_cal_hitlist(int ical, int iFirstStart)
{
/*
** Compress the pointer array to make room for the next set of hit,
** and ensure the last hit is at MCFNumHitCal[ical] at the end 
*/

    int i, j, indexFree;
    
    for(i=iFirstStart, indexFree = -1; i< MCFNumHitCal[ical]; i++) {
       if ((indexFree == -1) && (MCFCalHits[ical][i] == NULL)) indexFree = i;
       else if ((indexFree > iFirstStart) && (MCFCalHits[ical][i] != NULL)) {
           MCFCalHits[ical][indexFree]  =  MCFCalHits[ical][i];
           MCFCalHits[ical][i] = NULL;
           j=iFirstStart;
           indexFree = -1;
           while((indexFree == -1) && (j < MCFNumHitCal[ical])) {
               if (MCFCalHits[ical][j] == NULL) indexFree = j;
               j++;
           }
        }
     }         
}
static float sum_energy(cal_hit *hit)
{
    return ((hit->e_mip + hit->e_em + hit->e_had));
}

int  num_tracks_cal_hit_( int ical, int icr1, int icr2 )
{
 
   int i ;
   cal_hit* hit ;
   int ntr = 0 ;

   for ( i=0; i<MCFNumHitCal[ical]; i++ )
   {
      hit = MCFCalHits[ical][i] ;
      if ( hit == 0 ) continue ;
      if ( hit->icr1 == icr1 && hit->icr2 == icr2 ) return hit->n_tracks ;
   }

   return ntr ;

}

void info_track_cal_hit_( int ical, int icr1, int icr2, int itrack,
                          int* hep, float* percent_e_tot )
{

   int i ;
   cal_hit* hit ;

   *hep = -1 ;
   *percent_e_tot = 0. ;

   if ( itrack < 0 ) return ;

   for ( i=0; i<MCFNumHitCal[ical]; i++ )
   {
      hit = MCFCalHits[ical][i] ;
      if ( hit == 0 ) continue ;
      if ( hit->icr1 == icr1 && hit->icr2 == icr2 )
      {
         if ( hit->info_tr == 0 ) return ;
         if ( itrack >= hit->n_tracks ) return ;
         *hep = ((hit->info_tr)+itrack)->tr_num ;
         *percent_e_tot = ((hit->info_tr)+itrack)->percent_e_tot ;
         return ;
      }
   }

}

float e_mip_cal_hit_( int ical, int icr1, int icr2 )
{

   int i ;
   cal_hit* hit ;
   float e = 0. ;

   for ( i=0; i<MCFNumHitCal[ical]; i++ )
   {
      hit = MCFCalHits[ical][i] ;
      if ( hit == 0 ) continue ;
      if ( hit->icr1 == icr1 && hit->icr2 == icr2 ) return hit->e_mip ;
   }

   return e ;

}

float e_em_cal_hit_( int ical, int icr1, int icr2 )
{

   int i ;
   cal_hit* hit ;
   float e = 0. ;

   for ( i=0; i<MCFNumHitCal[ical]; i++ )
   {
      hit = MCFCalHits[ical][i] ;
      if ( hit == 0 ) continue ;
      if ( hit->icr1 == icr1 && hit->icr2 == icr2 ) return hit->e_em ;
   }

   return e ;

}

float e_had_cal_hit_( int ical, int icr1, int icr2 )
{

   int i ;
   cal_hit* hit ;
   float e = 0. ;

   for ( i=0; i<MCFNumHitCal[ical]; i++ )
   {
      hit = MCFCalHits[ical][i] ;
      if ( hit == 0 ) continue ;
      if ( hit->icr1 == icr1 && hit->icr2 == icr2 ) return hit->e_had ;
   }

   return e ;

}



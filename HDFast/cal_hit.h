#ifndef _cal_hit_INC
#define _cal_hit_INC

#define MCFNUMCALORIMETERS 40 /* Very ugly ! Now this size id defined at 3
places in the McFast package. Fixed when we'll be moving entirely to c++ */

#define NOHIT -1  /*make a default for no hit state.*/

/** Basic calorimetry information **/


typedef enum _calHitState {
    EMPTY,     /* memory has been allocated, but no meaningfull info */
    NOISE,     /* Noise componenet. No track info, obviously */
    SHOWERING, /*  hits is created as the shower propagates. The track info 
    		  is not available at that time */
    SINGLE_TRACK, /* The amount of energy deposition is due to a signle track 
    		     typically created in make_cal_hit, after showering 
    		     process is completed */
    CONSOLIDATED   /* The energy deposition may now include the contribution 
    			from more than 1 track. Typically obtained the event 
    			has been completly traced. */
}calHitState;

typedef struct _cal_hit_tracks {
   int tr_num; /* The track number, refering to the HEP evt list */
   float percent_e_tot; /* The percentage of the total energy this track
                       contribute to the (cr1,cr2) cell this structure
                        belongs to */
} cal_hit_tracks;

typedef struct _cal_hit {
    int icr1; /* The coordinate-1 cell number. Currently may be x or phi.
                 Given by:
                 int((x-emcal_par(ical).xlimit(1))/dx) 
              or int(phi/d_phi) (in VAX-FORTRAN) */
    int icr2; /* The coordinate-2 cell number. Currently may be y or eta.
                 Given by :
                 int((y-emcal_par(ical).ylimit(1))/dy) 
              or int((eta-emcal_par(ical).eta_min)/d_eta) (in VAX-FORTRAN) */
    float e_mip; /* The amount of energy due to energy loss for a single 
    		    particle, occuring before showering starts */
    float e_em;  /* The amount of energy due to electromagnetic processes */
    float e_had; /* The amount of energy due hadronic processes */
    int status; /* A word defining the status of the hit, see calHitState */
    int n_tracks; /* The number of tracks contributing to this hit */ 
    cal_hit_tracks *info_tr; 
                 /* A pointer to a set of track vs cal. hit info d/s  */
} cal_hit;

extern int MCFNumHitCal[MCFNUMCALORIMETERS]; 
                   /* the total number of hit defined in the event */
extern int MCFNumHitCalAlloc[MCFNUMCALORIMETERS]; 
		  /* The current number of cal_hit pointers allocated below*/
extern  cal_hit **MCFCalHits[MCFNUMCALORIMETERS];
		 /* An array of pointers to the hits for each calorimeters */


/*added to make compatible with calls from C++, Amber 11/14/96*/
#if defined(c_plusplus) || defined(__cplusplus)
extern "C" {
#endif		
void init_all_cal_hits_(int numCal);  /* Global intialisation, once per job */		
void init_cal_hits_(int ical);  /* Initialization, one per event.
                                   F77 API, called from mcp_ top level */
cal_hit *Create_cal_hit(int ical); /* Create an empty cal_hit d/s */
void Destroy_cal_hit(cal_hit *hit); /* Destroy (free) a cal hit d/s */
void Destroy_all_cal_hits(int ical); /* Free all hits for calrimter ical */
void Print_cal_hit(int n, cal_hit *hit); /* Print a hit content to stdout */
void print_all_cal_hits_(int ical );
                  /* Prints all the hits for a given calorimeter */ 
int collect_shower_hits_(int ical, int num_start_hit, int tr_num); 
		  /* At the end of the showering process, collect all the hit 
		  	dribbles to move from SHOWERING to SINGLE_TRACK hit */
int consolidate_cal_hits_(int ical); 
		/* At the end of the event tracing, integrate all the hits */

/*
** Note: All indices are presumed "C" style, e.g. , starting from 0
*/

int num_cal_hits_(int ical);
		/* Returns the number of hits for a given calorimeter */
		   
float sum_e_tot_cal_hits_(int ical, int tr_num); 
       /* Simple convenience function to sum up the energy */

float energy_cal_hit_(int ical, int n_hit);
	/* Return the total energy for a particular hit number */

void info_cal_hit_(int ical, int n_hit, int *icr1, int *icr2, float *e_mip, 
                   float *e_em, float * e_had, int *ntr);
	/* Return some infomation for a particular hit */
                   
int hit_cal_addr_(int ical, int icr1, int icr2);
       /*Return infomation about a particular address */
				          
float sum_energy_cal_hit_(int ical, int icr1, int icr2); 
                /* Simple convenience function to return the total energy 
                	for a given cell in a given (F77 API, to fit in
                	calor_energy)  */
void smear_cal_hits_(int ical, float a_em, float b_em, float rweight, 
                    float a_had, float b_had, float em_had_ratio);
                /* Smudge the hits according to formulas found in the 
                    previous emcal_fill routine. */
                                  	
void set_cal_hit_showering_(int ical, 
                            int icr1, int icr2, float e, int mode);
	 /* Convenience routine to hook up the old emcal_find_cell. */				                                                 

void add_cal_hit_( int ical, int icr1, int icr2, 
                   float e, int mode, int tr_num, int istart ) ;

int   num_tracks_cal_hit_( int ical, int icr1, int icr2 ) ;

void  info_track_cal_hit_( int ical, int icr1, int icr2, int itrack,
                           int* hep, float* percent_e_tot ) ;

float e_mip_cal_hit_( int ical, int icr1, int icr2 ) ;
float e_em_cal_hit_(  int ical, int icr1, int icr2 ) ;

    		  
#if defined(c_plusplus) || defined(__cplusplus)
}
#endif
#endif

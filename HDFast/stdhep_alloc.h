/************************************************
 * stdhep_reduced.h 
 *  remap stdhep common block to a smaller size
 * for output
 * Paul Eugenio
 * Carnegie Mellon University
 * 8 Nov 98
 **********************************************/
#ifndef STDHEP_REDUCED_CHEADER
#define STDHEP_REDUCED_CHEADER


#define NMXHEP 4000
extern struct hepevt {
int nevhep;		/* The event number */
int nhep;		/* The number of entries in this event */
int isthep[NMXHEP]; 	/* The Particle id */
int idhep[NMXHEP];      /* The particle id */
int jmohep[NMXHEP][2];    /* The position of the mother particle */
int jdahep[NMXHEP][2];    /* Position of the first daughter... */
double phep[NMXHEP][5];    /* 4-Momentum, mass */
double vhep[NMXHEP][4];    /* Vertex information */
} hepevt_;
extern struct hepev2 {
int nmulti;		/* number of interactions in the list */
int jmulti[NMXHEP];     /* multiple interaction number */
} hepev2_;


/*
 * heppart_t  is used in usr_dump() 
 * to save only the necessary part 
 * of the commom block.
 */
struct heppart_t {
  int isthep;     /* The particle status */
  int idhep;      /* The particle id */
  int jmohep[2];    /* The position of the mother particle */
  int jdahep[2];    /* Position of the first daughter... */
  double phep[5];    /* 4-Momentum, mass */
  double vhep[4];    /* Vertex information */
} ; 


#endif

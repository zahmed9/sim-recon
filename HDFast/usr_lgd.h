/************************************************
 * usr_lgd.h 
 * 
 * Paul Eugenio
 * Carnegie Mellon University
 * 28 Jan 1999
 **********************************************/
#ifndef USR_LGD_CHEADER
#define USR_LGD_CHEADER

typedef struct  {
  int hepIndex;       /* index to the particle in the hepevt list */
  int type;           /* types: 0= hadron, 1=gamma */
  double xlocal;      /* x at lgd face */
  double ylocal;      /* y at lgd face */
  double px;          /* smeared momentum */
  double py;
  double pz;
  double vx;          /* production vertex */
  double vy;
  double vz;
  
}lgd_smearedpart_t;

typedef  struct {
  int nparts;            /*Number of particles detected by the lgd */
  lgd_smearedpart_t part[1];
}lgd_smearedparts_t ;


double Gauss(double mean,double sigma);
void smearLGDgamma(double *p);

#endif

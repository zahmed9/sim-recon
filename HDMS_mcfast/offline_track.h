/************************************************
 * offline_track.h 
 * Map2Fortran Common Block Structure
 * Paul Eugenio
 * Carnegie Mellon University
 * 28 Sept 98
 **********************************************/
#ifndef OFFLINE_TRACK_CHEADER
#define OFFLINE_TRACK_CHEADER


struct wtrack_struct {
  double px;
  double py;
  double pz;
  double E;
  double x;
  double y;
  double z;
  double pt; /* pt = sqrt(px*px+py*py) */
  double p; /* momentum */
  double q; /* charge */
} ;

struct offline_track_struct {
  struct wtrack_struct w;
  double mass;
  double cov[7][7]; /* covariance matrix */
  double chisq;     /* fit chisq */
  int nhit;         /* nhits in fit */
  int nhit_sil;     /* # of silicon hits */
  int nhit_stereo;  /* # of  hits with stereo info*/
  int icov;         /* icon = 0 if covariance matrix not defined
		            = 1 if covariance matrix defined
		            = 2 defined, but no momentum information */
  int hep;          /* position of corresp. track in HEPEVT list */
} ;

#define TRK_OFF_MAX 500
struct trk_off2 {
  struct offline_track_struct trk_off[TRK_OFF_MAX];
} ;

struct trk_off1 {
  int trk_off_num;
} ;

extern struct trk_off1 trk_off1_ ;
extern struct trk_off2 trk_off2_ ;

#endif

/*
 * trk_off1.trk_off_num = the number of smeared tracks
 *
 * trk_off2_.trk_off[i].w.px is the x-momentum of the 
 *                           i'th smeared track
 */


/************************************************
 * gen_track.h   see gen_track.inc
 * Map FORTRAN common block to C data structure
 * Paul Eugenio
 * Carnegie Mellon University
 * 28 Sept 98
 **********************************************/
#ifndef GEN_TRACK_CHEADER
#define GEN_TRACK_CHEADER

struct gen_track_s {
  float q;  /* charge: map to fortran real */
  int status; /* Status */
  int pdgtype; /*PDG aprticle type */
  int stbtype; /*Stable particle type */
  int hep; /* position in HEPEVT list */
};

#define TRK_GEN_MAX 500
struct trk_gen_c {
  int trk_gen_num; /* # of generated tracks */
  int idum_tkgn;  /* dummy for alignment */
  struct gen_track_s trk_gen[TRK_GEN_MAX]; /* list of generated tracks */
} ;

extern struct  trk_gen_c trk_gen_c_ ;

#endif

/* Usage:
 * trk_gen_c_.trk_gen_num
 *                            etc.
 * 
 */

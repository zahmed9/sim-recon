/**********************
 *
 * calor_hits.h
 *
 *********************/

#ifndef _calor_hits_INC
#define _calor_hits_INC

#define TRUE 1
#define FALSE 0

struct cal_hit_tracks_t {
  int tr_num;  
  float e_mip;
  float e_em;  
  float e_had; 
};

struct cal_hit_t {
  int icr1; 
  int icr2;  
  float e_tot;
  int n_tracks;
  struct cal_hit_tracks_t *info_tr; 
};
  
struct cal_hits_t {
  int nCalHits;
  struct cal_hit_t **CalorHits;
};


#endif

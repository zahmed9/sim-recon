
#ifndef MAX_LEN_LINE
#define MAX_LEN_LINE 128
#endif

      static char *comment = {"!"} ;

      static char *inp_char_id = {"'"} ;

      static char *geo_keys[] = {
      "MATERIAL",   "MIXTURE",
      "DETECTOR",
      "SIBARREL",   "LAYERSIB", "WAFER",
      "SIDISK",     "LAYERSIDI","WEDGE",
      "SIXY",       "LAYERSIXY",
      "DRIFT",      "LAYERDRFANO", "LAYERDRFCATHO", "OFFSETDRFANO",
      "FORTRACKING","LAYERFTRK",
      "DIPOLE",     "SOLENOID",
      "EMCALORIMETER", "CALORBOX", "HADCALORIMETER", 
      "MUON", "ABSORBER", "ABSORBERBOX",
      "RICH",
      "BEAMPIPE",
      "HITSONTRACK",
      "BEAMVRTX",
      NULL } ;

      static int n_par_key[]  = {
        9,           23,
        3,
        5,           11,         15, 
        5,           13,         14,
        5,           25,
       27,           17,         13,       11,
       27,           22,
       25,           16,
       19,           23,         16,
       12,           11,         15,
       12,
       15,
        4,
        7,
        0 } ;

extern upcase(char *inp_string) ;

extern void clear_detector_() ;
extern void geo_fill_mat_(char *, int *, int *, float *, char *, int, int) ;
extern void geo_fill_detector_general_(char *, int *, char *, int, int) ; 
extern void geo_fill_sixy_(char *, int *, float *, char *, int, int) ;
extern void geo_fill_sibarrel_(char *, int *, float *, char *, int, int) ;
extern void geo_fill_sidisk_(char *, int *, float *, char *, int, int) ;
extern void geo_fill_beam_vrtx_(char *, int *, float *, int) ;
extern void geo_fill_hits_trk_(char *, int *, float *, int) ;
extern void geo_fill_dip_(char *, int *, int *, float *, char *, int, int) ;
extern void geo_fill_sol_(char *, int *, int *, float *, char *, int, int) ;
extern void geo_fill_emcal_(char *, int *, int *, float *, char *, int, int) ;
extern void geo_fill_hcal_(char *, int *, int *, float *, char *, int, int) ;
extern void geo_fill_muon_(char *, int *, int *, float *, char *, int, int) ;
extern void geo_fill_absorber_(char *, int *, int *, float *, char *, int, int) ;
extern void geo_fill_rich_(char *, int *, int *, float *, char *, int, int) ;
extern void geo_fill_drift_(char *, int *, int *, float *, char *, int, int) ;
extern void geo_fill_ftrk_(char *, int *, int *, float *, char *, int, int) ;
extern void geo_fill_beampipe_(char *, int *, int *, float *, char *, int, int) ;
extern void geo_fill_volume_() ;
extern void geo_mother_volume_() ;
extern void geo_trkorder_() ;
extern void geo_trklayer_() ;
extern geo_set_trk_channels_() ;

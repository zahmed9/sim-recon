#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "geo_keys.h"

void geo_get_data_(char cfile[], int *explor, int lengthc ) {

      char *inp_file ;
      char line[MAX_LEN_LINE] , *lin ;
      FILE *input ;
      static char *seps = " \n" ;         /* word separators        */
      char *w ;                           /* some service pointers  */
      char *keyword ;             
      static char *word[MAX_LEN_LINE/2] ; /* buffer for char        */
      int nw = 0, nw_start = -1;          /* number of tokens in string */
      int nkey = 0 ;
      int i, j ;
      float buffer[MAX_LEN_LINE/2] ;      /* buffer to transfer reals to FORTRAN */
      int nwords_to_fortran ;
      int i_fill, len_word ;

      inp_file = strtok(cfile, seps) ; 
      input = fopen(inp_file,"r") ;

      if (input == NULL) {
       perror(inp_file) ;
       exit(2) ;
      }

      clear_detector_() ;

again :
      if (fgets(line, sizeof(line), input) == NULL) {

       if (nw_start >= 0) {
/*     Here we pass to FORTRAN accumulated data
       (if NOT done yet !) before we close input file
*/
        i_fill = 1 ;
        nw_start = 0 ;
        keyword = geo_keys[nkey] ;

/*   Handling Materials and Mixtures 
*/
        if (strcmp(keyword,"MATERIAL") ==0 || strcmp(keyword,"MIXTURE") ==0)
        geo_fill_mat_(keyword, &nw_start, &i_fill,
                      buffer, "", strlen(keyword), 0) ;

/*   Handling BeamPipe
*/
        if (strcmp(keyword,"BEAMPIPE") == 0) 
        geo_fill_beampipe_(keyword, &nw_start, &i_fill,
                           buffer, "", strlen(keyword), 0) ;  

/*   Handling Barrel Silicon 
*/
        if (strcmp(keyword,"SIBARREL") == 0 ||
            strcmp(keyword,"LAYERSIB") == 0 ||
            strcmp(keyword,"WAFER")    == 0) 
        geo_fill_sibarrel_(keyword, &i_fill,
                       buffer, "", strlen(keyword), 0) ;

/*   Handling Barrel Disks
*/
        if (strcmp(keyword,"SIDISK")    == 0 ||
            strcmp(keyword,"LAYERSIDI") == 0 ||
            strcmp(keyword,"WEDGE")     == 0) 
        geo_fill_sidisk_(keyword, &i_fill,
                       buffer, "", strlen(keyword), 0) ;

/*   Handling Planar Silicon (XY-Silicon)
*/
        if (strcmp(keyword,"SIXY")       == 0 ||
            strcmp(keyword,"LAYERSIXY")  == 0)
        geo_fill_sixy_(keyword, &i_fill,
                       buffer, "", strlen(keyword), 0) ;

/*   Handling Drift Chambers (Central Tracking)
*/
        if (strcmp(keyword,"DRIFT")        == 0 ||
            strcmp(keyword,"LAYERDRFANO")  == 0 ||
            strcmp(keyword,"OFFSETDRFANO") == 0 ||
            strcmp(keyword,"LAYERDRFCATHO")== 0)
         geo_fill_drift_(keyword, &nw_start, &i_fill,
                         buffer, "", strlen(keyword), 0) ;

/*   Handling Forward Tracking System
*/
        if (strcmp(keyword,"FORTRACKING") == 0 ||
            strcmp(keyword,"LAYERFTRK")   == 0)
        geo_fill_ftrk_(keyword, &nw_start, &i_fill,
                       buffer, "", strlen(keyword), 0) ;

/*   Handling Dipole
*/
        if (strcmp(keyword, "DIPOLE") == 0)
         geo_fill_dip_(keyword, &nw_start, &i_fill,
                       buffer, "", strlen(keyword), 0) ;

/*   Handling Solenoid
*/
        if (strcmp(keyword, "SOLENOID") == 0)
         geo_fill_sol_(keyword, &nw_start, &i_fill,
                       buffer, "", strlen(keyword), 0) ;

/*   Handling EM Calorimeter
*/
        if (strcmp(keyword, "EMCALORIMETER") == 0 ||
            strcmp(keyword, "CALORBOX") == 0)
         geo_fill_emcal_(keyword, &nw_start, &i_fill,
                       buffer, "", strlen(keyword), 0) ;


/*   Handling MUON system
*/
        if (strcmp(keyword, "MUON") == 0)
         geo_fill_muon_(keyword, &nw_start, &i_fill,
                       buffer, "", strlen(keyword), 0) ;

/*   Handling Absorbers
*/
        if (strcmp(keyword, "ABSORBER") == 0 ||
            strcmp(keyword, "ABSORBERBOX") == 0)
         geo_fill_absorber_(keyword, &nw_start, &i_fill,
                       buffer, "", strlen(keyword), 0) ;

/*   Handling Cherenkov counters
*/
        if (strcmp(keyword, "RICH") == 0)
         geo_fill_rich_(keyword, &nw_start, &i_fill,
                       buffer, "", strlen(keyword), 0) ;

/*   Handling Beam Vertex
*/
        if (strcmp(keyword,"BEAMVRTX") == 0) 
         geo_fill_beam_vrtx_(keyword, &i_fill, buffer, strlen(keyword)) ;

/*   Handling Hits-on-Track 
*/
        if (strcmp(keyword, "HITSONTRACK") == 0) 
         geo_fill_hits_trk_(keyword, &i_fill, buffer, strlen(keyword)) ;

/*   End passing accumulated data to FORTRAN 
*/
       }

/*   Close input file at the end of it !   
*/

       fclose(input) ;

       geo_fill_volume_() ;

       if (*explor == 0) { 
        geo_mother_volume_() ;
        geo_trkorder_() ;
        geo_trklayer_() ;
        geo_set_trk_channels_() ;
       }

       return ;

      }

      lin = line ;

      w = strtok(line, seps) ;

      if (w == NULL) goto again ;

      if (*w == *comment) goto again ;

       for (i=0; i<MAX_LEN_LINE/2; i++) {
        word[i]   = ""  ;
       }

      if (*lin != ' ') {

       if (nw_start >= 0) {
/*     Here we should pass to FORTRAN accumulated data
       (if NOT done yet !)
       before we handle contents against new keyword 
*/
        i_fill = 1 ;
        nw_start = 0 ;
        keyword = geo_keys[nkey] ;

/*   Handling Materials and Mixtures
*/
        if (strcmp(keyword,"MATERIAL") == 0 || strcmp(keyword,"MIXTURE") == 0)
        geo_fill_mat_(keyword, &nw_start, &i_fill,
                      buffer, "", strlen(keyword), 0) ;

/*   Handling BeamPipe
*/
        if (strcmp(keyword,"BEAMPIPE") == 0) 
        geo_fill_beampipe_(keyword, &nw_start, &i_fill,
                           buffer, "", strlen(keyword), 0) ;  

/*   Handling Barrel Silicon 
*/
        if (strcmp(keyword,"SIBARREL") == 0 ||
            strcmp(keyword,"LAYERSIB") == 0 ||
            strcmp(keyword,"WAFER")    == 0) 
        geo_fill_sibarrel_(keyword, &i_fill,
                       buffer, "", strlen(keyword), 0) ;

/*   Handling Barrel Disks
*/
        if (strcmp(keyword,"SIDISK")    == 0 ||
            strcmp(keyword,"LAYERSIDI") == 0 ||
            strcmp(keyword,"WEDGE")     == 0) 
        geo_fill_sidisk_(keyword, &i_fill,
                       buffer, "", strlen(keyword), 0) ;

/*   Handling Planar Silicon (XY-Silicon)
*/
        if (strcmp(keyword,"SIXY")       == 0 ||
            strcmp(keyword,"LAYERSIXY")  == 0)
        geo_fill_sixy_(keyword, &i_fill,
                       buffer, "", strlen(keyword), 0) ;

/*   Handling Drift Chambers (Central Tracking)
*/
        if (strcmp(keyword,"DRIFT")        == 0 ||
            strcmp(keyword,"LAYERDRFANO")  == 0 ||
            strcmp(keyword,"OFFSETDRFANO") == 0 ||
            strcmp(keyword,"LAYERDRFCATHO")== 0)
         geo_fill_drift_(keyword, &nw_start, &i_fill,
                         buffer, "", strlen(keyword), 0) ;

/*   Handling Forward Tracking System
*/
        if (strcmp(keyword,"FORTRACKING") == 0 ||
            strcmp(keyword,"LAYERFTRK")   == 0)
        geo_fill_ftrk_(keyword, &nw_start, &i_fill,
                       buffer, "", strlen(keyword), 0) ;

/*   Handling Dipole
*/
        if (strcmp(keyword, "DIPOLE") == 0)
         geo_fill_dip_(keyword, &nw_start, &i_fill,
                       buffer, "", strlen(keyword), 0) ;

/*   Handling Solenoid
*/
        if (strcmp(keyword, "SOLENOID") == 0)
         geo_fill_sol_(keyword, &nw_start, &i_fill,
                       buffer, "", strlen(keyword), 0) ;

/*   Handling EM Calorimeter
*/
        if (strcmp(keyword, "EMCALORIMETER") == 0 ||
            strcmp(keyword, "CALORBOX") == 0)
         geo_fill_emcal_(keyword, &nw_start, &i_fill,
                       buffer, "", strlen(keyword), 0) ;


/*   Handling MUON system
*/
        if (strcmp(keyword, "MUON") == 0)
         geo_fill_muon_(keyword, &nw_start, &i_fill,
                       buffer, "", strlen(keyword), 0) ;

/*   Handling Absorbers
*/
        if (strcmp(keyword, "ABSORBER") == 0 ||
            strcmp(keyword, "ABSORBERBOX") == 0)
         geo_fill_absorber_(keyword, &nw_start, &i_fill,
                       buffer, "", strlen(keyword), 0) ;

/*   Handling Cherenkov counters
*/
        if (strcmp(keyword, "RICH") == 0)
         geo_fill_rich_(keyword, &nw_start, &i_fill,
                       buffer, "", strlen(keyword), 0) ;

/*   Handling Beam Vertex
*/
        if (strcmp(keyword,"BEAMVRTX") == 0) {
         geo_fill_beam_vrtx_(keyword, &i_fill, buffer, strlen(keyword)) ;
        }

/*   Handling Hits-on-Track 
*/
        if (strcmp(keyword, "HITSONTRACK") == 0) {
         geo_fill_hits_trk_(keyword, &i_fill, buffer, strlen(keyword)) ;
        }

/*   End passing accumulated data to FORTRAN
*/
       }

/*   Start handling information against next keyword
*/
       nw_start = 0 ;
       for (i=0; i<MAX_LEN_LINE/2; i++) {
        buffer[i] = 0.0 ;
       }
       upcase(w) ;
       keyword = w ;
       for (nkey = 0 ; ; nkey++) 
        if (geo_keys[nkey] == NULL) {
         printf("\n Unknown keyword -> %s \n", keyword) ;
         goto again ;
        }
        else if (strcmp(geo_keys[nkey], keyword) == 0) break ;
       }
      else {
       nw_start = nw ;
       keyword = geo_keys[nkey] ;
      }

       for (nw = nw_start; nw < n_par_key[nkey]; nw++) { 
        if (w == NULL || *w == *comment ) break ; 
        if (nw > 0) {
         if (*w != *inp_char_id) {
          buffer[nw] = atof(w) ;
          word[nw] = "" ;
         }
         else {
          if (strlen(w) > 1) word[nw] = w + 1 ;
          else {
           w = strtok(NULL,seps) ;
           word[nw] = w ;
          }
build_string :
          if (*(w + strlen(w) - 1) != *inp_char_id) {
           w = strtok(NULL,seps) ;
           strcat(word[nw],w) ;
           goto build_string ;
          }
         }
        }
        w = strtok(NULL, seps) ;
       }

       i_fill = 0 ;

       nwords_to_fortran = nw - nw_start ;

/*   Passing Material or Mixture parameters (maybe NOT all) to FORTRAN 
*/
       if (strcmp(keyword,"MIXTURE") == 0 || strcmp(keyword,"MATERIAL") == 0) {
        if (nw_start == 0 && nwords_to_fortran == n_par_key[nkey]) {
         for (i=0; i<n_par_key[nkey]; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) { 
           len_word = strlen(word[i]) - 1;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_mat_(keyword,&i,&i_fill,
                         0, word[i], strlen(keyword), len_word) ;
          }
         }
         i_fill = 1 ;
         geo_fill_mat_(keyword, &i, &i_fill,
                       buffer,"", strlen(keyword), 0) ;
         nw_start = -1 ;
        }
        else {
         for (i=nw_start; i<nw; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) { 
           len_word = strlen(word[i]) - 1;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_mat_(keyword,&i,&i_fill,
                         0, word[i], strlen(keyword), len_word) ;
          }
         }
        }
       }

/*   Passing General Detector characteristics (maybe not all) to FORTRAN
*/

       if (strcmp(keyword,"DETECTOR") == 0 ) {
         for (i=nw_start; i<nw; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) { 
           len_word = strlen(word[i]) - 1;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_detector_general_(keyword, &i, 
                                      word[i], strlen(keyword), len_word) ;
          }
         }
       }

/*   Passing BeamPipe parameters (maybe not all) to FORTRAN
*/

       if (strcmp(keyword,"BEAMPIPE") == 0 ) {
        if (nw_start == 0 && nwords_to_fortran == n_par_key[nkey]) {
         for (i=0; i<n_par_key[nkey]; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) { 
           len_word = strlen(word[i]) - 1;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_beampipe_(keyword, &i, &i_fill,
                          0, word[i], strlen(keyword), len_word) ;
          }
         }
         i_fill = 1 ;
         geo_fill_beampipe_(keyword, &i, &i_fill,
                        buffer,"", strlen(keyword), 0) ;
         nw_start = -1 ;
        }
        else {
         for (i=nw_start; i<nw; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) { 
           len_word = strlen(word[i]) - 1;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_beampipe_(keyword, &i, &i_fill,
                          0, word[i], strlen(keyword), len_word) ;
          }
         }
        }
       }

/*   Passing Barrel SVX parameters (maybe NOT all) to FORTRAN 
*/
       if (strcmp(keyword,"SIBARREL") == 0 || 
           strcmp(keyword,"LAYERSIB") == 0 ||
           strcmp(keyword,"WAFER")    == 0) {
        if (nw_start == 0 && nwords_to_fortran == n_par_key[nkey]) {
         for (i=0; i<n_par_key[nkey]; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) { 
           len_word = strlen(word[i]) - 1;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_sibarrel_(keyword,&i_fill,
                          buffer, word[i], strlen(keyword), len_word) ;
          }
         }
         i_fill = 1 ;
         geo_fill_sibarrel_(keyword, &i_fill,
                        buffer,"", strlen(keyword), 0) ;
         nw_start = -1 ;
        }
        else {
         for (i=nw_start; i<nw; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) { 
           len_word = strlen(word[i]) - 1;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_sibarrel_(keyword,&i_fill,
                          buffer, word[i], strlen(keyword), len_word) ;
          }
         }
        }
       }

/*   Passing Silicon Disk parameters (maybe NOT all) to FORTRAN 
*/
       if (strcmp(keyword,"SIDISK")    == 0 || 
           strcmp(keyword,"LAYERSIDI") == 0 ||
           strcmp(keyword,"WEDGE")     == 0) {
        if (nw_start == 0 && nwords_to_fortran == n_par_key[nkey]) {
         for (i=0; i<n_par_key[nkey]; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) { 
           len_word = strlen(word[i]) - 1;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_sidisk_(keyword,&i_fill,
                          buffer, word[i], strlen(keyword), len_word) ;
          }
         }
         i_fill = 1 ;
         geo_fill_sidisk_(keyword, &i_fill,
                        buffer,"", strlen(keyword), 0) ;
         nw_start = -1 ;
        }
        else {
         for (i=nw_start; i<nw; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) { 
           len_word = strlen(word[i]) - 1;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_sidisk_(keyword,&i_fill,
                          buffer, word[i], strlen(keyword), len_word) ;
          }
         }
        }
       }

/*   Passing XY-Silicon parameters (maybe NOT all) to FORTRAN 
*/
       if (strcmp(keyword,"SIXY") == 0 || strcmp(keyword,"LAYERSIXY") == 0) {
        if (nw_start == 0 && nwords_to_fortran == n_par_key[nkey]) {
         for (i=0; i<n_par_key[nkey]; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) { 
           len_word = strlen(word[i]) - 1;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_sixy_(keyword,&i_fill,
                          buffer, word[i], strlen(keyword), len_word) ;
          }
         }
         i_fill = 1 ;
         geo_fill_sixy_(keyword, &i_fill,
                        buffer,"", strlen(keyword), 0) ;
         nw_start = -1 ;
        }
        else {
         for (i=nw_start; i<nw; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) { 
           len_word = strlen(word[i]) - 1;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_sixy_(keyword,&i_fill,
                          buffer, word[i], strlen(keyword), len_word) ;
          }
         }
        }
       }

/*   Passing Drift Chambers (Central Tracking System) (maybe NOT all) to FORTRAN 
*/
       if (strcmp(keyword,"DRIFT") == 0) {
        if (nw_start == 0 && nwords_to_fortran == n_par_key[nkey]) {
         for (i=0; i<n_par_key[nkey]; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) { 
           len_word = strlen(word[i]) - 1;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_drift_(keyword,&i,&i_fill,
                          buffer, word[i], strlen(keyword), len_word) ;
          }
         }
         i_fill = 1 ;
         geo_fill_drift_(keyword, &i, &i_fill,
                        buffer,"", strlen(keyword), 0) ;
         nw_start = -1 ;
        }
        else {
         for (i=nw_start; i<nw; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) { 
           len_word = strlen(word[i]) - 1;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_drift_(keyword, &i, &i_fill,
                          buffer, word[i], strlen(keyword), len_word) ;
          }
         }
        }
       }

/*   Passing Forward Tracking System (maybe NOT all) to FORTRAN 
*/
       if (strcmp(keyword,"FORTRACKING") == 0) {
        if (nw_start == 0 && nwords_to_fortran == n_par_key[nkey]) {
         for (i=0; i<n_par_key[nkey]; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) { 
           len_word = strlen(word[i]) - 1;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_ftrk_(keyword,&i,&i_fill,
                          buffer, word[i], strlen(keyword), len_word) ;
          }
         }
         i_fill = 1 ;
         geo_fill_ftrk_(keyword, &i, &i_fill,
                        buffer,"", strlen(keyword), 0) ;
         nw_start = -1 ;
        }
        else {
         for (i=nw_start; i<nw; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) { 
           len_word = strlen(word[i]) - 1;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_ftrk_(keyword, &i, &i_fill,
                          buffer, word[i], strlen(keyword), len_word) ;
          }
         }
        }
       }

/*   Passing Dipole parameters to FORTRAN
*/
       if (strcmp(keyword,"DIPOLE") == 0) { 
        if (nw_start == 0 && nwords_to_fortran == n_par_key[nkey]) {
         for (i=0; i<n_par_key[nkey]; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) {
           len_word = strlen(word[i]) - 1 ;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_dip_(keyword, &i, &i_fill, 
                         buffer, word[i], strlen(keyword), len_word) ;
          }
         }
         i_fill = 1 ;
         geo_fill_dip_(keyword, &i, &i_fill,
                       buffer, "", strlen(keyword), 0) ;
         nw_start = -1 ;
        }
        else {
         for (i=nw_start; i<nw; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) {
           len_word = strlen(word[i]) - 1 ;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_dip_(keyword, &i, &i_fill, 
                         buffer, word[i], strlen(keyword), len_word) ;
          }
         }
        }
       }

/*   Passing Solenoid parameters to FORTRAN
*/
       if (strcmp(keyword,"SOLENOID") == 0) { 
        if (nw_start == 0 && nwords_to_fortran == n_par_key[nkey]) {
         for (i=0; i<n_par_key[nkey]; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) {
           len_word = strlen(word[i]) - 1 ;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_sol_(keyword, &i, &i_fill, 
                         buffer, word[i], strlen(keyword), len_word) ;
          }
         }
         i_fill = 1 ;
         geo_fill_sol_(keyword, &i, &i_fill,
                       buffer, "", strlen(keyword), 0) ;
         nw_start = -1 ;
        }
        else {
         for (i=nw_start; i<nw; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) {
           len_word = strlen(word[i]) - 1 ;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_sol_(keyword, &i, &i_fill, 
                         buffer, word[i], strlen(keyword), len_word) ;
          }
         }
        }
       }

/*   Passing EM Calorimeter parameters to FORTRAN
*/
       if (strcmp(keyword,"EMCALORIMETER") == 0 ||
            strcmp(keyword, "CALORBOX") == 0) { 
        if (nw_start == 0 && nwords_to_fortran == n_par_key[nkey]) {
         for (i=0; i<n_par_key[nkey]; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) {
           len_word = strlen(word[i]) - 1 ;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_emcal_(keyword, &i, &i_fill, 
                         buffer, word[i], strlen(keyword), len_word) ;
          }
         }
         i_fill = 1 ;
         geo_fill_emcal_(keyword, &i, &i_fill,
                       buffer, "", strlen(keyword), 0) ;
         nw_start = -1 ;
        }
        else {
         for (i=nw_start; i<nw; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) {
           len_word = strlen(word[i]) - 1 ;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_emcal_(keyword, &i, &i_fill, 
                         buffer, word[i], strlen(keyword), len_word) ;
          }
         }
        }
       }


/*   Passing MUON system parameters to FORTRAN
*/
       if (strcmp(keyword,"MUON") == 0) { 
        if (nw_start == 0 && nwords_to_fortran == n_par_key[nkey]) {
         for (i=0; i<n_par_key[nkey]; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) {
           len_word = strlen(word[i]) - 1 ;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_muon_(keyword, &i, &i_fill, 
                         buffer, word[i], strlen(keyword), len_word) ;
          }
         }
         i_fill = 1 ;
         geo_fill_muon_(keyword, &i, &i_fill,
                       buffer, "", strlen(keyword), 0) ;
         nw_start = -1 ;
        }
        else {
         for (i=nw_start; i<nw; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) {
           len_word = strlen(word[i]) - 1 ;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_muon_(keyword, &i, &i_fill, 
                         buffer, word[i], strlen(keyword), len_word) ;
          }
         }
        }
       }

/*   Passing Absorber parameters to FORTRAN
*/
       if (strcmp(keyword,"ABSORBER") == 0 ||
           strcmp(keyword,"ABSORBERBOX") == 0 ){ 
        if (nw_start == 0 && nwords_to_fortran == n_par_key[nkey]) {
         for (i=0; i<n_par_key[nkey]; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) {
           len_word = strlen(word[i]) - 1 ;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_absorber_(keyword, &i, &i_fill, 
                         buffer, word[i], strlen(keyword), len_word) ;
          }
         }
         i_fill = 1 ;
         geo_fill_absorber_(keyword, &i, &i_fill,
                       buffer, "", strlen(keyword), 0) ;
         nw_start = -1 ;
        }
        else {
         for (i=nw_start; i<nw; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) {
           len_word = strlen(word[i]) - 1 ;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_absorber_(keyword, &i, &i_fill, 
                         buffer, word[i], strlen(keyword), len_word) ;
          }
         }
        }
       }

/*   Passing Cherenkov counters parameters to FORTRAN
*/
       if (strcmp(keyword,"RICH") == 0) { 
        if (nw_start == 0 && nwords_to_fortran == n_par_key[nkey]) {
         for (i=0; i<n_par_key[nkey]; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) {
           len_word = strlen(word[i]) - 1 ;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_rich_(keyword, &i, &i_fill, 
                         buffer, word[i], strlen(keyword), len_word) ;
          }
         }
         i_fill = 1 ;
         geo_fill_rich_(keyword, &i, &i_fill,
                       buffer, "", strlen(keyword), 0) ;
         nw_start = -1 ;
        }
        else {
         for (i=nw_start; i<nw; i++) {
          if (word[i] != NULL && strcmp(word[i], "") != 0) {
           len_word = strlen(word[i]) - 1 ;
           len_word = (len_word > 0) ? len_word : 0 ;
           geo_fill_rich_(keyword, &i, &i_fill, 
                         buffer, word[i], strlen(keyword), len_word) ;
          }
         }
        }
       }

/*   Passing Beam Vertex parameters to FORTRAN
*/
        if (strcmp(keyword,"BEAMVRTX") == 0) {
         if (nw_start == 0 && nwords_to_fortran == n_par_key[nkey]) {
          i_fill = 1;
          geo_fill_beam_vrtx_(keyword, &i_fill, buffer, strlen(keyword)) ;
          nw_start = -1 ;
         }
        }

/*   Passing Hits-on-Track to FORTRAN
*/
        if (strcmp(keyword, "HITSONTRACK") == 0) {
         if (nw_start == 0 && nwords_to_fortran == n_par_key[nkey]) {
          i_fill = 1 ;
          geo_fill_hits_trk_(keyword, &i_fill, buffer, strlen(keyword)) ;
          nw_start = -1 ;
         }
        }

      goto again;

}

#include "mcfast_db.h"
#include <stdio.h>
#include <math.h>
#include "Mcf_Explorer_typedefs.h"
#include "Mcf_Explorer_externs.h"
static grShape *pshape_tail = NULL;
extern grShape *pshape_head;
int McfShapeFill(void);
int McfShapeFill(void)
{
    FILE* fl = stdout;
    char *cstring;
    static int maxstrlen = 100;
    char string[100];
    struct grShape *pshape; 
    int i, j, indx, idet;
    float color[3] ={1.0, 0.0, 0.0} ;
    int ndet = 0;
    float arrow_len;
    int iwaf = 0;
    /**** BEAM PIPE ******/
     fprintf(fl,"Beam pipe:    %3d declared.\n",*n_obj_bpipe);
    for (i=0;i<*n_obj_bpipe;i++) {
        fprintf(fl,"  %-6s r=%5.3G,%-5.3G  z0=%5.3G  zlen=%5.3G\n",
                bpipe[i].name,bpipe[i].rmin,bpipe[i].rmax,bpipe[i].z0,
                bpipe[i].zlen);
        ndet++;        
        cstring =(char *) malloc(maxstrlen*sizeof(char));
        sprintf(cstring,"dev%d_%s",ndet,bpipe[i].name);
        pshape = (grShape *) malloc(sizeof(grShape));
        if(pshape == NULL){
           printf("detector: Unable to allocate memory!\n");
           return;
        }
        if(pshape_head == NULL){  /*First link*/
           pshape_head = pshape;
        }else{
           pshape_tail->pnext_link = pshape;
        }
        pshape->pnext_link = NULL;
        pshape -> type 	  = CONE;
        pshape -> name         = cstring;
        pshape -> devtype  = BMPIPE;
        pshape -> xpos 	  = 0.;
        pshape -> ypos 	  = 0.;
        pshape -> zpos 	  = bpipe[i].z0;
        pshape -> color[0]	  = 1.0;
        pshape -> color[1]	  = 1.0;
        pshape -> color[2]	  = 0.0;
        pshape -> rotation[0]  = X_ROTATION;
        pshape -> rotation[1]  = Y_ROTATION;
        pshape -> rotation[2]  = Z_ROTATION;    
        pshape -> transparency = SHEER;
        pshape -> visibility   = WIREFRAME;
        pshape -> cutaway      = NOCUT;
        pshape -> angle_begin  = ANGLE_BEGIN;
        pshape -> angle_end    = ANGLE_END;
        pshape -> nsides       = DEFAULT_NSIDES;
        pshape -> frame        = NOFRAME;
        pshape -> xlen_out[0]  = 0.;
        pshape -> xlen_out[1]  = 0.;
        pshape -> ylen_out[0]  = 0.;
        pshape -> ylen_out[1]  = 0.;
        pshape -> zlen_out[0]  = 0.;
        pshape -> zlen_out[1]  = 0.;
        pshape -> xlen_inn[0]  = 0.;
        pshape -> xlen_inn[1]  = 0.;
        pshape -> ylen_inn[0]  = 0.;
        pshape -> ylen_inn[1]  = 0.;
        pshape -> zlen_inn[0]  = 0.;
        pshape -> zlen_inn[1]  = 0.;
        pshape -> half_z       = bpipe[i].zlen/2.;
        pshape -> rad_in_lowz  = bpipe[i].rmin;
        pshape -> rad_out_lowz = bpipe[i].rmax;
        pshape -> rad_in_hiz   = bpipe[i].rmin;
        pshape -> rad_out_hiz  = bpipe[i].rmax;
        pshape_tail = pshape;  
    }
    fprintf(fl,"Absorber:     %3d declared.\n",*n_obj_absorber);
    for (i=0;i<*n_obj_absorber;i++) {
      fprintf(fl,"  %-6s %s Mat=%s rlo=%5.3G,%-5.3G rhi=%5.3G,%-5.3G z0=%5.3G zlen=%5.3G\n",
      absorber[i].name,absorber[i].shape,absorber[i].material,
      absorber[i].rmin[0],absorber[i].rmax[0],
      absorber[i].rmin[1],absorber[i].rmax[1],
      absorber[i].z0,absorber[i].zlen);
        ndet++;        
        cstring =(char *) malloc(maxstrlen*sizeof(char));
        sprintf(cstring,"dev%d_%s",ndet,absorber[i].name);
        pshape = (grShape *) malloc(sizeof(grShape));
        if(pshape == NULL){
           printf("detector: Unable to allocate memory!\n");
           return;
        }
        if(pshape_head == NULL){  /*First link*/
           pshape_head = pshape;
        }else{
           pshape_tail->pnext_link = pshape;
        }
        pshape->pnext_link = NULL;
        pshape -> type 	       = CONE;
        pshape -> name         = cstring;
        pshape -> devtype      = ABSORBER;  
        pshape -> xpos 	       = 0.;
        pshape -> ypos 	       = 0.;
        pshape -> zpos 	       = absorber[i].z0;
        pshape -> color[0]     = 0.7;
        pshape -> color[1]     = 0.7;
        pshape -> color[2]     = 0.2;
        pshape -> rotation[0]  = X_ROTATION;
        pshape -> rotation[1]  = Y_ROTATION;
        pshape -> rotation[2]  = Z_ROTATION;    
        pshape -> transparency = SHEER;
        pshape -> visibility   = SOLID;
        pshape -> cutaway      = NOCUT;
        pshape -> angle_begin  = ANGLE_BEGIN;
        pshape -> angle_end    = ANGLE_END;
        pshape -> nsides       = DEFAULT_NSIDES;
        pshape -> frame        = NOFRAME;
        pshape -> xlen_out[0]  = 0.;
        pshape -> xlen_out[1]  = 0.;
        pshape -> ylen_out[0]  = 0.;
        pshape -> ylen_out[1]  = 0.;
        pshape -> zlen_out[0]  = 0.;
        pshape -> zlen_out[1]  = 0.;
        pshape -> xlen_inn[0]  = 0.;
        pshape -> xlen_inn[1]  = 0.;
        pshape -> ylen_inn[0]  = 0.;
        pshape -> ylen_inn[1]  = 0.;
        pshape -> zlen_inn[0]  = 0.;
        pshape -> zlen_inn[1]  = 0.;
        pshape -> half_z       = absorber[i].zlen/2.;
        pshape -> rad_in_lowz  = absorber[i].rmin[0];
        pshape -> rad_out_lowz = absorber[i].rmax[0];
        pshape -> rad_in_hiz   = absorber[i].rmin[1];
        pshape -> rad_out_hiz  = absorber[i].rmax[1];
        pshape_tail = pshape;
    }
    fprintf(fl,"XY Absorber:      %3d declared.\n",*n_obj_absorberbox);
    for (i=0;i<*n_obj_absorberbox;i++) {
    fprintf(fl, "absorber, %f, %f, %f, %f, %f, %f, %f, %f, %f\n",
            absorberbox[i].xlimit[0], absorberbox[i].xlimit[1],
            absorberbox[i].xlimit_gap[0], absorberbox[i].xlimit_gap[1],
            absorberbox[i].ylimit[0], absorberbox[i].ylimit[1],
            absorberbox[i].ylimit_gap[0], absorberbox[i].ylimit_gap[1],
            absorberbox[i].zlen);
             
        ndet++;        
        cstring =(char *) malloc(maxstrlen*sizeof(char));
        sprintf(cstring,"dev%d_%s",ndet,absorberbox[i].name);
        pshape = (grShape *) malloc(sizeof(grShape));
        if(pshape == NULL){
           printf("detector: Unable to allocate memory!\n");
           return;
        }
        if(pshape_head == NULL){  /*First link*/
           pshape_head = pshape;
        }else{
           pshape_tail->pnext_link = pshape;
        }
        pshape->pnext_link = NULL;
        pshape -> type 	       = BOX;
        pshape -> name         = cstring;
        pshape -> devtype      = ABSORBERXY;  
        pshape -> xpos 	       = 0.;
        pshape -> ypos 	       = 0.;
        pshape -> zpos 	       = absorberbox[i].z0;
        pshape -> color[0]     = 1.0;
        pshape -> color[1]     = 0.68;
        pshape -> color[2]     = 0.45;
        pshape -> rotation[0]  = X_ROTATION;
        pshape -> rotation[1]  = Y_ROTATION;
        pshape -> rotation[2]  = Z_ROTATION;    
        pshape -> transparency = SHEER;
        pshape -> visibility   = SOLID;
        pshape -> cutaway      = NOCUT;
        pshape -> angle_begin  = ANGLE_BEGIN;
        pshape -> angle_end    = ANGLE_END;
        pshape -> nsides       = DEFAULT_NSIDES;
        pshape -> frame        = NOFRAME;
        pshape -> xlen_out[0]  = absorberbox[i].xlimit[0];
        pshape -> xlen_out[1]  = absorberbox[i].xlimit[1];
        pshape -> ylen_out[0]  = absorberbox[i].ylimit[0];
        pshape -> ylen_out[1]  = absorberbox[i].ylimit[1];
        pshape -> zlen_out[0]  = -0.5*absorberbox[i].zlen;
        pshape -> zlen_out[1]  =  0.5*absorberbox[i].zlen;
        pshape -> xlen_inn[0]  = absorberbox[i].xlimit_gap[0];
        pshape -> xlen_inn[1]  = absorberbox[i].xlimit_gap[1];
        pshape -> ylen_inn[0]  = absorberbox[i].ylimit_gap[0];
        pshape -> ylen_inn[1]  = absorberbox[i].ylimit_gap[1];
        pshape -> zlen_inn[0]  = -0.5*absorberbox[i].zlen;
        pshape -> zlen_inn[1]  =  0.5*absorberbox[i].zlen;
        pshape -> half_z       = 0.;
        pshape -> rad_in_lowz  = 0.;
        pshape -> rad_out_lowz = 0.;
        pshape -> rad_in_hiz   = 0.;
        pshape -> rad_out_hiz  = 0.;
        pshape_tail = pshape;
    }
    fprintf(fl,"Dipole:       %3d declared.\n",*n_obj_dipole);
    for (i=0;i<*n_obj_dipole;i++) {
      fprintf(fl,"  %-6s Mat=%s B=%5.3G x=%5.3G,%-5.3G y=%5.3G,%-5.3G z0=%5.3G zlen=%5.3G\n",
      dipole[i].name,dipole[i].mat_fill,dipole[i].bfield,
      dipole[i].xmin,dipole[i].xmax,
      dipole[i].ymin,dipole[i].ymax,
      dipole[i].z0,dipole[i].zlen);
        ndet++;     
        cstring =(char *) malloc(maxstrlen*sizeof(char));
        sprintf(cstring,"dev%d_%s_frame",ndet,dipole[i].name);
        pshape = (grShape *) malloc(sizeof(grShape));
        if(pshape == NULL){
           printf("detector: Unable to allocate memory!\n");
           return;
        }
        if(pshape_head == NULL){  /*First link*/
           pshape_head = pshape;
        }else{
           pshape_tail->pnext_link = pshape;
        }
        pshape->pnext_link = NULL;
        pshape -> type 	       = BOX;
        pshape -> name         = cstring;
        pshape -> devtype      = DIPOLE;  
        pshape -> xpos 	       = 0.5*(dipole[i].xmin + dipole[i].xmax);
        pshape -> ypos 	       = 0.5*(dipole[i].ymin + dipole[i].ymax);
        pshape -> zpos 	       = dipole[i].z0; 
        pshape -> color[0]     = 0.0;
        pshape -> color[1]     = 0.0;
        pshape -> color[2]     = 1.0;
        pshape -> rotation[0]  = X_ROTATION;
        pshape -> rotation[1]  = Y_ROTATION;
        pshape -> rotation[2]  = Z_ROTATION;    
        pshape -> transparency = SHEER;
        pshape -> visibility   = WIREFRAME;
        pshape -> cutaway      = NOCUT;
        pshape -> angle_begin  = ANGLE_BEGIN;
        pshape -> angle_end    = ANGLE_END;
        pshape -> nsides       = DEFAULT_NSIDES;
        pshape -> frame        = NOFRAME;
        pshape -> xlen_out[0]  =
                -0.5*(dipole[i].xmax-dipole[i].xmin)-dipole[i].thick_boun[0];
        pshape -> xlen_out[1]  = 
                 0.5*(dipole[i].xmax-dipole[i].xmin)+dipole[i].thick_boun[1];
        pshape -> ylen_out[0]  =
                -0.5*(dipole[i].ymax-dipole[i].ymin)-dipole[i].thick_boun[2];
        pshape -> ylen_out[1]  =
                 0.5*(dipole[i].ymax-dipole[i].ymin)+dipole[i].thick_boun[3];
        pshape -> zlen_out[0]  = -0.5*dipole[i].zlen-dipole[i].thick_boun[4];
        pshape -> zlen_out[1]  =  0.5*dipole[i].zlen+dipole[i].thick_boun[5];
        pshape -> xlen_inn[0]  = -0.5*(dipole[i].xmax-dipole[i].xmin);
        pshape -> xlen_inn[1]  =  0.5*(dipole[i].xmax-dipole[i].xmin);
        pshape -> ylen_inn[0]  = -0.5*(dipole[i].ymax-dipole[i].ymin);
        pshape -> ylen_inn[1]  =  0.5*(dipole[i].ymax-dipole[i].ymin);
        pshape -> zlen_inn[0]  = -0.5*dipole[i].zlen;
        pshape -> zlen_inn[1]  = 0.5*dipole[i].zlen;
        pshape -> half_z       = 0.;
        pshape -> rad_in_lowz  = 0.;
        pshape -> rad_out_lowz = 0.;
        pshape -> rad_in_hiz   = 0.;
        pshape -> rad_out_hiz  = 0.;
        pshape_tail = pshape;
    /*  Dipoles also get two tubes to indicate field strength and direction */
        ndet++;        
        cstring =(char *) malloc(maxstrlen*sizeof(char));
        sprintf(cstring,"dev%d_%s_stem",ndet,dipole[i].name);
        pshape = (grShape *) malloc(sizeof(grShape));
        if(pshape == NULL){
           printf("detector: Unable to allocate memory!\n");
           return;
        }
        if(pshape_head == NULL){  /*First link*/
           pshape_head = pshape;
        }else{
           pshape_tail->pnext_link = pshape;
        }
           arrow_len=0.5*sqrt(
              pow((dipole[i].xmax-dipole[i].xmin)*dipole[i].dircos[0],2.)
             +pow((dipole[i].ymax-dipole[i].ymin)*dipole[i].dircos[1],2.)  
             +pow(dipole[i].zlen*dipole[i].dircos[2],2));
        pshape->pnext_link = NULL;
        pshape -> type 	       = CONE;
        pshape -> name         = cstring;
        pshape -> devtype      = DIPOLE;  
        pshape -> xpos 	       = 0.5*(dipole[i].xmin + dipole[i].xmax);
        pshape -> ypos 	       = 0.5*(dipole[i].ymin + dipole[i].ymax);
        pshape -> zpos 	       = dipole[i].z0; 
        pshape -> color[0]     = 0.5;
        pshape -> color[1]     = 0.5;
        pshape -> color[2]     = 0.0;
        pshape -> rotation[0]  = dipole[i].dircos[0];
        pshape -> rotation[1]  = dipole[i].dircos[1];
        pshape -> rotation[2]  = dipole[i].dircos[2];    
        pshape -> transparency = SHEER;
        pshape -> visibility   = SOLID;
        pshape -> cutaway      = NOCUT;
        pshape -> angle_begin  = ANGLE_BEGIN;
        pshape -> angle_end    = ANGLE_END;
        pshape -> nsides       = DEFAULT_NSIDES;
        pshape -> frame        = NOFRAME;
        pshape -> xlen_out[0]  = 0.;
        pshape -> xlen_out[1]  = 0.;
        pshape -> ylen_out[0]  = 0.;
        pshape -> ylen_out[1]  = 0.;
        pshape -> zlen_out[0]  = 0.;
        pshape -> zlen_out[1]  = 0.;
        pshape -> xlen_inn[0]  = 0.;
        pshape -> xlen_inn[1]  = 0.;
        pshape -> ylen_inn[0]  = 0.;
        pshape -> ylen_inn[1]  = 0.;
        pshape -> zlen_inn[0]  = 0.;
        pshape -> zlen_inn[1]  = 0.;
        pshape -> half_z       = arrow_len;
        pshape -> rad_in_lowz  = dipole[i].bfield;
        pshape -> rad_out_lowz = dipole[i].bfield;
        pshape -> rad_in_hiz   = dipole[i].bfield;
        pshape -> rad_out_hiz  = dipole[i].bfield;
        pshape_tail = pshape;
        ndet++;        
        cstring =(char *) malloc(maxstrlen*sizeof(char));
        sprintf(cstring,"dev%d_%s_point",ndet,dipole[i].name);
        pshape = (grShape *) malloc(sizeof(grShape));
        if(pshape == NULL){
           printf("detector: Unable to allocate memory!\n");
           return;
        }
        if(pshape_head == NULL){  /*First link*/
           pshape_head = pshape;
        }else{
           pshape_tail->pnext_link = pshape;
        }
        pshape->pnext_link = NULL;
        pshape -> type 	       = CONE;
        pshape -> name         = cstring;
        pshape -> devtype      = DIPOLE;  
        pshape -> xpos 	       = 0.5*(dipole[i].xmin + dipole[i].xmax);
        pshape -> ypos 	       = 0.5*(dipole[i].ymin + dipole[i].ymax) +
                                 arrow_len;
        pshape -> zpos 	       = dipole[i].z0; 
        pshape -> color[0]     = 0.5;
        pshape -> color[1]     = 0.5;
        pshape -> color[2]     = 0.0;
        pshape -> rotation[0]  = dipole[i].dircos[0];
        pshape -> rotation[1]  = dipole[i].dircos[1];
        pshape -> rotation[2]  = dipole[i].dircos[2];    
        pshape -> transparency = SHEER;
        pshape -> visibility   = SOLID;
        pshape -> cutaway      = NOCUT;
        pshape -> angle_begin  = ANGLE_BEGIN;
        pshape -> angle_end    = ANGLE_END;
        pshape -> nsides       = DEFAULT_NSIDES;
        pshape -> frame        = NOFRAME;
        pshape -> xlen_out[0]  = 0.;
        pshape -> xlen_out[1]  = 0.;
        pshape -> ylen_out[0]  = 0.;
        pshape -> ylen_out[1]  = 0.;
        pshape -> zlen_out[0]  = 0.;
        pshape -> zlen_out[1]  = 0.;
        pshape -> xlen_inn[0]  = 0.;
        pshape -> xlen_inn[1]  = 0.;
        pshape -> ylen_inn[0]  = 0.;
        pshape -> ylen_inn[1]  = 0.;
        pshape -> zlen_inn[0]  = 0.;
        pshape -> zlen_inn[1]  = 0.;
        pshape -> half_z       = arrow_len/10.;
        pshape -> rad_in_lowz  = 10*dipole[i].bfield;
        pshape -> rad_out_lowz = 10*dipole[i].bfield;
        pshape -> rad_in_hiz   = 0.0;
        pshape -> rad_out_hiz  = 0.0;
        pshape_tail = pshape;
    
    }
    fprintf(fl,"Solenoid:     %3d declared.\n",*n_obj_solenoid);
    for (i=0;i<*n_obj_solenoid;i++) {
        fprintf(fl,"  %-6s Mat=%s r=%5.3G,%-5.3G  z0=%5.3G  zlen=%5.3G\n",
                solenoid[i].name,solenoid[i].mat_fill,
                solenoid[i].rmin,solenoid[i].rmax,solenoid[i].z0,solenoid[i].zlen);
        fprintf(fl,"     rlo \"%s\" rhi \"%s\" zlo \"%s\" zhi \"%s\"\n",
                solenoid[i].mat_boun[0],solenoid[i].mat_boun[1],solenoid[i].mat_boun[2],
                solenoid[i].mat_boun[3]);
        ndet++;        
        cstring =(char *) malloc(maxstrlen*sizeof(char));
        sprintf(cstring,"dev%d_%s",ndet,solenoid[i].name);
        pshape = (grShape *) malloc(sizeof(grShape));
        if(pshape == NULL){
           printf("detector: Unable to allocate memory!\n");
           return;
        }
        if(pshape_head == NULL){  /*First link*/
           pshape_head = pshape;
        }else{
           pshape_tail->pnext_link = pshape;
        }
        pshape->pnext_link = NULL;
        pshape -> type 	       = CONE;
        pshape -> name         = cstring;
        pshape -> devtype      = SOLENOID;  
        pshape -> xpos 	       = 0.;
        pshape -> ypos 	       = 0.;
        pshape -> zpos 	       = solenoid[i].z0;
        pshape -> color[0]     = color[0];
        pshape -> color[1]     = color[1];
        pshape -> color[2]     = color[2];
        pshape -> rotation[0]  = X_ROTATION;
        pshape -> rotation[1]  = Y_ROTATION;
        pshape -> rotation[2]  = Z_ROTATION;    
        pshape -> transparency = SHEER;
        pshape -> visibility   = WIREFRAME;
        pshape -> cutaway      = NOCUT;
        pshape -> angle_begin  = ANGLE_BEGIN;
        pshape -> angle_end    = ANGLE_END;
        pshape -> nsides       = DEFAULT_NSIDES;
        pshape -> frame        = NOFRAME;
        pshape -> xlen_out[0]  = 0.;
        pshape -> xlen_out[1]  = 0.;
        pshape -> ylen_out[0]  = 0.;
        pshape -> ylen_out[1]  = 0.;
        pshape -> zlen_out[0]  = 0.;
        pshape -> zlen_out[1]  = 0.;
        pshape -> xlen_inn[0]  = 0.;
        pshape -> xlen_inn[1]  = 0.;
        pshape -> ylen_inn[0]  = 0.;
        pshape -> ylen_inn[1]  = 0.;
        pshape -> zlen_inn[0]  = 0.;
        pshape -> zlen_inn[1]  = 0.;
        pshape -> half_z       = solenoid[i].zlen/2.;
        pshape -> rad_in_lowz  = solenoid[i].rmin;
        pshape -> rad_out_lowz = solenoid[i].rmax;
        pshape -> rad_in_hiz   = solenoid[i].rmin;
        pshape -> rad_out_hiz  = solenoid[i].rmax;
        pshape_tail = pshape;
    }
    fprintf(fl,"Drift cham:   %3d declared.\n",*n_obj_drift);
    if (*n_obj_drift>0) {
      for (i=0;i<*n_obj_drift;i++) {
        fprintf(fl,"  %-6s Mat=%s Nano,cath=%d,%-d r=%5.3G,%-5.3G  z0=%5.3G  zlen=%5.3G\n",
                drift[i].name,drift[i].material,
                drift[i].num_anode,drift[i].num_cathode,
                drift[i].rmin,drift[i].rmax,drift[i].z0,drift[i].zlen);
        ndet++;        
        cstring =(char *) malloc(maxstrlen*sizeof(char));
        sprintf(cstring,"dev%d_%s",ndet,drift[i].name);
        pshape = (grShape *) malloc(sizeof(grShape));
        if(pshape == NULL){
           printf("detector: Unable to allocate memory!\n");
           return;
        }
        if(pshape_head == NULL){  /*First link*/
           pshape_head = pshape;
        }else{
           pshape_tail->pnext_link = pshape;
        }
        pshape->pnext_link = NULL;
        pshape -> type 	       = CONE;
        pshape -> name         = cstring;
        pshape -> devtype      = DRTCHMB;  
        pshape -> xpos 	       = 0.;
        pshape -> ypos 	       = 0.;
        pshape -> zpos 	       = drift[i].z0;
        pshape -> color[0]     = 0.0;
        pshape -> color[1]     = 0.7;
        pshape -> color[2]     = 0.7;
        pshape -> rotation[0]  = X_ROTATION;
        pshape -> rotation[1]  = Y_ROTATION;
        pshape -> rotation[2]  = Z_ROTATION;    
        pshape -> transparency = SHEER;
        pshape -> visibility   = WIREFRAME;
        pshape -> cutaway      = NOCUT;
        pshape -> angle_begin  = ANGLE_BEGIN;
        pshape -> angle_end    = ANGLE_END;
        pshape -> nsides       = DEFAULT_NSIDES;
        pshape -> frame        = NOFRAME;
        pshape -> xlen_out[0]  = 0.;
        pshape -> xlen_out[1]  = 0.;
        pshape -> ylen_out[0]  = 0.;
        pshape -> ylen_out[1]  = 0.;
        pshape -> zlen_out[0]  = 0.;
        pshape -> zlen_out[1]  = 0.;
        pshape -> xlen_inn[0]  = 0.;
        pshape -> xlen_inn[1]  = 0.;
        pshape -> ylen_inn[0]  = 0.;
        pshape -> ylen_inn[1]  = 0.;
        pshape -> zlen_inn[0]  = 0.;
        pshape -> zlen_inn[1]  = 0.;
        pshape -> half_z       = drift[i].zlen/2.;
        pshape -> rad_in_lowz  = drift[i].rmin;
        pshape -> rad_out_lowz = drift[i].rmax;
        pshape -> rad_in_hiz   = drift[i].rmin;
        pshape -> rad_out_hiz  = drift[i].rmax;
        pshape_tail = pshape;
      }
      fprintf(fl,"    Total anodes:         %3d declared.\n",*n_obj_layerdrfano);
      fprintf(fl,"    Total anode offsets:  %3d declared.\n",*n_obj_offsetdrfano);
      fprintf(fl,"    Total cathodes:       %3d declared.\n",*n_obj_layerdrfcatho);
    }

    fprintf(fl,"Si barrel:    %3d declared.\n",*n_obj_sibarrel);
    if (*n_obj_sibarrel>0) {
      for (i=0;i<*n_obj_sibarrel;i++) {
        fprintf(fl,"  %-6s Nlay=%d z0=%G\n",sibarrel[i].name,sibarrel[i].nlyr,
           sibarrel[i].z0_global);
      }
      fprintf(fl,"    Total layers:         %3d declared.\n",*n_obj_layersib);
      fprintf(fl,"    Total wafers:         %3d declared.\n",*n_obj_wafer);
      for (i=0;i<*n_obj_layersib;i++) {
        ndet++;        
        cstring =(char *) malloc(maxstrlen*sizeof(char));
        sprintf(cstring,"dev%d_%s_%d_lyr_%d",
        ndet,sibarrel[layersib[i].det-1].name,layersib[i].det,layersib[i].lyr);
        pshape = (grShape *) malloc(sizeof(grShape));
        if(pshape == NULL){
           printf("detector: Unable to allocate memory!\n");
           return;
        }
        if(pshape_head == NULL){  /*First link*/
           pshape_head = pshape;
        }else{
           pshape_tail->pnext_link = pshape;
        }
        idet = layersib[i].det - 1;
        pshape->pnext_link = NULL;
        pshape -> type 	       = CONE;
        pshape -> name         = cstring;
        pshape -> devtype      = SIBAR;  
        pshape -> xpos 	       = 0.;
        pshape -> ypos 	       = 0.;
        pshape -> zpos 	       = sibarrel[idet].z0_global;
        pshape -> color[0]     = color[0];
        pshape -> color[1]     = color[1];
        pshape -> color[2]     = color[2];
        pshape -> rotation[0]  = X_ROTATION;
        pshape -> rotation[1]  = Y_ROTATION;
        pshape -> rotation[2]  = Z_ROTATION;    
        pshape -> transparency = SHEER;
        pshape -> visibility   = WIREFRAME;
        pshape -> cutaway      = NOCUT;
        pshape -> angle_begin  = ANGLE_BEGIN;
        pshape -> angle_end    = ANGLE_END;
        pshape -> nsides       = layersib[i].nwaf;
        pshape -> frame        = NOFRAME;
        pshape -> xlen_out[0]  = 0.;
        pshape -> xlen_out[1]  = 0.;
        pshape -> ylen_out[0]  = 0.;
        pshape -> ylen_out[1]  = 0.;
        pshape -> zlen_out[0]  = 0.;
        pshape -> zlen_out[1]  = 0.;
        pshape -> xlen_inn[0]  = 0.;
        pshape -> xlen_inn[1]  = 0.;
        pshape -> ylen_inn[0]  = 0.;
        pshape -> ylen_inn[1]  = 0.;
        pshape -> zlen_inn[0]  = 0.;
        pshape -> zlen_inn[1]  = 0.;
        pshape -> half_z       = layersib[i].zlen/2.;
        pshape -> rad_in_lowz  = sqrt(layersib[i].delta*layersib[i].delta + 
                                 (layersib[i].width*layersib[i].width /4.));
        pshape -> rad_out_lowz = sqrt(layersib[i].delta*layersib[i].delta + 
                                 (layersib[i].width*layersib[i].width /4.))
                                 + layersib[i].thick;
        pshape -> rad_in_hiz   = sqrt(layersib[i].delta*layersib[i].delta + 
                                 (layersib[i].width*layersib[i].width /4.));
        pshape -> rad_out_hiz  = sqrt(layersib[i].delta*layersib[i].delta + 
                                 (layersib[i].width*layersib[i].width /4.)) 
                                 + layersib[i].thick;
        pshape_tail = pshape;
      }
    }
    fprintf(fl,"Si disks:     %3d declared.\n",*n_obj_sidisk);
    if (*n_obj_sidisk>0) {
      for (i=0;i<*n_obj_sidisk;i++) {
        fprintf(fl,"  %-6s Nlay=%d z0=%G\n",sidisk[i].name,sidisk[i].nlyr,
           sidisk[i].zpos);
      }
      fprintf(fl,"    Total layers:         %3d declared.\n",*n_obj_layersidi);
      fprintf(fl,"    Total wedges:         %3d declared.\n",*n_obj_wedge);
      for (i=0;i<*n_obj_layersidi;i++) {
        ndet++;        
        cstring =(char *) malloc(maxstrlen*sizeof(char));
        sprintf(cstring,"dev%d_%s_%d_lyr_%d",
        ndet,sidisk[layersidi[i].det-1].name,layersidi[i].det,layersidi[i].lyr);
        pshape = (grShape *) malloc(sizeof(grShape));
        if(pshape == NULL){
           printf("detector: Unable to allocate memory!\n");
           return;
        }
        if(pshape_head == NULL){  /*First link*/
           pshape_head = pshape;
        }else{
           pshape_tail->pnext_link = pshape;
        }
        pshape->pnext_link = NULL;
        idet = layersidi[i].det - 1;
        pshape -> type 	       = CONE;
        pshape -> name         = cstring;
        pshape -> devtype      = SIDISK;  
        pshape -> xpos 	       = 0.;
        pshape -> ypos 	       = 0.;
        pshape -> zpos 	       = sidisk[idet].zpos +
                                    layersidi[i].z_local;
        pshape -> color[0]     = color[0];
        pshape -> color[1]     = color[1];
        pshape -> color[2]     = color[2];
        pshape -> rotation[0]  = X_ROTATION;
        pshape -> rotation[1]  = Y_ROTATION;
        pshape -> rotation[2]  = Z_ROTATION;    
        pshape -> transparency = SHEER;
        pshape -> visibility   = WIREFRAME;
        pshape -> cutaway      = CUT;
        pshape -> angle_begin  = layersidi[i].phi[1];
        pshape -> angle_end    = layersidi[i].phi[2];
        pshape -> nsides       = layersidi[i].nwed;
        pshape -> frame        = NOFRAME;
        pshape -> xlen_out[0]  = 0.;
        pshape -> xlen_out[1]  = 0.;
        pshape -> ylen_out[0]  = 0.;
        pshape -> ylen_out[1]  = 0.;
        pshape -> zlen_out[0]  = 0.;
        pshape -> zlen_out[1]  = 0.;
        pshape -> xlen_inn[0]  = 0.;
        pshape -> xlen_inn[1]  = 0.;
        pshape -> ylen_inn[0]  = 0.;
        pshape -> ylen_inn[1]  = 0.;
        pshape -> zlen_inn[0]  = 0.;
        pshape -> zlen_inn[1]  = 0.;
        pshape -> half_z       = layersidi[i].thick/2.;
        pshape -> rad_in_lowz  = layersidi[i].rmin;
        pshape -> rad_out_lowz = layersidi[i].rmax;
        pshape -> rad_in_hiz   = layersidi[i].rmin;
        pshape -> rad_out_hiz  = layersidi[i].rmax;
        pshape_tail = pshape;
      }
    }
    fprintf(fl,"Si XY:        %3d declared.\n",*n_obj_sixy);
    if (*n_obj_sixy>0) {
      for (i=0;i<*n_obj_sixy;i++) {
        fprintf(fl,"  %-6s Nlay=%d z0=%G\n",sixy[i].name,sixy[i].nly,
           sixy[i].zpos);
      }
      fprintf(fl,"    Total layers:         %3d declared.\n",*n_obj_layersixy);
      for (i=0;i<*n_obj_layersixy;i++) {
        ndet++;
        idet = layersixy[i].det - 1 ;        
        cstring =(char *) malloc(maxstrlen*sizeof(char));
        sprintf(cstring,"dev%d_%s_%d_lyr_%d",
        ndet,sixy[idet].name,layersixy[i].det,layersixy[i].lyr);
        pshape = (grShape *) malloc(sizeof(grShape));
        if(pshape == NULL){
           printf("detector: Unable to allocate memory!\n");
           return;
        }
        if(pshape_head == NULL){  /*First link*/
           pshape_head = pshape;
        }else{
           pshape_tail->pnext_link = pshape;
        }
        pshape->pnext_link = NULL;
        pshape -> type 	       = BOX;
        pshape -> name         = cstring;
        pshape -> devtype      = SIXY;  
        pshape -> xpos 	       = 0.5*(layersixy[i].xmax+layersixy[i].xmin);
        pshape -> ypos 	       = 0.5*(layersixy[i].ymax+layersixy[i].ymin);
        pshape -> zpos 	       = layersixy[i].z_local + sixy[idet].zpos;
        pshape -> color[0]     = 0.0;
        pshape -> color[1]     = 1.0;
        pshape -> color[2]     = 0.0;
        pshape -> rotation[0]  = X_ROTATION;
        pshape -> rotation[1]  = Y_ROTATION;
        pshape -> rotation[2]  = Z_ROTATION;    
        pshape -> transparency = SHEER;
        pshape -> visibility   = SOLID;
        pshape -> cutaway      = NOCUT;
        pshape -> angle_begin  = ANGLE_BEGIN;
        pshape -> angle_end    = ANGLE_END;
        pshape -> nsides       = DEFAULT_NSIDES;
        pshape -> frame        = NOFRAME;
        pshape -> xlen_out[0]  = layersixy[i].xmin;
        pshape -> xlen_out[1]  = layersixy[i].xmax;
        pshape -> ylen_out[0]  = layersixy[i].ymin;
        pshape -> ylen_out[1]  = layersixy[i].ymax;
        pshape -> zlen_out[0]  = -0.5*layersixy[i].thick;
        pshape -> zlen_out[1]  =  0.5*layersixy[i].thick;
        pshape -> xlen_inn[0]  = layersixy[i].xmin_gap;
        pshape -> xlen_inn[1]  = layersixy[i].xmax_gap;
        pshape -> ylen_inn[0]  = layersixy[i].ymin_gap;
        pshape -> ylen_inn[1]  = layersixy[i].ymax_gap;
        pshape -> zlen_inn[0]  = -0.5*layersixy[i].thick;
        pshape -> zlen_inn[1]  =  0.5*layersixy[i].thick;
        pshape -> half_z       = 0.;
        pshape -> rad_in_lowz  = 0.;
        pshape -> rad_out_lowz = 0.;
        pshape -> rad_in_hiz   = 0.;
        pshape -> rad_out_hiz  = 0.;
        pshape_tail = pshape;
      }
    }
    fprintf(fl,"ZRect pixel device:        %3d declared.\n",*n_obj_sizrect);
    if (*n_obj_sizrect>0) {
      for (i=0;i<*n_obj_sizrect;i++) {
        fprintf(fl,"  %-6s Nlay=%d  position =(%G,%G,%G)\n",
           sizrect[i].name,sizrect[i].nlayer,
           sizrect[i].xpos, sizrect[i].ypos, sizrect[i].zpos);
      }
      fprintf(fl,"    Total layers:         %3d declared.\n",*n_obj_layersizrect);
      for (i=0;i<*n_obj_layersizrect;i++) {
        ndet++;
        idet = layersizrect[i].det - 1 ;
        for(j=i; i < *n_obj_wfrsizrect; j++){
           if(layersizrect[i].lyr == wfrsizrect[j].lyr &&
              layersizrect[i].det == wfrsizrect[j].det){
              iwaf = j;
              break;
           }
        }
        cstring =(char *) malloc(maxstrlen*sizeof(char));
        sprintf(cstring,"dev%d_%s_%d_lyr_%d",
        ndet,sizrect[idet].name,layersizrect[i].det,layersizrect[i].lyr);
        pshape = (grShape *) malloc(sizeof(grShape));
        if(pshape == NULL){
           printf("detector: Unable to allocate memory!\n");
           return;
        }
        if(pshape_head == NULL){  /*First link*/
           pshape_head = pshape;
        }else{
           pshape_tail->pnext_link = pshape;
        }
        pshape->pnext_link = NULL;
        pshape -> type 	       = BOX;
        pshape -> name         = cstring;
        pshape -> devtype      = ZRECT;  
        pshape -> xpos 	       = sizrect[idet].xpos;
        pshape -> ypos 	       = sizrect[idet].ypos;
        pshape -> zpos 	       = layersizrect[i].zlayerlocal
                                 + sizrect[idet].zpos;
        pshape -> color[0]     = 0.0;
        pshape -> color[1]     = 1.0;
        pshape -> color[2]     = 0.0;
        pshape -> rotation[0]  = X_ROTATION;
        pshape -> rotation[1]  = Y_ROTATION;
        pshape -> rotation[2]  = Z_ROTATION;    
        pshape -> transparency = SHEER;
        pshape -> visibility   = SOLID;
        pshape -> cutaway      = NOCUT;
        pshape -> angle_begin  = ANGLE_BEGIN;
        pshape -> angle_end    = ANGLE_END;
        pshape -> nsides       = DEFAULT_NSIDES;
        pshape -> frame        = NOFRAME;
        pshape -> xlen_out[0]  = -layersizrect[i].xlen/2.;
        pshape -> xlen_out[1]  = layersizrect[i].xlen/2.;
        pshape -> ylen_out[0]  = -layersizrect[i].ylen/2.;
        pshape -> ylen_out[1]  = layersizrect[i].ylen/2.;
        pshape -> zlen_out[0]  = -wfrsizrect[iwaf].zlen;
        pshape -> zlen_out[1]  =  wfrsizrect[iwaf].zlen;
        pshape -> xlen_inn[0]  = -layersizrect[i].gapxlen/2;
        pshape -> xlen_inn[1]  = layersizrect[i].gapxlen/2;
        pshape -> ylen_inn[0]  = -layersizrect[i].gapylen/2;
        pshape -> ylen_inn[1]  = layersizrect[i].gapylen/2;
        pshape -> zlen_inn[0]  = -wfrsizrect[iwaf].zlen;
        pshape -> zlen_inn[1]  =  wfrsizrect[iwaf].zlen;
        pshape -> half_z       = 0.;
        pshape -> rad_in_lowz  = 0.;
        pshape -> rad_out_lowz = 0.;
        pshape -> rad_in_hiz   = 0.;
        pshape -> rad_out_hiz  = 0.;
        pshape_tail = pshape;
      }
    }
    fprintf(fl,"Forw tracker: %3d declared.\n",*n_obj_ftrk);
    if (*n_obj_ftrk>0) {
      for (i=0;i<*n_obj_ftrk;i++) {
        fprintf(fl,"  %-6s Mat=%s Nly=%d x=%5.3G,%-5.3G y=%5.3G,%-5.3G z0=%5.3G zlen=%5.3G\n",
        ftrk[i].name,ftrk[i].mat_fill,ftrk[i].nlyr,
        ftrk[i].xmin,ftrk[i].xmax,
        ftrk[i].ymin,ftrk[i].ymax,
        ftrk[i].z0,ftrk[i].zlen);
        ndet++;     
        cstring =(char *) malloc(maxstrlen*sizeof(char));
        sprintf(cstring,"dev%d_%s_%d",ndet,ftrk[i].name,ftrk[i].det);
        pshape = (grShape *) malloc(sizeof(grShape));
        if(pshape == NULL){
           printf("detector: Unable to allocate memory!\n");
           return;
        }
        if(pshape_head == NULL){  /*First link*/
           pshape_head = pshape;
        }else{
           pshape_tail->pnext_link = pshape;
        }
        pshape->pnext_link = NULL;
        pshape -> type 	       = BOX;
        pshape -> name         = cstring;
        pshape -> devtype      = FWTRK;  
        pshape -> xpos 	       = 0.5*(ftrk[i].xmax+ftrk[i].xmin);
        pshape -> ypos 	       = 0.5*(ftrk[i].ymax+ftrk[i].ymin);
        pshape -> zpos 	       = ftrk[i].z0; 
        pshape -> color[0]     = 0.0;
        pshape -> color[1]     = 0.0;
        pshape -> color[2]     = 1.0;
        pshape -> rotation[0]  = X_ROTATION;
        pshape -> rotation[1]  = Y_ROTATION;
        pshape -> rotation[2]  = Z_ROTATION;    
        pshape -> transparency = SHEER;
        pshape -> visibility   = WIREFRAME;
        pshape -> cutaway      = NOCUT;
        pshape -> angle_begin  = ANGLE_BEGIN;
        pshape -> angle_end    = ANGLE_END;
        pshape -> nsides       = DEFAULT_NSIDES;
        pshape -> frame        = NOFRAME;
        pshape -> xlen_out[0]  = ftrk[i].xmin;
        pshape -> xlen_out[1]  = ftrk[i].xmax;
        pshape -> ylen_out[0]  = ftrk[i].ymin;
        pshape -> ylen_out[1]  = ftrk[i].ymax;
        pshape -> zlen_out[0]  = -0.5*ftrk[i].zlen;
        pshape -> zlen_out[1]  =  0.5*ftrk[i].zlen;
        pshape -> xlen_inn[0]  = pshape -> xlen_out[0];
        pshape -> xlen_inn[1]  = pshape -> xlen_out[1];
        pshape -> ylen_inn[0]  = pshape -> ylen_out[0];
        pshape -> ylen_inn[1]  = pshape -> ylen_out[1];
        pshape -> zlen_inn[0]  = 0.0;
        pshape -> zlen_inn[1]  = pshape ->zlen_inn[0];
        pshape -> half_z       = 0.;
        pshape -> rad_in_lowz  = 0.;
        pshape -> rad_out_lowz = 0.;
        pshape -> rad_in_hiz   = 0.;
        pshape -> rad_out_hiz  = 0.;
        pshape_tail = pshape;
      }
      fprintf(fl,"    Total layers:         %3d declared.\n",*n_obj_layerftrk);
      for (i=0;i<*n_obj_layerftrk;i++) {
        ndet++;
        idet = layerftrk[i].det - 1 ;        
        cstring =(char *) malloc(maxstrlen*sizeof(char));
        sprintf(cstring,"dev%d_%s_%d_lyr%d",
        ndet,ftrk[idet].name,layerftrk[i].det,layerftrk[i].lyr);
        pshape = (grShape *) malloc(sizeof(grShape));
        if(pshape == NULL){
           printf("detector: Unable to allocate memory!\n");
           return;
        }
        if(pshape_head == NULL){  /*First link*/
           pshape_head = pshape;
        }else{
           pshape_tail->pnext_link = pshape;
        }
        pshape->pnext_link = NULL;
        pshape -> type 	       = BOX;
        pshape -> name         = cstring;
        pshape -> devtype      = FWTRK;  
        pshape -> xpos 	       = 0.5*(ftrk[idet].xmax+ftrk[idet].xmin);
        pshape -> ypos 	       = 0.5*(ftrk[idet].ymax+ftrk[idet].ymin);
        pshape -> zpos 	       = layerftrk[i].z_local + ftrk[idet].z0;
        pshape -> color[0]     = 0.0;
        pshape -> color[1]     = 1.0;
        pshape -> color[2]     = 0.0;
        pshape -> rotation[0]  = X_ROTATION;
        pshape -> rotation[1]  = Y_ROTATION;
        pshape -> rotation[2]  = Z_ROTATION;    
        pshape -> transparency = SHEER;
        pshape -> visibility   = SOLID;
        pshape -> cutaway      = NOCUT;
        pshape -> angle_begin  = ANGLE_BEGIN;
        pshape -> angle_end    = ANGLE_END;
        pshape -> nsides       = DEFAULT_NSIDES;
        pshape -> frame        = NOFRAME;
        pshape -> xlen_out[0]  = layerftrk[i].xmin;
        pshape -> xlen_out[1]  = layerftrk[i].xmax;
        pshape -> ylen_out[0]  = layerftrk[i].ymin;
        pshape -> ylen_out[1]  = layerftrk[i].ymax;
        pshape -> zlen_out[0]  = -0.5*layerftrk[i].thick;
        pshape -> zlen_out[1]  =  0.5*layerftrk[i].thick;
        pshape -> xlen_inn[0]  = layerftrk[i].xmin_gap;
        pshape -> xlen_inn[1]  = layerftrk[i].xmax_gap;
        pshape -> ylen_inn[0]  = layerftrk[i].ymin_gap;
        pshape -> ylen_inn[1]  = layerftrk[i].ymax_gap;
        pshape -> zlen_inn[0]  = -0.5*layerftrk[i].thick;
        pshape -> zlen_inn[1]  =  0.5*layerftrk[i].thick;
        pshape -> half_z       = 0.;
        pshape -> rad_in_lowz  = 0.;
        pshape -> rad_out_lowz = 0.;
        pshape -> rad_in_hiz   = 0.;
        pshape -> rad_out_hiz  = 0.;
        pshape_tail = pshape;
      }
    }
    fprintf(fl,"EM cal:       %3d declared.\n",*n_obj_emcal);
    for (i=0;i<*n_obj_emcal;i++) {
      fprintf(fl,"  %-6s %s Mat=%s Np,e=%3d,%-3d rlo=%5.3G,%-5.3G rhi=%5.3G,%-5.3G z0=%5.3G zlen=%5.3G\n",
      emcal[i].name,emcal[i].shape,emcal[i].material,
      emcal[i].nphi,emcal[i].neta,
      emcal[i].rmin[0],emcal[i].rmax[0],
      emcal[i].rmin[1],emcal[i].rmax[1],
      emcal[i].z0,emcal[i].zlen);
        ndet++;        
        cstring =(char *) malloc(maxstrlen*sizeof(char));
        sprintf(cstring,"dev%d_%s",ndet,emcal[i].name);
        pshape = (grShape *) malloc(sizeof(grShape));
        if(pshape == NULL){
           printf("detector: Unable to allocate memory!\n");
           return;
        }
        if(pshape_head == NULL){  /*First link*/
           pshape_head = pshape;
        }else{
           pshape_tail->pnext_link = pshape;
        }
        pshape->pnext_link = NULL;
        pshape -> type 	       = CONE;
        pshape -> name         = cstring;
        pshape -> devtype      = CAL;  
        pshape -> xpos 	       = 0.;
        pshape -> ypos 	       = 0.;
        pshape -> zpos 	       = emcal[i].z0;
        pshape -> color[0]     = 0.2;
        pshape -> color[1]     = 0.3;
        pshape -> color[2]     = 0.7;
        pshape -> rotation[0]  = X_ROTATION;
        pshape -> rotation[1]  = Y_ROTATION;
        pshape -> rotation[2]  = Z_ROTATION;    
        pshape -> transparency = SHEER;
        pshape -> visibility   = SOLID;
        pshape -> cutaway      = NOCUT;
        pshape -> angle_begin  = ANGLE_BEGIN;
        pshape -> angle_end    = ANGLE_END;
        pshape -> nsides       = DEFAULT_NSIDES;
        pshape -> frame        = NOFRAME;
        pshape -> xlen_out[0]  = 0.;
        pshape -> xlen_out[1]  = 0.;
        pshape -> ylen_out[0]  = 0.;
        pshape -> ylen_out[1]  = 0.;
        pshape -> zlen_out[0]  = 0.;
        pshape -> zlen_out[1]  = 0.;
        pshape -> xlen_inn[0]  = 0.;
        pshape -> xlen_inn[1]  = 0.;
        pshape -> ylen_inn[0]  = 0.;
        pshape -> ylen_inn[1]  = 0.;
        pshape -> zlen_inn[0]  = 0.;
        pshape -> zlen_inn[1]  = 0.;
        pshape -> half_z       = emcal[i].zlen/2.;
        pshape -> rad_in_lowz  = emcal[i].rmin[0];
        pshape -> rad_out_lowz = emcal[i].rmax[0];
        pshape -> rad_in_hiz   = emcal[i].rmin[1];
        pshape -> rad_out_hiz  = emcal[i].rmax[1];
        pshape_tail = pshape;
    }
    fprintf(fl,"XY cal:      %3d declared.\n",*n_obj_calorbox);
    for (i=0;i<*n_obj_calorbox;i++) {
        ndet++;        
        cstring =(char *) malloc(maxstrlen*sizeof(char));
        sprintf(cstring,"dev%d_%s",ndet,calorbox[i].name);
        pshape = (grShape *) malloc(sizeof(grShape));
        if(pshape == NULL){
           printf("detector: Unable to allocate memory!\n");
           return;
        }
        if(pshape_head == NULL){  /*First link*/
           pshape_head = pshape;
        }else{
           pshape_tail->pnext_link = pshape;
        }
        pshape->pnext_link = NULL;
        pshape -> type 	       = BOX;
        pshape -> name         = cstring;
        pshape -> devtype      = XYCAL;  
        pshape -> xpos 	       = 0.;
        pshape -> ypos 	       = 0.;
        pshape -> zpos 	       = calorbox[i].z0;
        pshape -> color[0]     = 0.5;
        pshape -> color[1]     = 0.2;
        pshape -> color[2]     = 0.8;
        pshape -> rotation[0]  = X_ROTATION;
        pshape -> rotation[1]  = Y_ROTATION;
        pshape -> rotation[2]  = Z_ROTATION;    
        pshape -> transparency = SHEER;
        pshape -> visibility   = SOLID;
        pshape -> cutaway      = NOCUT;
        pshape -> angle_begin  = ANGLE_BEGIN;
        pshape -> angle_end    = ANGLE_END;
        pshape -> nsides       = DEFAULT_NSIDES;
        pshape -> frame        = NOFRAME;
        pshape -> xlen_out[0]  = calorbox[i].xlimit[0];
        pshape -> xlen_out[1]  = calorbox[i].xlimit[1];
        pshape -> ylen_out[0]  = calorbox[i].ylimit[0];
        pshape -> ylen_out[1]  = calorbox[i].ylimit[1];
        pshape -> zlen_out[0]  = -0.5*calorbox[i].zlen;
        pshape -> zlen_out[1]  =  0.5*calorbox[i].zlen;
        pshape -> xlen_inn[0]  = calorbox[i].xlimit_gap[0];
        pshape -> xlen_inn[1]  = calorbox[i].xlimit_gap[1];
        pshape -> ylen_inn[0]  = calorbox[i].ylimit_gap[0];
        pshape -> ylen_inn[1]  = calorbox[i].ylimit_gap[1];
        pshape -> zlen_inn[0]  = -0.5*calorbox[i].zlen;
        pshape -> zlen_inn[1]  =  0.5*calorbox[i].zlen;
        pshape -> half_z       = 0.;
        pshape -> rad_in_lowz  = 0.;
        pshape -> rad_out_lowz = 0.;
        pshape -> rad_in_hiz   = 0.;
        pshape -> rad_out_hiz  = 0.;
        pshape_tail = pshape;
    }
    fprintf(fl,"Had cal:      %3d declared.\n",*n_obj_hadcal);
    for (i=0;i<*n_obj_hadcal;i++) {
      fprintf(fl,"  %-6s %s Mat=%s Np,e=%3d,%-3d rlo=%5.3G,%-5.3G rhi=%5.3G,%-5.3G z0=%5.3G zlen=%5.3G\n",
      hadcal[i].name,hadcal[i].shape,hadcal[i].material,
      hadcal[i].nphi,hadcal[i].neta,
      hadcal[i].rmin[0],hadcal[i].rmax[0],
      hadcal[i].rmin[1],hadcal[i].rmax[1],
      hadcal[i].z0,hadcal[i].zlen);
        ndet++;        
        cstring =(char *) malloc(maxstrlen*sizeof(char));
        sprintf(cstring,"dev%d_%s",ndet,hadcal[i].name);
        pshape = (grShape *) malloc(sizeof(grShape));
        if(pshape == NULL){
           printf("detector: Unable to allocate memory!\n");
           return;
        }
        if(pshape_head == NULL){  /*First link*/
           pshape_head = pshape;
        }else{
           pshape_tail->pnext_link = pshape;
        }
        pshape->pnext_link = NULL;
        pshape -> type 	       = CONE;
        pshape -> name         = cstring;
        pshape -> devtype      = CAL;  
        pshape -> xpos 	       = 0.;
        pshape -> ypos 	       = 0.;
        pshape -> zpos 	       = hadcal[i].z0;
        pshape -> color[0]     = 0.5;
        pshape -> color[1]     = 0.2;
        pshape -> color[2]     = 0.8;
        pshape -> rotation[0]  = X_ROTATION;
        pshape -> rotation[1]  = Y_ROTATION;
        pshape -> rotation[2]  = Z_ROTATION;    
        pshape -> transparency = SHEER;
        pshape -> visibility   = SOLID;
        pshape -> cutaway      = NOCUT;
        pshape -> angle_begin  = ANGLE_BEGIN;
        pshape -> angle_end    = ANGLE_END;
        pshape -> nsides       = DEFAULT_NSIDES;
        pshape -> frame        = NOFRAME;
        pshape -> xlen_out[0]  = 0.;
        pshape -> xlen_out[1]  = 0.;
        pshape -> ylen_out[0]  = 0.;
        pshape -> ylen_out[1]  = 0.;
        pshape -> zlen_out[0]  = 0.;
        pshape -> zlen_out[1]  = 0.;
        pshape -> xlen_inn[0]  = 0.;
        pshape -> xlen_inn[1]  = 0.;
        pshape -> ylen_inn[0]  = 0.;
        pshape -> ylen_inn[1]  = 0.;
        pshape -> zlen_inn[0]  = 0.;
        pshape -> zlen_inn[1]  = 0.;
        pshape -> half_z       = hadcal[i].zlen/2.;
        pshape -> rad_in_lowz  = hadcal[i].rmin[0];
        pshape -> rad_out_lowz = hadcal[i].rmax[0];
        pshape -> rad_in_hiz   = hadcal[i].rmin[1];
        pshape -> rad_out_hiz  = hadcal[i].rmax[1];
        pshape_tail = pshape;
    }
    fprintf(fl,"Muon:         %3d declared.\n",*n_obj_muon);
    for (i=0;i<*n_obj_muon;i++) {
      fprintf(fl,"  %-6s %s Mat=%s rlo=%5.3G,%-5.3G rhi=%5.3G,%-5.3G z0=%5.3G zlen=%5.3G\n",
      muon[i].name,muon[i].shape,muon[i].material,
      muon[i].rmin[0],muon[i].rmax[0],
      muon[i].rmin[1],muon[i].rmax[1],
      muon[i].z0,muon[i].zlen);
        ndet++;        
        cstring =(char *) malloc(maxstrlen*sizeof(char));
        sprintf(cstring,"dev%d_%s",ndet,muon[i].name);
        pshape = (grShape *) malloc(sizeof(grShape));
        if(pshape == NULL){
           printf("detector: Unable to allocate memory!\n");
           return;
        }
        if(pshape_head == NULL){  /*First link*/
           pshape_head = pshape;
        }else{
           pshape_tail->pnext_link = pshape;
        }
        pshape->pnext_link = NULL;
        pshape -> type 	  = CONE;
        pshape -> name         = cstring;
        pshape -> devtype      = MUON;  
        pshape -> xpos 	       = 0.;
        pshape -> ypos 	       = 0.;
        pshape -> zpos 	       = muon[i].z0;
        pshape -> color[0]     = 0.1;
        pshape -> color[1]     = 0.4;
        pshape -> color[2]     = 0.7;
        pshape -> rotation[0]  = X_ROTATION;
        pshape -> rotation[1]  = Y_ROTATION;
        pshape -> rotation[2]  = Z_ROTATION;    
        pshape -> transparency = SHEER;
        pshape -> visibility   = SOLID;
        pshape -> cutaway      = NOCUT;
        pshape -> angle_begin  = ANGLE_BEGIN;
        pshape -> angle_end    = ANGLE_END;
        pshape -> nsides       = DEFAULT_NSIDES;
        pshape -> frame        = NOFRAME;
        pshape -> xlen_out[0]  = 0.;
        pshape -> xlen_out[1]  = 0.;
        pshape -> ylen_out[0]  = 0.;
        pshape -> ylen_out[1]  = 0.;
        pshape -> zlen_out[0]  = 0.;
        pshape -> zlen_out[1]  = 0.;
        pshape -> xlen_inn[0]  = 0.;
        pshape -> xlen_inn[1]  = 0.;
        pshape -> ylen_inn[0]  = 0.;
        pshape -> ylen_inn[1]  = 0.;
        pshape -> zlen_inn[0]  = 0.;
        pshape -> zlen_inn[1]  = 0.;
        pshape -> half_z       = muon[i].zlen/2.;
        pshape -> rad_in_lowz  = muon[i].rmin[0];
        pshape -> rad_out_lowz = muon[i].rmax[0];
        pshape -> rad_in_hiz   = muon[i].rmin[1];
        pshape -> rad_out_hiz  = muon[i].rmax[1];
        pshape_tail = pshape;
    }
    return ndet;
}

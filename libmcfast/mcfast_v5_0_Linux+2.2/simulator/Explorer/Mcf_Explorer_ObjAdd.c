/*****************************************************************************/
/* PATLIB_ObjAdd.c - Explorer - Dave Swoboda at Fermilab - 9/2/94	     */
/* Mcf_Explorer_ObjAdd.c  2/22/95                        		     */
/*___________________________________________________________________________*/
/* This file is a library of functions meant to serve as an interface	     */
/* between MCFAST and any graphical display utility.  MCFAST loads up a	     */
/* geometry buffer which is then manipulated by this library and fed to the  */
/* graphics package.							     */
/*****************************************************************************/

/**************************/
/* Standard include files */
/**************************/
#include <string.h>
#include <ctype.h>

/************************/
/* Mcf_Explorer INCLUDE FILES */
/************************/
#include "Mcf_Explorer_typedefs.h"
#include "Mcf_Explorer_prototypes.h"
#include "Mcf_Explorer_externs.h"
#include "mcfio_Dict.h"
#include "McfError.h"
/* file for outputing the configuration file */
#include "grDisp.h"
grShape *pshape_head = NULL;
static grShape *pshape_tail = NULL;
extern grShape *pshape_head;
/******************************************************************************
*******************************************************************************
**************                                                   **************
**************    F O R T R A N    N A M E   F U N C T I O N S   **************
**************                                                   **************
*******************************************************************************
******************************************************************************/

/******************************************************************************
** define_box2_f_							     **
** This function calls a fortran string converter function before calling    **
** the appropriate geometry routine.                                         **
******************************************************************************/
void define_box2_f_(grGeneral *igr, int *ndet, char fstring[], 
                   float *xlen_out, float *ylen_out, float *zlen_out,
                   float *xlen_inn, float *ylen_inn, float *zlen_inn,
                   int flen)
{
char *cstring;
static int maxstrlen = 100;
char string[100];
struct grShape *pshape; 
    cstring =(char *) malloc(maxstrlen*sizeof(char));
    sprintf(cstring,"dev%d_%s",*ndet,getFortranString(fstring, flen));
    pshape = (grShape *) malloc(sizeof(grShape));
    if(pshape == NULL){
       printf("Define_box: Unable to allocate memory!\n");
       return;
    }
    if(pshape_head == NULL){  /*First link*/
       pshape_head = pshape;
    }else{
       pshape_tail->pnext_link = pshape;
    }
    pshape->pnext_link = NULL;
    pshape -> type 	  = BOX;
    pshape -> name         = cstring;
    pshape -> xpos 	  = igr->xpos;
    pshape -> ypos 	  = igr->ypos;
    pshape -> zpos 	  = igr->zpos;
    pshape -> color[0]	  = igr->color[0];
    pshape -> color[1]	  = igr->color[1];
    pshape -> color[2]	  = igr->color[2];
    pshape -> rotation[0]  = igr->rotation[0];
    pshape -> rotation[1]  = igr->rotation[1];
    pshape -> rotation[2]  = igr->rotation[2];    
    pshape -> transparency = igr->transparency;
    pshape -> visibility   = igr->visibility;
    pshape -> cutaway      = igr ->cutaway;
    pshape -> angle_begin  = igr->angle_begin;
    pshape -> angle_end    = igr->angle_end;
    pshape -> nsides       = igr->nsides;
    pshape -> xlen_out[0]  = xlen_out[0];
    pshape -> xlen_out[1]  = xlen_out[1];
    pshape -> ylen_out[0]  = ylen_out[0];
    pshape -> ylen_out[1]  = ylen_out[1];
    pshape -> zlen_out[0]  = zlen_out[0];
    pshape -> zlen_out[1]  = zlen_out[1];
    pshape -> xlen_inn[0]  = xlen_inn[0];
    pshape -> xlen_inn[1]  = xlen_inn[1];
    pshape -> ylen_inn[0]  = ylen_inn[0];
    pshape -> ylen_inn[1]  = ylen_inn[1];
    pshape -> zlen_inn[0]  = zlen_inn[0];
    pshape -> zlen_inn[1]  = zlen_inn[1];
    pshape -> half_z       = 0;
    pshape -> rad_in_lowz  = 0;
    pshape -> rad_out_lowz = 0;
    pshape -> rad_in_hiz   = 0;
    pshape -> rad_out_hiz  = 0;
    pshape_tail = pshape;
    return;
}

/******************************************************************************
** define_ConeTube_f_					             **
** This function calls a fortran string converter function before calling    **
** the appropriate geometry routine.                                         **
******************************************************************************/
void define_conetube_f_(grGeneral *igr, int *ndet, char fstring[], float *half_z, 
			float *rad_in_lowz, float *rad_out_lowz, 
			float *rad_in_hiz, float *rad_out_hiz, 
			int flen)
{
char *cstring;
static int maxstrlen = 100;
char string[100];
struct grShape *pshape; 
    cstring =(char *) malloc(maxstrlen*sizeof(char));
    sprintf(cstring,"dev%d_%s",*ndet,getFortranString(fstring, flen));
    pshape = (grShape *) malloc(sizeof(grShape));
    if(pshape == NULL){
       printf("define_conetube_f: Unable to allocate memory!\n");
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
    pshape -> xpos 	  = igr->xpos;
    pshape -> ypos 	  = igr->ypos;
    pshape -> zpos 	  = igr->zpos;
    pshape -> color[0]	  = igr->color[0];
    pshape -> color[1]	  = igr->color[1];
    pshape -> color[2]	  = igr->color[2];
    pshape -> rotation[0]  = igr->rotation[0];
    pshape -> rotation[1]  = igr->rotation[1];
    pshape -> rotation[2]  = igr->rotation[2];    
    pshape -> transparency = igr->transparency;
    pshape -> visibility	  = igr->visibility;
    pshape -> cutaway      = igr->cutaway;
    pshape -> angle_begin  = igr->angle_begin;
    pshape -> angle_end    = igr->angle_end;
    pshape -> nsides       = igr->nsides;
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
    pshape -> half_z       = *half_z;
    pshape -> rad_in_lowz  = *rad_in_lowz;
    pshape -> rad_out_lowz = *rad_out_lowz;
    pshape -> rad_in_hiz   = *rad_in_hiz;
    pshape -> rad_out_hiz  = *rad_out_hiz;
    pshape_tail = pshape;
    return;
}
/******************************************************************************
** define_arrow_f_							     **
** This function calls a fortran string converter function before calling    **
** the appropriate geometry routine.                                         **
******************************************************************************/
void define_arrow_f_(grGeneral *igr, int *ndet, char fstring[], float *axis_rot,      
                        float *alpha, float *rad_stem, float *rad_base,
			float *half_z, int flen)
{
   printf("\n\n\nHelp Help\n");  
 
   igr->name = getFortranString(fstring, flen);   
    
   printf("define_arrow_f(): %s %.1f %.1f %.1f %.1f %d\n", 
    		igr->name, *alpha, *rad_stem, *rad_base,
    		           *half_z, flen);

   /*GeomDefineArrow(igr, axis_rot, *alpha, *rad_stem, *rad_base, *half_z);*/ 

   printf("Amber turned off the arrow!\n");
}
/*****************************************************************************
** get_rgb_values_()							    **
*****************************************************************************/ 
void get_rgb_values_(int *id, float * rgb) 
{
/* use id to get rgb triplet */
int ip;

ip = *id - 1;
    if(ip < 0 || ip >= 16 ) {
	rgb[0] = 0;
	rgb[1] = 0;
	rgb[2] = 0;
    } else {
	rgb[0] = grColors[ip][0];
	rgb[1] = grColors[ip][1];
	rgb[2] = grColors[ip][2];
    }
}
/******************************************************************************
/*****************************************************************************
** getFortranString							    **
*****************************************************************************/ 

char *getFortranString(char *fstring, int flen)
{
char *cstring;
int i, clen;

/* Make C string equal to a Fortran string without trailing blanks and including null character.
   If Fortran string is all blanks, make a C null string. */

    for (clen=flen-1; clen >= 0 && fstring[clen] == ' ' ;clen--); /* make clen the end of fstring */
    cstring = (char *) malloc((clen+2)*sizeof(char));	/* Create space for cstring */
    for (i=0; i<=clen; i++)				/* Copy fstring to cstring */
        cstring[i] = fstring[i];

    cstring[clen+1] = NULL;				/* Put NULL character at the end */
      
    return(cstring);
}

/******************************************************************************
**    box_connections                                                        **
**    3-Mar-95  Amber Boehnlein                                              **
**    sets up the box connects for either a box with hole or a solid box     **
**    There are 4 vertex connections for each face and six faces for the     **
**    solid box.  The vertex numbering is clockwise starting at the face     **
**    nearest you, 0,1,2,3,4,5,6,7.                                          **
**    -1 indicates the end of the series of connections                      **
**                                                                           **
**    The box with the hole allows an opening on the z face.  There are four **
**    faces for the inner and outer boxes connected with the z face          **
**    connections four trapizodal connections from the outer to the inner box**
**    -1 indicates the end of the connection.  Example: fwd tracker with gap **                               
**                                                                           **
**    The box with open sides (x or y) makes two narrow boxes with the outer **
**    box connected to the inner box closest to it, but no connections       **
**    between the opposite faces of the outer box or inner box               **
**    Example, dipole volume                                                 **
******************************************************************************/
void box_connections(int box_type, int *ct){
     if (box_type == 0){  /*solid box*/
       ct[0]  =  3; ct[1]  =  0; ct[2]  =  1; ct[3]  =  2; ct[4]  = -1; 
       ct[5]  =  0; ct[6]  =  4; ct[7]  =  5; ct[8]  =  1; ct[9]  = -1;
       ct[10] =  4; ct[11] =  7; ct[12] =  6; ct[13] =  5; ct[14] = -1; 
       ct[15] =  7; ct[16] =  3; ct[17] =  2; ct[18] =  6; ct[19] = -1;
     }else if (box_type==1){ /*box with hole*/
       /*  Outside connected faces */
       ct[0]  =  3; ct[1]  =  0; ct[2]  =  1; ct[3]  =  2; ct[4]  = -1; 
       ct[5]  =  0; ct[6]  =  4; ct[7]  =  5; ct[8]  =  1; ct[9]  = -1;
       ct[10] =  4; ct[11] =  7; ct[12] =  6; ct[13] =  5; ct[14] = -1; 
       ct[15] =  7; ct[16] =  3; ct[17] =  2; ct[18] =  6; ct[19] = -1;
       /* Inside connected faces */
       ct[20] = 11; ct[21] =  8; ct[22] =  9; ct[23] = 10; ct[24] = -1; 
       ct[25] =  8; ct[26] = 12; ct[27] = 13; ct[28] =  9; ct[29] = -1;
       ct[30] = 12; ct[31] = 15; ct[32] = 14; ct[33] = 13; ct[34] = -1; 
       ct[35] = 15; ct[36] = 11; ct[37] = 10; ct[38] = 14; ct[39] = -1;
       /* trapzoid connections for z front face */
       ct[40] =  8; ct[41]= 0; ct[42] = -1;
       ct[43] =  9; ct[44]= 1; ct[45] = -1;
       ct[46] = 11; ct[47]= 3; ct[48] = -1; 
       ct[49] = 10; ct[50]= 2; ct[51] = -1;       
       /* trapozoid connections for z back face */
       ct[52] = 12; ct[53]= 4;  ct[54] = -1;
       ct[55] = 13; ct[56]= 5;  ct[57] = -1;
       ct[58] = 15; ct[59]= 7;  ct[60] = -1; 
       ct[61] = 14; ct[62]= 6;  ct[63] = -1;       
     } else if (box_type == 2) { /* box with x-z faces open*/
       ct[0]  = 10; ct[1]  =  9; ct[2]  =  1; ct[3]  =  2; ct[4]  = -1; 
       ct[5]  =  9; ct[6]  = 13; ct[7]  =  5; ct[8]  =  1; ct[9]  = -1;
       ct[10] = 13; ct[11] = 14; ct[12] =  6; ct[13] =  5; ct[14] = -1; 
       ct[15] = 14; ct[16] = 10; ct[17] =  2; ct[18] =  6; ct[19] = -1;
       ct[20] =  3; ct[21] =  0; ct[22] =  8; ct[23] = 11; ct[24] = -1; 
       ct[25] =  0; ct[26] =  4; ct[27] = 12; ct[28] =  8; ct[29] = -1;
       ct[30] =  4; ct[31] =  7; ct[32] = 15; ct[33] = 12; ct[34] = -1; 
       ct[35] =  7; ct[36] =  3; ct[37] = 11; ct[38] = 15; ct[39] = -1;
       
     } else if (box_type == 3) { /* box with y-z faces open */
       ct[0]  =  8; ct[1]  =  0; ct[2]  =  1; ct[3]  =  9; ct[4]  = -1; 
       ct[5]  =  0; ct[6]  =  4; ct[7]  =  5; ct[8]  =  1; ct[9]  = -1;
       ct[10] =  4; ct[11] = 12; ct[12] = 13; ct[13] =  5; ct[14] = -1; 
       ct[15] = 12; ct[16] =  8; ct[17] =  9; ct[18] = 13; ct[19] = -1;
       ct[20] =  3; ct[21] = 11; ct[22] = 10; ct[23] =  2; ct[24] = -1; 
       ct[25] = 11; ct[26] = 15; ct[27] = 14; ct[28] = 10; ct[29] = -1;
       ct[30] = 15; ct[31] =  7; ct[32] =  6; ct[33] = 14; ct[34] = -1; 
       ct[35] =  7; ct[36] =  3; ct[37] =  2; ct[38] =  6; ct[39] = -1;
     } return;
  
 }
/*****************************************************************
**       inner_box                                              **
**     03-MAR-95 Amber Boehnlein                                **
**     figures out the type of inner box                        **
*****************************************************************/
int inner_box ( float *xilen, float *yilen, float *zilen,
                float *xolen, float *yolen, float *zolen,
                int *num_ver,int *num_con){
 int box_type;
  printf("figuring out the type of box\n");
    printf( "%f, %f, %f, %f, %f, %f\n",
    xilen[0],xilen[1],yilen[0],yilen[1],zilen[0],zilen[1]);
    
    /* box with zero inner dimensions
    if(xilen[0] == xilen[1] && 
       yilen[0] == yilen[1]){          
          *num_ver = 16; *num_con = 20;
          return  0;         
       }
    /* box with same inner and outer dimesions in x and y is a simple box */   
    if(xilen[0] == xolen[0] && xilen[1] == xolen[1] &&
       yilen[0] == yolen[0] && yilen[1] == yolen[1]){
          *num_ver = 16; *num_con = 20; return 0;
     }
     /* a box with only x inner and out dimensions the same has open faces */
     if(xilen[0] == xolen[0] && xilen[1] == xolen[1]){
          *num_ver = 16; *num_con = 40; return  2;
     }
     /* a box with only y inner and out dimensions the same has open faces */
     if(yilen[0] == yolen[0] && yilen[1] == yolen[1]){
          *num_ver = 16; *num_con = 40;  return  3;
     }
     /* anything else: use connections along the zface */
          *num_ver = 16; *num_con = 64; 
          return  1;           
}
void GeomShapeOut(int ndet){
int i;
struct grShape *pshape;
    pshape = pshape_head;
    while(pshape != NULL){
      GeomDrawObject(pshape);
      pshape = pshape->pnext_link;      
    }
    return; 
}   
int MakeDetectorList(int ndet,char *cstring){
char *NewLine = "\n";
struct grShape *pshape;
    pshape = pshape_head;
    while(pshape != NULL){
       strcat(cstring,pshape->name);
       strcat(cstring,NewLine);
       pshape = pshape->pnext_link;
    }
    return 0;
}        
int ModifyDetector(int idet, grDisplay r){
struct grShape *pshape;
    if (GetLink(idet,&pshape) == ERROR){
      printf("ModifyDetector: Device id not found\n");
      return ERROR;
    }
    pshape -> color[0]	  = r.color.red;
    pshape -> color[1]	  = r.color.green;
    pshape -> color[2]	  = r.color.blue;
    pshape -> transparency = r.transparency;
    pshape -> nsides       = r.nsides;
    pshape -> visibility	  = r.visibility;
    pshape -> cutaway	  = r.cutaway;
    pshape -> angle_begin = r.angle_begin;
    pshape -> angle_end   = r.angle_end;
    return AOK;
}
int GetDetectorParameters(int idet, grDisplay *pr){ 
struct grShape *pshape;
     if(GetLink(idet,&pshape)== -1){
      printf("GetDetectorParameters: Device id not found\n");
      return ERROR;
     }
    pr->color.red          =   pshape -> color[0];
    pr->color.green        =   pshape -> color[1];
    pr->color.blue         =   pshape -> color[2];
    pr->transparency       =   pshape -> transparency; 
    pr->nsides             =   pshape -> nsides;
    pr->visibility         =   pshape -> visibility;
    pr->cutaway            =   pshape -> cutaway;
    pr->angle_begin        =   pshape -> angle_begin;
    pr->angle_end          =   pshape -> angle_end;
    return AOK;
}
int GetLink(int ndet, grShape **igr){
struct grShape *pshape;
    pshape = pshape_head;
    while(pshape != NULL){
      if(GetDevNum(pshape->name) == ndet){
        *igr = pshape;
        return AOK;
      }
      pshape = pshape->pnext_link;     
    }
    return ERROR; 
} 
int GetNumSet(char *string){
/* find out how many newline terminated strings are in a string*/
int number = 0;
int i;
int value;
int nextdev = 1;
    for(i=0; i < strlen(string); i++){
        value = string[i];
        if(iscntrl(value)) nextdev = 1;
        if(isdigit(value)&&nextdev){
          number++;
          nextdev = 0;
        }
    }
   return number;
}  
int GetDevNum(char *string){
int i;
int value;
int number;
int status = ERROR;
    for(i=0; i < strlen(string); i++){
        value = string[i];
        if(isdigit(value) ){
            sscanf(string+i, "%d",&number);
            return number;
        }
    }
    return number;
} 
int GetDevList(char *string,int *devnum){
int i;
int j=0;
int value;
int nextdev = 1;
int status = ERROR;
    for(i=0; i < strlen(string); i++){
        value = string[i];
        if(iscntrl(value)) nextdev = 1;
        if(isdigit(value) && nextdev){
            /*printf("GetDevList:value = %d\n",value);*/
            sscanf(string+i, "%d", devnum+j);
            j++;
            nextdev = 0;
            status = AOK;
        }
    }
    /*printf("the device number is %d\n",*devnum);*/
    return status;
} 
int FreeDetList(void){
struct grShape *pshape;
    pshape = pshape_head;
    while(pshape != NULL){
      pshape_tail = pshape->pnext_link;
      free(pshape);
      pshape = pshape_tail;     
    }
    pshape_head = NULL;
    pshape_tail = NULL;
    return AOK; 
}   
int WriteConfig(int stream, int blkids){ 
struct grShape *pshape;
struct DetDisplayConfig_struct *pr;
    pshape = pshape_head;
    pr = (DetDisplayConfig_struct *) malloc(sizeof(DetDisplayConfig_struct));
    while(pshape != NULL){
      pr->red                =   pshape -> color[0];
      pr->green              =   pshape -> color[1];
      pr->blue               =   pshape -> color[2];
      pr->transparency       =   pshape -> transparency; 
      pr->nsides             =   pshape -> nsides;
      pr->visibility         =   pshape -> visibility;
      pr->cutaway            =   pshape -> cutaway;
      pr->angle_begin        =   pshape -> angle_begin;
      pr->angle_end          =   pshape -> angle_end;
      pr->frame              =   pshape -> frame;
      pr->idet               =  1;
      pr->detnumber = GetDevNum(pshape->name);
      strcpy(pr->version,"1.00");
      if(mcfioC_NTuple(stream,blkids, pr)
         == -1){
         printf("Problem encoding configuration file!\n");
         free(pr);
         return ERROR;
         }
      if(mcfioC_NextEvent(stream)==-1){
         printf("Error writing event\n");
         free(pr);
         return ERROR;
      }         
      pshape = pshape->pnext_link;     
    }
        free(pr);
        return AOK;
}
int ReadConfig(int stream, int blkids){ 
struct grShape *pshape;
struct DetDisplayConfig_struct *pr;
int istat;
    pshape = pshape_head;
    pr = (DetDisplayConfig_struct *)malloc(sizeof(DetDisplayConfig_struct));
    while(pshape != NULL){ 
      if(mcfioC_NextEvent(stream) == MCFIO_RUNNING){
        if(mcfioC_NTuple(stream,blkids,pr->version) == -1){
          printf("Error reading configuration file\n");
          free (pr);
          return ERROR;
        }      
        pshape -> color[0]     = pr -> red;       
        pshape -> color[1]     = pr -> green;
        pshape -> color[2]     = pr -> blue;
        pshape -> transparency = pr->transparency; 
        pshape -> nsides       = pr->nsides;
        pshape -> visibility   = pr->visibility;
        pshape -> cutaway      = pr->cutaway;
        pshape -> angle_begin  = pr->angle_begin;
        pshape -> angle_end    = pr->angle_end;
        pshape -> frame        = pr->frame;
        if(pr->detnumber != GetDevNum(pshape->name)){
          printf("Mis-match between configuration file and geom file\n");
          free(pr);
          return ERROR;
        }
        pshape = pshape->pnext_link;     
      }else{
         mcfioC_InfoStreamInt(stream,MCFIO_STATUS,&istat);
         if(istat == MCFIO_EOF){
            mcfioC_Close(stream);
            printf("Mis-match between config file and geom file?\n");
            printf("Config EOF reached before all detectors initialized\n");
            free (pr);
            return ERROR;
         }
      }
    }
    mcfioC_Close(stream);
    free (pr);
    return AOK;
}
int Mcf_WriteConfigFile(char *filename){
    int stream, status;
    int ndec = 1;
    int blkids;
    stream = mcfioC_OpenWriteDirect(filename,"DetConfigs",
                                     "comment",500,&blkids,0);
    blkids = mcfioC_DeclareNtuple(22,
                                 "Detector Configs",
                                 "Detector parameters",
                                 stream, "grDisp.db");  
    if(mcfioC_EndDeclNTuples(stream)!= ndec){
      printf("Problem with Ntuple stream declaration\n");
      return -999;
    }
    status = WriteConfig(stream,blkids);
    mcfioC_Close(stream);
   return status;   
}    
int Mcf_ReadConfigFile(char *filename){
    int stream, status;
    int ntup;
    int ndec = 1;
    int blkids;
    stream = mcfioC_OpenReadDirect(filename);
    ntup = mcfioC_GetNTupleIds(stream,&blkids,1);
    /*if(ntup > 1){*/
      /*printf("File %s is probably not a configuration file\n",*/
      /*   filename);*/
      /*return -1;*/
    /*}*/
    
    if (mcfioC_GetNTupleUID(blkids) == 22){
      status = ReadConfig(stream,blkids);
    }
   mcfioC_Close(stream);
   return status;   
}    
char *FindAllType(char *string){
char *cstring;
struct grShape *pshape;
struct grShape *temp;
char *NewLine = "\n";
    if(GetLink(GetDevNum(string),&temp)==AOK){
      cstring = (char *) malloc(30*300 * sizeof(char));
      pshape = pshape_head;
      while(pshape != NULL){
      if(pshape->devtype == temp->devtype){
        strcat(cstring,pshape->name);
        strcat(cstring,NewLine);
      }
      pshape = pshape->pnext_link;     
    }
      return cstring;
    } else {
      return NULL;
    } 
  
}

/***************************************************/
/* PATLIB_ExplorerModule.c - Dave Swoboda - 9/2/94 */
/***************************************************/
/* Modified 4/17/95  A. Boehnlein  added switch for plane visibility*/
/*****************/
/* include files */
/*****************/
#ifndef EXPLORER
#define EXPLORER
#include <cx/DataTypes.h>
#include <cx/DataAccess.h>
#include <cx/UserFuncs.h>
#include <cx/Geometry.h>
#endif
#include <cx/PortAccess.h>
#include <cx/Lookup.h>

#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <malloc.h>
#include <errno.h>

#include "Mcf_Explorer_typedefs.h"
#include "Mcf_Explorer_prototypes.h"
#include "Mcf_Explorer_globalloc.h"
#include "McfGeomUtil.h"
#include "McfReadEvent.h"

#define True 1
#define False 0

/********************/
/* GLOBAL VARIABLES */
/********************/
int GeomNumber = 0;
int GeomInitDone = False;
/*************************/ 
/* function declarations */
/*************************/
void Mcf_ExplorerDisplay (
	 cxGeometry *	* geoOut, 
	 cxParameter *	  Detector, 
	 cxParameter *	  Config, 
	 int    	  DetChanged, 
	 cxParameter *	  Color, 
	 int    	  ColorChanged, 
	 cxParameter *	  Transparency, 
	 int    	  TransparencyChanged, 
	 cxParameter *	  Visibility, 
	 int    	  VisibilityChanged, 
	 cxParameter *	  List, 
	 int    	  ListChanged, 
	 int    	  Update, 
	 cxParameter *	  AngleBegin, 
	 int    	  AngleBeginChanged, 
	 cxParameter *	  AngleEnd, 
	 int    	  AngleEndChanged, 
	 cxParameter *	  Nsides, 
	 int    	  NsidesChanged, 
	 cxParameter *	  DetName, 
	 int    	  DetNameChanged, 
	 int    	  Nodisplay, 
	 cxParameter *	  Cutaway, 
	 int    	  CutawayChanged,
	 long             ColorWin,
	 cxParameter *    ModByType,
	 int              ModChanged); 
void open_display(cxGeometry **geoOut);
void geom_init();
void geom_exit(cxGeometry *geoOut);
void cleanup_selected(cxGeometry *geoLocal);
void cleanup_geometry(cxGeometry *geoLocal);
int get_geom_file(char *temp);
void McfDrawColor(long window, struct grRgb expColor);

void prgeom(FILE*);
/***************************/
/* Mcf_ExplorerDisplay functions */
/***************************/
void geom_init()
{
printf("ENTER: geom_init()\n");
    cxGeoInit();
printf("LEAVE: geom_init()\n");
}

void Mcf_ExplorerDisplay (
	 cxGeometry *	* geoOut, 
	 cxParameter *	  Detector, 
	 cxParameter *	  Config, 
	 int    	  DetChanged, 
	 cxParameter *	  Color, 
	 int    	  ColorChanged, 
	 cxParameter *	  Transparency, 
	 int    	  TransparencyChanged, 
	 cxParameter *	  Visibility, 
	 int    	  VisibilityChanged, 
	 cxParameter *	  List, 
	 int    	  ListChanged, 
	 int    	  Update, 
	 cxParameter *	  AngleBegin, 
	 int    	  AngleBeginChanged, 
	 cxParameter *	  AngleEnd, 
	 int    	  AngleEndChanged, 
	 cxParameter *	  Nsides, 
	 int    	  NsidesChanged, 
	 cxParameter *	  DetName, 
	 int    	  DetNameChanged, 
	 int    	  Nodisplay, 
	 cxParameter *	  Cutaway, 
	 int    	  CutawayChanged,
	 long             ColorWin,
	 cxParameter *    ModByType,
	 int              ModChanged){
char *DetFile;
static char *OldFile;
char *ConfigFile;
int i;
int geo_flag = 1;
static int firstpass  = 0;
static int ndetectors = 0;
char *ListTemp;
char *string, *string2;
char name[30];
int det_to_modify;
int *detnum;
struct grDisplay dparam, temp;
float rgba[4];
long rw;
int stream, status, evenno;
static int first = 1;
    if (first == 1){
       first = 0;
       cxInWdgtDblSet("Transparency",1.0);
       cxInWdgtLongSet("Visibility",0);
       cxInWdgtLongSet("Cutaway",1);
       mcfioC_Init();
       mcfioC_SetForSaveDecoding(0);
       cxInWdgtDisable("ConfigFile");
       OldFile = (char *) malloc(FILENAME_MAX * sizeof(char));
       strcpy(OldFile, "\0");
       return;
    } 

    printf("ENTER: Mcf_ExplorerDisplay()\n");
    DetFile = (char *) malloc(FILENAME_MAX * sizeof(char));   
    DetFile = cxParamPathnameGet( Detector );     
    if(DetChanged && strcmp(DetFile,OldFile) == 0) return;
    if(!Nodisplay == 0){
       open_display(geoOut);
       geom_exit(*geoOut);    
       return;
    }
		
	/* CALL MCFAST FUNCTIONS */

    if(!DetChanged == 0 && strcmp(DetFile,OldFile) != 0) {
        strcpy(OldFile,DetFile);
        FreeDetList();
        if(!strstr(DetFile,".geo") == NULL){        
          printf("Sorry! FFREAD Style Geometery files not supported\n");
          return;
        }else if(!strstr(DetFile,".db") == NULL){
        /* db file*/
           printf("Using DBin input%s\n",DetFile);
           mcfast_read_(DetFile);
          }else{        
        /* maybe it's a McFio file with geometry, try that */
           printf("Using MCFIO input\n");
           stream = Mcf_OpenFile(DetFile);
           status = Mcf_ReadGeom(stream); 
        }
        ndetectors = McfShapeFill();
        string = (char *) malloc(30 * ndetectors * sizeof(char));
        MakeDetectorList(ndetectors,string); 
        cxInWdgtScrollListItemsSet("List",ndetectors,string);
        free (string);
        firstpass = 1;
        free (DetFile);
    }
    
    /* Get updates to the geometry if any */
 
     string = (char *) malloc(30 *ndetectors * sizeof(char));
     if(DetNameChanged){
       string = cxParamStrGet(DetName);
       cxInWdgtScrollListItemsSel("List",string);       
     }
     string = cxParamStrGet(List);
     if(cxParamLongGet(ModByType) == 1){
       string2 = FindAllType(string);
       if(string2 != NULL){
         if(strcmp(string2,string) != 0){       
           cxInWdgtScrollListItemsSel("List",string2);
         }
         free (string2);
         string = cxParamStrGet(List);
       }   
     }
     if(firstpass == 1){
        det_to_modify = 0;
     } else {
       det_to_modify = GetNumSet(string);
     }
     
     if(det_to_modify > 0){
       detnum = (int *) malloc(det_to_modify * sizeof(int));
       status = GetDevList(string,detnum);
       free (string);
       GetDetectorParameters(detnum[0], &dparam);
       if(ListChanged || DetNameChanged){ 
     /* changed detector to modify.  redisplay  parameters*/
            cxInWdgtDblSet("Transparency",dparam.transparency);
            cxInWdgtLongSet("Visibility",dparam.visibility);
            cxInWdgtLongSet("Cutaway",dparam.cutaway);
            cxInWdgtDblSet("CutAngleStart",dparam.angle_begin);
            cxInWdgtDblSet("CutAngleEnd",dparam.angle_end);
            cxInWdgtDblSet("Red",dparam.color.red);
            cxInWdgtDblSet("Green",dparam.color.green);
            cxInWdgtDblSet("Blue",dparam.color.blue);
            cxInWdgtLongSet("Nsides",dparam.nsides);
            McfDrawColor(ColorWin,dparam.color);
       }
     }
     if(ColorChanged){
       cxParamColorFloatGet(Color, rgba);
       temp.color.red    = rgba[0];
       temp.color.green  = rgba[1];
       temp.color.blue   = rgba[2];
       cxInWdgtDblSet("Red",temp.color.red);
       cxInWdgtDblSet("Green",temp.color.green);
       cxInWdgtDblSet("Blue",temp.color.blue);
       McfDrawColor(ColorWin,temp.color);
       
     }
     if(TransparencyChanged){
       temp.transparency = cxParamDblGet( Transparency);
     }
     if(VisibilityChanged){
       temp.visibility = cxParamLongGet( Visibility);
     }
     if(CutawayChanged){
       temp.cutaway = cxParamLongGet(Cutaway);
     }
     if(AngleBeginChanged){
       temp.angle_begin = cxParamDblGet( AngleBegin);
     }
     if(AngleEndChanged){
       temp.angle_end = cxParamDblGet( AngleEnd);
     }
     if(NsidesChanged){
       temp.nsides = cxParamLongGet( Nsides);     
     }
                      
    if(det_to_modify > 0){
        for(i=0;i<det_to_modify;i++){
          GetDetectorParameters(detnum[i], &dparam);
            if(ColorChanged){
               dparam.color.red   = temp.color.red;
               dparam.color.green = temp.color.green;
               dparam.color.blue  = temp.color.blue;
            }
            if(TransparencyChanged){
               dparam.transparency   = temp.transparency;
            }
            if(VisibilityChanged){
               dparam.visibility   = temp.visibility;
            }
            if(CutawayChanged){
               dparam.cutaway  = temp.cutaway;
            }
            if(AngleBeginChanged){
               dparam.angle_begin  = temp.angle_begin;
            }
            if(AngleEndChanged){
               dparam.angle_end  = temp.angle_end;
            }
            if(NsidesChanged){
               dparam.nsides  = temp.nsides;
            }
          ModifyDetector(detnum[i], dparam);
        }
        free(detnum);
    }       
   
    Update = cxInputDataChanged(cxInputPortOpen("Display"));
    if(Update != 0 || firstpass == 1){
       open_display(geoOut);
       GeomShapeOut(ndetectors);
       geom_exit(*geoOut);
       firstpass = 0;
    }
    if(cxInputDataChanged(cxInputPortOpen("RWconfig")) != 0){
       cxInWdgtEnable("ConfigFile");       
    }
    if(cxInputDataChanged(cxInputPortOpen("ConfigFile"))){
      ConfigFile = (char *) malloc(FILENAME_MAX * sizeof(char));   
      ConfigFile = cxParamPathnameGet( Config );
      printf("Config file name is %s\n",ConfigFile);     
      rw = cxParamLongGet((cxParameter *)
           cxInputDataGet(cxInputPortOpen("RWconfig")));
      if(rw == WRITE){
        Mcf_WriteConfigFile(ConfigFile);
      } else if(rw == READ){
        open_display(geoOut);
        Mcf_ReadConfigFile(ConfigFile);
        GeomShapeOut(ndetectors);
        geom_exit(*geoOut);
      }
      cxInWdgtDisable("ConfigFile"); 
      free (ConfigFile);            
    }    
    printf("LEAVE: Mcf_ExplorerDisplay()\n");
}

int get_geom_file(char *temp)
/* get the name of the geometery file and */
/* make sure that it can be openned. */
{
    cxParameter *parm = 0;
    FILE *file;
    char *geom_file;

    parm = (cxParameter *)cxInputDataGet(cxInputPortOpen("geom_filename"));
    geom_file = cxParamPathnameGet( parm );
    if(geom_file == NULL)
    {
	 return 1;
    }
    if(geom_file[0] == NULL) return 2;    
    if((file = fopen(geom_file,"r")) == NULL){ 
	 char str[128];
	 sprintf(str, "Cannot open the Geometry file.\n%s: %s\n", geom_file,
	  strerror(errno));
	 cxModAlert(str);
	 printf("%s", str);
	 free( geom_file );
	 return 3;
    }
    strcpy(temp,geom_file);
    return 0;
}

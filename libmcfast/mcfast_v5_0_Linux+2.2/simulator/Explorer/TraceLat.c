/******************************************************************************/
/* test of tracks from HEP list                                               */ 
/******************************************************************************/

/**************************/
/* STANDARD INCLUDE FILES */
/**************************/
#include <math.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <malloc.h>
#include <errno.h>

/*************************************/
/* EXPLORER AND mcf_explorer INCLUDE FILES */
/*************************************/
#include <cx/cxLattice.h>
#include <cx/cxLattice.api.h>
#include <cx/Lookup.h>
#include "Mcf_Explorer_typedefs.h"
#include "Mcf_Explorer_prototypes.h"
#include "Mcf_Explorer_externs.h"
#include "McfReadEvent.h"
#include "McfEvent.h"
#include "McfPositionUtil.h"

#define True 1
#define False 0
int GeomInitDone = False;
void TraceDisplay (
	 cxGeometry *	* geoOut, 
	 cxLattice *	* heplat, 
	 cxParameter *	  File, 
	 int    	  Fn_changed, 
	 int    	  donext, 
	 int    	  eventnumber, 
	 int    	  eventnchanged, 
	 long   	  PlotTrace, 
	 int    	  PlotTraceChanged, 
	 long   	  PlotTrack, 
	 int    	  PlotTrackChanged, 
	 long   	  PlotNeutr, 
	 int    	  PlotNeutrChanged, 
	 long   	  PlotHit, 
	 int    	  PlotHitChanged, 
	 double 	  EtaMin, 
	 int    	  EtaMinChanged, 
	 double 	  EtaMax, 
	 int    	  EtaMaxChanged, 
	 long   	  PlotAxis, 
	 int    	  PlotAxisChanged, 
	 long   	  MomSwitch, 
	 int    	  MomSwitchChanged, 
	 double 	  MomCut, 
	 int    	  MomCutChanged, 
	 int    	  PickTraceInfo, 
	 int    	  PickHepNum, 
	 int    	  PickHepNumChanged, 
	 int    	  Reset,
	 double           RadMax,
	 int              RadMaxChanged);
void open_display(cxGeometry **geoOut);
void geom_init();
void geom_exit(cxGeometry *geoOut);
void cleanup_selected(cxGeometry *geoLocal);
void cleanup_geometry(cxGeometry *geoLocal);
int TraceDisplayAddAxis(void);
void TraceDisplay (
	 cxGeometry *	* geoOut, 
	 cxLattice *	* heplat, 
	 cxParameter *	  File, 
	 int    	  Fn_changed, 
	 int    	  donext, 
	 int    	  eventnumber, 
	 int    	  eventnchanged, 
	 long   	  PlotTrace, 
	 int    	  PlotTraceChanged, 
	 long   	  PlotTrack, 
	 int    	  PlotTrackChanged, 
	 long   	  PlotNeutr, 
	 int    	  PlotNeutrChanged, 
	 long   	  PlotHit, 
	 int    	  PlotHitChanged, 
	 double 	  EtaMin, 
	 int    	  EtaMinChanged, 
	 double 	  EtaMax, 
	 int    	  EtaMaxChanged, 
	 long   	  PlotAxis, 
	 int    	  PlotAxisChanged, 
	 long   	  MomSwitch, 
	 int    	  MomSwitchChanged, 
	 double 	  MomCut, 
	 int    	  MomCutChanged, 
	 int    	  PickTraceInfo, 
	 int    	  PickHepNum, 
	 int    	  PickHepNumChanged, 
	 int    	  Reset,
	 double           RadMax,
	 int              RadMaxChanged){
int evenno;
int status = 0;
long nhep = 0;
static int first = 0;
static int stream = 0;
int firstevent = 0;
int count;
int icount, info;
float *hepdata;
float *latdata;
char *FileName;
char string[30];
char font[] =
"-sgi-fixed-bold-r-normal--24-170-100-100-c-120-iso8859-3";
  if(first == 0){
      mcfioC_Init();
      first = 1;
      PlotTrace = 1;
      PlotTrack = 1;
      PlotNeutr = 0;
      PlotHit = 0;
      PlotAxis = 1;
      EtaMin = -10.;
      EtaMax =  10.;
      MomSwitch = 0;
      MomCut = 0.0;
      return;
  }
  if(Fn_changed != 0) {
    FileName = (char *) malloc(FILENAME_MAX * sizeof(char));   
    FileName = cxParamPathnameGet( File );     
         printf("filename = %s\n",FileName);
         stream = Mcf_OpenFile(FileName);
         firstevent = 1;
  }
  if (stream < 0){
     printf("open failure, file %s\n",FileName);
     printf("Check to make sure file exists and is McFio output\n");
     return;
  }  

  if(donext != 0 || firstevent !=0){
    status = Mcf_ReadEvent(stream,&evenno);
    if(status < 0){
      printf("Problem with McFio next event. Try reopening file\n");
      return;
    }
    cxInWdgtLongSet("EventNumber",evenno);
    McfDefineTrace();
    Reset = 1;
    if(status<0){            
        return;
    }
  }
   count = sprintf(string,"Event Number = %d",evenno);
  if(donext           != 0 || firstevent       != 0 ||
     PlotTraceChanged != 0 || PlotTrackChanged != 0 ||
     PlotNeutrChanged != 0 ||
     PlotHitChanged   != 0 || PlotAxisChanged  != 0 ||
     EtaMinChanged    != 0 || EtaMaxChanged    != 0 ||
     MomCutChanged    != 0 || MomSwitchChanged != 0 ||
     eventnchanged    != 0 || RadMaxChanged    != 0 ||
     McfSetDisp(Reset,PickTraceInfo,PickHepNum) != 0){
       open_display(geoOut);
       McfTracePosition(PlotTrack, PlotTrace, PlotNeutr, PlotHit,
                        EtaMin, EtaMax, MomSwitch, MomCut, RadMax);
       if(PlotAxis == 1){
         TraceDisplayAddAxis();
       }
       geom_exit(*geoOut);   
   }
    McfHepLattice(&nhep, &hepdata); 
    *heplat = cxLatDataNew(
              1,
              &nhep,
              HEPLATDATASIZE,
              cx_prim_float);
              cxLatPtrGet(*heplat,NULL,(void **)&latdata,NULL,NULL);
      for(icount = 0;
          icount < nhep;
          icount++){
        for(info = 0;
            info < HEPLATDATASIZE;
            info++){
              latdata[icount*HEPLATDATASIZE + info] = 
              hepdata[icount*HEPLATDATASIZE + info];
           }
         }
    free(hepdata);       /*hepdata gets malloced in McfHepLattice*/
}

void open_display(cxGeometry **geoOut)
{
    cxGeometry *geoLocal;

    printf("ENTER: open_display()\n");
    
    if(GeomInitDone == False ) { 
       cxGeoInit();
       printf("initializing geometry\n");
       GeomInitDone = True;
    }

    /* Initialize geometry object and prepare for data; */

    geoLocal = cxGeoNew();
    if( cxDataAllocErrorGet() ) cleanup_geometry(geoLocal);
    cxGeoBufferSelect(geoLocal);
    cxGeoRoot();
    if( cxDataAllocErrorGet() ) cleanup_selected(geoLocal);
    cxGeoDelete();
    if( cxDataAllocErrorGet() ) cleanup_selected(geoLocal);

    *geoOut = geoLocal;
printf("LEAVE: open_display()\n");
}



/********************************************/
/* Display close down and output procedures */
/********************************************/
void geom_exit(cxGeometry *geoOut)
{
printf("\n\n\nENTER: geom_exit()\n");
    cxGeoBufferClose(geoOut);
printf("LEAVE: geom_exit()\n");
return;
}

/* Clean up geometry if out of memory */
void cleanup_selected(cxGeometry *geoLocal)
{
printf("ENTER: cleanup_selected()\n");
    cxGeoBufferClose(geoLocal);
    cleanup_geometry(geoLocal);    
printf("LEAVE: cleanup_selected()\n");
}

void cleanup_geometry(cxGeometry *geoLocal)
{
printf("ENTER: cleanup_geometry()\n");
    cxDataRefDec(geoLocal);
printf("LEAVE: cleanup_geometry()\n");
    return;
}

void Mcf_HepTrackDisplay(struct Position begin, struct Position end, 
                         float color[3]){
int nvert = 3;
float vert[9];
float radius = 10.;
float radius2 = 20.;
int check;
    printf("entering  Mcf_HepTrackDisplay\n");
/*    cxGeoColorAdd(1,&color[0],CX_GEO_PER_OBJECT); */  
    printf("called geometry Mcf_HepTrackDisplay\n");
    vert[0] = begin.x;
    vert[1] = begin.y;
    vert[2] = begin.z;
    vert[3] = end.x;
    vert[4] = end.y;
    vert[5] = end.z;
    vert[6] = end.x + 10;
    vert[7] = end.y + 10;
    vert[8] = end.z;    
    cxGeoCylindersDefine(1,&vert[0],&vert[3],&radius);
    /*cxGeoConesDefine(1,&vert[3],&vert[6],&radius2);*/
    cxGeoColorAdd(1,&color[0],CX_GEO_PER_OBJECT);   
}
int McfTraceDisplay(int nvert, struct Position *pos, float *color, int id){
/* first version--nice green lines, connect the dots */
int n, count;
double len;
static double avelen = 0.0;
int nvcomp = 0;
float *pv;
char sid[30];
  if(nvert < 1){
    printf(" McfTraceDisplay: must define vertices before call\n");
    return -1;
    }
  if(nvert < 2){
    printf(" McfTraceDisplay: not enough traces on track\n");
    return -2;
  }
  nvcomp = TraceCompress(nvert, pos);
  pv = (float *) malloc((nvcomp*3)*sizeof(float));  
  for(n=0; n<nvcomp; n++){
     pv[(3*n)+0] = pos[n].x;
     pv[(3*n)+1] = pos[n].y;
     pv[(3*n)+2] = pos[n].z; 
  }
  cxGeoLinesDefine(nvcomp, pv, 0, NULL);
  cxGeoColorAdd(1,color,CX_GEO_PER_OBJECT);
  count = sprintf(sid,"%d",id);
  cxGeoLabelAdd(sid);   
  free (pv);
  return 0; 
}
int McfHitDisplay(int nhit, struct Position *hit){
int n;
float color[3] = {0.5, 0.6, 1.0};
float *pv;
/* Make little crosses to mark the hits */
  pv = (float *) malloc(6*sizeof(float));  
  for(n=0; n<nhit; n++){
     pv[0] = hit[n].x+5;
     pv[1] = hit[n].y;
     pv[2] = hit[n].z;
     pv[3] = hit[n].x-5;
     pv[4] = hit[n].y;
     pv[5] = hit[n].z;
     cxGeoLinesDefine(2, pv, 0, NULL);
     cxGeoColorAdd(1,color,CX_GEO_PER_OBJECT);
     pv[0] = hit[n].x;
     pv[1] = hit[n].y+5;
     pv[2] = hit[n].z;
     pv[3] = hit[n].x;
     pv[4] = hit[n].y-5;
     pv[5] = hit[n].z;
     cxGeoLinesDefine(2, pv, 0, NULL);
     cxGeoColorAdd(1,color,CX_GEO_PER_OBJECT);
  }
  free (pv);
  return 0; 
}
int TraceDisplayAddAxis(void){
float color[3];
float pv[9];
float radius = 10.;
char axis[6] = "xaxis";
  pv[0] = 0.0; pv[1]=0.0; pv[2] = 0.0;
  /*xaxis*/
  pv[3] = 1000.0; pv[4] = 0.0; pv[5] = 0.0;
  pv[6] = 1100.0; pv[7] = 0.0; pv[8] = 0.0;
  color[0] = 0.36; color[1] = 0.07; color[2] = 1.0;
  cxGeoLinesDefine(3, pv, 0, NULL);
  cxGeoColorAdd(1,color,CX_GEO_PER_OBJECT);
  cxGeoConesDefine(1,&pv[3],&pv[6],&radius);
  cxGeoColorAdd(1,color,CX_GEO_PER_OBJECT);
  cxGeoLabelAdd(axis);
  /*yaxis*/
  pv[3] = 0.0; pv[4] = 1000.0; pv[5] = 0.0;
  pv[6] = 0.0; pv[7] = 1100.0; pv[8] = 0.0;
  color[0] = 0.33; color[1] = 0.88; color[2] = 1.0;
  cxGeoLinesDefine(3, pv, 0, NULL);
  cxGeoColorAdd(1,color,CX_GEO_PER_OBJECT);
  cxGeoConesDefine(1,&pv[3],&pv[6],&radius);
  cxGeoColorAdd(1,color,CX_GEO_PER_OBJECT);
  cxGeoLabelAdd("yaxis");
    /*zaxis*/
  pv[3] = 0.0; pv[4] = 0.0; pv[5] = 2000.0;
  pv[6] = 0.0; pv[7] = 0.0; pv[8] = 2100.0;  
  color[0] = 1.00; color[1] = 0.94; color[2] = 0.61;
  cxGeoLinesDefine(3, pv, 0, NULL);
  cxGeoColorAdd(1,color,CX_GEO_PER_OBJECT);  
  cxGeoConesDefine(1,&pv[3],&pv[6],&radius);
  cxGeoColorAdd(1,color,CX_GEO_PER_OBJECT);
  cxGeoLabelAdd("zaxis");
  }
int TraceCompress(int nvert, struct Position *p){
struct Position *temp;
int n1, n2, n3, next;
int nvcomp = 0;
double cutoff = 1.01;
struct Vector v1, v2;
         temp = (struct Position *)malloc(nvert*sizeof(struct Position)); 
        for(n1 = 0; n1<nvert; n1++){
           temp[n1].x = p[n1].x;
           temp[n1].y = p[n1].y;
           temp[n1].z = p[n1].z;
        }
        n1 = 0; n2 = n1 + 1; n3 = n1 + 2;
        while(n3<nvert){
          MakeVect((temp + n1),(temp + n2),&v1); 
          MakeVect((temp + n1),(temp + n3),&v2);
          if(GetCos(v1,v2)>=cutoff){
            next = n3 + 1; n2 = n3; n3 = next;
          }else{
            nvcomp++;
            p[nvcomp].x = temp[n2].x;
            p[nvcomp].y = temp[n2].y;
            p[nvcomp].z = temp[n2].z;
            next = n3 + 1; n1 = n2; n2 = n3; n3 = next;
          }
        }
        nvcomp++;
        p[nvcomp].x = temp[nvert-1].x;
        p[nvcomp].y = temp[nvert-1].y;
        p[nvcomp].z = temp[nvert-1].z;
        nvcomp++;
        free(temp);
        return nvcomp;        
}

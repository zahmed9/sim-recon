#include <stdio.h>
#include <iostream.h>
#include <math.h>
#ifndef MCFAST
#define MCFAST
#include "mcfast_db.h"
#endif
#include "SiZRectCommon.hh"
#include "SilZRectData.hh"  //includes the structures for global, layer,
                            //wafer and strip information
                           
void getSilZRectGlobalData(int which, SilZRectGlobalData &data)
{
     data.xpos   = sizrect[which-1].xpos;
     data.ypos   = sizrect[which-1].ypos;
     data.zpos   = sizrect[which-1].zpos;
     data.nlayer = sizrect[which-1].nlayer;
     return;
};
void getSilZRectLayerData(int which, SilZRectLayerData &data)
{
//From Julia--defination of wafer1xlocal--called startXWafer here:
//wafer1xlocal is the coordinate of the 1st wafer center.
//Later I check if it's legal, I mean if distance between it and the layer's
//edge is >= xlen/2. of wafer so thta the wafer really fits in.
 
     data.nwaferX     = layersizrect[which-1].nwaferx;
     data.nwaferY     = layersizrect[which-1].nwafery;
     data.zLocal      = layersizrect[which-1].zlayerlocal;
     data.rotation    = layersizrect[which-1].rotation;
     data.lenXLayer   = layersizrect[which-1].xlen;
     data.lenYLayer   = layersizrect[which-1].ylen;
     data.lenXGap     = layersizrect[which-1].gapxlen;
     data.lenYGap     = layersizrect[which-1].gapylen;
     data.startXWafer = -layersizrect[which-1].xlen/2.;
     data.startYWafer = layersizrect[which-1].ylen/2.;
     data.thick       = getSilZRectLayerThickness(which);
     //adjust for mcfast weirdness
     if(layersizrect[which-1].xlen == layersizrect[which-1].gapxlen)
         data.lenXGap =0;
     if(layersizrect[which-1].ylen == layersizrect[which-1].gapylen)
         data.lenYGap =0;
     char string[3];
     strncpy(string,layersizrect[which-1].staggeringpattern,2);
     if(strncmp(string,"X",1)==0)
     {
        data.pattern = XTILE;
     }
     else if(strncmp(string,"Y",1)==0)
     {
        data.pattern = YTILE;
     } 
     else if(strncmp(string, "CH", 2) == 0)
     {
        data.pattern = CHECKER;
     }
     else
     {
        data.pattern = NOTILE;
     }
     return;
};
void getSilZRectWaferData(int which, SilZRectWaferData &data)
{
     data.waferNumX  = wfrsizrect[which-1].waferx;
     data.waferNumY  = wfrsizrect[which-1].wafery;
     data.measureType= wfrsizrect[which-1].type;
     data.stereo     = wfrsizrect[which-1].stereo;
     data.lenXWaf    = wfrsizrect[which-1].xlen;
     data.lenYWaf    = wfrsizrect[which-1].ylen;
     data.thick      = wfrsizrect[which-1].zlen;
     data.zOffset    = wfrsizrect[which-1].zoffset;
     data.nsegX      = wfrsizrect[which-1].nsegm_x;
     data.nsegY      = wfrsizrect[which-1].nsegm_y;
     data.pitchX     = wfrsizrect[which-1].pitch_x;
     data.pitchY     = wfrsizrect[which-1].pitch_y;
     data.startXPixel= wfrsizrect[which-1].coord0_x;
     data.startYPixel= wfrsizrect[which-1].coord0_y;
     return;
}
int getSilZRectWaferType(int which)
{
     char string[4];
     strncpy(string,wfrsizrect[which-1].speci,3);
     if(strncmp(string,"ALL",3)==0)
     {
        return ALL;
     }
     else if(strncmp(string,"SPC",3)==0)
     {
        return SPC;
     } 
     return -999;
};
void getSilZRectLayerEdges(int which, float &xmin, float &xmax,
                                      float &ymin, float &ymax,
                                      float &zmin, float &zmax)
{
    int det = layersizrect[which-1].det;
    xmin = sizrect[det-1].xpos - layersizrect[which-1].xlen/2.;    
    xmax = sizrect[det-1].xpos + layersizrect[which-1].xlen/2.;    
    ymin = sizrect[det-1].ypos - layersizrect[which-1].ylen/2.;    
    ymax = sizrect[det-1].ypos + layersizrect[which-1].ylen/2.;
    zmin = sizrect[det-1].zpos + layersizrect[which-1].zlayerlocal;
    zmax = zmin;
    return;   
}
float getSilZRectLayerThickness(int which)
{
     stagger pattern;
     float thick = 0;
     char string[4];
     strncpy(string,layersizrect[which-1].staggeringpattern,2);
     if(strncmp(string,"X",1)==0)
     {
        pattern = XTILE;
     }
     else if(strncmp(string,"Y",1)==0)
     {
        pattern = YTILE;
     } 
     else if(strncmp(string, "CH", 2) == 0)
     {
        pattern = CHECKER;
     }
     else
     {
        pattern = NOTILE;
     }
    for (int i = which-1; i < NumSiZRectWafers(); i++)
    {
        if( layersizrect[which-1].lyr == wfrsizrect[i].lyr &&
            layersizrect[which-1].det == wfrsizrect[i].det )
        {
	   strncpy(string,wfrsizrect[i].speci,3);
	   if(strncmp(string,"ALL",3)==0 && pattern == NOTILE)
	   {
              thick = wfrsizrect[i].zlen + wfrsizrect[i].zoffset;
              return thick;
	   }
	   else if(strncmp(string,"ALL",3)==0)
	   {
	      thick = 2*(wfrsizrect[i].zlen + fabs(wfrsizrect[i].zoffset));
	      return thick;
	   }
	   else if(strncmp(string,"SPC",3)==0)
	   {
	      thick += wfrsizrect[i].zlen + fabs(wfrsizrect[i].zoffset);
	   }
	}
    }
    return thick;
}
void getSilZRectGlobalName(int which, char *name)
{
      strcpy(name, sizrect[which-1].name);
      return;
};
int NumSiZRect(void)
{
    return *n_obj_sizrect;
};
int NumSiZRectWafers(void)
{
    return *n_obj_wfrsizrect;
}
int WhichSiZRectLayer(int idet, int ilyr)
{
    //returns the absolute layer given a detector and local layer number
    for (int i = 0; i < *n_obj_layersizrect; i++)
    {
        if (layersizrect[i].det == idet && layersizrect[i].lyr == ilyr)
              return (i+1);
   
    }
    return -999;
}
int WhichSiZRectWafer(int idet, int ilyr, int iwafX, int iwafY)
{
    //returns the absolute wafer given a detector and local layer/wafer
    for (int i = 0; i < *n_obj_wfrsizrect; i++)
    {
        if (wfrsizrect[i].det == idet && wfrsizrect[i].lyr == ilyr)
        {
           char string[4];
           strncpy(string,wfrsizrect[i].speci,3);
           if(strncmp(string,"ALL",3)==0)
                 return (i+1);  //for all, just return that wafer

           for(int j = i; j < *n_obj_wfrsizrect; j++)
           {
              if(wfrsizrect[j].waferx == iwafX &&
                 wfrsizrect[j].wafery == iwafY) return (j+1);
           }
        }
    }
    return -999;
}
int LayerToWafer(int which)
{
    for(int i = which; i < *n_obj_wfrsizrect+1; i++)
    {
        if(wfrsizrect[i-1].lyr == layersizrect[which-1].lyr)
        return (i);  
    }
    return -999;
}
ZRectLayerType getSilZRectLayerType(int which)
{
    
    if(layersizrect[which-1].gapxlen == layersizrect[which-1].xlen &&
       layersizrect[which-1].gapylen == layersizrect[which-1].ylen) return ONE;
       
    if(layersizrect[which-1].gapxlen == layersizrect[which-1].xlen) return TWOY;
    if(layersizrect[which-1].gapylen == layersizrect[which-1].ylen) return TWOX;
    
    return HOLE;
    
    
};

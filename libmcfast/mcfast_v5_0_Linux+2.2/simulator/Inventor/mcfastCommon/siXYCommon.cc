#ifndef MCFAST
#define MCFAST
#include "mcfast_db.h"
#endif
#include <math.h>
#include "SiXYCommon.hh"
#include "SilXYPlaneData.hh"  //includes both layer and global silxy structures

void getSilXYGlobalData(int which, SilXYGlobalData &data)
{
     data.z0 = sixy[which-1].zpos;
     data.nlayer = sixy[which-1].nly;
     return;
}
void getSilXYPlaneData(int which, SilXYPlaneData &data)
{
      data.z          = layersixy[which-1].z_local; 
      data.thick      = layersixy[which-1].thick;
      data.stereo     = layersixy[which-1].stereo;
      data.xmin       = layersixy[which-1].xmin;
      data.xmax       = layersixy[which-1].xmax;
      data.ymin       = layersixy[which-1].ymin;
      data.ymax       = layersixy[which-1].ymax;
      data.xminGap    = layersixy[which-1].xmin_gap;
      data.xmaxGap    = layersixy[which-1].xmax_gap;
      data.yminGap    = layersixy[which-1].ymin_gap;
      data.ymaxGap    = layersixy[which-1].ymax_gap;
      data.nsegX      = layersixy[which-1].nsegm_x;
      data.nsegY      = layersixy[which-1].nsegm_y;
      data.pitchX     = layersixy[which-1].pitch_x;
      data.pitchY     = layersixy[which-1].pitch_y;
      data.startX     = fabs(layersixy[which-1].coord0_x
                        - layersixy[which-1].xmin);
      data.startY     = fabs(layersixy[which-1].coord0_y 
                        - layersixy[which-1].ymin);

//for some reason, xminGap = xmin etc., the default for no gap
//no gap should really be xminGap etc. = 0

      if(data.xminGap == data.xmin) data.xminGap = 0.;
      if(data.xmaxGap == data.xmax) data.xmaxGap = 0.;
      if(data.yminGap == data.ymin) data.yminGap = 0.;
      if(data.ymaxGap == data.ymax) data.ymaxGap = 0.;
      return;
}
void getSiXYGlobalName(int which, char *name)
{
    strcpy(name, sixy[which-1].name);
    return;      
}
//the following routines are dummies for now.
char *checkSiXYGlobal(int which)
{
      return NULL;
}
char *checkSiXYPlane(int which)
{
      return NULL;
}
int NumSilXY(void)
{
    return *n_obj_sixy;
}
int WhichPixelPlane(int idet, int ilyr)
{
    //returns the absolute layer given a detector and local layer
    for (int i = 0; i < *n_obj_layersixy; i++)
    {
        if (layersixy[i].det == idet && layersixy[i].lyr == ilyr)
             return (i + 1);
    }
    return -999;

}

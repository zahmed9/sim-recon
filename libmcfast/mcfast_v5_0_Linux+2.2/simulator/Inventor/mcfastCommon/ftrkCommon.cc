#ifndef MCFAST
#define MCFAST
#include "mcfast_db.h"
#endif
#include "ftrkCommon.hh"
#include <iostream.h>
//this get the information from the forward tracker commons

void getFtrkData(int which, frameDetectorData &data)
{
       //first off check thickness.  I assume that the chamber is
       //symetric but Mcfast allows for other possiblities
      if( ftrk[which-1].thick_boun[0] != ftrk[which-1].thick_boun[1] ||
          ftrk[which-1].thick_boun[2] != ftrk[which-1].thick_boun[3] ||
          ftrk[which-1].thick_boun[4] != ftrk[which-1].thick_boun[5] )
          cout << " This display assumes a symmetric amount of material \n"
                << " material shown will be the average \n";
                
      data.z0 = ftrk[which-1].z0;

      data.xLenInner = (ftrk[which-1].xmax - ftrk[which-1].xmin)/2.;
      data.yLenInner = (ftrk[which-1].ymax - ftrk[which-1].ymin)/2.;
      data.zLenInner = (ftrk[which-1].zlen)/2.;
      
      data.xLenOuter = data.xLenInner + (ftrk[which-1].thick_boun[0] 
                      + ftrk[which-1].thick_boun[1])/2.;
      data.yLenOuter = data.yLenInner + (ftrk[which-1].thick_boun[2] 
                      + ftrk[which-1].thick_boun[3])/2.;
      data.zLenOuter = data.zLenInner + (ftrk[which-1].thick_boun[4] 
                      + ftrk[which-1].thick_boun[5])/2.;

      return;
}
void getFtrkLayerData(int which, frameDetectorData &data1, 
                                 forTrackerLayer &data2)
{
      data1.z0 = layerftrk[which-1].z_local;
      
      data1.xLenInner = (layerftrk[which-1].xmax_gap -
                         layerftrk[which-1].xmin_gap)/2.;
      data1.yLenInner = (layerftrk[which-1].ymax_gap -
                         layerftrk[which-1].ymin_gap)/2.;
      data1.zLenInner = layerftrk[which-1].thick;
      if(data1.zLenInner < 0.05) data1.zLenInner *= 100.;

      data1.xLenOuter = (layerftrk[which-1].xmax -
                         layerftrk[which-1].xmin)/2.;
      data1.yLenOuter = (layerftrk[which-1].ymax -
                         layerftrk[which-1].ymin)/2.;
      
      data1.zLenOuter = layerftrk[which-1].thick;
      if(data1.zLenOuter < 0.05) data1.zLenOuter *= 100.;
      
      data2.stereo = layerftrk[which-1].stereo;
      data2.xStart = layerftrk[which-1].coord0_x;
      data2.yStart = layerftrk[which-1].coord0_y;
      
      return;
}
int NumFtrk(void)
{
    return *n_obj_ftrk;
}
int NumFtrklayer(int which)
{
    return ftrk[which-1].nlyr;
}
void getFtrkName(int which, char *name)
{
    strcpy(name, ftrk[which-1].name);
    return;      
}


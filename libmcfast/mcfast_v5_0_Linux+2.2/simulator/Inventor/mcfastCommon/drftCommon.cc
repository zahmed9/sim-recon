#ifndef MCFAST
#define MCFAST
#include "mcfast_db.h"
#endif
#include "drftCommon.hh"
#include "ConicalDetectorData.hh"
#include "driftChamberData.hh"
#include <iostream.h>
#include <string.h>
//this get the information from the drift chambers
int NumDrift(void)
{
    return *n_obj_drift;
}
void getDriftName(int which, char *name)
{
    strcpy(name, drift[which-1].name);
    return;
}
int NumDriftAnodeLayer(int which)
{
    return drift[which-1].num_anode;
}
int NumDriftCathodeLayer(int which)
{
    return drift[which-1].num_cathode;
}
int NumDriftAnode(void)
{
    return *n_obj_layerdrfano;
}
int NumDriftCathode(void)
{
    return *n_obj_layerdrfcatho;
}
int NumDriftAnodeOffset(void)
{
    return *n_obj_offsetdrfano;
}
void getDriftData(int which, ConicalDetectorData &data)
{
      data.z0 = drift[which-1].z0;
      data.zlen = drift[which-1].zlen;
      
      data.rminZlow  = drift[which-1].rmin;
      data.rminZhigh = drift[which-1].rmin;
      data.rmaxZlow  = drift[which-1].rmax;
      data.rmaxZhigh = drift[which-1].rmax;

       return;
}
void getDriftAnodeData(int which, driftAnodeData &data)
{
      data.detector    = layerdrfano[which-1].det;
      data.layer       = layerdrfano[which-1].lyr;
      data.nwires      = layerdrfano[which-1].nwires;
      data.radius      = layerdrfano[which-1].radius;
      data.zlen        = layerdrfano[which-1].zlen;
      data.cellHeight  = layerdrfano[which-1].cell_height;
      data.phi0        = layerdrfano[which-1].phi0;
      data.stereo      = layerdrfano[which-1].stereo_tau;
      data.stereoOffset= layerdrfano[which-1].stereo_offset;
      return;
     
} 
void getDriftCathodeData(int which, driftCathodeData &data)
{
      data.detector    = layerdrfcatho[which-1].det;
      data.layer       = layerdrfcatho[which-1].lyr;
      data.nstrips     = layerdrfcatho[which-1].nstrips;
      data.nPhiSeg     = layerdrfcatho[which-1].n_phi_segm;
      data.cellOffset  = layerdrfcatho[which-1].cell_offset;
      data.zlen        = layerdrfcatho[which-1].zlen;
      data.deltaR      = layerdrfcatho[which-1].delta_r;
      return;

}
void getDriftOffsetData(int which, driftOffsetData &data)
{
      data.detector    = offsetdrfano[which-1].det;
      data.layer       = offsetdrfano[which-1].lyr;
      data.cellOffset  = offsetdrfano[which-1].cell_offset;
      data.sag         = offsetdrfano[which-1].sag;

}

#ifndef MCFAST
#define MCFAST
#include "mcfast_db.h"
#endif
#include "SiBarrelCommon.hh"
#include "SilBarrelData.hh"  //includes the structures for global, layer,
                            //wafer and strip information
                            
void getSilBarrelGlobalData(int which, SilBarrelGlobalData &data)
{
     data.z0 = sibarrel[which-1].z0_global;
     data.nlayer = sibarrel[which-1].nlyr;
     return;
};
void getSilBarrelLayerData(int which, SilBarrelLayerData &data)
{
     data.zlen    = layersib[which-1].zlen;
     data.beta    = layersib[which-1].beta;
     data.delta   = layersib[which-1].delta;
     data.width   = layersib[which-1].width;
     data.type    = layersib[which-1].type;
     data.nwafer  = layersib[which-1].nwaf;
     data.ilyr    = layersib[which-1].lyr;
//for some reason, people tend to define the second layer of a
//double sided layer as having 0 thickness.  MCFast apparently doesn't
//care, but of course the graphics does.  Correct for that by getting
//the previous layer thickness for double sided layers

     if(IsDoubleSiBLayer(which))
     {
	data.thick = layersib[which-2].thick;
     }
     else
     {
     data.thick   = layersib[which-1].thick;
     }
     
     return;
};
void getSilBarrelWaferData(int which, SilBarrelWaferData &data)
{
     data.tilt    = wafer[which-1].tilt;
     data.c0x     = wafer[which-1].c0x;
     data.x0y     = wafer[which-1].c0y;
     data.pitch   = wafer[which-1].pitch;
     data.stereo  = wafer[which-1].stereo;
     data.nstrip  = wafer[which-1].nstrip;
     data.ilyr    = wafer[which-1].lyr;

     char string[4];
     strncpy(string,wafer[which-1].speci,3);
     if(strncmp(string,"ALL",3)==0)
     {
        data.waferType = ALL;
     }
     else if(strncmp(string,"SPC",3)==0)
     {
        data.waferType = SPC;
     } 
     return;
};
void getSiBarrelGlobalName(int which, char *name)
{
      strcpy(name, sibarrel[which-1].name);
      return;
};
int NumSilBarrel(void)
{
    return *n_obj_sibarrel;
};
int NumSilBarrelWafers(void)
{
    return *n_obj_wafer;
}
Boolean IsDoubleSiBLayer(int which)
{
  if(which == 1) return FALSE;
  if(layersib[which-1].det   == layersib[which-2].det &&
     layersib[which-1].nwaf  == layersib[which-2].nwaf &&
     layersib[which-1].zlen  == layersib[which-2].zlen &&
     layersib[which-1].beta  == layersib[which-2].beta &&
     layersib[which-1].delta == layersib[which-2].delta ) return TRUE;
     return FALSE;  
};
int WhichBarrelLayer(int idet, int ilyr)
{
    //returns the absolute layer given a detector and local layer number
    for (int i = 0; i < *n_obj_layersib; i++)
    {
        if (layersib[i].det == idet && layersib[i].lyr == ilyr)
              return (i+1);
   
    }
    return -999;
}
int WhichBarrelWafer(int idet, int ilyr, int iwaf)
{
    //returns the absolute wafer given a detector and local layer/wafer
    for (int i = 0; i < *n_obj_wafer; i++)
    {
        if (wafer[i].det == idet && wafer[i].lyr == ilyr)
        {
           char string[4];
           strncpy(string,wafer[i].speci,3);
           if(strncmp(string,"ALL",3)==0)
                 return (i+1);  //for all, just return that wafer

           for(int j = i; j < *n_obj_wafer; j++)
           {
              if(wafer[j].nwaf == iwaf) return (j+1);
           }
        }
    }
    return -999;
}

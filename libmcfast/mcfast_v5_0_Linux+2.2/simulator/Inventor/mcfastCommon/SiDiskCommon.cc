#ifndef MCFAST
#define MCFAST
#include "mcfast_db.h"
#endif
#include <math.h>
#include "SiDiskCommon.hh"
#include "SilDiskData.hh"  //includes the structures for global, layer,
                            //wafer and strip information
                            
void getSilDiskGlobalData(int which, SilDiskGlobalData &data)
{
     data.z0 = sidisk[which-1].zpos;
     data.nlayer = sidisk[which-1].nlyr;
     return;
};
void getSilDiskLayerData(int which, SilDiskLayerData &data)
{
     data.zlocal  = layersidi[which-1].z_local;
     data.thick   = layersidi[which-1].thick;
     data.rmin    = layersidi[which-1].rmin;
     data.rmax    = layersidi[which-1].rmax;
     data.phi[0]  = layersidi[which-1].phi[0];
     data.phi[1]  = layersidi[which-1].phi[1];
     data.dphi    = layersidi[which-1].dphi;
     data.type    = layersidi[which-1].type;
     data.nwedge  = layersidi[which-1].nwed;
     data.ilyr    = layersidi[which-1].lyr;
     return;
};
void getSilDiskWedgeData(int which, SilDiskWedgeData &data)
{
     data.c0r     = wedge[which-1].c0_r;
     data.c0phi   = wedge[which-1].c0_phi;
     data.pitch   = wedge[which-1].pitch;
     data.stereo  = wedge[which-1].stereo;
     data.nstrip  = wedge[which-1].nstrip;
     data.ilyr    = wedge[which-1].lyr;

     char string[4];
     strncpy(string,wedge[which-1].speci,3);
     if(strncmp(string,"ALL",3)==0)
     {
        data.wedgeType = ALL;
     }
     else if(strncmp(string,"SPC",3)==0)
     {
        data.wedgeType = SPC;
     } 
     return;
};
void getSiDiskGlobalName(int which, char *name)
{
      strcpy(name, sidisk[which-1].name);
      return;
};
int NumSilDisk(void)
{
    return *n_obj_sidisk;
};
int NumSilDiskWedges(void)
{
    return *n_obj_wedge;
}
Boolean IsDoubleSiDLayer(int which)
{
  if (which == 1) return FALSE;
  if (layersidi[which-1].det != layersidi[which-2].det) return FALSE;
  if (layersidi[which-1].nwed != layersidi[which-2].nwed) return FALSE;
  if (layersidi[which-1].rmin != layersidi[which-2].rmin) return FALSE;
  if (layersidi[which-1].rmax != layersidi[which-2].rmax) return FALSE;
  if (layersidi[which-1].phi[0] != layersidi[which-2].phi[0]) return FALSE;
  if (layersidi[which-1].phi[1] != layersidi[which-2].phi[1]) return FALSE;
//Mcfast has some strange geometry conventions.  Need to add a check on the
//relative Z location of the disks for atlas which doesn't use a separate 
//detector for each disk doublet.  But the thickness isn't always filled for 
//both disks in a doublet. 

  float thickness = (layersidi[which-1].thick > layersidi[which-2].thick) ? 
                    layersidi[which-1].thick:
                    layersidi[which-2].thick;       
  
  //add little for roundoff error
  thickness = thickness + 0.1 * thickness;
  if (abs(layersidi[which-1].z_local - layersidi[which-2].z_local) > thickness)
               return FALSE;
  return TRUE;

//the following doesn't work.  Compiler bug or some stupidity I have just 
//overlooked?

//  if(layersidi[which-1].det == layersidi[which-2].det &&
//     layersidi[which-1].nwed == layersidi[which-2].nwed &&
//     layersidi[which-1].rmin == layersidi[which-2].rmin &&
//     layersidi[which-1].rmax == layersidi[which-2].rmax &&
//     layersidi[which-1].phi[0] == layersidi[which-2].phi[0] &&
//     layersidi[which-1].phi[1] == layersidi[which-2].phi[1]) return TRUE;
//     return FALSE;
}
int WhichDiskLayer(int idet, int ilyr)
{
    //returns the absolute layer given a detector and local layer number
    for (int i = 0; i < *n_obj_layersidi; i++)
    {
        if (layersidi[i].det == idet && layersidi[i].lyr == ilyr)
              return (i+1);
   
    }
    return -999;
}
int WhichDiskWedges(int idet, int ilyr, int iwed)
{
    //returns the absolute wedge given a detector and local layer/wedge
    for (int i = 0; i < *n_obj_wedge; i++)
    {
        if (wedge[i].det == idet && wedge[i].lyr == ilyr)
        {
           char string[4];
           strncpy(string,wedge[i].speci,3);
           if(strncmp(string,"ALL",3)==0)
                 return (i+1);  //for all, just return that wedge

           for(int j = i; j < *n_obj_wedge; j++)
           {
              if(wedge[j].nwed == iwed) return (j+1);
           }
        }
    }
    return -999;

}
                           

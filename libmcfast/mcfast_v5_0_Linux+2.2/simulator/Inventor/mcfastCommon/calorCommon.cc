#ifndef MCFAST_DB
#define MCFAST_DB
#include "mcfast_db.h"
#endif
#include "calorCommon.hh"
#include "McFBarrelCal.hh"
#include "McFForwardCal.hh"
#include <iostream.h>

int NumCalorProj(void)
{
    return *n_obj_emcal;
}
int TypeCalorProj(int which)
{
    cout << "Which calorimeter " << which
    << " calorimeter type " << emcal[which-1].type << endl;
    if (emcal[which-1].type == 1 ) 
    {
        return BARREL;
    }
    else if(emcal[which-1].type == 2 )
    {
         
	 return FORWARD;
    }
    else if(emcal[which-1].type == 51) 
    {
         return ZPHI;
    }
    else if(emcal[which-1].type == 52) 
    {
         return RPHI;
    }
    else return NOTIMP;
}
void getProjectiveCalData(int which, projectiveCalData &data)
{   
         data.z0 = emcal[which-1].z0;
         data.zLength = emcal[which-1].zlen;
         data.rMin[0] = emcal[which-1].rmin[0];
         data.rMin[1] = emcal[which-1].rmin[1];
         data.rMax[0] = emcal[which-1].rmax[0];
         data.rMax[1] = emcal[which-1].rmax[1];
         data.nPhi    = emcal[which-1].nphi;
         data.nEta    = emcal[which-1].neta;
}
//void getBoxCalDataEmcal(int which, boxCalData &data)
//{
//       data.z0 = emcal[which-1].z0;
//
//      data.xLenInner = (emcal[which-1].xlimit_gap[1] 
//                        - emcal[which-1].xlimit_gap[0])/2.;
//      data.yLenInner = (emcal[which-1].ylimit_gap[1] 
//                        - emcal[which-1].ylimit_gap[0])/2.;
//      data.xLenOuter = (emcal[which-1].xlimit[1] 
//                        - emcal[which-1].xlimit[0])/2.;
//      data.yLenOuter = (emcal[which-1].ylimit[1] 
//                        - emcal[which-1].ylimit[0])/2.;
//
//      data.zLenInner = (emcal[which-1].zlen)/2.;
//      data.zLenOuter = (emcal[which-1].zlen)/2.;
//      data.nSeg1 = calorbox[which-1].ncoor1;
//      data.nSeg2 = calorbox[which-1].ncoor2;
//}
void getCalorName(int which, char *name)
{
    strcpy(name, emcal[which-1].name);
    return;      
}
int getNPhiSegments(int which)
{
   return emcal[which-1].nphi;
}
int getNEtaSegments(int which)
{
   return emcal[which-1].neta;
}

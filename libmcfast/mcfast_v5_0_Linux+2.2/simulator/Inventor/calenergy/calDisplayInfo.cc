#include "calDisplayInfo.hh"
void calDispInfoInitialize( displayType calPlot, calDispInfo *temp)
{
    temp->dispEorEt = MOMENTUM;  // Default to display energy
    temp->threshold = DEFAULTTHRESHOLD; 
    temp->minEnergy = ON;
    temp->hadEnergy = ON;
    temp->emEnergy  = ON;
    temp->dispFrame = ON;
    if(calPlot.type == TDPLOT) temp->dispFrame = OFF;  
    return;
}
void calDispInfoSet( calDispInfo set, calDispInfo *temp)
{
   temp->dispEorEt = set.dispEorEt;
   temp->threshold = set.threshold;
   temp->dispFrame = set.dispFrame;
   temp->minEnergy = set.minEnergy;
   temp->hadEnergy = set.hadEnergy;
   temp->emEnergy  = set.emEnergy;
   return;
}

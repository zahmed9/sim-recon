#include "displayTypes.hh"
#ifndef CALDISPLAYINFO
#define CALDISPLAYINFO

const float DEFAULTTHRESHOLD = 0.05; //set cut at 50 MeV

//This structure holds the information necessary to control the calorimeter
// hit display

struct calDispInfo
{
     float threshold;
     momType dispEorEt;
     toggleType dispFrame;
     toggleType minEnergy;
     toggleType hadEnergy;
     toggleType emEnergy;
     
};
void calDispInfoInitialize(displayType calPlot, calDispInfo *temp);
void calDispInfoSet( calDispInfo set, calDispInfo *temp);
#endif

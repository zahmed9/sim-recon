#ifndef CALPLOT 
#define CALPLOT
#include "Calorimeter.hh"
#include "towerHit.hh"
#include "mcfCalEnergy.hh"
#include "eventInformation.hh"
class SoSeparator;
class calPlot
{
protected: 
    mcfCalEnergy *energy;
public:
    calPlot(void)
    {
       eventInformation *eventInfo = eventInformation::eventInfo();
       energy = eventInfo->calEnergy();
    }
    virtual SoSeparator *MakePlotFrame(int ncal, int *pical) = 0;
    virtual SoSeparator *FillInEnergy(void);
    virtual SoSeparator *MakeEnergyPlot(void)
    {
         return FillInEnergy();
    }
};
#endif

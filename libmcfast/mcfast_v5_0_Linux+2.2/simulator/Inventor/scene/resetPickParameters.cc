#include "hepvis/SoMcFCalEnergyKit.hh"
#include "hepvis/SoMcFTraceKit.hh"
#include "hepvis/SoMcFSilStripHitKit.hh"
#include "resetPickParameters.hh"
void resetPickParameters(void)
{
    SoMcFCalEnergyKit::resetPick();
    SoMcFTraceKit::resetPick();
    SoMcFSilStripHitKit::resetPick();
    return;   
}

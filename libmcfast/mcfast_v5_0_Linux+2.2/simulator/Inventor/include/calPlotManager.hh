#include "calPlot.hh"
#include "displayTypes.hh"
#ifndef CALPLOTMANAGER
#define CALPLOTMANAGER
class calPlotManager
{
   public: 
       calPlotManager(void){};
       calPlot *PlotType(PlotTypes calEtype);
};
#endif

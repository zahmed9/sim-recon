#include "calPlotManager.hh"
#include "threeDPlot.hh"
#include "etaCalPlot.hh"
#include "phiCalPlot.hh"
calPlot *calPlotManager::PlotType(PlotTypes calEtype)
{
     if( calEtype == LEGOPLOT )
     {
        return NULL;
     }
     else if( calEtype == ETAPLOT )
     {
        etaCalPlot *plot = new etaCalPlot;
        return plot;
     }
     else if( calEtype == PHIPLOT )
     {
        phiCalPlot *plot = new phiCalPlot;
        return plot;
     }
     else if( calEtype == TDPLOT )
     {
        threeDPlot *plot = new threeDPlot;
        return plot;
     }
     return NULL;
}

#include "traceDisplay.hh" 
#include "threeDTracePlot.hh"
#include "rPhiTracePlot.hh"
#include "rZTracePlot.hh"
#include "momTracePlot.hh"
void traceDisplay::makeTraceDisplay(SoSeparator *root, displayType plot,
                                    traceDispInfo info)
{
     if ( plot.type == NOPLOT ) return;
     pTracePlot = whichPlotType(plot);
     if ( pTracePlot == NULL ) return;
     pTracePlot -> makeTraces();
     traces = pTracePlot -> tracesToDisplay( info );
     root->addChild( traces );
     return;
     
}
void traceDisplay::updateTraceDisplay(SoSeparator *root, displayType plot,
                                      traceDispInfo info)
{
     if(plot.action == NOACTION || plot.type == NOPLOT) return;
     if(traces != NULL) root->removeChild(traces);
     if(plot.action == NEXTEVENT)
     {
       pTracePlot -> makeTraces();
     }
     if(plot.action == NEWPARAMETERS || plot.action == NEXTEVENT)
     {
       traces = pTracePlot -> tracesToDisplay( info ); 
       root->addChild(traces);
     }
     return;
}
tracePlot *traceDisplay::whichPlotType(displayType plot)
{

     if (plot.type == NOPLOT)
     {
         return NULL;
     }
     else if ( plot.type == TDPLOT )
     {
        threeDTracePlot *plot = new threeDTracePlot;
        return plot;
     }
     else if ( plot.type == RPHIPLOT )
     {
        rPhiTracePlot *plot = new rPhiTracePlot;
        return plot;
     }
     else if ( plot.type == RZPLOT )
     {
        rZTracePlot *plot = new rZTracePlot;
        return plot;
     }
     else if ( plot.type == MOMPLOT )
     {
        momTracePlot *plot = new momTracePlot;
        return plot;
     }
     else 
     {
         return NULL;        
     }  
   
}

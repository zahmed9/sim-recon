#include "detectorDisplay.hh"
#include "ivFileDetPlot.hh"
#include "threeDDetPlot.hh"
void detectorDisplay::makeDetPlot(SoSeparator *root, PlotTypes type)
{
     if( type  == NOPLOT ) return;
     pdetectorPlot = whichPlotType(type);
     if (pdetectorPlot == NULL ) return;
     detector = pdetectorPlot-> makeDetector();
     detector->whichChild = 0;
     root->addChild(detector);
     return;
}

void detectorDisplay::updateDetectorDisplay(SoSeparator *root, PlotActions
Action)
{
    if(pdetectorPlot == NULL) return; // no active plot
    if(Action == REMOVEFRAME)
    {
       detector->whichChild = SO_SWITCH_NONE;
       return;
    }
    else if(Action == ADDFRAME)
    {
       detector->whichChild = 0;
       return;
    }
    return;
}
detectorPlot *detectorDisplay::whichPlotType(PlotTypes plot)
{
      if (plot == NOPLOT)
      {
          return NULL;          
      }
      else if ( plot == TDPLOT )
      {
         threeDDetPlot *plot = new threeDDetPlot;
         return plot;
      } 
      else 
      {
         return NULL;
      } 
}

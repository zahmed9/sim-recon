#include "traceDisplayInfo.hh"
#include "tracePlot.hh"
#include <Inventor/nodes/SoGroup.h>
#include <Inventor/nodes/SoSeparator.h>
#ifndef TRACEDISPLAY
#define TRACEDISPLAY
class traceDisplay
{
    private:
      tracePlot *pTracePlot;
      SoSeparator *traces;
    public:
      traceDisplay(void)
      {
        pTracePlot = NULL;
        traces = NULL;
      }
      ~traceDisplay(void)
      {
        if( pTracePlot != NULL ) delete pTracePlot;
      }
      void makeTraceDisplay(SoSeparator *root, displayType plot,
                            traceDispInfo info);
      void updateTraceDisplay(SoSeparator *root, displayType plot,
                              traceDispInfo info);
      tracePlot *whichPlotType(displayType Plot); 
};
#endif

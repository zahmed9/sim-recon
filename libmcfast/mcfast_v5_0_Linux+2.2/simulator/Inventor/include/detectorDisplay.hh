#include <Inventor/nodes/SoGroup.h>
#include <Inventor/nodes/SoSeparator.h>
#include "displayTypes.hh"
#include "detectorPlot.hh"

#ifndef DETECTORDISPLAY
#define DETECTORDISPLAY
class detectorDisplay
{
    private:
      detectorPlot *pdetectorPlot;
      SoSwitch *detector;
    public:
    void makeDetPlot(SoSeparator *root, PlotTypes type);
    void updateDetectorDisplay(SoSeparator *root, PlotActions Action);
    detectorPlot *whichPlotType(PlotTypes plot);
};
#endif

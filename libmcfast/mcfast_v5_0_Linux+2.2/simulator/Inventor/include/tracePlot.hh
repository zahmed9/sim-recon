#include <Inventor/nodes/SoSeparator.h>
#include "traceDisplayInfo.hh"
#include "rgb.hh"
#ifndef TRACEPLOT
#define TRACEPLOT
class SoSwitch;
class tracePlot
{
     protected:
         SoSeparator *soTraces;
     public:
         tracePlot(void)
         {
            soTraces = new SoSeparator;
            soTraces->ref();
         }
         ~tracePlot(void)
         {
            soTraces->unref();
         }
         void makeTraces(void);
         virtual SoSwitch *makeTraceSegment(int ihep, myRGB color)=0;
         SoSeparator *tracesToDisplay(traceDispInfo Info);
};
#endif

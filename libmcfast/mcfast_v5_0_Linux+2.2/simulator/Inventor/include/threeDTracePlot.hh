#include "tracePlot.hh"
#ifndef THREEDTRACEPLOT
#define THREEDTRACEPLOT
class SoSwitch;
class threeDTracePlot : public tracePlot
{
    public:
    SoSwitch *makeTraceSegment(int ihep, myRGB color);

};
#endif

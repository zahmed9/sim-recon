#include <Inventor/nodes/SoSeparator.h>
#include "tracePlot.hh"
#ifndef MOMTRACEPLOT
#define MOMTRACEPLOT
class momTracePlot : public tracePlot
{
    public:
    SoSwitch *makeTraceSegment(int ihep, myRGB color);

};
#endif

#include <Inventor/nodes/SoSeparator.h>
#include "tracePlot.hh"
#ifndef RZTRACEPLOT
#define RZTRACEPLOT
class rZTracePlot : public tracePlot
{
    public:
    SoSwitch *makeTraceSegment(int ihep, myRGB color);

};
#endif

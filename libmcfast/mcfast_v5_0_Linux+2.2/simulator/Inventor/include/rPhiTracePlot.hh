#include <Inventor/nodes/SoSeparator.h>
#include "tracePlot.hh"
#ifndef RPHITRACEPLOT
#define RPHITRACEPLOT
class rPhiTracePlot : public tracePlot
{
    public:
    SoSwitch *makeTraceSegment(int ihep, myRGB color);

};
#endif

#ifndef DETECTORPLOT
#define DETECTORPLOT
#include <Inventor/nodes/SoSwitch.h>
class detectorPlot
{
    public:
        virtual SoSwitch *makeDetector(void) = 0;
};
#endif

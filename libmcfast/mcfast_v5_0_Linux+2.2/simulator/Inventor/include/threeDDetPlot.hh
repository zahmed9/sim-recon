#include "detectorPlot.hh"
#ifndef THREEDDETPLOT
#define THREEDDETPLOT
class SoSwitch;
class threeDDetPlot : public detectorPlot
{
    private:
        static SoSwitch *detector;
        static int hasBeenCreated;
    public:
        SoSwitch *makeDetector(void);
};
#endif

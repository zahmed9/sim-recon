#include "detectorPlot.hh"
#ifndef IVFILEDETPLOT
#define IVFILEDETPLOT
class ivFileDetPlot
{
    private:
        static SoSeparator *detector;
    public:
        static SoSeparator *makeDetector(void);
        
};
#endif

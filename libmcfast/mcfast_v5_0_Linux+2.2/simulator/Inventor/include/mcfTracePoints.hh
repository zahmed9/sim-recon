#include "rgb.hh"
#ifndef MCFTRACEPOINTS
#define MCFTRACEPOINTS
#include "traceData.hh"
class mcfTracePoints
{
    private:
      traceData *pTrace;
      int numTracePart;
    public:
      mcfTracePoints(void);
       ~mcfTracePoints(void)
      {
         delete [] pTrace;
      }
      int numTraces(void)
      {
        return numTracePart;
      }
      int hepNumber(int i)
      {
        return (pTrace+i)->hep;
      }
      traceData *pTraceData(int i)
      {
        return (pTrace+i);
      }
      myRGB defaultTraceColor(int i);
};
#endif


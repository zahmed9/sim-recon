#include <string.h>
#include <stdio.h>
#include <math.h>
#include "traceDisplayInfo.hh"
#include "traceData.hh"
#include "mcfTracePoints.hh"
#include "traceCommon.hh"
mcfTracePoints::mcfTracePoints(void)  // default constructor makes all traces
{
    pTrace = new traceData [NumGoodTrace()];
    this->numTracePart=0;
    for (int i = 0; i < NumHepTrace(); i++)
    {
       if(getTraceData( i, (pTrace + this->numTracePart) )) 
                               this->numTracePart++;
       
    } 

}

myRGB mcfTracePoints::defaultTraceColor(int i)
{
   myRGB defColors[4];
   defColors[0].red = 0.0;
   defColors[0].green = 1.0;
   defColors[0].blue = 0.0;

   defColors[1].red = 1.0;
   defColors[1].green = 0.0;
   defColors[1].blue = 0.0;

   defColors[2].red = 0.0;
   defColors[2].green = 0.0;
   defColors[2].blue = 1.0;

   defColors[3].red = 0.0;
   defColors[3].green = 0.0;
   defColors[3].blue = 0.0;
   
   if( (pTrace+i)-> charge == 0 ) return defColors[2];
   if( (pTrace+i)-> traceType == TRACK ) return defColors[1];
   if( (pTrace+i)-> traceType == TRACE ) return defColors[0];
   return defColors[3];   
}

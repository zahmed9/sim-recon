#include <stdlib.h>
#include "mcfTracePoints.hh"
#include "mcfCalEnergy.hh"
#include "mcfCalEtaEnergy.hh"
#include "mcfCalPhiEnergy.hh"

//This class is a "Singleton".  See pg 127 of "Design Patterns"
#ifndef EVENTINFORMATION
#define EVENTINFORMATION
class eventInformation
{
    private:
      static eventInformation *_eventInfo;   
      mcfTracePoints *traceInfo;
      mcfCalEnergy *calEnergyInfo;
      mcfCalEtaEnergy *calEtaEnergyInfo;
      mcfCalPhiEnergy *calPhiEnergyInfo;

    protected:
      eventInformation(void)
      {
	   traceInfo = NULL;
	   calEnergyInfo = NULL;
	   calEtaEnergyInfo = NULL;
	   calPhiEnergyInfo = NULL;
      }
    public:
      static eventInformation *eventInfo(void);
      void updateEventInformation(void);
      mcfTracePoints *traces(void)
      {
          return traceInfo;
      }
      mcfCalEnergy *calEnergy(void)
      {
         return calEnergyInfo;
      }

      mcfCalEnergy *calEtaEnergy(void)
      {
         if(calEtaEnergyInfo == NULL) 
            calEtaEnergyInfo = new mcfCalEtaEnergy;
         return (mcfCalEnergy *) calEtaEnergyInfo;
      }

      mcfCalEnergy *calPhiEnergy(void)
      {
         if(calPhiEnergyInfo == NULL) 
            calPhiEnergyInfo = new mcfCalPhiEnergy;
         return (mcfCalEnergy *) calPhiEnergyInfo;
      }
};
#endif

#include "eventInformation.hh"

eventInformation *eventInformation::_eventInfo = NULL;

eventInformation *eventInformation::eventInfo(void)
{
    if(_eventInfo == NULL)
    _eventInfo = new eventInformation;
    
    return _eventInfo;
}
void eventInformation::updateEventInformation(void)
{
     if(_eventInfo == NULL)
     {
         _eventInfo = new eventInformation;
     }
     else
     {
     
         if(traceInfo != NULL) delete traceInfo;
         traceInfo = new mcfTracePoints;

         if(calEnergyInfo != NULL) delete calEnergyInfo; 
         calEnergyInfo = new mcfCalEnergy;
         

         if(calEtaEnergyInfo != NULL)  //update only if in previous event
         {
            delete calEtaEnergyInfo;
            calEtaEnergyInfo = new mcfCalEtaEnergy;
         }

         if(calPhiEnergyInfo != NULL)  //update only if in previous event
         {
            delete calPhiEnergyInfo;
            calPhiEnergyInfo = new mcfCalPhiEnergy;
         }
     }
     
     
}


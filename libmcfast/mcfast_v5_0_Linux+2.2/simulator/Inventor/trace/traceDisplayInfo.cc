#include "traceDisplayInfo.hh"
void traceDispInfoInitialize( traceDispInfo *temp)
{
   //set up defaults for trace plot
   temp->PlotTrack = 1;    //display tracks
   temp->PlotTrace = 1;    //display traces
   temp->PlotNeutr = 0;    //do not display neutrals
   temp->EtaMin = -10.0;   
   temp->EtaMax = 10.0;
   temp->MomType = MOMENTUM;
   temp->MomMin = 0.0;     //no momentum cut
   temp->itrack = -999;    // no active track
   temp->trackAction = 0; // no track action
   return;
}
void traceDispInfoSet( traceDispInfo set, traceDispInfo *temp)
{
   temp->PlotTrack = set.PlotTrack;
   temp->PlotTrace = set.PlotTrace;
   temp->PlotNeutr = set.PlotNeutr;
   temp->EtaMin = set.EtaMin;
   temp->EtaMax = set.EtaMax;
   temp->MomType = set.MomType;
   temp->MomMin = set.MomMin;
   temp->itrack = set.itrack;
   temp->trackAction = set.trackAction;
   return;
}

#include "tracePlot.hh"
#include "eventInformation.hh"
#include "mcfTracePoints.hh"
#include <string.h>
#include <stdio.h>
#include <iostream.h>
#include <ctype.h>
#include <Inventor/SbString.h>
#include <Inventor/nodes/SoNode.h>
#include <Inventor/nodes/SoSwitch.h>
#include "hepvis/SoMcFTraceKit.hh"
void tracePlot::makeTraces(void)
{
      
    int children = soTraces->getNumChildren();
    for (int j = 0; j < children; j++)
    {
       soTraces->removeChild(children-(j+1));
    }

    eventInformation *event = eventInformation::eventInfo();
    mcfTracePoints *traceInfo = event->traces();

    for( int i = 0; i < traceInfo->numTraces(); i++)
    {
        myRGB color = traceInfo->defaultTraceColor(i);
	soTraces->addChild( makeTraceSegment( 
	                    traceInfo->hepNumber(i), color ) );
    }
    return;
}
SoSeparator *tracePlot::tracesToDisplay(traceDispInfo Info)
{
    SoNode *tmp;
    SoSwitch *sw;
    traceData *pTraceData;
    char string[30];
    int numTraces = soTraces->getNumChildren();

    eventInformation *event = eventInformation::eventInfo();
    mcfTracePoints *traceInfo = event->traces();

    SoSeparator *tracesToDisplay = new SoSeparator;
    tracesToDisplay->ref();
    sprintf(string, "Traces");
    SbName *traceName = new SbName(string);
    tracesToDisplay->setName(*traceName);
    tracesToDisplay->addChild(soTraces);

    if( traceInfo->numTraces() != numTraces ) //glup something is wrong!
    {
       cout << "The number of Traces to display is inconsistent\n";
       return tracesToDisplay;
    }

    for(int i = 0; i < traceInfo->numTraces(); i++)
    {
       
       pTraceData = traceInfo->pTraceData(i);
       tmp = (SoNode *) soTraces->getChild(i);
       if (tmp->isOfType(SoSwitch::getClassTypeId()))
       {
          sw = (SoSwitch *) tmp;
          sw->whichChild = SO_SWITCH_NONE;

          if(
           ((Info.MomType == MOMENTUM && (pTraceData)-> p >= Info.MomMin) ||
            (Info.MomType == TRANSMOM && (pTraceData)-> pt >=Info.MomMin)) &&

           ((Info.PlotTrace && (pTraceData)-> traceType == TRACE) ||
            (Info.PlotTrack && (pTraceData)-> traceType == TRACK) ||
            (Info.PlotNeutr && (pTraceData)-> traceType == NEUTR)) &&

            (pTraceData) -> eta >= Info.EtaMin &&
            (pTraceData) -> eta <= Info.EtaMax)
          {
            sw->whichChild = 0;
          }
        }
    }
    tracesToDisplay->unrefNoDelete();
    return tracesToDisplay;    
}

/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoMcFTraceKit                                     */
/* Description:      Represents a hit silicon strip                          */
/* Author:           Amber Boehnlein 5/1/97                                  */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/events/SoMouseButtonEvent.h>
#include <Inventor/SoPickedPoint.h>
#include <Inventor/nodes/SoCoordinate3.h>
#include <Inventor/nodes/SoLineSet.h>
#include <Inventor/nodes/SoPickStyle.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodekits/SoNodeKitListPart.h>
#include <Inventor/nodekits/SoBaseKit.h>
#include <Inventor/nodes/SoSelection.h>
#include <Inventor/nodekits/SoSeparatorKit.h>
#include <Inventor/nodekits/SoShapeKit.h>
#include <Inventor/nodes/SoCube.h>
#include <Inventor/SoPath.h>
#include "hepvis/SoMcFTraceKit.hh"
#include "traceCommon.hh"
//this is the window for displaying the trace information
//it should really be an SoXt class...
#include "mcfPickInfoWindow.hh"
static SoMcFTraceKit *selectedTraceKit = NULL;


// This statement is required
SO_KIT_SOURCE(SoMcFTraceKit);

// initClass
void SoMcFTraceKit::initClass(){
  SO_KIT_INIT_CLASS(SoMcFTraceKit,SoBaseKit,"BaseKit");
}

// Constructor
SoMcFTraceKit::SoMcFTraceKit() {
  SO_KIT_CONSTRUCTOR(SoMcFTraceKit);

  SO_NODE_ADD_FIELD(alternateRep, (NULL));

  SO_KIT_ADD_CATALOG_ENTRY     (     topSeparator,    SoSeparator,      
                                     FALSE,  this, ,  FALSE);
                                     
  SO_KIT_ADD_CATALOG_ENTRY     (     Appearance,     SoAppearanceKit,    
                                     FALSE,  topSeparator, , TRUE);
                                                
  SO_KIT_ADD_CATALOG_ENTRY     (     Transform,     SoTransform,    
                                     FALSE,  topSeparator, , TRUE);
                                                
  SO_KIT_ADD_CATALOG_ENTRY     (     Coord3,     SoCoordinate3,    
                                     FALSE,  topSeparator, , TRUE);
                                                
  SO_KIT_ADD_CATALOG_ENTRY     (     LineSet,    SoLineSet,    
                                     FALSE,  topSeparator, , TRUE);           

  SO_KIT_ADD_CATALOG_ENTRY     (     PointSet,    SoPointSet,    
                                     FALSE,  topSeparator, , TRUE);           
  
  SO_KIT_INIT_INSTANCE();
  createInitialTree();
  
  traceid = -999;
}

// Destructor
SoMcFTraceKit::~SoMcFTraceKit() {
}

SbBool SoMcFTraceKit::affectsState() const {
  return FALSE;
}

void SoMcFTraceKit::createInitialTree() {

   SoEventCallback *myCallback = new SoEventCallback();
   myCallback->addEventCallback(SoMouseButtonEvent::getClassTypeId(),
                               SoMcFTraceKit::printTrace  ,
                               this);
   setPart("callbackList[0]",myCallback);
 return;
}

// generateAlternateRep
void SoMcFTraceKit::generateAlternateRep() {
  alternateRep.setValue(topSeparator.getValue());
}

void SoMcFTraceKit::clearAlternateRep() {
  alternateRep.setValue(NULL);
}
void SoMcFTraceKit::printTrace(void *userData, SoEventCallback *eventCB){
  SoDrawStyle *drawStyle;
  if (eventCB->isHandled()) return;

  const SoMouseButtonEvent *event = (SoMouseButtonEvent *)
                                            eventCB->getEvent();

  if (!SoMouseButtonEvent::isButtonPressEvent
                     (event,SoMouseButtonEvent::BUTTON1))
                          return;

  if (event->wasCtrlDown()) return;
  if (event->wasShiftDown()) return;
  
  SoMcFTraceKit *This = (SoMcFTraceKit *) userData;


  SoHandleEventAction *handleEventAction = eventCB->getAction();
  const SoPickedPoint *pickedPoint = handleEventAction->getPickedPoint();
  if (!pickedPoint)
  {
    //reset the old picked point
    if(selectedTraceKit != NULL)
    {
       drawStyle = (SoDrawStyle *)
                  selectedTraceKit->getPart("Appearance.drawStyle",TRUE);
      drawStyle->lineWidth.setValue(0.0);
      drawStyle->linePattern.setValue(0xffff);
      selectedTraceKit = NULL;  
    } 
    return;
  }
  SoPath *path = (SoPath *) pickedPoint->getPath();
  SoNode *ancestorNode=NULL;

  SbBool foundKit = FALSE;
  for (int i=0;i<path->getLength();i++)
  {
    ancestorNode  = path->getNodeFromTail(i);
    if (ancestorNode->isOfType(SoMcFTraceKit::getClassTypeId()))
    {
       foundKit = TRUE;
       if (This!=ancestorNode) return;
    }
  }
  if(!foundKit)
  {
    //there wasn't a track kit in the path
    //reset the old picked point
    if(selectedTraceKit != NULL)
    {
       drawStyle = (SoDrawStyle *)
                  selectedTraceKit->getPart("Appearance.drawStyle",TRUE);
      drawStyle->lineWidth.setValue(0.0);
      drawStyle->linePattern.setValue(0xffff);
      selectedTraceKit = NULL;  
    } 
    return;
     
  }

//reset the old picked point
  if(selectedTraceKit != NULL)
  {
     drawStyle = (SoDrawStyle *)
                selectedTraceKit->getPart("Appearance.drawStyle",TRUE);
    drawStyle->lineWidth.setValue(0.0);
    drawStyle->linePattern.setValue(0xffff);
    selectedTraceKit = NULL;  
  }

  drawStyle = (SoDrawStyle *)
                 This->getPart("Appearance.drawStyle",TRUE);
  drawStyle->lineWidth.setValue(3.0);
  drawStyle->linePattern.setValue(0xfff0);
  selectedTraceKit = This;

  mcfPickInfoWindow *pickWindow = 
             mcfPickInfoWindow::pickInfoWindow(SoXt::getTopLevelWidget());
  pickWindow->updateText(traceMessage(This->traceid));

  eventCB->setHandled();


}
void SoMcFTraceKit::resetPick(void)
{
   selectedTraceKit = NULL;
}

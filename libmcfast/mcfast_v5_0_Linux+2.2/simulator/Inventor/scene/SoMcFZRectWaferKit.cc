/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoMcFZRectWaferKit                                     */
/* Description:      Represents a hit silicon strip                          */
/* Author:           Amber Boehnlein 5/1/97                                  */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/events/SoMouseButtonEvent.h>
#include <Inventor/SoPickedPoint.h>
#include <Inventor/nodes/SoCube.h>
#include <Inventor/nodes/SoPickStyle.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodekits/SoNodeKitListPart.h>
#include <Inventor/nodekits/SoBaseKit.h>
#include <Inventor/nodekits/SoSeparatorKit.h>
#include <Inventor/nodekits/SoShapeKit.h>
#include <Inventor/nodes/SoCube.h>
#include "hepvis/SoMcFZRectWaferKit.hh"
//get the information about a hit
#include "hitsCommon.hh"
//this is the window for displaying the hit information
//it should really be an SoXt class...
#include "mcfPickInfoWindow.hh"
static SoMcFZRectWaferKit *selectedZRectWaferKit = NULL;


// This statement is required
SO_KIT_SOURCE(SoMcFZRectWaferKit);

// initClass
void SoMcFZRectWaferKit::initClass(){
  SO_KIT_INIT_CLASS(SoMcFZRectWaferKit,SoBaseKit,"BaseKit");
}

// Constructor
SoMcFZRectWaferKit::SoMcFZRectWaferKit() {
  SO_KIT_CONSTRUCTOR(SoMcFZRectWaferKit);

  SO_NODE_ADD_FIELD(alternateRep, (NULL));

  SO_KIT_ADD_CATALOG_ENTRY     (     topSeparator,    SoSeparator,      
                                     FALSE,  this, ,  FALSE);
                                     
  SO_KIT_ADD_CATALOG_ENTRY     (     appearance,     SoAppearanceKit,    
                                     FALSE,  topSeparator, , TRUE);
                                                
  SO_KIT_ADD_CATALOG_ENTRY     (     transform,     SoTransform,    
                                     FALSE,  topSeparator, , TRUE);
                                                
  SO_KIT_ADD_CATALOG_ENTRY     (     wafer,     SoCube,    
                                     FALSE,  topSeparator, , TRUE);
                                                
  
  SO_KIT_INIT_INSTANCE();
  createInitialTree();
  
  hitid = -999;
}

// Destructor
SoMcFZRectWaferKit::~SoMcFZRectWaferKit() {
}

SbBool SoMcFZRectWaferKit::affectsState() const {
  return FALSE;
}

void SoMcFZRectWaferKit::createInitialTree() {

   SoEventCallback *myCallback = new SoEventCallback();
   myCallback->addEventCallback(SoMouseButtonEvent::getClassTypeId(),
                               SoMcFZRectWaferKit::printHit  ,
                               this);
   setPart("callbackList[0]",myCallback);
 return;
}

// generateAlternateRep
void SoMcFZRectWaferKit::generateAlternateRep() {
  alternateRep.setValue(topSeparator.getValue());
}

void SoMcFZRectWaferKit::clearAlternateRep() {
  alternateRep.setValue(NULL);
}
void SoMcFZRectWaferKit::printHit(void *userData, SoEventCallback *eventCB){
  SoDrawStyle *drawStyle;
  if (eventCB->isHandled()) return;
  const SoMouseButtonEvent *event = (SoMouseButtonEvent *)
                                            eventCB->getEvent();

  if (!SoMouseButtonEvent::isButtonPressEvent
                     (event,SoMouseButtonEvent::BUTTON1))
                          return;

  if (event->wasCtrlDown()) return;
  if (event->wasShiftDown()) return;
  
  SoMcFZRectWaferKit *This = (SoMcFZRectWaferKit *) userData;


  SoHandleEventAction *handleEventAction = eventCB->getAction();
  const SoPickedPoint *pickedPoint = handleEventAction->getPickedPoint();
  if (!pickedPoint)
  {
    //reset the old picked point
    if(selectedZRectWaferKit != NULL)
    {
       drawStyle = (SoDrawStyle *)
                  selectedZRectWaferKit->getPart("Appearance.drawStyle",TRUE);
      drawStyle->style = SoDrawStyle::FILLED;
      drawStyle->lineWidth.setValue(0.0);
      drawStyle->linePattern.setValue(0xffff);
      selectedZRectWaferKit = NULL;  
    } 
    return;
  }
  SoFullPath *path = (SoFullPath *) pickedPoint->getPath();
  SoNode *ancestorNode=NULL;

  SbBool foundKit = FALSE;
  for (int i=0;i<path->getLength();i++)
  {
    ancestorNode  = path->getNodeFromTail(i);
    if (ancestorNode->isOfType(SoMcFZRectWaferKit::getClassTypeId()))
    {
       foundKit = TRUE;
       if (This!=ancestorNode) return;
    }
  }

  if(!foundKit)
  {
    //there wasn't a pixel kit in the path
    //reset the old picked point
    if(selectedZRectWaferKit != NULL)
    {
       drawStyle = (SoDrawStyle *)
        	  selectedZRectWaferKit->getPart("Appearance.drawStyle",TRUE);
      drawStyle->lineWidth.setValue(0.0);
      drawStyle->style = SoDrawStyle::FILLED;
      drawStyle->linePattern.setValue(0xffff);
      selectedZRectWaferKit = NULL;  
    } 
    return;
     
  }

//reset the old picked point
  if(selectedZRectWaferKit != NULL)
  {
     drawStyle = (SoDrawStyle *)
                selectedZRectWaferKit->getPart("Appearance.drawStyle",TRUE);
      drawStyle->style = SoDrawStyle::FILLED;
    drawStyle->lineWidth.setValue(0.0);
    drawStyle->linePattern.setValue(0xffff);
    selectedZRectWaferKit = NULL;  
  }


  drawStyle = (SoDrawStyle *)
                 This->getPart("Appearance.drawStyle",TRUE);
  drawStyle->style = SoDrawStyle::LINES;
  drawStyle->lineWidth.setValue(3.0);
  drawStyle->linePattern.setValue(0xfff0);
  selectedZRectWaferKit = This;

  mcfPickInfoWindow *pickWindow = 
             mcfPickInfoWindow::pickInfoWindow(SoXt::getTopLevelWidget());
  pickWindow->updateText(hitMessage(This->hitid));

  eventCB->setHandled();


}
void SoMcFZRectWaferKit::resetPick(void)
{
    selectedZRectWaferKit = NULL;
    return;
}

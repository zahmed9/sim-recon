/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoMcFSilStripHitKit                                     */
/* Description:      Represents a hit silicon strip                          */
/* Author:           Amber Boehnlein 5/1/97                                  */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/events/SoMouseButtonEvent.h>
#include <Inventor/SoPickedPoint.h>
#include <Inventor/nodes/SoCoordinate3.h>
#include <Inventor/nodes/SoCube.h>
#include <Inventor/nodes/SoLineSet.h>
#include <Inventor/nodes/SoPickStyle.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodekits/SoNodeKitListPart.h>
#include <Inventor/nodekits/SoBaseKit.h>
#include <Inventor/nodekits/SoSeparatorKit.h>
#include <Inventor/nodekits/SoShapeKit.h>
#include <Inventor/nodes/SoCube.h>
#include "hepvis/SoMcFSilStripHitKit.hh"
#include "hepvis/SoMcFXYPlaneKit.hh"
//get the information about a hit
#include "hitsCommon.hh"
//this is the window for displaying the hit information
//it should really be an SoXt class...
#include "mcfPickInfoWindow.hh"
static SoMcFSilStripHitKit *selectedStripHitKit = NULL;


// This statement is required
SO_KIT_SOURCE(SoMcFSilStripHitKit);

// initClass
void SoMcFSilStripHitKit::initClass(){
  SO_KIT_INIT_CLASS(SoMcFSilStripHitKit,SoBaseKit,"BaseKit");
}

// Constructor
SoMcFSilStripHitKit::SoMcFSilStripHitKit() {
  SO_KIT_CONSTRUCTOR(SoMcFSilStripHitKit);

  SO_NODE_ADD_FIELD(alternateRep, (NULL));

  SO_KIT_ADD_CATALOG_ENTRY     (     topSeparator,    SoSeparator,      
                                     FALSE,  this, ,  FALSE);
                                     
  SO_KIT_ADD_CATALOG_ENTRY     (     Appearance,     SoAppearanceKit,    
                                     FALSE,  topSeparator, , TRUE);
                                                
  SO_KIT_ADD_CATALOG_ENTRY     (     Transform,     SoTransform,    
                                     FALSE,  topSeparator, , TRUE);
  SO_KIT_ADD_CATALOG_ENTRY     (     stripSeparator,         SoCube,
                                     FALSE,   topSeparator, , TRUE  );                                              

  SO_KIT_ADD_CATALOG_ENTRY     (     Coord3,     SoCoordinate3,    
                                     FALSE,  topSeparator, , TRUE);
                                                
  SO_KIT_ADD_CATALOG_ENTRY     (     LineSet,    SoLineSet,    
                                     FALSE,  topSeparator, , TRUE);           
  
  SO_KIT_INIT_INSTANCE();
  createInitialTree();
  
  hitid = -999;
}

// Destructor
SoMcFSilStripHitKit::~SoMcFSilStripHitKit() {
}

SbBool SoMcFSilStripHitKit::affectsState() const {
  return FALSE;
}

void SoMcFSilStripHitKit::createInitialTree() {

   SoEventCallback *myCallback = new SoEventCallback();
   myCallback->addEventCallback(SoMouseButtonEvent::getClassTypeId(),
                               SoMcFSilStripHitKit::printHit  ,
                               this);
   setPart("callbackList[0]",myCallback);
 return;
}

// generateAlternateRep
void SoMcFSilStripHitKit::generateAlternateRep() {
  alternateRep.setValue(topSeparator.getValue());
}

void SoMcFSilStripHitKit::clearAlternateRep() {
  alternateRep.setValue(NULL);
}
void SoMcFSilStripHitKit::printHit(void *userData, SoEventCallback *eventCB){
  SoDrawStyle *drawStyle;
  if (eventCB->isHandled()) return;
  const SoMouseButtonEvent *event = (SoMouseButtonEvent *)
                                            eventCB->getEvent();

  if (!SoMouseButtonEvent::isButtonPressEvent
                     (event,SoMouseButtonEvent::BUTTON1))
                          return;

  if (event->wasCtrlDown()) return;
  if (event->wasShiftDown()) return;
  
  SoMcFSilStripHitKit *This = (SoMcFSilStripHitKit *) userData;


  SoHandleEventAction *handleEventAction = eventCB->getAction();
  const SoPickedPoint *pickedPoint = handleEventAction->getPickedPoint();
  if (!pickedPoint)
  {
    //reset the old picked point
    if(selectedStripHitKit != NULL)
    {
       drawStyle = (SoDrawStyle *)
                  selectedStripHitKit->getPart("Appearance.drawStyle",TRUE);
      drawStyle->lineWidth.setValue(0.0);
      drawStyle->linePattern.setValue(0xffff);
      selectedStripHitKit = NULL;  
    } 
    return;
  }
  SoFullPath *path = (SoFullPath *) pickedPoint->getPath();
  SoNode *ancestorNode=NULL;

  SbBool foundKit = FALSE;
  for (int i=0;i<path->getLength();i++)
  {
    ancestorNode  = path->getNodeFromTail(i);
    if (ancestorNode->isOfType(SoMcFSilStripHitKit::getClassTypeId()))
    {
       foundKit = TRUE;
       if (This!=ancestorNode) return;
    }
  }

  if(!foundKit)
  {
    //there wasn't a strip kit in the path
    //reset the old picked point
    if(selectedStripHitKit != NULL)
    {
       drawStyle = (SoDrawStyle *)
        	  selectedStripHitKit->getPart("Appearance.drawStyle",TRUE);
      drawStyle->lineWidth.setValue(0.0);
      drawStyle->linePattern.setValue(0xffff);
      selectedStripHitKit = NULL;  
    } 
    return;
     
  }

//reset the old picked point
  if(selectedStripHitKit != NULL)
  {
     drawStyle = (SoDrawStyle *)
                selectedStripHitKit->getPart("Appearance.drawStyle",TRUE);
    drawStyle->lineWidth.setValue(0.0);
    drawStyle->linePattern.setValue(0xffff);
    selectedStripHitKit = NULL;  
  }


  drawStyle = (SoDrawStyle *)
                 This->getPart("Appearance.drawStyle",TRUE);
  drawStyle->lineWidth.setValue(3.0);
  drawStyle->linePattern.setValue(0xfff0);
  selectedStripHitKit = This;

  mcfPickInfoWindow *pickWindow = 
             mcfPickInfoWindow::pickInfoWindow(SoXt::getTopLevelWidget());
  pickWindow->updateText(hitMessage(This->hitid));

  eventCB->setHandled();


}
void SoMcFSilStripHitKit::resetPick(void)
{
    selectedStripHitKit = NULL;
    return;
}

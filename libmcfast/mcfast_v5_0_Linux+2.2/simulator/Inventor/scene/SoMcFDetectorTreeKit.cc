/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoMcFDetectorTreeKit                                         */
/* Description:      Represents a single sided silicon strip detector        */
/* Author:           Joe Boudreau Nov 11 1996                                */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/events/SoMouseButtonEvent.h>
#include <Inventor/events/SoKeyboardEvent.h>
#include <Inventor/events/SoEvent.h>
#include <Inventor/SoPickedPoint.h>
#include <Inventor/nodes/SoPickStyle.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodekits/SoAppearanceKit.h>
#include <Inventor/nodekits/SoNodeKitListPart.h>
#include <Inventor/nodekits/SoBaseKit.h>
#include <Inventor/nodes/SoSelection.h>
#include <Inventor/nodes/SoSwitch.h>
#include <Inventor/nodekits/SoSeparatorKit.h>
#include <Inventor/nodekits/SoShapeKit.h>
#include <Inventor/Xt/SoXtMaterialEditor.h>
#include "hepvis/SoMcFDetectorTreeKit.hh"
#include "McFDetDevice.hh"
#include "detectorPrint.hh"
#include "mcfPickInfoWindow.hh"

static SoDrawStyle *oldStyle = NULL; 
static SoMcFDetectorTreeKit *selectedTreeKit = NULL;

// This statement is required
SO_KIT_SOURCE(SoMcFDetectorTreeKit);

// initClass
void SoMcFDetectorTreeKit::initClass(){
  SO_KIT_INIT_CLASS(SoMcFDetectorTreeKit,SoBaseKit,"BaseKit");
}

// Constructor
SoMcFDetectorTreeKit::SoMcFDetectorTreeKit() {
  SO_KIT_CONSTRUCTOR(SoMcFDetectorTreeKit);

  SO_NODE_ADD_FIELD(alternateRep, (NULL));

  SO_KIT_ADD_CATALOG_ENTRY     (     topSeparator,         SoSeparator, FALSE,          this, ,             FALSE);
  SO_KIT_ADD_CATALOG_ENTRY     (        pickStyle,         SoSeparator, FALSE,  topSeparator, ,              TRUE);
  SO_KIT_ADD_CATALOG_ENTRY     (       appearance,     SoAppearanceKit, FALSE,  topSeparator, ,              TRUE);
  SO_KIT_ADD_CATALOG_ENTRY     (            units,             SoUnits, FALSE,  topSeparator, ,              TRUE);
  SO_KIT_ADD_CATALOG_ENTRY     (        transform,         SoTransform, FALSE,  topSeparator, ,              TRUE);
  SO_KIT_ADD_CATALOG_ENTRY     (texture2Transform, SoTexture2Transform, FALSE,  topSeparator, ,              TRUE);
  SO_KIT_ADD_CATALOG_ENTRY     (        childList,            SoSwitch, FALSE,  topSeparator, ,             FALSE);
  SO_KIT_ADD_CATALOG_ENTRY     ( previewSeparator,         SoSeparator, FALSE,     childList, ,              TRUE);
  SO_KIT_ADD_CATALOG_ENTRY     (    fullSeparator,         SoSeparator, FALSE,     childList, ,              TRUE);

  SO_KIT_INIT_INSTANCE();
  createInitialTree();
  whichDevice = -99;
  device = NODEVICE;
  
}

// Destructor
SoMcFDetectorTreeKit::~SoMcFDetectorTreeKit() {
}

SbBool SoMcFDetectorTreeKit::affectsState() const {
  return FALSE;
}

void SoMcFDetectorTreeKit::createInitialTree() {

  SoEventCallback *myCallback = new SoEventCallback();
  myCallback->addEventCallback(SoKeyboardEvent::getClassTypeId(),
                               SoMcFDetectorTreeKit::expand,
                               this);
  myCallback->addEventCallback(SoKeyboardEvent::getClassTypeId(),
                               SoMcFDetectorTreeKit::contract  ,
                               this);
  myCallback->addEventCallback(SoKeyboardEvent::getClassTypeId(),
                               SoMcFDetectorTreeKit::color  ,
                               this);
  myCallback->addEventCallback(SoKeyboardEvent::getClassTypeId(),
                               SoMcFDetectorTreeKit::solid  ,
                               this);
  myCallback->addEventCallback(SoKeyboardEvent::getClassTypeId(),
                               SoMcFDetectorTreeKit::wire  ,
                               this);
  myCallback->addEventCallback(SoKeyboardEvent::getClassTypeId(),
                               SoMcFDetectorTreeKit::gone  ,
                               this);
   myCallback->addEventCallback(SoMouseButtonEvent::getClassTypeId(),
                               SoMcFDetectorTreeKit::selectCB  ,
                               this);
                              

  setPart("callbackList[0]",myCallback); 

  SoSwitch *theChildList = (SoSwitch *) childList.getValue();
  theChildList->whichChild.setValue(0);
  
  return;
}

void SoMcFDetectorTreeKit::color(void *userData, SoEventCallback *eventCB){
static SoXtMaterialEditor *colorEditor = NULL;

  // Was the event previously handled? Is it the right kind?

  if (eventCB->isHandled()) return;
  const SoEvent *event = (SoEvent *) eventCB->getEvent();
  if (!event->wasCtrlDown()) return;
  if(!SoKeyboardEvent::isKeyPressEvent(event, SoKeyboardEvent::M))return;

  // Which Detector is this being called for?
  SoMcFDetectorTreeKit *This = (SoMcFDetectorTreeKit *) userData;

  // Find out whether that's the one that has been picked.  This is the lowest detector
  // tree kit in the hierarchy.
  SoHandleEventAction *handleEventAction = eventCB->getAction();
  const SoPickedPoint *pickedPoint = handleEventAction->getPickedPoint();
  if (!pickedPoint) return;

  SoNodeKitPath          *path        = (SoNodeKitPath *) pickedPoint->getPath();
  if (This!= findAncestorNode(path)) return;


  //set up material editor and attach to material
  
  if(colorEditor == NULL) 
    colorEditor = new SoXtMaterialEditor;

  SoMaterial *theMaterial = (SoMaterial *)
                    This->getPart("appearance.material",TRUE);
  if(theMaterial != NULL){
    colorEditor->attach(theMaterial);
    colorEditor->show();
  }
  eventCB->setHandled();
     
}

void SoMcFDetectorTreeKit::expand(void *userData, SoEventCallback *eventCB){

  // Was the event previously handled? Is it the right kind?

  if (eventCB->isHandled()) return;
  const SoEvent *event = (SoEvent *) eventCB->getEvent();
  if (!event->wasCtrlDown()) return;
  if(!SoKeyboardEvent::isKeyPressEvent(event, SoKeyboardEvent::E))return;

  // Which Strip Detector is this being called for?
  SoMcFDetectorTreeKit *This = (SoMcFDetectorTreeKit *) userData;

  // Find out whether that's the one that has been picked.  This is the lowest detector
  // tree kit in the hierarchy.
  SoHandleEventAction *handleEventAction = eventCB->getAction();
  const SoPickedPoint *pickedPoint = handleEventAction->getPickedPoint();
  if (!pickedPoint) return;

  SoNodeKitPath          *path        = (SoNodeKitPath *) pickedPoint->getPath();
  if (This!= findAncestorNode(path)) return;
  // Deactivate the Preview
  This->setPreview(FALSE);
  eventCB->setHandled();
     
}

void SoMcFDetectorTreeKit::contract(void *userData, SoEventCallback *eventCB){

  // Was the event previously handled? Is it the right kind?
  if (eventCB->isHandled()) return;
  const SoEvent *event = (SoEvent *) eventCB->getEvent();
  if (!event->wasCtrlDown()) return;
  if(!SoKeyboardEvent::isKeyPressEvent(event, SoKeyboardEvent::C))return;

  // Which Strip Detector is this being called for?
  SoMcFDetectorTreeKit *This = (SoMcFDetectorTreeKit *) userData;

  // Find out whether that's the one that has been picked
  SoHandleEventAction *handleEventAction = eventCB->getAction();
  const SoPickedPoint *pickedPoint = handleEventAction->getPickedPoint();
  if (!pickedPoint) return;
 
  SoNodeKitPath  *path        = (SoNodeKitPath *) pickedPoint->getPath();
  SoNode *ancestorNode = NULL;
  SbBool firstTreeFound = FALSE;
  for (int i = 0; i < path->getLength(); i++)
  {
     ancestorNode = path->getNodeFromTail(i);
     if ( ancestorNode -> isOfType( SoMcFDetectorTreeKit::getClassTypeId()))
     {
        if ( !firstTreeFound ) 
        {
           if (This != ancestorNode) return;
           firstTreeFound = TRUE;
        }
        SoMcFDetectorTreeKit *That = (SoMcFDetectorTreeKit *) ancestorNode;
        if(!That->getPreview()) 
        {
          That->setPreview(TRUE);
          eventCB->setHandled();
          return;
        }
     }
  }
}
void SoMcFDetectorTreeKit::wire(void *userData, SoEventCallback *eventCB){

  // Was the event previously handled? Is it the right kind?
  if (eventCB->isHandled()) return;
  const SoEvent *event = (SoEvent *) eventCB->getEvent();
  if (!event->wasCtrlDown()) return;
  if(!SoKeyboardEvent::isKeyPressEvent(event, SoKeyboardEvent::W))return;

  // Which detector is this being called for?
  SoMcFDetectorTreeKit *This = (SoMcFDetectorTreeKit *) userData;

  // Find out whether that's the one that has been picked
  SoHandleEventAction *handleEventAction = eventCB->getAction();
  const SoPickedPoint *pickedPoint = handleEventAction->getPickedPoint();
  if (!pickedPoint) return;
 
  SoNodeKitPath          *path        = (SoNodeKitPath *) pickedPoint->getPath();
  if (This!= findAncestorNode(path)) return;
  SoDrawStyle *drawStyle = (SoDrawStyle *)
                This->getPart("appearance.drawStyle",TRUE);
  drawStyle->style = SoDrawStyle::LINES;
  eventCB->setHandled();
  return;
}
void SoMcFDetectorTreeKit::solid(void *userData, SoEventCallback *eventCB){

  // Was the event previously handled? Is it the right kind?
  if (eventCB->isHandled()) return;
  const SoEvent *event = (SoEvent *) eventCB->getEvent();
  if (!event->wasCtrlDown()) return;
  if(!SoKeyboardEvent::isKeyPressEvent(event, SoKeyboardEvent::S))return;

  // Which detector is this being called for?
  SoMcFDetectorTreeKit *This = (SoMcFDetectorTreeKit *) userData;

  // Find out whether that's the one that has been picked
  SoHandleEventAction *handleEventAction = eventCB->getAction();
  const SoPickedPoint *pickedPoint = handleEventAction->getPickedPoint();
  if (!pickedPoint) return;
 
  SoNodeKitPath          *path        = (SoNodeKitPath *) pickedPoint->getPath();
  if (This!= findAncestorNode(path)) return;
  SoDrawStyle *drawStyle = (SoDrawStyle *)
                    This->getPart("appearance.drawStyle",TRUE);
  drawStyle->style = SoDrawStyle::FILLED;
  eventCB->setHandled();
  return;
}
void SoMcFDetectorTreeKit::gone(void *userData, SoEventCallback *eventCB){

  // Was the event previously handled? Is it the right kind?
  if (eventCB->isHandled()) return;
  const SoKeyboardEvent *keyboardEvent = (SoKeyboardEvent *) eventCB->getEvent();
  if (!keyboardEvent->wasCtrlDown()) return;
  if(keyboardEvent->getKey() != SoKeyboardEvent::G)return;

  // Which detector is this being called for?
  SoMcFDetectorTreeKit *This = (SoMcFDetectorTreeKit *) userData;

  // Find out whether that's the one that has been picked
  SoHandleEventAction *handleEventAction = eventCB->getAction();
  const SoPickedPoint *pickedPoint = handleEventAction->getPickedPoint();
  if (!pickedPoint) return;
 
  // Find out whether that's the one that has been picked.  This is the lowest
  //detector
  // tree kit in the hierarchy.
  SoNodeKitPath          *path        = (SoNodeKitPath *) pickedPoint->getPath();
  if (This!= findAncestorNode(path)) return;
  SoDrawStyle *drawStyle = (SoDrawStyle *)
                 This->getPart("appearance.drawStyle",TRUE);
  drawStyle->style = SoDrawStyle::INVISIBLE;
  eventCB->setHandled();
  return;
}
void SoMcFDetectorTreeKit::selectCB(void *userData, SoEventCallback *eventCB){
  // Was the event previously handled? Is it the right kind?
  if (eventCB->isHandled()) return;
  const SoMouseButtonEvent *event = (SoMouseButtonEvent *)
                                            eventCB->getEvent();

  if (!SoMouseButtonEvent::isButtonPressEvent
                     (event,SoMouseButtonEvent::BUTTON1))
  return;

  if (event->wasCtrlDown()) return;
  if (event->wasShiftDown()) return;

  if(oldStyle == NULL) oldStyle = new SoDrawStyle;   

  // Which detector is this being called for?
  SoMcFDetectorTreeKit *This = (SoMcFDetectorTreeKit *) userData;

  // Find out whether that's the one that has been picked
  SoHandleEventAction *handleEventAction = eventCB->getAction();
  const SoPickedPoint *pickedPoint = handleEventAction->getPickedPoint();
  if (!pickedPoint){
     resetSelected();
     return;
  }
 
  // Find out whether that's the one that has been picked.  This is the lowest
  //detector
  // tree kit in the hierarchy.
  SoFullPath          *path        = (SoFullPath *)
  pickedPoint->getPath();
  SoNode *ancestorNode=NULL;
  SbBool firstTreeFound=FALSE;
  for (int i=0;i<path->getLength();i++) {
    ancestorNode  = path->getNodeFromTail(i);
    if (ancestorNode->isOfType(SoMcFDetectorTreeKit::getClassTypeId())) {
      if (!firstTreeFound) {
        //if (selectedTreeKit != ancestorNode) resetSelected();
        resetSelected();
        if (This!=ancestorNode) return;
        firstTreeFound=TRUE;
      }
      SoDrawStyle *drawStyle = (SoDrawStyle *)
                  This->getPart("appearance.drawStyle",TRUE);

      //save the old style so we can get back to it on deselect
      oldStyle->style = drawStyle->style;
      oldStyle->lineWidth.setValue(drawStyle->lineWidth.getValue());         
      oldStyle->linePattern.setValue(drawStyle->linePattern.getValue());

      drawStyle->style = SoDrawStyle::LINES;
      drawStyle->lineWidth.setValue(2.0);
      drawStyle->linePattern.setValue(0xff0);
      selectedTreeKit = This;
      
      mcfPickInfoWindow *pickWindow = 
             mcfPickInfoWindow::pickInfoWindow(SoXt::getTopLevelWidget());
      pickWindow->updateText(printDetector( This->device, This->whichDevice));

      eventCB->setHandled();
      return;
  }
 }
 //picked object is not an SoMcFDetectorTreeKit
   resetSelected();

 return;

}
void SoMcFDetectorTreeKit::resetSelected(void){
SoDrawStyle *selDrawStyle;
 if(selectedTreeKit != NULL && oldStyle != NULL){
    selDrawStyle = (SoDrawStyle *)
                  selectedTreeKit->getPart("appearance.drawStyle",TRUE);
    selDrawStyle->style = oldStyle->style;
    selDrawStyle->lineWidth.setValue(oldStyle->lineWidth.getValue());

    selDrawStyle->
                  linePattern.setValue(oldStyle->linePattern.getValue());
    selectedTreeKit = NULL;
 }

}

void SoMcFDetectorTreeKit::setPreview(SbBool Flag) {
  SoSwitch *theChildList = (SoSwitch *) childList.getValue();
  if (Flag) {
    theChildList->whichChild.setValue(0);
  }
  else {
    theChildList->whichChild.setValue(1);
  }
}
void SoMcFDetectorTreeKit::setOff(void) {
  SoSwitch *theChildList = (SoSwitch *) childList.getValue();
    theChildList->whichChild = SO_SWITCH_NONE;
}

SbBool SoMcFDetectorTreeKit::getPreview() const {
  SoSwitch *theChildList = (SoSwitch *) childList.getValue();
  if (theChildList->whichChild.getValue()==0) return TRUE;
  return FALSE;
}
SbBool SoMcFDetectorTreeKit::isVisible() const {
 SoSwitch *theChildList = (SoSwitch *) childList.getValue();
 if (theChildList->whichChild.getValue()==SO_SWITCH_NONE) return FALSE;
 return TRUE;
}


SoSeparator *SoMcFDetectorTreeKit::getPreviewSeparator() const {
  return (SoSeparator *) previewSeparator.getValue();
}

SoSeparator *SoMcFDetectorTreeKit::getFullSeparator() const {
  return (SoSeparator *) fullSeparator.getValue();
}




// generateAlternateRep
void SoMcFDetectorTreeKit::generateAlternateRep() {
  alternateRep.setValue(topSeparator.getValue());
}

void SoMcFDetectorTreeKit::clearAlternateRep() {
  alternateRep.setValue(NULL);
}

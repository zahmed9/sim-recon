/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoDetectorTreeKit                                         */
/* Description:      Represents a single sided silicon strip detector        */
/* Author:           Joe Boudreau Nov 11 1996                                */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/events/SoMouseButtonEvent.h>
#include <Inventor/SoPickedPoint.h>
#include <Inventor/nodes/SoPickStyle.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodekits/SoAppearanceKit.h>
#include <Inventor/nodekits/SoNodeKitListPart.h>
#include <Inventor/nodekits/SoBaseKit.h>
#include <Inventor/nodes/SoSwitch.h>
#include <Inventor/nodekits/SoSeparatorKit.h>
#include <Inventor/nodekits/SoShapeKit.h>
#include <Inventor/Xt/SoXtMaterialEditor.h>
#include "hepvis/SoDetectorTreeKit.hh"

// This statement is required
SO_KIT_SOURCE(SoDetectorTreeKit);

// initClass
void SoDetectorTreeKit::initClass(){
  SO_KIT_INIT_CLASS(SoDetectorTreeKit,SoBaseKit,"BaseKit");
}

// Constructor
SoDetectorTreeKit::SoDetectorTreeKit() {
  SO_KIT_CONSTRUCTOR(SoDetectorTreeKit);

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
}

// Destructor
SoDetectorTreeKit::~SoDetectorTreeKit() {
}

SbBool SoDetectorTreeKit::affectsState() const {
  return FALSE;
}

void SoDetectorTreeKit::createInitialTree() {

  SoEventCallback *myCallback = new SoEventCallback();
  myCallback->addEventCallback(SoMouseButtonEvent::getClassTypeId(),
                               SoDetectorTreeKit::expand,
                               this);
  myCallback->addEventCallback(SoMouseButtonEvent::getClassTypeId(),
                               SoDetectorTreeKit::contract  ,
                               this);
  myCallback->addEventCallback(SoMouseButtonEvent::getClassTypeId(),
                               SoDetectorTreeKit::color  ,
                               this);

  setPart("callbackList[0]",myCallback); 

  SoSwitch *theChildList = (SoSwitch *) childList.getValue();
  theChildList->whichChild.setValue(0);
}

void SoDetectorTreeKit::color(void *userData, SoEventCallback *eventCB){

  // Was the event previously handled? Is it the right kind?

  if (eventCB->isHandled()) return;
  const SoMouseButtonEvent *event= (SoMouseButtonEvent *) eventCB->getEvent();
  if (!SoMouseButtonEvent::isButtonPressEvent(event,SoMouseButtonEvent::BUTTON1)) return;
  if (!event->wasCtrlDown()) return;
  if (!event->wasShiftDown()) return;

  // Which Detector is this being called for?
  SoDetectorTreeKit *This = (SoDetectorTreeKit *) userData;

  // Find out whether that's the one that has been picked.  This is the lowest detector
  // tree kit in the hierarchy.
  SoHandleEventAction *handleEventAction = eventCB->getAction();
  const SoPickedPoint *pickedPoint = handleEventAction->getPickedPoint();
  if (!pickedPoint) return;

  SoFullPath          *path        = (SoFullPath *) pickedPoint->getPath();
  SoNode *ancestorNode=NULL;
  for (int i=0;i<path->getLength();i++) {
    ancestorNode  = path->getNodeFromTail(i);
    if (ancestorNode->isOfType(SoDetectorTreeKit::getClassTypeId()))  break;
  }
  if (This!=ancestorNode) return;
 


  //set up material editor and attach to material
  
  SoMaterial *theMaterial = (SoMaterial *)
                    This->getPart("appearance.material",TRUE);
  if(theMaterial != NULL){
    SoXtMaterialEditor *colorEditor = new SoXtMaterialEditor;
    colorEditor->attach(theMaterial);
    colorEditor->show();
  }
  eventCB->setHandled();
     
}

void SoDetectorTreeKit::expand(void *userData, SoEventCallback *eventCB){

  // Was the event previously handled? Is it the right kind?

  if (eventCB->isHandled()) return;
  const SoMouseButtonEvent *event= (SoMouseButtonEvent *) eventCB->getEvent();
  if (!SoMouseButtonEvent::isButtonPressEvent(event,SoMouseButtonEvent::BUTTON1)) return;
  if (event->wasCtrlDown()) return;
  if (event->wasShiftDown()) return;

  // Which Strip Detector is this being called for?
  SoDetectorTreeKit *This = (SoDetectorTreeKit *) userData;

  // Find out whether that's the one that has been picked.  This is the lowest detector
  // tree kit in the hierarchy.
  SoHandleEventAction *handleEventAction = eventCB->getAction();
  const SoPickedPoint *pickedPoint = handleEventAction->getPickedPoint();
  if (!pickedPoint) return;

  SoFullPath          *path        = (SoFullPath *) pickedPoint->getPath();
  SoNode *ancestorNode=NULL;
  for (int i=0;i<path->getLength();i++) {
    ancestorNode  = path->getNodeFromTail(i);
    if (ancestorNode->isOfType(SoDetectorTreeKit::getClassTypeId()))  break;
  }
  if (This!=ancestorNode) return;
  //  if (!ancestorNode->isOfType(SoDetectorTreeKit::getClassTypeId())) return;
 

  // Deactivate the Preview
  This->setPreview(FALSE);
  eventCB->setHandled();
     
}

void SoDetectorTreeKit::contract(void *userData, SoEventCallback *eventCB){

  // Was the event previously handled? Is it the right kind?
  if (eventCB->isHandled()) return;
  const SoMouseButtonEvent *event= (SoMouseButtonEvent *) eventCB->getEvent();
  if (!SoMouseButtonEvent::isButtonPressEvent(event,SoMouseButtonEvent::BUTTON1)) return;
  if (!event->wasCtrlDown()) return;
  if (event->wasShiftDown()) return;

  // Which Strip Detector is this being called for?
  SoDetectorTreeKit *This = (SoDetectorTreeKit *) userData;

  // Find out whether that's the one that has been picked
  SoHandleEventAction *handleEventAction = eventCB->getAction();
  const SoPickedPoint *pickedPoint = handleEventAction->getPickedPoint();
  if (!pickedPoint) return;
 
  // Find out whether that's the one that has been picked.  This is the lowest detector
  // tree kit in the hierarchy.
  SoFullPath          *path        = (SoFullPath *) pickedPoint->getPath();
  SoNode *ancestorNode=NULL;
  SbBool firstTreeFound=FALSE;
  for (int i=0;i<path->getLength();i++) {
    ancestorNode  = path->getNodeFromTail(i);
    if (ancestorNode->isOfType(SoDetectorTreeKit::getClassTypeId())) {
      if (!firstTreeFound) {
        if (This!=ancestorNode) return;
        firstTreeFound=TRUE;
      }
      SoDetectorTreeKit *That = (SoDetectorTreeKit *) ancestorNode;
      if (!That->getPreview()) {
        That->setPreview(TRUE);
        eventCB->setHandled();
        return;
      }
    }
  }
}

void SoDetectorTreeKit::setPreview(SbBool Flag) {
  SoSwitch *theChildList = (SoSwitch *) childList.getValue();
  if (Flag) {
    theChildList->whichChild.setValue(0);
  }
  else {
    theChildList->whichChild.setValue(1);
  }
}

SbBool SoDetectorTreeKit::getPreview() const {
  SoSwitch *theChildList = (SoSwitch *) childList.getValue();
  if (theChildList->whichChild.getValue()==0) return TRUE;
  return FALSE;
}


SoSeparator *SoDetectorTreeKit::getPreviewSeparator() const {
  return (SoSeparator *) previewSeparator.getValue();
}

SoSeparator *SoDetectorTreeKit::getFullSeparator() const {
  return (SoSeparator *) fullSeparator.getValue();
}




// generateAlternateRep
void SoDetectorTreeKit::generateAlternateRep() {
  alternateRep.setValue(topSeparator.getValue());
}

void SoDetectorTreeKit::clearAlternateRep() {
  alternateRep.setValue(NULL);
}

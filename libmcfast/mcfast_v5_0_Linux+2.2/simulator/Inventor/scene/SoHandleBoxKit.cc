/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoHandleBoxKit                                          */
/* Description:      Use a handlebox to crop the objects displayed           */
/* Author:           Amber Boehnlein Aug. 27, 1997                           */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/actions/SoSearchAction.h>
#include <Inventor/events/SoMouseButtonEvent.h>
#include <Inventor/events/SoKeyboardEvent.h>
#include <Inventor/SoLists.h>
#include <Inventor/SoPath.h>
#include <Inventor/SoPickedPoint.h>
#include <Inventor/nodes/SoPickStyle.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/nodekits/SoNodeKitListPart.h>
#include <Inventor/nodekits/SoBaseKit.h>
#include <Inventor/nodes/SoSwitch.h>
#include <Inventor/nodekits/SoSeparatorKit.h>
#include <Inventor/nodekits/SoShapeKit.h>
#include <Inventor/draggers/SoHandleBoxDragger.h>
#include "hepvis/SoHandleBoxKit.hh"
#include <Inventor/actions/SoWriteAction.h>
#include <math.h>

// This statement is required
SO_KIT_SOURCE(SoHandleBoxKit);

// initClass
void SoHandleBoxKit::initClass(){
  SO_KIT_INIT_CLASS(SoHandleBoxKit,SoBaseKit,"BaseKit");
}

// Constructor
SoHandleBoxKit::SoHandleBoxKit() {
  SO_KIT_CONSTRUCTOR(SoHandleBoxKit);

  SO_NODE_ADD_FIELD(alternateRep, (NULL));

  SO_KIT_ADD_CATALOG_ENTRY     (     topSeparator,         SoSeparator, FALSE,  
         this, ,             FALSE);
  SO_KIT_ADD_CATALOG_ENTRY     (        childList,            SoSwitch, FALSE, 
  topSeparator, ,             FALSE);
  SO_KIT_ADD_CATALOG_ENTRY     ( cropSwitch,         SoSwitch, FALSE,  
    childList, ,              TRUE);
  SO_KIT_ADD_CATALOG_ENTRY     ( fullSeparator,         SoSeparator, FALSE,  
    childList, ,              TRUE);
  SO_KIT_ADD_CATALOG_ENTRY     ( handleBoxSeparator,   SoSeparator, FALSE,  
    cropSwitch, ,              TRUE);
  SO_KIT_ADD_CATALOG_ENTRY     ( cropSeparator,   SoSeparator, FALSE,  
    cropSwitch, ,              TRUE);
  SO_KIT_ADD_CATALOG_ENTRY     ( handleBox,         SoHandleBoxDragger, FALSE,  
    handleBoxSeparator, ,              TRUE);



  SO_KIT_INIT_INSTANCE();
  firstTime = TRUE;
  createInitialTree();
}

// Destructor
SoHandleBoxKit::~SoHandleBoxKit() {
}

SbBool SoHandleBoxKit::affectsState() const {
  return FALSE;
}

void SoHandleBoxKit::createInitialTree() {

  SoEventCallback *myCallback = new SoEventCallback();
  myCallback->addEventCallback(SoKeyboardEvent::getClassTypeId(),
                               SoHandleBoxKit::EnableHandleBox,
                               this);
  myCallback->addEventCallback(SoKeyboardEvent::getClassTypeId(),
                               SoHandleBoxKit::DisableHandleBox  ,
                               this);
  myCallback->addEventCallback(SoKeyboardEvent::getClassTypeId(),
                               SoHandleBoxKit::FullView  ,
                               this);
  myCallback->addEventCallback(SoMouseButtonEvent::getClassTypeId(),
                               SoHandleBoxKit::HandleBoxPick  ,
                               this);

  setPart("callbackList[0]",myCallback); 

  SoSwitch *theChildList = (SoSwitch *) childList.getValue();
//the full separator is default
  theChildList->whichChild.setValue(1);

//The handlebox separator contains the crop separator.
  SoSeparator *handlesep = (SoSeparator *) handleBoxSeparator.getValue();
  SoSeparator *cropsep = (SoSeparator *) cropSeparator.getValue();
  handlesep->addChild(cropsep);

  size.setValue(1.0, 1.0, 1.0);
  center.setValue(0.0, 0.0, 0.0);
}

void SoHandleBoxKit::EnableHandleBox(void *userData, SoEventCallback *eventCB){

  // Was the event previously handled? Is it the right kind?

  if (eventCB->isHandled()) return;
  const SoKeyboardEvent *keyboardEvent = (SoKeyboardEvent *)
      eventCB->getEvent();
  if (!keyboardEvent->wasCtrlDown()) return;
  if(keyboardEvent->getKey() != SoKeyboardEvent::B)return;

  // Which Detector is this being called for?
  SoHandleBoxKit *This = (SoHandleBoxKit *) userData;

  // Find out whether that's the one that has been picked. 
  SoHandleEventAction *handleEventAction = eventCB->getAction();
  const SoPickedPoint *pickedPoint = handleEventAction->getPickedPoint();
  if (!pickedPoint) return;
  //don't bother if the box is already up
  if(This->getCrop() && This->getBoxVisible())return; 


  SoFullPath *path        = (SoFullPath *) pickedPoint->getPath();
  SoNode *ancestorNode=NULL;
  for (int i=0;i<path->getLength();i++) {
    ancestorNode  = path->getNodeFromTail(i);
    if (ancestorNode->isOfType(SoHandleBoxKit::getClassTypeId()))  break;
  }
  if (This!=ancestorNode) return;
  if(This->firstTime){
     This->calculateBoxSize();
     
     This->firstTime = FALSE;
  }
  This->generateCrop();
  
//Switch to the cropped separator
  This->setCrop(TRUE);
  This->setBoxVisible(TRUE); 
  eventCB->setHandled();
     
}
void SoHandleBoxKit::DisableHandleBox(void *userData, SoEventCallback *eventCB){

//This method takes the box off

  // Was the event previously handled? Is it the right kind?

  if (eventCB->isHandled()) return;
  const SoKeyboardEvent *keyboardEvent = (SoKeyboardEvent *)
  eventCB->getEvent();
  if (!keyboardEvent->wasCtrlDown()) return;
  if (!keyboardEvent->wasShiftDown()) return;
  if(keyboardEvent->getKey() != SoKeyboardEvent::B)return;

  // Which Detector is this being called for?
  SoHandleBoxKit *This = (SoHandleBoxKit *) userData;

  // Find out whether that's the one that has been picked. 
  SoHandleEventAction *handleEventAction = eventCB->getAction();
  const SoPickedPoint *pickedPoint = handleEventAction->getPickedPoint();
  if (!pickedPoint) return;

  SoFullPath *path        = (SoFullPath *) pickedPoint->getPath();
  SoNode *ancestorNode=NULL;
  for (int i=0;i<path->getLength();i++) {
    ancestorNode  = path->getNodeFromTail(i);
    if (ancestorNode->isOfType(SoHandleBoxKit::getClassTypeId()))  break;
  }
  if (This!=ancestorNode) return;

  if(!This->getCrop()) return; //already in full mode, leave it alone
  
  This->setCrop(TRUE);
  This->setBoxVisible(FALSE); 
  eventCB->setHandled();
     
}
void SoHandleBoxKit::FullView(void *userData, SoEventCallback
*eventCB){

//This method returns to the full view

  // Was the event previously handled? Is it the right kind?

  if (eventCB->isHandled()) return;
  const SoKeyboardEvent *keyboardEvent = (SoKeyboardEvent *)
  eventCB->getEvent();
  if (!keyboardEvent->wasCtrlDown()) return;
  if (!keyboardEvent->wasShiftDown()) return;
  if(keyboardEvent->getKey() != SoKeyboardEvent::F)return;

  // Which Detector is this being called for?
  SoHandleBoxKit *This = (SoHandleBoxKit *) userData;

  // Find out whether that's the one that has been picked. 
  SoHandleEventAction *handleEventAction = eventCB->getAction();
  const SoPickedPoint *pickedPoint = handleEventAction->getPickedPoint();
  if (!pickedPoint) return;

  SoFullPath *path        = (SoFullPath *) pickedPoint->getPath();
  SoNode *ancestorNode=NULL;
  for (int i=0;i<path->getLength();i++) {
    ancestorNode  = path->getNodeFromTail(i);
    if (ancestorNode->isOfType(SoHandleBoxKit::getClassTypeId()))  break;
  }
  if (This!=ancestorNode) return;
  
  This->setCrop(FALSE);
  This->setBoxVisible(FALSE); 
  eventCB->setHandled();
     
}

void SoHandleBoxKit::HandleBoxPick(void *userData, SoEventCallback *eventCB){

  // Was the event previously handled? Is it the right kind?

  if (eventCB->isHandled()) return;
  const SoMouseButtonEvent *event= (SoMouseButtonEvent *) eventCB->getEvent();
  if
  (!SoMouseButtonEvent::isButtonPressEvent(event,SoMouseButtonEvent::BUTTON1))
  return;

  // Which Detector is this being called for?
  SoHandleBoxKit *This = (SoHandleBoxKit *) userData;

  // Find out whether that's the one that has been picked. 
  SoHandleEventAction *handleEventAction = eventCB->getAction();
  const SoPickedPoint *pickedPoint = handleEventAction->getPickedPoint();
  if (!pickedPoint) return;
  //don't bother if the box is not  up
  if(This->getCrop() && !This->getBoxVisible())return; 


  SoFullPath *path        = (SoFullPath *) pickedPoint->getPath();
  SoNode *ancestorNode=NULL;
  for (int i=0;i<path->getLength();i++) {
    ancestorNode  = path->getNodeFromTail(i);
    if (ancestorNode->isOfType(SoHandleBoxKit::getClassTypeId()))  break;
  }
  if (This!=ancestorNode) return;
  This->generateCrop();
  
  eventCB->setHandled();
     
}

void SoHandleBoxKit::setCrop(SbBool Flag) {
  SoSwitch *theChildList = (SoSwitch *) childList.getValue();
  if (Flag) {
    theChildList->whichChild.setValue(0);
  }
  else {
    theChildList->whichChild.setValue(1);
  }
}

SbBool SoHandleBoxKit::getCrop() const {
  SoSwitch *theChildList = (SoSwitch *) childList.getValue();
  if (theChildList->whichChild.getValue()==0) return TRUE;
  return FALSE;
}

void SoHandleBoxKit::setBoxVisible(SbBool Flag) {
  SoSwitch *theChildList = (SoSwitch *) cropSwitch.getValue();
  if (Flag) {
    theChildList->whichChild.setValue(0);
  }
  else {
    theChildList->whichChild.setValue(1);
  }
}

SbBool SoHandleBoxKit::getBoxVisible() const {
  SoSwitch *theChildList = (SoSwitch *) cropSwitch.getValue();
  if (theChildList->whichChild.getValue()==0) return TRUE;
  return FALSE;
}


// generateAlternateRep
void SoHandleBoxKit::generateAlternateRep() {
  alternateRep.setValue(topSeparator.getValue());
}

void SoHandleBoxKit::clearAlternateRep() {
  alternateRep.setValue(NULL);
}
void SoHandleBoxKit::calculateBoxSize(void)
{
  float xmax = 1.0, ymax = 1.0, zmax = 1.0;
  float x, y, z;
  SoPathList pathList;
  SoTransform *transform;

  SoSeparator *sep = (SoSeparator *) fullSeparator.getValue();

  SoSearchAction action;
  action.setType(SoTransform::getClassTypeId());
  action.setInterest(SoSearchAction::ALL);
  action.apply(sep);
  if(action.getPaths() != NULL){
    pathList = (SoPathList) action.getPaths();
    for(int i = 0; i < pathList.getLength(); i++){
    SoPath *path = pathList[i];
    SoNode *transNode=NULL;
      for (int j=0; j<path->getLength(); j++) {
	transNode  = path->getNodeFromTail(j);
	if (transNode->isOfType
             (SoTransform::getClassTypeId())){
          transform = (SoTransform *) transNode;  
          (transform->translation.getValue()).getValue(x,y,z);
          if(fabs(x) > xmax) xmax = fabs(x);
          if(fabs(y) > ymax) ymax = fabs(y);
          if(fabs(z) > zmax) zmax = fabs(z);
	}
      }
    }
  }          
  size.setValue(xmax,ymax,zmax);
  return;
}
void SoHandleBoxKit::generateCrop(void)
{
  float xmin, xmax, ymin, ymax, zmin, zmax;
  float x0=0.0, y0=0.0, z0=0.0, x=0.0, y=0.0, z=0.0;

  SoPathList pathList;
  SoTransform *transform;

  SoSeparator *fullsep = (SoSeparator *) fullSeparator.getValue();
  SoSeparator *cropsep = (SoSeparator *) cropSeparator.getValue();
//first dump everything from the cropped separator
  int children = cropsep->getNumChildren();
  for (int i = cropsep->getNumChildren() - 1; i >= 0; i--)
  {
           cropsep->removeChild(i);
  }

  (size.getValue()).getValue(x0,y0,z0);
  (center.getValue()).getValue(x,y,z);
  
  xmin = x0 - x; xmax = x0 + x; 
  ymin = y0 - y; ymax = y0 + y; 
  zmin = z0 - z; zmax = z0 + z; 

  SoSearchAction action;
  action.setType(SoTransform::getClassTypeId());
  action.setInterest(SoSearchAction::ALL);
  action.apply(fullsep);
  if(action.getPaths() != NULL){
    pathList = (SoPathList) action.getPaths();
    for(int i = 0; i < pathList.getLength(); i++){
    SoPath *path = pathList[i];
    SoNode *transNode=NULL;
      for (int j=0; j<path->getLength(); j++) {
	transNode  = path->getNodeFromTail(j);
	if (transNode->isOfType
             (SoTransform::getClassTypeId())){
          transform = (SoTransform *) transNode;  
          (transform->translation.getValue()).getValue(x,y,z);
          if(x > xmin && x < xmax &&
             y > ymin && y < ymax &&
             z > zmin && z < zmax ){
             // try to get the full node, one in from the 
             // Path head --This looks like an accident waiting to
             // happen.
                SoNode *node = (SoNode *) path->getNode(0);
                cropsep->addChild(node);
          } 
 	}
      }
    }
  }
          
  return;
}

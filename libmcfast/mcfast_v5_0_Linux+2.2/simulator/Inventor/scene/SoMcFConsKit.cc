/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoMcFConsKit                                        */
/* Description:      Represents a calorimeter block                          */
/* Author:           Amber Boehnlein 1/11/97                                 */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/events/SoMouseButtonEvent.h>
#include <Inventor/SoPickedPoint.h>
#include <Inventor/nodes/SoPickStyle.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodekits/SoNodeKitListPart.h>
#include <Inventor/nodekits/SoBaseKit.h>
#include <Inventor/nodekits/SoSeparatorKit.h>
#include <Inventor/nodekits/SoShapeKit.h>
#include <Inventor/nodekits/SoAppearanceKit.h>
#include <Inventor/Xt/SoXtMaterialEditor.h>
#include <Inventor/Xt/SoXt.h>
#include "hepvis/SoXtAngleSlider.hh"
#include "hepvis/SoG4Cons.hh"

#include "hepvis/SoMcFConsKit.hh"

// This statement is required
SO_KIT_SOURCE(SoMcFConsKit);

// initClass
void SoMcFConsKit::initClass(){
  SO_KIT_INIT_CLASS(SoMcFConsKit,SoBaseKit,"BaseKit");
}

// Constructor
SoMcFConsKit::SoMcFConsKit() {
//the indices are always the same so define them on construction.
  SO_KIT_CONSTRUCTOR(SoMcFConsKit);

  SO_NODE_ADD_FIELD(alternateRep, (NULL));

  SO_KIT_ADD_CATALOG_ENTRY     (     topSeparator,    SoSeparator,      
                                     FALSE,  this, ,  FALSE);
  SO_KIT_ADD_CATALOG_ENTRY     (     appearance,     SoAppearanceKit,    
                                     FALSE,  topSeparator, , TRUE);           
  SO_KIT_ADD_CATALOG_ENTRY     (     transform, SoTransform, 
                                     FALSE, topSeparator, ,TRUE);
  SO_KIT_ADD_CATALOG_ENTRY     (     cons,  SoG4Cons, 
                                     FALSE, topSeparator, , TRUE);
  
  SO_KIT_INIT_INSTANCE();
  createInitialTree();
}

// Destructor
SoMcFConsKit::~SoMcFConsKit() {
}

SbBool SoMcFConsKit::affectsState() const {
  return FALSE;
}

void SoMcFConsKit::createInitialTree() {
  SoEventCallback *myCallback = new SoEventCallback();
  myCallback->addEventCallback(SoMouseButtonEvent::getClassTypeId(),
                               SoMcFConsKit::cutView  ,
                               this);
  myCallback->addEventCallback(SoMouseButtonEvent::getClassTypeId(),
                               SoMcFConsKit::color  ,
                               this);

  setPart("callbackList[0]",myCallback); 

 return;
}

// generateAlternateRep
void SoMcFConsKit::generateAlternateRep() {
  alternateRep.setValue(topSeparator.getValue());
}

void SoMcFConsKit::clearAlternateRep() {
  alternateRep.setValue(NULL);
}
void SoMcFConsKit::color(void *userData, SoEventCallback *eventCB){

  // Was the event previously handled? Is it the right kind?

  if (eventCB->isHandled()) return;
  const SoMouseButtonEvent *event= (SoMouseButtonEvent *) eventCB->getEvent();
  if
  (!SoMouseButtonEvent::isButtonPressEvent(event,SoMouseButtonEvent::BUTTON1))
  return;
  if (!event->wasCtrlDown()) return;
  if (!event->wasShiftDown()) return;

  // Which Cons is this being called for?
  SoMcFConsKit *This = (SoMcFConsKit *) userData;

  // Find out whether that's the one that has been picked
  SoHandleEventAction *handleEventAction = eventCB->getAction();
  const SoPickedPoint *pickedPoint = handleEventAction->getPickedPoint();
  if (!pickedPoint) return;

  SoFullPath          *path        = (SoFullPath *) pickedPoint->getPath();
  SoNode *ancestorNode=NULL;
  for (int i=0;i<path->getLength();i++) {
    ancestorNode  = path->getNodeFromTail(i);
    if (ancestorNode->isOfType(SoMcFConsKit::getClassTypeId()))  break;
  }
  if (This!=ancestorNode) return;
 


  //set up material editor and attach to material
  
  SoXtMaterialEditor *colorEditor = new SoXtMaterialEditor;
  SoMaterial *theMaterial = (SoMaterial *)
                    This->getPart("appearance.material",TRUE);
  colorEditor->attach(theMaterial);
  colorEditor->show();
  eventCB->setHandled();
     
}
void SoMcFConsKit::cutView(void *userData, SoEventCallback *eventCB){

  // Was the event previously handled? Is it the right kind?

  if (eventCB->isHandled()) return;
  const SoMouseButtonEvent *event= (SoMouseButtonEvent *) eventCB->getEvent();
  if
  (!SoMouseButtonEvent::isButtonPressEvent(event,SoMouseButtonEvent::BUTTON2))
  return;
  if (!event->wasShiftDown()) return;

  // Which Cons is this being called for?
  SoMcFConsKit *This = (SoMcFConsKit *) userData;

  // Find out whether that's the one that has been picked. 
  SoHandleEventAction *handleEventAction = eventCB->getAction();
  const SoPickedPoint *pickedPoint = handleEventAction->getPickedPoint();
  if (!pickedPoint) return;

  SoFullPath          *path        = (SoFullPath *) pickedPoint->getPath();
  SoNode *ancestorNode=NULL;
  for (int i=0;i<path->getLength();i++) {
    ancestorNode  = path->getNodeFromTail(i);
    if (ancestorNode->isOfType(SoMcFConsKit::getClassTypeId()))  break;
  }
  if (This!=ancestorNode) return;
 


  //set up angle editor and attach to SoG4Cons
  
  SoXtAngleSlider *angleSlider = new SoXtAngleSlider(SoXt::getTopLevelWidget());
  SoG4Cons *cons = (SoG4Cons *)
                    This->getPart("cons",TRUE);
  angleSlider->attachSliders( cons );
  angleSlider->show();
  eventCB->setHandled();
     
}

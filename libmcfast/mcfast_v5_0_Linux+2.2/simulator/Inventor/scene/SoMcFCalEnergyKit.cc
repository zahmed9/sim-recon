/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoMcFCalEnergyKit                                       */
/* Description:      Represents a calorimeter cell with energy               */
/* Author:           Amber Boehnlein                                         */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/events/SoMouseButtonEvent.h>
#include <Inventor/events/SoKeyboardEvent.h>
#include <Inventor/SoPickedPoint.h>
#include <Inventor/nodes/SoPickStyle.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodekits/SoAppearanceKit.h>
#include <Inventor/nodekits/SoNodeKitListPart.h>
#include <Inventor/nodekits/SoBaseKit.h>
#include <Inventor/nodekits/SoShapeKit.h>
#include <Inventor/SoPath.h>
#include "hepvis/SoMcFCalEnergyKit.hh"
#include "hepvis/SoMcFCalCellKit.hh"
#include "calCellPrint.hh"
#include "mcfPickInfoWindow.hh"
static SoMcFCalEnergyKit *selectedCellEnergyKit = NULL;
// This statement is required
SO_KIT_SOURCE(SoMcFCalEnergyKit);

// initClass
void SoMcFCalEnergyKit::initClass(){
  SO_KIT_INIT_CLASS(SoMcFCalEnergyKit,SoBaseKit,"BaseKit");
}

// Constructor
SoMcFCalEnergyKit::SoMcFCalEnergyKit() {
  minEnergy = -999.;
  hadEnergy = -999.;
  emEnergy = -999.; 
  cellEt   = -999.;

  SO_KIT_CONSTRUCTOR(SoMcFCalEnergyKit);

  SO_NODE_ADD_FIELD(alternateRep, (NULL));

  SO_KIT_ADD_CATALOG_ENTRY     (     topSeparator,         SoSeparator, FALSE,          this, ,             FALSE);
  SO_KIT_ADD_CATALOG_ENTRY     (        calCellKit,     SoMcFCalCellKit,
  FALSE,  topSeparator, ,        TRUE);
  
  SO_KIT_INIT_INSTANCE();
  createInitialTree();
}

// Destructor
SoMcFCalEnergyKit::~SoMcFCalEnergyKit() {
}

SbBool SoMcFCalEnergyKit::affectsState() const {
  return FALSE;
}

void SoMcFCalEnergyKit::createInitialTree() {
  SoEventCallback *myCallback = new SoEventCallback();
   myCallback->addEventCallback(SoMouseButtonEvent::getClassTypeId(),
			       SoMcFCalEnergyKit::selectCB  ,
			       this);
  setPart("callbackList[0]",myCallback); 

 return;
}

// generateAlternateRep
void SoMcFCalEnergyKit::generateAlternateRep() {
  alternateRep.setValue(topSeparator.getValue());
}

void SoMcFCalEnergyKit::clearAlternateRep() {
  alternateRep.setValue(NULL);
}
void SoMcFCalEnergyKit::defineCellColor(float energy, float maxEnergy)
{

   float hue, saturation, value;
   if (energy < 0 ) 
   {
      hue = 0.0;
      saturation = 0.0;
      value = 1.0;
   }
   hue = 1.0 - energy/maxEnergy;  if(hue < 0.0) hue = 0.0; 
   saturation = energy/maxEnergy;  if(saturation > 1.0) saturation = 1.0;
   value = 1.0;
   
   SoMcFCalCellKit *kit = (SoMcFCalCellKit *) this->getPart("calCellKit",
                              TRUE);
   SoMaterial *material = (SoMaterial *)
                   kit->getPart("appearance.material",TRUE);
   material ->diffuseColor.setHSVValue(hue, saturation, value);
   return;

}
void SoMcFCalEnergyKit::resetPick(void)
{
   selectedCellEnergyKit = NULL;
   return;
}
void SoMcFCalEnergyKit::selectCB(void *userData, SoEventCallback *eventCB){
  // Was the event previously handled? Is it the right kind?
  SoDrawStyle *drawStyle;
  if (eventCB->isHandled()) return;
  const SoMouseButtonEvent *event = (SoMouseButtonEvent *)
                                            eventCB->getEvent();

  if (!SoMouseButtonEvent::isButtonPressEvent
                     (event,SoMouseButtonEvent::BUTTON1))return;

  if (event->wasCtrlDown()) return;
  if (event->wasShiftDown()) return;

  // Which Cell is this being called for?
  SoMcFCalEnergyKit *This; 
  SoNode *Node = (SoNode *) userData;

  SoHandleEventAction *handleEventAction = eventCB->getAction();
  const SoPickedPoint *pickedPoint = handleEventAction->getPickedPoint();
  if (!pickedPoint)
  {
    //reset the old picked point
    if(selectedCellEnergyKit != NULL)
    {
      SoMcFCalCellKit *kit = (SoMcFCalCellKit *)
                        selectedCellEnergyKit->getPart("calCellKit", TRUE);
      drawStyle = (SoDrawStyle *)
                  kit->getPart("appearance.drawStyle",TRUE);
      drawStyle->style = SoDrawStyle::FILLED;
      drawStyle->lineWidth.setValue(0.0);
      drawStyle->linePattern.setValue(0xffff);
      selectedCellEnergyKit = NULL;  
    } 
    return;
  }
  SoPath *path = (SoPath *) pickedPoint->getPath();
  SoNode *ancestorNode=NULL;

  SbBool foundKit = FALSE;
  for (int i=0;i<path->getLength();i++)
  {
    ancestorNode  = path->getNodeFromTail(i);
    if (ancestorNode->isOfType(SoMcFCalEnergyKit::getClassTypeId()))
    {
       foundKit = TRUE;
       if (Node!=ancestorNode) return;
       This = (SoMcFCalEnergyKit *) userData;
       break;

    }
  }
  if(!foundKit)
  {
    //there wasn't a track kit in the path
    //reset the old picked point
    if(selectedCellEnergyKit != NULL)
    {
      SoMcFCalCellKit *kit = (SoMcFCalCellKit *)
                        selectedCellEnergyKit->getPart("calCellKit", TRUE);
      drawStyle = (SoDrawStyle *)
                  kit->getPart("appearance.drawStyle",TRUE);
      drawStyle->style = SoDrawStyle::FILLED;
      drawStyle->lineWidth.setValue(0.0);
      drawStyle->linePattern.setValue(0xffff);
      selectedCellEnergyKit = NULL;  
    } 
    return;
     
  }

//reset the old picked point
  if(selectedCellEnergyKit != NULL)
  {
     SoMcFCalCellKit *kit = (SoMcFCalCellKit *)
                        selectedCellEnergyKit->getPart("calCellKit", TRUE);
     drawStyle = (SoDrawStyle *)
                kit->getPart("appearance.drawStyle",TRUE);
     drawStyle->style = SoDrawStyle::FILLED;
     drawStyle->lineWidth.setValue(0.0);
     drawStyle->linePattern.setValue(0xffff);
     selectedCellEnergyKit = NULL;  
  }

  selectedCellEnergyKit = This;

  SoMcFCalCellKit *kit = (SoMcFCalCellKit *)
                        selectedCellEnergyKit->getPart("calCellKit", TRUE);

  drawStyle = (SoDrawStyle *)
                 kit->getPart("appearance.drawStyle",TRUE);
  drawStyle->style = SoDrawStyle::LINES;
  drawStyle->lineWidth.setValue(3.0);
  drawStyle->linePattern.setValue(0xfff0);
 
  mcfPickInfoWindow *pickWindow = 
         mcfPickInfoWindow::pickInfoWindow(SoXt::getTopLevelWidget());
  pickWindow->updateText(calCellPrint( kit->cellIcal.getValue() - 1,
                                       kit->cellIeta.getValue(),
                                       kit->cellIphi.getValue()));

   eventCB->setHandled();
   return;
 
}

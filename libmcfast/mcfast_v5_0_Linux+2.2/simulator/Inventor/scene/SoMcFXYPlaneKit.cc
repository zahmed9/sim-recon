/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoMcFXYPlaneKit                                           */
/* Description:      Represents a silicon XY  plane                          */
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
#include <Inventor/nodes/SoSelection.h>
#include <Inventor/nodekits/SoSeparatorKit.h>
#include <Inventor/nodekits/SoShapeKit.h>
#include <Inventor/nodes/SoCube.h>
#include "hepvis/SoMcFXYPlaneKit.hh"

// This statement is required
SO_KIT_SOURCE(SoMcFXYPlaneKit);

// initClass
void SoMcFXYPlaneKit::initClass(){
  SO_KIT_INIT_CLASS(SoMcFXYPlaneKit,SoBaseKit,"BaseKit");
}

// Constructor
SoMcFXYPlaneKit::SoMcFXYPlaneKit() {
  SO_KIT_CONSTRUCTOR(SoMcFXYPlaneKit);

  SO_NODE_ADD_FIELD(alternateRep, (NULL));

  SO_KIT_ADD_CATALOG_ENTRY     (     topSeparator,    SoSeparator,      
                                     FALSE,  this, ,  FALSE);
  SO_KIT_ADD_CATALOG_ENTRY     (     Appearance,     SoAppearanceKit,    
                                     FALSE,  topSeparator, , TRUE);           
  SO_KIT_ADD_CATALOG_ENTRY     (     Transform,     SoTransform,    
                                     FALSE,  topSeparator, , TRUE);           
  SO_KIT_ADD_CATALOG_ENTRY     (     Plane,     SoCube,    
                                     FALSE,  topSeparator, , TRUE);           
  
  SO_KIT_INIT_INSTANCE();
  createInitialTree();
}

// Destructor
SoMcFXYPlaneKit::~SoMcFXYPlaneKit() {
}

SbBool SoMcFXYPlaneKit::affectsState() const {
  return FALSE;
}

void SoMcFXYPlaneKit::createInitialTree() {

 return;
}

// generateAlternateRep
void SoMcFXYPlaneKit::generateAlternateRep() {
  alternateRep.setValue(topSeparator.getValue());
}

void SoMcFXYPlaneKit::clearAlternateRep() {
  alternateRep.setValue(NULL);
}

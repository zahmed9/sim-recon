/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoMcFXYSilKit                                           */
/* Description:      Represents an XY silcon detector                        */
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
#include <Inventor/nodes/SoCube.h>
#include "hepvis/SoMcFXYSilKit.hh"
#include "hepvis/SoMcFXYPlaneKit.hh"

// This statement is required
SO_KIT_SOURCE(SoMcFXYSilKit);

// initClass
void SoMcFXYSilKit::initClass(){
  SO_KIT_INIT_CLASS(SoMcFXYSilKit,SoBaseKit,"BaseKit");
}

// Constructor
SoMcFXYSilKit::SoMcFXYSilKit() {
  SO_KIT_CONSTRUCTOR(SoMcFXYSilKit);

  SO_NODE_ADD_FIELD(alternateRep, (NULL));

  SO_KIT_ADD_CATALOG_ENTRY     (     topSeparator,    SoSeparator,      
                                     FALSE,  this, ,  FALSE);
                                     
  SO_KIT_ADD_CATALOG_ENTRY     (     Appearance,     SoAppearanceKit,    
                                     FALSE,  topSeparator, , TRUE);
                                                
  SO_KIT_ADD_CATALOG_ENTRY     (     Transform,     SoTransform,    
                                     FALSE,  topSeparator, , TRUE);
                                                
  SO_KIT_ADD_CATALOG_ENTRY     (     XYPlane1,     SoMcFXYPlaneKit,    
                                     FALSE,  topSeparator, , TRUE);
                                                
  SO_KIT_ADD_CATALOG_ENTRY     (     XYPlane2,    SoMcFXYPlaneKit,    
                                     FALSE,  topSeparator, , TRUE);           
  
  SO_KIT_INIT_INSTANCE();
  createInitialTree();
}

// Destructor
SoMcFXYSilKit::~SoMcFXYSilKit() {
}

SbBool SoMcFXYSilKit::affectsState() const {
  return FALSE;
}

void SoMcFXYSilKit::createInitialTree() {

 return;
}

// generateAlternateRep
void SoMcFXYSilKit::generateAlternateRep() {
  alternateRep.setValue(topSeparator.getValue());
}

void SoMcFXYSilKit::clearAlternateRep() {
  alternateRep.setValue(NULL);
}

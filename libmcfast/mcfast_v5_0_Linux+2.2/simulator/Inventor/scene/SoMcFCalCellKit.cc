/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoDetectorTreeKit                                       */
/* Description:      Represents a calorimeter cell                           */
/* Author:           Amber Boehnlein                                         */
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
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/nodes/SoCoordinate3.h>
#include <Inventor/Xt/SoXtMaterialEditor.h>
#include "hepvis/SoMcFCalCellKit.hh"
#include "hepvis/SoMcFCalBlockKit.hh"
#include "McfCalGeomDisplay.hh" 
// This statement is required
SO_KIT_SOURCE(SoMcFCalCellKit);

// initClass
void SoMcFCalCellKit::initClass(){
  SO_KIT_INIT_CLASS(SoMcFCalCellKit,SoBaseKit,"BaseKit");
}

// Constructor
SoMcFCalCellKit::SoMcFCalCellKit() {
  cellEnergy = -999.;
  cellIeta = -999;
  cellIphi = -999;
  cellIcal = -999;
  SO_KIT_CONSTRUCTOR(SoMcFCalCellKit);

  SO_NODE_ADD_FIELD(alternateRep, (NULL));

  SO_KIT_ADD_CATALOG_ENTRY     (     topSeparator,         SoSeparator, FALSE,          this, ,             FALSE);
  SO_KIT_ADD_CATALOG_ENTRY     (        pickStyle,         SoSeparator, FALSE,  topSeparator, ,              TRUE);
  SO_KIT_ADD_CATALOG_ENTRY     (       appearance,     SoAppearanceKit, FALSE,  topSeparator, ,              TRUE);
  SO_KIT_ADD_CATALOG_ENTRY     (            units,             SoUnits, FALSE,  topSeparator, ,              TRUE);
  SO_KIT_ADD_CATALOG_ENTRY     (        transform,         SoTransform, FALSE,  topSeparator, ,              TRUE);
  SO_KIT_ADD_CATALOG_ENTRY     (texture2Transform, SoTexture2Transform, FALSE,  topSeparator, ,              TRUE);
  SO_KIT_ADD_CATALOG_ENTRY     (        calBlockKit,     SoMcFCalBlockKit, FALSE,  topSeparator, ,           
  TRUE);
  
  SO_KIT_INIT_INSTANCE();
  createInitialTree();
}

// Destructor
SoMcFCalCellKit::~SoMcFCalCellKit() {
}

SbBool SoMcFCalCellKit::affectsState() const {
  return FALSE;
}

void SoMcFCalCellKit::createInitialTree() {

 return;
}
// generate the representation of a cell;
void SoMcFCalCellKit::generateCellRepresentation(McfCalGeomDisplay *calGeom) 
{

    SoMcFCalBlockKit *Block = (SoMcFCalBlockKit *) 
                            this->getPart("calBlockKit", TRUE);
    SoCoordinate3 *Coords = (SoCoordinate3 *) 
                            Block->getPart("BlockCoords",TRUE);
			    
    SoTransform *Transform = (SoTransform *) this->getPart("transform",
     TRUE);
    calGeom->setCellIndices(cellIphi.getValue(), cellIeta.getValue(),
                            Coords);
    calGeom->setCellTransform(cellIphi.getValue(), cellIeta.getValue(),
                            Transform);			    
    Block->generateAlternateRep();
    return;
    
}

// generateAlternateRep
void SoMcFCalCellKit::generateAlternateRep() {
  alternateRep.setValue(topSeparator.getValue());
}

void SoMcFCalCellKit::clearAlternateRep() {
  alternateRep.setValue(NULL);
}

/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoMcFCalBlockKit                                        */
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
#include <Inventor/nodekits/SoShapeKit.h>
#include <Inventor/nodes/SoCoordinate3.h>
#include <Inventor/nodes/SoShapeHints.h>
#include <Inventor/nodes/SoIndexedFaceSet.h>

#include "hepvis/SoMcFCalBlockKit.hh"

// This statement is required
SO_KIT_SOURCE(SoMcFCalBlockKit);

// initClass
void SoMcFCalBlockKit::initClass(){
  SO_KIT_INIT_CLASS(SoMcFCalBlockKit,SoBaseKit,"BaseKit");
}

// Constructor
SoMcFCalBlockKit::SoMcFCalBlockKit() {
//the indices are always the same so define them on construction.
 const int NFACES=6, NINDICES = NFACES*5;
#ifdef INVENTOR2_0
  static long  
#else 
  static int32_t
#endif
  indices[NINDICES] = {3,2,1,0, SO_END_FACE_INDEX, // bottom
                       4,5,6,7, SO_END_FACE_INDEX, // top
                       0,1,5,4, SO_END_FACE_INDEX, 
                       1,2,6,5, SO_END_FACE_INDEX,
                       2,3,7,6, SO_END_FACE_INDEX,
                       3,0,4,7, SO_END_FACE_INDEX};

  SO_KIT_CONSTRUCTOR(SoMcFCalBlockKit);

  SO_NODE_ADD_FIELD(alternateRep, (NULL));

  SO_KIT_ADD_CATALOG_ENTRY     (     topSeparator,    SoSeparator,      
                                     FALSE,  this, ,  FALSE);
  SO_KIT_ADD_CATALOG_ENTRY     (     hints,     SoShapeHints,    
                                     FALSE,  topSeparator, , TRUE);           
  SO_KIT_ADD_CATALOG_ENTRY     (     BlockCoords,     SoCoordinate3,    
                                     FALSE,  topSeparator, , TRUE);           
  SO_KIT_ADD_CATALOG_ENTRY     (     BlockIndFaceSet, SoIndexedFaceSet, 
                                     FALSE, topSeparator, , TRUE);
  
  SO_KIT_INIT_INSTANCE();
  createInitialTree();
  //fill in indices and shape hints
  
  SoIndexedFaceSet *FaceSet = (SoIndexedFaceSet *)this->getPart("BlockIndFaceSet", TRUE);
  FaceSet->coordIndex.setValues(0, NINDICES ,indices);
  
  SoShapeHints *Hints = (SoShapeHints *)this->getPart("hints", TRUE);
  Hints->vertexOrdering = SoShapeHints::COUNTERCLOCKWISE;
  Hints->creaseAngle = 0;
}

// Destructor
SoMcFCalBlockKit::~SoMcFCalBlockKit() {
}

SbBool SoMcFCalBlockKit::affectsState() const {
  return FALSE;
}

void SoMcFCalBlockKit::createInitialTree() {

 return;
}

// generateAlternateRep
void SoMcFCalBlockKit::generateAlternateRep() {
  alternateRep.setValue(topSeparator.getValue());
}

void SoMcFCalBlockKit::clearAlternateRep() {
  alternateRep.setValue(NULL);
}

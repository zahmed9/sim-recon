/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoD0Circle                                                */
/* Description:      Represents the McFCons Geant Geometry entity             */
/* Author:           Joe Boudreau Nov 11 1996                                */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#include <assert.h>
#include <math.h>
#include <Inventor/SbBox.h>
#include <Inventor/actions/SoGLRenderAction.h>
#include <Inventor/fields/SoSFFloat.h>
#include <Inventor/fields/SoSFLong.h>
#include <Inventor/misc/SoChildList.h>
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoLineSet.h>
#include <Inventor/nodes/SoCoordinate3.h>
#include "hepvis/SoD0Circle.hh"

// This statement is required
SO_NODE_SOURCE(SoD0Circle);

// Constructor
SoD0Circle::SoD0Circle() {
  // This statement is required
  SO_NODE_CONSTRUCTOR(SoD0Circle);

  // Data fields are initialized like this:
  SO_NODE_ADD_FIELD(fRadius,               (1.0));
  SO_NODE_ADD_FIELD(smoothDraw,          (TRUE));
  SO_NODE_ADD_FIELD(alternateRep,        (NULL));
  children = new SoChildList(this);
}

// Destructor
SoD0Circle::~SoD0Circle() {
}


// initClass
void SoD0Circle::initClass(){
  // This statement is required.
  SO_NODE_INIT_CLASS(SoD0Circle,SoShape,"Shape");
}


// GLRrender
void SoD0Circle::GLRender(SoGLRenderAction *action) {
  if (!shouldGLRender(action)) return;
  if (children->getLength() == 0) generateChildren();
  updateChildren();
  children->traverse(action);  
}

// generatePrimitives
void SoD0Circle::generatePrimitives(SoAction *action) {
  if (children->getLength()==0) generateChildren();
  updateChildren();
  children->traverse(action);
}

// getChildren
SoChildList *SoD0Circle::getChildren() const {
  return children;
}


// computeBBox
void SoD0Circle::computeBBox(SoAction *, SbBox3f &box, SbVec3f &center ){
 float fR= fRadius.getValue();  
 
  SbVec3f min(-fR*cos(M_PI/4.),-fR*sin(M_PI/4.),0.);
  SbVec3f max( fR*cos(M_PI/4.), fR*sin(M_PI/4.),0.);
  center.setValue(0,0,0);
  box.setBounds(min,max);
}




// updateChildren
void SoD0Circle::updateChildren() {


  // Redraw the McFCons....

  assert(children->getLength()==1);
  SoSeparator       *sep                
                = (SoSeparator *)  ( *children)[0];
  SoCoordinate3     *theCoordinates    
                = (SoCoordinate3 *)      ( sep->getChild(0));
  SoLineSet  *theLineSet         
                = (SoLineSet *)   ( sep->getChild(1));

  const int NPHI = 120;
  const int NPOINTS = NPHI + 1;
  SbVec3f points[NPOINTS]; 
  
  float DeltaPhi = 2*M_PI/NPHI;
  float phi = 0.;
  for (int i = 0; i<=NPHI; i++)
  {
    points[i].setValue(fRadius.getValue()*cos(phi),
                                  fRadius.getValue()*sin(phi),
                                  0.0);

    phi+=DeltaPhi;
  }
  points[NPHI].setValue(fRadius.getValue(), 0.0, 0.0);
  theCoordinates->point.setValues(0,NPOINTS,points);
  theLineSet->numVertices.setValues(0,1,&NPOINTS);
}

// generateChildren
void SoD0Circle::generateChildren() {

  // This routines creates one SoSeparator, one SoCoordinate3, and
  // one SoLineSet, and puts it in the child list.  This is done only
  // once, whereas redrawing the position of the coordinates occurs each
  // time an update is necessary, in the updateChildren routine. 

  assert(children->getLength() ==0);
  SoSeparator      *sep              = new SoSeparator(); 
  SoCoordinate3    *theCoordinates   = new SoCoordinate3();
  SoLineSet *theLineSet       = new SoLineSet();
  // 
  // This line costs some in render quality! but gives speed.
  // 
  sep->addChild(theCoordinates);
  sep->addChild(theLineSet);
  children->append(sep);
}

// generateAlternateRep
void SoD0Circle::generateAlternateRep() {

  // This routine sets the alternate representation to the child
  // list of this mode.  

  if (children->getLength() == 0) generateChildren();
  updateChildren();
  alternateRep = (SoSeparator *)  ( *children)[0];
}

// clearAlternateRep
void SoD0Circle::clearAlternateRep() {
  alternateRep = NULL;
}


/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoMcFBoxWithGap                                                */
/* Description:      Represents the G4Trd Geant Geometry entity             */
/* Author:           Joe Boudreau Nov 11 1996                                */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#include <assert.h>
#include <math.h>
#include <Inventor/SbBox.h>
#include <Inventor/actions/SoGLRenderAction.h>
#include <Inventor/fields/SoSFFloat.h>
#include <Inventor/misc/SoChildList.h>
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoIndexedFaceSet.h>
#include <Inventor/nodes/SoNormal.h>
#include <Inventor/nodes/SoCoordinate3.h>
#include <Inventor/nodes/SoNormalBinding.h>
#include "hepvis/SoMcFBoxWithGap.hh"

// This statement is required
SO_NODE_SOURCE(SoMcFBoxWithGap);

// Constructor
SoMcFBoxWithGap::SoMcFBoxWithGap() {
  // This statement is required
  SO_NODE_CONSTRUCTOR(SoMcFBoxWithGap);

  // Data fields are initialized like this:
  SO_NODE_ADD_FIELD(fDxInner,                (1.0));
  SO_NODE_ADD_FIELD(fDxOuter,                (2.0));
  SO_NODE_ADD_FIELD(fDyInner,                (1.0));
  SO_NODE_ADD_FIELD(fDyOuter,                (2.0));
  SO_NODE_ADD_FIELD(fDzInner,                (1.0));
  SO_NODE_ADD_FIELD(fDzOuter,                (1.0));
  SO_NODE_ADD_FIELD(alternateRep,        (NULL));
  children = new SoChildList(this);
}

// Destructor
SoMcFBoxWithGap::~SoMcFBoxWithGap() {
}


// initClass
void SoMcFBoxWithGap::initClass(){
  // This statement is required.
  SO_NODE_INIT_CLASS(SoMcFBoxWithGap,SoShape,"Shape");
}


// GLRrender
void SoMcFBoxWithGap::GLRender(SoGLRenderAction *action) {
  if (!shouldGLRender(action)) return;
  if (children->getLength() == 0) generateChildren();
  updateChildren();
  children->traverse(action);  
}

// generatePrimitives
void SoMcFBoxWithGap::generatePrimitives(SoAction *action) {
  if (children->getLength()==0) generateChildren();
  updateChildren();
  children->traverse(action);
}

// getChildren
SoChildList *SoMcFBoxWithGap::getChildren() const {
  return children;
}


// computeBBox
void SoMcFBoxWithGap::computeBBox(SoAction *, SbBox3f &box, SbVec3f &center ){

  SbVec3f min(-fDxOuter.getValue(),-fDyOuter.getValue(),-fDzOuter.getValue()), 
          max( fDxOuter.getValue(), fDyOuter.getValue(), fDzOuter.getValue());

  center.setValue(0,0,0);
  box.setBounds(min,max);
}




// updateChildren
void SoMcFBoxWithGap::updateChildren() {


  // Redraw the Box....

  assert(children->getLength()==1);
  SoSeparator       *sep                = (SoSeparator *)  ( *children)[0];
  SoCoordinate3     *theCoordinates     = (SoCoordinate3 *)      (
  sep->getChild(0));
  SoNormal          *theNormals         = (SoNormal *)           (
  sep->getChild(1)); 
  SoNormalBinding   *theNormalBinding   = (SoNormalBinding *)    (
  sep->getChild(2));
  SoIndexedFaceSet  *theFaceSet         = (SoIndexedFaceSet *)   (
  sep->getChild(3));

  const int NPOINTS=16, NFACES=16, NINDICES = NFACES*5;
  float points[NPOINTS][3];
  float normals[NFACES][3]= {{1,  0, 0}, {-1, 0, 0},  { 0, 1, 0}, {0, -1,  0}, 
                             {-1,  0, 0}, {-1, 0, 0},  { 0, 1, 0}, {0, 1,  0},
                             {0, 0,  -1}, {0, 0,  -1}, {0, 0,  -1}, { 0, 0, -1},
                             {0, 0, 1}, {0, 0, 1}, {0, 0, 1}, { 0, 0, 1}};
  // Indices for the eight faces
#ifdef INVENTOR2_0
  static long  
#else 
  static int32_t
#endif
  indices[NINDICES] = {0,3,7,4, SO_END_FACE_INDEX, // sides of outer box
                       1,5,6,2, SO_END_FACE_INDEX, 
                       0,1,5,4, SO_END_FACE_INDEX,  
                       2,3,7,6, SO_END_FACE_INDEX,
                       
                       8,11,15,12, SO_END_FACE_INDEX,    //sides of inner box
                       9,13,14,10, SO_END_FACE_INDEX,   
                        8, 9,13,12, SO_END_FACE_INDEX ,   
                       10,11,15,14, SO_END_FACE_INDEX,

                       0,8,11,3, SO_END_FACE_INDEX,
                       3,11,10,2,  SO_END_FACE_INDEX,
                       2,10,9,1, SO_END_FACE_INDEX,
                       1,9,8,0, SO_END_FACE_INDEX,
                       
                       4,12,15,7, SO_END_FACE_INDEX,
                       7,15,14,6, SO_END_FACE_INDEX,
                       6,14,13,5, SO_END_FACE_INDEX,
                       5,13,12,4, SO_END_FACE_INDEX  };
  
  // points for the sixteen vertices
  points[0][0] =  fDxOuter.getValue(); 
  points[0][1] =  fDyOuter.getValue(); 
  points[0][2] = -fDzOuter.getValue();
  
  points[1][0] = -fDxOuter.getValue();
  points[1][1] =  fDyOuter.getValue(); 
  points[1][2] = -fDzOuter.getValue();
  
  points[2][0] = -fDxOuter.getValue();
  points[2][1] = -fDyOuter.getValue();
  points[2][2] = -fDzOuter.getValue();
  
  points[3][0] =  fDxOuter.getValue();
  points[3][1] = -fDyOuter.getValue();
  points[3][2] = -fDzOuter.getValue();
  
  points[4][0] =  fDxOuter.getValue(); 
  points[4][1] =  fDyOuter.getValue(); 
  points[4][2] =  fDzOuter.getValue();
  
  points[5][0] = -fDxOuter.getValue(); 
  points[5][1] =  fDyOuter.getValue(); 
  points[5][2] =  fDzOuter.getValue();
  
  points[6][0] = -fDxOuter.getValue(); 
  points[6][1] = -fDyOuter.getValue(); 
  points[6][2] =  fDzOuter.getValue();

  points[7][0] =  fDxOuter.getValue(); 
  points[7][1] = -fDyOuter.getValue(); 
  points[7][2] =  fDzOuter.getValue();
  
  points[8][0] =  fDxInner.getValue(); 
  points[8][1] =  fDyInner.getValue(); 
  points[8][2] = -fDzInner.getValue();
  
  points[9][0] = -fDxInner.getValue();
  points[9][1] =  fDyInner.getValue(); 
  points[9][2] = -fDzInner.getValue();
  
  points[10][0] = -fDxInner.getValue();
  points[10][1] = -fDyInner.getValue();
  points[10][2] = -fDzInner.getValue();
  
  points[11][0] =  fDxInner.getValue();
  points[11][1] = -fDyInner.getValue();
  points[11][2] = -fDzInner.getValue();
  
  points[12][0] =  fDxInner.getValue(); 
  points[12][1] =  fDyInner.getValue(); 
  points[12][2] =  fDzInner.getValue();
  
  points[13][0] = -fDxInner.getValue(); 
  points[13][1] =  fDyInner.getValue(); 
  points[13][2] =  fDzInner.getValue();
  
  points[14][0] = -fDxInner.getValue(); 
  points[14][1] = -fDyInner.getValue(); 
  points[14][2] =  fDzInner.getValue();

  points[15][0] =  fDxInner.getValue(); 
  points[15][1] = -fDyInner.getValue(); 
  points[15][2] =  fDzInner.getValue();
  
  float t1 = atan((fDzInner.getValue()-fDzOuter.getValue())
                  /fDxInner.getValue()-fDxOuter.getValue()),
        t2 = atan((fDzInner.getValue()-fDzOuter.getValue())
                  /fDyInner.getValue()-fDyOuter.getValue()),
        st1 = sin(t1), st2=sin(t2), ct1=cos(t1), ct2 = cos(t2);

  normals[8][0] = 0   ; normals[8][1] =  ct2; normals [8][2] = st2;    
  normals[9][0] = -ct1; normals[9][1] =    0; normals [9][2] = st1;    
  normals[10][0] = 0   ; normals[10][1] = -ct2; normals [10][2] = st2;    
  normals[11][0] =  ct1; normals[11][1] =    0; normals [11][2] = st1;    
  normals[12][0] = 0   ; normals[12][1] =  ct2; normals [12][2] = -st2;    
  normals[13][0] = -ct1; normals[13][1] =    0; normals [13][2] = -st1;    
  normals[14][0] = 0   ; normals[14][1] = -ct2; normals [14][2] = -st2;    
  normals[15][0] =  ct1; normals[15][1] =    0; normals [15][2] = -st1;    

  theCoordinates->point.setValues(0,NPOINTS,points);
  theFaceSet->coordIndex.setValues(0,NINDICES,indices);
  theNormals->vector.setValues(0,NFACES,normals);
  theNormalBinding->value=SoNormalBinding::PER_FACE;
}

// generateChildren
void SoMcFBoxWithGap::generateChildren() {

  // This routines creates one SoSeparator, one SoCoordinate3, and
  // one SoLineSet, and puts it in the child list.  This is done only
  // once, whereas redrawing the position of the coordinates occurs each
  // time an update is necessary, in the updateChildren routine. 

  assert(children->getLength() ==0);
  SoSeparator      *sep              = new SoSeparator(); 
  SoCoordinate3    *theCoordinates   = new SoCoordinate3();
  SoNormal         *theNormals       = new SoNormal(); 
  SoNormalBinding  *theNormalBinding = new SoNormalBinding();
  SoIndexedFaceSet *theFaceSet       = new SoIndexedFaceSet();
  // 
  // This line costs some in render quality! but gives speed.
  // 
  sep->addChild(theCoordinates);
  sep->addChild(theNormals);
  sep->addChild(theNormalBinding);
  sep->addChild(theFaceSet);
  children->append(sep);
}

// generateAlternateRep
void SoMcFBoxWithGap::generateAlternateRep() {

  // This routine sets the alternate representation to the child
  // list of this mode.  

  if (children->getLength() == 0) generateChildren();
  updateChildren();
  alternateRep = (SoSeparator *)  ( *children)[0];
}

// clearAlternateRep
void SoMcFBoxWithGap::clearAlternateRep() {
  alternateRep = NULL;
}

/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoG4Cons                                                */
/* Description:      Represents the G4Cons Geant Geometry entity             */
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
#include "hepvis/SoG4Cons.hh"

// This statement is required
SO_NODE_SOURCE(SoG4Cons);

// Constructor
SoG4Cons::SoG4Cons() {
  // This statement is required
  SO_NODE_CONSTRUCTOR(SoG4Cons);

  // Data fields are initialized like this:
  SO_NODE_ADD_FIELD(fRmin1,               (0.0));
  SO_NODE_ADD_FIELD(fRmin2,               (0.0));
  SO_NODE_ADD_FIELD(fRmax1,               (1.0));
  SO_NODE_ADD_FIELD(fRmax2,               (1.0));
  SO_NODE_ADD_FIELD(fDz,                 (10.0));
  SO_NODE_ADD_FIELD(fSPhi,                (0.0));
  SO_NODE_ADD_FIELD(fDPhi,             (2*M_PI));
  SO_NODE_ADD_FIELD(smoothDraw,          (TRUE));
  SO_NODE_ADD_FIELD(alternateRep,        (NULL));
  children = new SoChildList(this);
}

// Destructor
SoG4Cons::~SoG4Cons() {
}


// initClass
void SoG4Cons::initClass(){
  // This statement is required.
  SO_NODE_INIT_CLASS(SoG4Cons,SoShape,"Shape");
}


// GLRrender
void SoG4Cons::GLRender(SoGLRenderAction *action) {
  if (!shouldGLRender(action)) return;
  if (children->getLength() == 0) generateChildren();
  updateChildren();
  children->traverse(action);  
}

// generatePrimitives
void SoG4Cons::generatePrimitives(SoAction *action) {
  if (children->getLength()==0) generateChildren();
  updateChildren();
  children->traverse(action);
}

// getChildren
SoChildList *SoG4Cons::getChildren() const {
  return children;
}


// computeBBox
void SoG4Cons::computeBBox(SoAction *, SbBox3f &box, SbVec3f &center ){
  float fRmax= fRmax1.getValue();  
  if (fRmax2.getValue() > fRmax) fRmax = fRmax2.getValue(); 

  SbVec3f min(-fRmax,-fRmax,-fDz.getValue()), 
          max( fRmax, fRmax, fDz.getValue());
  center.setValue(0,0,0);
  box.setBounds(min,max);
}




// updateChildren
void SoG4Cons::updateChildren() {


  // Redraw the G4Cons....

  assert(children->getLength()==1);
  SoSeparator       *sep                = (SoSeparator *)  ( *children)[0];
  SoCoordinate3     *theCoordinates     = (SoCoordinate3 *)      ( sep->getChild(0));
  SoNormal          *theNormals         = (SoNormal *)           ( sep->getChild(1)); 
  SoNormalBinding   *theNormalBinding   = (SoNormalBinding *)    ( sep->getChild(2));
  SoIndexedFaceSet  *theFaceSet         = (SoIndexedFaceSet *)   ( sep->getChild(3));

  const int NPHI=24, NPOINTS=2*(2*NPHI+2), NFACES=4*NPHI+2, NINDICES = NFACES*5;
  float points[NPOINTS][3],normals[NFACES][3];
#ifdef INVENTOR2_0
  static long     indices[NINDICES];
#else
  static int32_t  indices[NINDICES];
#endif
  static int init=0;
  double phi, pp, DeltaPhi;

  // Indices need to be generated once! This is here to keep it close to the point
  // generation, since otherwise it will be confusing.

  int i;
  if (!init) {
    init = 1;
    // Outer face
    for (i = 0; i< NPHI; i++) {
      // 0 1 3 2;
      indices[5*i+0] =  2*i+0;
      indices[5*i+1] =  2*i+1;
      indices[5*i+2] =  2*i+3;
      indices[5*i+3] =  2*i+2;
      indices[5*i+4] = SO_END_FACE_INDEX;
    }
    // the inner face
    for (i=0;i<NPHI;i++) {
      indices[5*1*NPHI + 5*i+0] = 2*NPHI+2 + 2*i+0;  
      indices[5*1*NPHI + 5*i+1] = 2*NPHI+2 + 2*i+1;
      indices[5*1*NPHI + 5*i+2] = 2*NPHI+2 + 2*i+3;
      indices[5*1*NPHI + 5*i+3] = 2*NPHI+2 + 2*i+2;
      indices[5*1*NPHI + 5*i+4] = SO_END_FACE_INDEX;
    }
    // the top side
    for (i=0;i<NPHI;i++) {
      indices[5*2*NPHI + 5*i+0] = 2*i+0;
      indices[5*2*NPHI + 5*i+1] = 2*i+2;
      indices[5*2*NPHI + 5*i+2] = NPOINTS - (2*i+4);
      indices[5*2*NPHI + 5*i+3] = NPOINTS - (2*i+2);
      indices[5*2*NPHI + 5*i+4] = SO_END_FACE_INDEX;
    }
    // the bottom side
    for (i=0;i<NPHI;i++) {
      indices[5*3*NPHI + 5*i+0] = 2*i+1;
      indices[5*3*NPHI + 5*i+1] = NPOINTS - (2*i+1);
      indices[5*3*NPHI + 5*i+2] = NPOINTS - (2*i+3);
      indices[5*3*NPHI + 5*i+3] = 2*i+3;
      indices[5*3*NPHI + 5*i+4] = SO_END_FACE_INDEX;
    }
    // the odd side
    indices[5*4*NPHI +0] = 2*NPHI;
    indices[5*4*NPHI +1] = 2*NPHI+1;
    indices[5*4*NPHI +2] = 2*NPHI+3;
    indices[5*4*NPHI +3] = 2*NPHI+2;
    indices[5*4*NPHI +4] = SO_END_FACE_INDEX;
    // aother odd side
    indices[5*4*NPHI +5 +0] = 0;
    indices[5*4*NPHI +5 +1] = NPOINTS-2;
    indices[5*4*NPHI +5 +2] = NPOINTS-1;
    indices[5*4*NPHI +5 +3] = 1;
    indices[5*4*NPHI +5 +4] = SO_END_FACE_INDEX;
  }
  // Points need to be generated each time:

  // The outer surface
  DeltaPhi = fDPhi.getValue()/NPHI, phi = fSPhi.getValue();
  float  t,st,ct;
  t = atan((fRmax2.getValue()-fRmax1.getValue())/(2*fDz.getValue())), st = sin(t), ct = cos(t);
  for (i = 0; i<=NPHI; i++) {
    points[2*i+0][0] = fRmax2.getValue()*cos(phi); 
    points[2*i+0][1] = fRmax2.getValue()*sin(phi); 
    points[2*i+0][2] = +fDz.getValue();
    points[2*i+1][0] = fRmax1.getValue()*cos(phi); 
    points[2*i+1][1] = fRmax1.getValue()*sin(phi); 
    points[2*i+1][2] = -fDz.getValue();
    pp = phi+DeltaPhi/2.0;
    if (i!=NPHI) {
      normals[i][0] = ct*cos(pp); normals[i][1] = ct*sin(pp); normals[i][2] = -st;
    }
    phi+=DeltaPhi;
  }
  // The inner surface
  phi = fSPhi.getValue() + fDPhi.getValue();
  t = atan((fRmin2.getValue()-fRmin1.getValue())/(2*fDz.getValue())), st = sin(t), ct = cos(t);
  for (i = 0; i<=NPHI; i++) {
    points[2*NPHI+2+2*i+0][0] = fRmin2.getValue()*cos(phi); 
    points[2*NPHI+2+2*i+0][1] = fRmin2.getValue()*sin(phi); 
    points[2*NPHI+2+2*i+0][2] = +fDz.getValue();
    points[2*NPHI+2+2*i+1][0] = fRmin1.getValue()*cos(phi); 
    points[2*NPHI+2+2*i+1][1] = fRmin1.getValue()*sin(phi); 
    points[2*NPHI+2+2*i+1][2] = -fDz.getValue();
    pp = phi-DeltaPhi/2.0;
    if (i!=NPHI) {
      normals[NPHI+i][0] = -ct*cos(pp); normals[NPHI+i][1] = -ct*sin(pp); normals[NPHI+i][2] = st;
    }
    phi-=DeltaPhi;
  }
  // The top side
  for (i=0;i<NPHI;i++) {
    normals[2*NPHI+i][0]=normals[2*NPHI+i][1]=0; normals[2*NPHI+i][2]=  1.0;
  } 
  // The bottom side
  for (i=0;i<NPHI;i++) {
    normals[3*NPHI+i][0]=normals[3*NPHI+i][1]=0; normals[3*NPHI+i][2]= -1.0;
  } 
  // The odd side
  phi = fSPhi.getValue(); 
    normals[4*NPHI+0][0]=sin(phi); normals[4*NPHI+0][1]= -cos(phi); normals[4*NPHI+0][2]=0;

  // Another odd side
  phi = fSPhi.getValue()+fDPhi.getValue(); 
    normals[4*NPHI+1][0]=-sin(phi); normals[4*NPHI+1][1]= +cos(phi); normals[4*NPHI+1][2]=0;

  theCoordinates->point.setValues(0,NPOINTS,points);
  theFaceSet->coordIndex.setValues(0,NINDICES,indices);
  if (smoothDraw.getValue()) {
    theNormals->vector.deleteValues(0);
    theNormalBinding->value=SoNormalBinding::DEFAULT;
  }
  else {
    theNormals->vector.setValues(0,NFACES,normals);
    theNormalBinding->value=SoNormalBinding::PER_FACE;
  }
}

// generateChildren
void SoG4Cons::generateChildren() {

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
void SoG4Cons::generateAlternateRep() {

  // This routine sets the alternate representation to the child
  // list of this mode.  

  if (children->getLength() == 0) generateChildren();
  updateChildren();
  alternateRep = (SoSeparator *)  ( *children)[0];
}

// clearAlternateRep
void SoG4Cons::clearAlternateRep() {
  alternateRep = NULL;
}


/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoMcFCons                                                */
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
#include <Inventor/nodes/SoIndexedFaceSet.h>
#include <Inventor/nodes/SoNormal.h>
#include <Inventor/nodes/SoCoordinate3.h>
#include <Inventor/nodes/SoNormalBinding.h>
#include "hepvis/SoMcFCons.hh"

// This statement is required
SO_NODE_SOURCE(SoMcFCons);

// Constructor
SoMcFCons::SoMcFCons() {
  // This statement is required
  SO_NODE_CONSTRUCTOR(SoMcFCons);

  // Data fields are initialized like this:
  SO_NODE_ADD_FIELD(fRmin1,               (0.0));
  SO_NODE_ADD_FIELD(fRmin2,               (0.0));
  SO_NODE_ADD_FIELD(fRmax1,               (1.0));
  SO_NODE_ADD_FIELD(fRmax2,               (1.0));
  SO_NODE_ADD_FIELD(fDz,                 (10.0));
  SO_NODE_ADD_FIELD(fSPhi,                (0.0));
  SO_NODE_ADD_FIELD(fDPhi,             (2*M_PI));
  SO_NODE_ADD_FIELD(nPhi,                  (24));
  SO_NODE_ADD_FIELD(smoothDraw,          (TRUE));
  SO_NODE_ADD_FIELD(alternateRep,        (NULL));
  children = new SoChildList(this);
}

// Destructor
SoMcFCons::~SoMcFCons() {
}


// initClass
void SoMcFCons::initClass(){
  // This statement is required.
  SO_NODE_INIT_CLASS(SoMcFCons,SoShape,"Shape");
}


// GLRrender
void SoMcFCons::GLRender(SoGLRenderAction *action) {
  if (!shouldGLRender(action)) return;
  if (children->getLength() == 0) generateChildren();
  updateChildren();
  children->traverse(action);  
}

// generatePrimitives
void SoMcFCons::generatePrimitives(SoAction *action) {
  if (children->getLength()==0) generateChildren();
  updateChildren();
  children->traverse(action);
}

// getChildren
SoChildList *SoMcFCons::getChildren() const {
  return children;
}


// computeBBox
void SoMcFCons::computeBBox(SoAction *, SbBox3f &box, SbVec3f &center ){
  float fRmax= fRmax1.getValue();  
  if (fRmax2.getValue() > fRmax) fRmax = fRmax2.getValue(); 

  SbVec3f min(-fRmax,-fRmax,-fDz.getValue()), 
          max( fRmax, fRmax, fDz.getValue());
  center.setValue(0,0,0);
  box.setBounds(min,max);
}




// updateChildren
void SoMcFCons::updateChildren() {


  // Redraw the McFCons....

  assert(children->getLength()==1);
  SoSeparator       *sep                = (SoSeparator *)  ( *children)[0];
  SoCoordinate3     *theCoordinates     = (SoCoordinate3 *)      ( sep->getChild(0));
  SoNormal          *theNormals         = (SoNormal *)           ( sep->getChild(1)); 
  SoNormalBinding   *theNormalBinding   = (SoNormalBinding *)    ( sep->getChild(2));
  SoIndexedFaceSet  *theFaceSet         = (SoIndexedFaceSet *)   ( sep->getChild(3));

  int NPHI = (int) nPhi.getValue();
  int NPOINTS=2*(2*NPHI+2), NFACES=4*NPHI+2, NINDICES = NFACES*5;
  //float *points[3];
  //*points = new float[NPOINTS];
  SbVec3f *points = new SbVec3f[NPOINTS];
  //float *normals[3];
  //*normals = new float[NFACES];
  SbVec3f *normals = new SbVec3f[NFACES];
#ifdef INVENTOR2_0
  long     *indices  = new long[NINDICES];
#else
  int32_t  *indices = new int32_t [NINDICES];
#endif
   double phi, pp, DeltaPhi;

  int i;

  // Points and indices need to be generated each time:

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

  // The outer surface
  DeltaPhi = fDPhi.getValue()/NPHI, phi = fSPhi.getValue();
  float  t,st,ct;
  t = atan((fRmax2.getValue()-fRmax1.getValue())/(2*fDz.getValue())), st = sin(t), ct = cos(t);
  for (i = 0; i<=NPHI; i++) {
    points[2*i+0].setValue(fRmax2.getValue()*cos(phi),
                                  fRmax2.getValue()*sin(phi),
                                  +fDz.getValue());
    points[2*i+1].setValue(fRmax1.getValue()*cos(phi),
                                  fRmax1.getValue()*sin(phi),
                                  -fDz.getValue());

    pp = phi+DeltaPhi/2.0;
    if (i!=NPHI) {
      normals[i].setValue(ct*cos(pp), ct*sin(pp), -st);
    }
    phi+=DeltaPhi;
  }
  // The inner surface
  phi = fSPhi.getValue() + fDPhi.getValue();
  t = atan((fRmin2.getValue()-fRmin1.getValue())/(2*fDz.getValue())), st = sin(t), ct = cos(t);
  for (i = 0; i<=NPHI; i++) {
    points[2*NPHI+2+2*i+0].setValue(fRmin2.getValue()*cos(phi), 
                                    fRmin2.getValue()*sin(phi), 
                                    +fDz.getValue()); 
    points[2*NPHI+2+2*i+1].setValue(fRmin1.getValue()*cos(phi), 
                                    fRmin1.getValue()*sin(phi), 
                                    -fDz.getValue()); 
    pp = phi-DeltaPhi/2.0;
    if (i!=NPHI) {
      normals[NPHI+i].setValue( -ct*cos(pp), -ct*sin(pp), st);
    }
    phi-=DeltaPhi;
  }
  // The top side
  for (i=0;i<NPHI;i++) {
    normals[2*NPHI+i].setValue(0.0,0.0,1.0); 
  } 
  // The bottom side
  for (i=0;i<NPHI;i++) {
    normals[3*NPHI+i].setValue(0.0,0.0,-1.0); 
  } 
  // The odd side
  phi = fSPhi.getValue(); 
    normals[4*NPHI+0].setValue(sin(phi), -cos(phi), 0);

  // Another odd side
  phi = fSPhi.getValue()+fDPhi.getValue(); 
    normals[4*NPHI+1].setValue(-sin(phi),  +cos(phi), 0);

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
  delete [] indices;
}

// generateChildren
void SoMcFCons::generateChildren() {

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
void SoMcFCons::generateAlternateRep() {

  // This routine sets the alternate representation to the child
  // list of this mode.  

  if (children->getLength() == 0) generateChildren();
  updateChildren();
  alternateRep = (SoSeparator *)  ( *children)[0];
}

// clearAlternateRep
void SoMcFCons::clearAlternateRep() {
  alternateRep = NULL;
}


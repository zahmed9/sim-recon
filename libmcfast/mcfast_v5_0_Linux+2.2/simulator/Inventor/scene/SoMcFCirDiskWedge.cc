/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoMcFCirDiskWedge                                       */
/* Description:      Represents the circular wedge of a disk                 */
/* Author:           Amber Boehnlein May 13, 1997                            */
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
#include <Inventor/nodes/SoShapeHints.h>
#include "hepvis/SoMcFCirDiskWedge.hh"

// This statement is required
SO_NODE_SOURCE(SoMcFCirDiskWedge);

// Constructor
SoMcFCirDiskWedge::SoMcFCirDiskWedge() {
  // This statement is required
  SO_NODE_CONSTRUCTOR(SoMcFCirDiskWedge);

  // Data fields are initialized like this:
  SO_NODE_ADD_FIELD(fRmin,               (1.0));
  SO_NODE_ADD_FIELD(fRmax,               (10.0));
  SO_NODE_ADD_FIELD(fDz,                 (10.0));
  SO_NODE_ADD_FIELD(fSPhi,                (0.0));
  SO_NODE_ADD_FIELD(fDPhi,             (M_PI/4.));
  SO_NODE_ADD_FIELD(smoothDraw,          (TRUE));
  SO_NODE_ADD_FIELD(alternateRep,        (NULL));
  children = new SoChildList(this);
}

// Destructor
SoMcFCirDiskWedge::~SoMcFCirDiskWedge() {
}


// initClass
void SoMcFCirDiskWedge::initClass(){
  // This statement is required.
  SO_NODE_INIT_CLASS(SoMcFCirDiskWedge,SoShape,"Shape");
}


// GLRrender
void SoMcFCirDiskWedge::GLRender(SoGLRenderAction *action) {
  if (!shouldGLRender(action)) return;
  if (children->getLength() == 0) generateChildren();
  updateChildren();
  children->traverse(action);  
}

// generatePrimitives
void SoMcFCirDiskWedge::generatePrimitives(SoAction *action) {
  if (children->getLength()==0) generateChildren();
  updateChildren();
  children->traverse(action);
}

// getChildren
SoChildList *SoMcFCirDiskWedge::getChildren() const {
  return children;
}


// computeBBox
void SoMcFCirDiskWedge::computeBBox(SoAction *, SbBox3f &box, SbVec3f &center ){

  SbVec3f min(-fRmax.getValue(),-fRmax.getValue(),-fDz.getValue()), 
          max( fRmax.getValue(), fRmax.getValue(), fDz.getValue());
  center.setValue(0,0,0);
  box.setBounds(min,max);
}




// updateChildren
void SoMcFCirDiskWedge::updateChildren() {


  // Redraw the McFCirDiskWedge....

  assert(children->getLength()==1);
  SoSeparator       *sep                = (SoSeparator *)  ( *children)[0];
  SoCoordinate3     *theCoordinates     = (SoCoordinate3 *)      ( sep->getChild(0));
  SoNormal          *theNormals         = (SoNormal *)           ( sep->getChild(1)); 
  SoNormalBinding   *theNormalBinding   = (SoNormalBinding *)    ( sep->getChild(2));
  SoShapeHints      *theShapeHints      = (SoShapeHints *)
  (sep->getChild(3));
  SoIndexedFaceSet  *theFaceSet         = (SoIndexedFaceSet *)   (
  sep->getChild(4));

  const int NPHI=6, NPOINTS= NPHI * 2 * 2, NFACES = 14;
  const int NINDICES = 13*2  //front&back face                
                     + 5*5*2 //top&bottom faces
                     + 5 * 2; //side faces
  
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
    int offset = 0;
     //top and bottom faces
     for (i = 0; i < 5; i++){
       indices[offset + i * 5 + 0] = 1 + i;
       indices[offset + i * 5 + 1] = 7 + i;
       indices[offset + i * 5 + 2] = 6 + i;
       indices[offset + i * 5 + 3] = 0 + i;
       indices[offset + i * 5 + 4] = SO_END_FACE_INDEX;

       indices[offset + 25 + i * 5 + 0] = 12 + i;
       indices[offset + 25 + i * 5 + 1] = 18 + i;
       indices[offset + 25 + i * 5 + 2] = 19 + i;
       indices[offset + 25 + i * 5 + 3] = 13 + i;
       indices[offset + 25 + i * 5 + 4] = SO_END_FACE_INDEX;
    }
    //front and back face
    offset = 50;
    indices[offset + 0] = 12;
    indices[offset + 1] = 13;
    indices[offset + 2] = 14;
    indices[offset + 3] = 15;
    indices[offset + 4] = 16;
    indices[offset + 5] = 17;
    indices[offset + 6] = 5;
    indices[offset + 7] = 4;
    indices[offset + 8] = 3;
    indices[offset + 9] = 2;
    indices[offset + 10] = 1;
    indices[offset + 11] = 0;
    indices[offset + 12] = SO_END_FACE_INDEX;
    indices[offset + 0  + 13] = 6;
    indices[offset + 1  + 13] = 7;
    indices[offset + 2  + 13] = 8;
    indices[offset + 3  + 13] = 9;
    indices[offset + 4  + 13] = 10;
    indices[offset + 5  + 13] = 11;
    indices[offset + 6  + 13] = 23;
    indices[offset + 7  + 13] = 22;
    indices[offset + 8  + 13] = 21;
    indices[offset + 9  + 13] = 20;
    indices[offset + 10 + 13] = 19;
    indices[offset + 11 + 13] = 18;
    indices[offset + 12 + 13] = SO_END_FACE_INDEX;
    //side faces
    offset = 76;
    indices[offset + 0 * 5 + 0] =  6;
    indices[offset + 0 * 5 + 1] = 18;
    indices[offset + 0 * 5 + 2] = 12;
    indices[offset + 0 * 5 + 3] =  0;
    indices[offset + 0 * 5 + 4] = SO_END_FACE_INDEX;

    indices[offset + 1 * 5 + 0] =  5;
    indices[offset + 1 * 5 + 1] = 17;
    indices[offset + 1 * 5 + 2] = 23;
    indices[offset + 1 * 5 + 3] = 11;
    indices[offset + 1 * 5 + 4] = SO_END_FACE_INDEX;


     
  }
  // Points need to be generated each time:

  // The inner surface

  phi = fSPhi.getValue();
  DeltaPhi = fDPhi.getValue()/(NPHI-1);
  for (i = 0; i<NPHI; i++) {
    points[i + 0*NPHI][0] = fRmin.getValue()*cos(phi); 
    points[i + 0*NPHI][1] = fRmin.getValue()*sin(phi); 
    points[i + 0*NPHI][2] = +fDz.getValue();
    points[i + 1*NPHI][0] = fRmin.getValue()*cos(phi); 
    points[i + 1*NPHI][1] = fRmin.getValue()*sin(phi); 
    points[i + 1*NPHI][2] = -fDz.getValue();
    pp = phi+DeltaPhi/2.0;
    if (i!=(NPHI-1)) {
      normals[i][0] = -cos(pp); normals[i][1] = -sin(pp); normals[i][2] = 0.0;
    }
    phi+=DeltaPhi;
  }
  // The outer surface
  phi = fSPhi.getValue();
  for (i = 0; i<NPHI; i++) {
    points[i + 2*NPHI][0] = fRmax.getValue()*cos(phi); 
    points[i + 2*NPHI][1] = fRmax.getValue()*sin(phi); 
    points[i + 2*NPHI][2] = +fDz.getValue();
    points[i + 3*NPHI][0] = fRmax.getValue()*cos(phi); 
    points[i + 3*NPHI][1] = fRmax.getValue()*sin(phi); 
    points[i + 3*NPHI][2] = -fDz.getValue();
    pp = phi+DeltaPhi/2.0;
    if (i!=(NPHI-1)) {
      normals[NPHI+i-1][0] = cos(pp); normals[NPHI+i-1][1] = sin(pp);
      normals[NPHI+i-1][2] =0.0;
    }
    phi+=DeltaPhi;
  }
  // The odd sides
    normals[10][0]=normals[10][1]=0; normals[10][2]=  1.0;
    normals[11][0]=normals[11][1]=0; normals[11][2]= -1.0;
  phi = fSPhi.getValue(); 
    normals[12][0]=sin(phi); normals[12][1]= -cos(phi); normals[12][2]=0;
  phi = fSPhi.getValue()+fDPhi.getValue(); 
    normals[13][0]=-sin(phi); normals[13][1]= +cos(phi); normals[13][2]=0;

  theShapeHints->shapeType = SoShapeHints::SOLID;
  theShapeHints->vertexOrdering = SoShapeHints::COUNTERCLOCKWISE;
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
void SoMcFCirDiskWedge::generateChildren() {

  // This routines creates one SoSeparator, one SoCoordinate3, and
  // one SoLineSet, and puts it in the child list.  This is done only
  // once, whereas redrawing the position of the coordinates occurs each
  // time an update is necessary, in the updateChildren routine. 

  assert(children->getLength() ==0);
  SoSeparator      *sep              = new SoSeparator(); 
  SoCoordinate3    *theCoordinates   = new SoCoordinate3();
  SoNormal         *theNormals       = new SoNormal(); 
  SoNormalBinding  *theNormalBinding = new SoNormalBinding();
  SoShapeHints     *theShapeHints    = new SoShapeHints();
  SoIndexedFaceSet *theFaceSet       = new SoIndexedFaceSet();
  // 
  // This line costs some in render quality! but gives speed.
  //
   
  sep->addChild(theCoordinates);
  sep->addChild(theNormals);
  sep->addChild(theNormalBinding);
  sep->addChild(theShapeHints);
  sep->addChild(theFaceSet);
  children->append(sep);
}

// generateAlternateRep
void SoMcFCirDiskWedge::generateAlternateRep() {

  // This routine sets the alternate representation to the child
  // list of this mode.  

  if (children->getLength() == 0) generateChildren();
  updateChildren();
  alternateRep = (SoSeparator *)  ( *children)[0];
}

// clearAlternateRep
void SoMcFCirDiskWedge::clearAlternateRep() {
  alternateRep = NULL;
}


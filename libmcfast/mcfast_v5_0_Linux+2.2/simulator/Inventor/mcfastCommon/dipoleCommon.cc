#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoCylinder.h>
#include <Inventor/nodes/SoCone.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodes/SoTransform.h>
#include <math.h>
#ifndef MCFAST_DB
#define MCFAST_DB
#include "mcfast_db.h"
#endif
#include "McFDetectorTreeList.hh"
#include "McFDetDevice.hh"
#include "hepvis/SoMcFDetectorTreeKit.hh"
#include "hepvis/SoMcFBoxWithGap.hh"
#include <iostream.h>
#include "dipoleCommon.hh"
int NumDipole(void)
{
    return *n_obj_dipole;
}
void getDipoleData(int which, frameDetectorData &data1, 
                              magneticFieldData &data2)
{
       //first off check thickness.  I assume that the magnet is
       //symetric but Mcfast allows for other possiblities
      if( dipole[which-1].thick_boun[0] != dipole[which-1].thick_boun[1] ||
          dipole[which-1].thick_boun[2] != dipole[which-1].thick_boun[3] ||
          dipole[which-1].thick_boun[4] != dipole[which-1].thick_boun[5] )
          cout << " This display assumes a symmetric amount of material \n"
                << " material shown will be the average \n";
                
      data1.z0 = dipole[which-1].z0;

      data1.xLenInner = (dipole[which-1].xmax - dipole[which-1].xmin)/2.;
      data1.yLenInner = (dipole[which-1].ymax - dipole[which-1].ymin)/2.;
      data1.zLenInner = (dipole[which-1].zlen)/2.;
      
      data1.xLenOuter = data1.xLenInner + (dipole[which-1].thick_boun[0] 
                      + dipole[which-1].thick_boun[1])/2.;
      data1.yLenOuter = data1.yLenInner + (dipole[which-1].thick_boun[2] 
                      + dipole[which-1].thick_boun[3])/2.;
      data1.zLenOuter = data1.zLenInner + (dipole[which-1].thick_boun[4] 
                      + dipole[which-1].thick_boun[5])/2.;

      data2.dircos[0] = dipole[which-1].dircos[0];
      data2.dircos[1] = dipole[which-1].dircos[1];
      data2.dircos[2] = dipole[which-1].dircos[2];
      data2.bfield    = dipole[which-1].bfield;

      return;
}
void getDipoleName(int which, char *name)
{
    strcpy(name, dipole[which-1].name);
    return;      
}
SoSeparator *Dipole(void)
{
    SoSeparator *dip = new SoSeparator;
    dip->ref();
//make the head of the dipole detectors
    if( NumDipole() > 0)
    {
      McFDetectorTreeList *dipole = new McFDetectorTreeList;
      dipole->AddToTopOfTree();  //This is a high level "volume"
      dipole->detector.deviceId = DIPOLE;
      dipole->detector.whichOne = 0;
      strcpy(dipole->detector.name, "DipoleHead");

      for(int i = 0; i < NumDipole(); i++)
      {
          dip->addChild(AddDipoleToDetectorTree((i+1), dipole));
      }
    }
    dip->unrefNoDelete();
    return dip;
 
}
SoMcFDetectorTreeKit *AddDipoleToDetectorTree(int which, 
                                              McFDetectorTreeList *mother )
{
    frameDetectorData data1;
    magneticFieldData data2;
    
    getDipoleData(which, data1, data2); //get the information from the 
                                        //fortran common
    McFDetectorTreeList *dip = new McFDetectorTreeList;
    dip->AddLeaf(mother);  //This is a "daughter"
    dip->detector.deviceId = DIPOLE;
    dip->detector.whichOne = which;
    getDipoleName(which, dip->detector.name);
        
    SoMcFDetectorTreeKit *dipKit = dip->getDetectorKit();
    dipKit->device = DIPOLE;
    dipKit->whichDevice = which;
    SoSeparator *preview = 
                   (SoSeparator *) dipKit->getPart("previewSeparator",TRUE); 
    SoSeparator *full = 
                   (SoSeparator *) dipKit->getPart("fullSeparator",TRUE); 

    SoTransform *transform = (SoTransform *)
                                dipKit->getPart("transform",TRUE);
    transform->translation.setValue(0,0,data1.z0);
 
//  the conventional representation of a Dipole is as a box with a hole
//  in it representing the gap + an arrow representing the direction and
//  magnitude of the magnetic field.  In this implementation, the color of
//  the arrow cannot be changed.

    SoMaterial *arrowMat = new SoMaterial;
    arrowMat->diffuseColor.setValue(1.0, 0.5, 0.5);
    
    float arrowLen = 0.5 * sqrt(
           data1.xLenInner*data2.dircos[0]*data1.xLenInner*data2.dircos[0] +
           data1.yLenInner*data2.dircos[1]*data1.yLenInner*data2.dircos[1] +
           data1.zLenInner*data2.dircos[2]*data1.zLenInner*data2.dircos[2]);
           
    SoCylinder *cylinder = new SoCylinder;
    cylinder->radius = data2.bfield;
    cylinder->height = arrowLen;
          
    SoCone *cone = new SoCone;
    cone->height = data2.bfield * 10.0;
    cone->bottomRadius = data2.bfield * 10.0;
    
    SoTransform *cylTransform = new SoTransform;
    //cones and cylinders point along y-axis
    //yet another kludge on this rotation, should really rotate
    //to z and then rotate.
    cylTransform->rotation.setValue(SbVec3f(0.,0,1.), 
                 data2.dircos[0]*M_PI/2.);

    SoTransform *coneTransform = new SoTransform;
    coneTransform->rotation.setValue(SbVec3f(0.,0,1.), 
                 data2.dircos[0]*M_PI/2.);
    coneTransform->translation.setValue(
           -data2.dircos[0]*arrowLen/2.,-data2.dircos[1]*arrowLen/2.,0.);
 
    SoSeparator *cylSep = new SoSeparator;
    preview->addChild(cylSep);
    full->addChild(cylSep);
    cylSep->addChild(arrowMat);
    cylSep->addChild(cylTransform);
    cylSep->addChild(cylinder); 

    SoSeparator *coneSep = new SoSeparator;
    preview->addChild(coneSep);
    full->addChild(coneSep);
    coneSep->addChild(arrowMat);
    coneSep->addChild(coneTransform);
    coneSep->addChild(cone); 


//make the magnet.  The color of the magnet comes from the detectortreekit
//so it is editable.
    SoMaterial *magMaterial = (SoMaterial *)
                               dipKit->getPart("appearance.material", TRUE);
    magMaterial->diffuseColor.setValue(0.5,0.0,1.0);
    
    SoMcFBoxWithGap *Block = new SoMcFBoxWithGap;
    Block->fDxOuter.setValue(data1.xLenOuter); 
    Block->fDyOuter.setValue(data1.yLenOuter); 
    Block->fDzOuter.setValue(data1.zLenOuter); 
    Block->fDxInner.setValue(data1.xLenInner); 
    Block->fDyInner.setValue(data1.yLenInner); 
    Block->fDzInner.setValue(data1.zLenInner); 
    Block->generateAlternateRep();

//  the convention is to draw the dipole as a wireframe.  Make that
//  the preview representation with the dipole as solid for the full
//  representation. 

    SoDrawStyle *style = new SoDrawStyle; 
    style->style = SoDrawStyle::LINES;
    style->lineWidth.setValue(2.0); //make the line a little thicker thicker
    SoSeparator *magSep = new SoSeparator;
    preview->addChild(magSep);
    
    magSep->addChild(style);
    magSep->addChild(Block);

    full->addChild(Block);// just stick block in directly with no separation

    dipKit->setPreview(TRUE);
    dipKit->generateAlternateRep();

    return dipKit;
    
}

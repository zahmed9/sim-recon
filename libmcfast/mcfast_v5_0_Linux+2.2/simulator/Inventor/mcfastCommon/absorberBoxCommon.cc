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
#include "absorberBoxCommon.hh"
int NumAbsorberBox(void)
{
    return *n_obj_absorberbox;
}
void getAbsorberBoxData(int which, frameDetectorData &data) 
{
      data.z0 = absorberbox[which-1].z0;

      data.xLenInner = (absorberbox[which-1].xlimit_gap[1] 
                        - absorberbox[which-1].xlimit_gap[0])/2.;
      data.yLenInner = (absorberbox[which-1].ylimit_gap[1] 
                        - absorberbox[which-1].ylimit_gap[0])/2.;
      data.xLenOuter = (absorberbox[which-1].xlimit[1] 
                        - absorberbox[which-1].xlimit[0])/2.;
      data.yLenOuter = (absorberbox[which-1].ylimit[1] 
                        - absorberbox[which-1].ylimit[0])/2.;

      data.zLenInner = (absorberbox[which-1].zlen)/2.;
      data.zLenOuter = (absorberbox[which-1].zlen)/2.;
      

      return;
}
void getAbsorberBoxName(int which, char *name)
{
    strcpy(name, absorberbox[which-1].name);
    return;      
}
SoSeparator *AbsorberBox(void)
{
    SoSeparator *Box = new SoSeparator;
    Box->ref();
//make the head of the absorber detectors
    if(NumAbsorberBox() > 0)
      {
      McFDetectorTreeList *AbsBox = new McFDetectorTreeList;
      AbsBox->AddToTopOfTree();  //This is a high level "volume"
      AbsBox->detector.deviceId = ABSORBERXY;
      AbsBox->detector.whichOne = 0;
      strcpy(AbsBox->detector.name, "AbsBoxHead");

      for(int i = 0; i < NumAbsorberBox(); i++)
      {
          Box->addChild(AddAbsorberBoxToDetectorTree((i+1), AbsBox));
      }
    }
    Box->unrefNoDelete();
    return Box;
 
}
SoMcFDetectorTreeKit *AddAbsorberBoxToDetectorTree(int which, 
                                              McFDetectorTreeList *mother )
{
    frameDetectorData data1;
    
    getAbsorberBoxData(which, data1); //get the information from the 
                                        //fortran common
    McFDetectorTreeList *abs = new McFDetectorTreeList;
    abs->AddLeaf(mother);  //This is a "daughter"
    abs->detector.deviceId = ABSORBERXY;
    abs->detector.whichOne = which;
    getAbsorberBoxName(which, abs->detector.name);
        
    SoMcFDetectorTreeKit *absKit = abs->getDetectorKit();
    absKit->device = ABSORBERXY;
    absKit->whichDevice = which;
    SoSeparator *preview = 
                   (SoSeparator *) absKit->getPart("previewSeparator",TRUE); 
    SoSeparator *full = 
                   (SoSeparator *) absKit->getPart("fullSeparator",TRUE); 

    SoTransform *transform = (SoTransform *)
                                absKit->getPart("transform",TRUE);
    transform->translation.setValue(0,0,data1.z0);
 


//make the box.  
    SoMaterial *Material = (SoMaterial *)
                               absKit->getPart("appearance.material", TRUE);
    Material->diffuseColor.setValue(0.0,0.5,1.0);
    
    SoMcFBoxWithGap *Block = new SoMcFBoxWithGap;
    Block->fDxOuter.setValue(data1.xLenOuter); 
    Block->fDyOuter.setValue(data1.yLenOuter); 
    Block->fDzOuter.setValue(data1.zLenOuter); 
    Block->fDxInner.setValue(data1.xLenInner); 
    Block->fDyInner.setValue(data1.yLenInner); 
    Block->fDzInner.setValue(data1.zLenInner); 
    Block->generateAlternateRep();

    SoDrawStyle *style = new SoDrawStyle; 
    style->style = SoDrawStyle::FILLED;
    style->lineWidth.setValue(2.0); //make the line a little thicker thicker
    SoSeparator *absSep = new SoSeparator;
    preview->addChild(absSep);
    
    absSep->addChild(style);
    absSep->addChild(Block);

    full->addChild(Block);
    absKit->setPreview(TRUE);
    absKit->generateAlternateRep();

    return absKit;
    
}

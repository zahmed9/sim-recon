#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodes/SoRotationXYZ.h>
#include <Inventor/nodes/SoTranslation.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/nodekits/SoNodeKitListPart.h>
#include <Inventor/nodekits/SoShapeKit.h>
#include "absorberCommon.hh"
#include "ConicalDetectorData.hh"
#ifndef MCFAST
#define MCFAST
#include "mcfast_db.h"
#endif
#include "hepvis/SoG4Cons.hh"
#include "hepvis/SoMcFConsKit.hh"
#include "hepvis/SoMcFDetectorTreeKit.hh"
#include "McFDetectorTreeList.hh"
#include "McFDetDevice.hh"
//absorbers are such a simple case that they don't rate a class
//at this time
void getAbsorberDetectorData(int which, ConicalDetectorData &data)
{
      data.z0            = absorber[which-1].z0; 
      data.zlen          = absorber[which-1].zlen;
      data.rminZlow      = absorber[which-1].rmin[0];
      data.rminZhigh     = absorber[which-1].rmin[1];
      data.rmaxZlow      = absorber[which-1].rmax[0];
      data.rmaxZhigh     = absorber[which-1].rmax[1];
      return;
}
void getAbsorberDetectorName(int which, char *name)
{
    strcpy(name, absorber[which-1].name);
    return;      
}
int NumAbsorber(void)
{
   return *n_obj_absorber;
}
SoSeparator *Absorber(void)
{
      SoSeparator *absorber = new SoSeparator;
      absorber->ref();
      if(NumAbsorber() > 0) 
      {
	McFDetectorTreeList *absHead = new McFDetectorTreeList;
	absHead->AddToTopOfTree();  //This is a high level "volume"
	absHead->detector.deviceId = ABSORBER;
	absHead->detector.whichOne = 0;
	strcpy(absHead->detector.name, "AbsorberHead");

	for( int i = 0; i < NumAbsorber(); i++)
	{
            absorber->addChild(AddAbsorberToDetectorTree(i+1, absHead));
	}
      }
      absorber->unrefNoDelete();
      return absorber;
};
SoMcFDetectorTreeKit *AddAbsorberToDetectorTree(int which, McFDetectorTreeList
                                                 *mother)
{
    ConicalDetectorData data;
    getAbsorberDetectorData(which, data);
    McFDetectorTreeList *absorber = new McFDetectorTreeList;
    absorber->AddLeaf(mother);
    absorber->detector.deviceId = ABSORBER;
    absorber->detector.whichOne = which;
    getAbsorberDetectorName(which, absorber->detector.name);
    
    SoMcFDetectorTreeKit *absorberKit =absorber->getDetectorKit();
    absorberKit->device = ABSORBER;
    absorberKit->whichDevice = which;
    
//transform the device to its location in Z
    SoTransform *Transform = (SoTransform *) 
                              absorberKit->getPart("transform", TRUE);
    Transform->translation.setValue(0,0,data.z0);


//give it a default color
    SoMaterial *Plastic = 
            (SoMaterial *) absorberKit->getPart("appearance.material", TRUE);
                 
    Plastic ->diffuseColor.setValue(0.24,0.95,1.0);



//define a conical section for the detector
    SoMcFConsKit *consKit = new SoMcFConsKit();
       
    SoG4Cons *cons = (SoG4Cons *) consKit->getPart("cons", TRUE);
    cons->fRmin1 = data.rminZlow;
    cons->fRmin2 = data.rminZhigh;
    cons->fRmax1 = data.rmaxZlow;
    cons->fRmax2 = data.rmaxZhigh;
    cons->fDz = data.zlen/2.;
    cons->generateAlternateRep();
//Since absorber detectors have no children (at this time) the full and preview
//representations are the same.

    SoSeparator *full = (SoSeparator *) 
                        absorberKit->getPart("fullSeparator",TRUE);
    SoSeparator *preview = (SoSeparator *) 
                        absorberKit->getPart("previewSeparator",TRUE);
    full->addChild(consKit);
    preview->addChild(consKit);
    consKit->generateAlternateRep();
    absorberKit->generateAlternateRep(); 
      
    return absorberKit;
};

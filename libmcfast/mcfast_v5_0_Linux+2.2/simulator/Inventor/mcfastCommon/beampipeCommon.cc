#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodes/SoRotationXYZ.h>
#include <Inventor/nodes/SoTranslation.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/nodekits/SoNodeKitListPart.h>
#include <Inventor/nodekits/SoShapeKit.h>
#include "beampipeCommon.hh"
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
//beampipes are such a simple case that they don't rate a class

void getBeampipeDetectorData(int which, ConicalDetectorData &data)
{
      data.z0            = bpipe[which-1].z0; 
      data.zlen          = bpipe[which-1].zlen;
      data.rminZlow      = bpipe[which-1].rmin;
      data.rminZhigh     = bpipe[which-1].rmin;
      data.rmaxZlow      = bpipe[which-1].rmax;
      data.rmaxZhigh     = bpipe[which-1].rmax;
      return;
}
void getBeampipeDetectorName(int which, char *name)
{
    strcpy(name, bpipe[which-1].name);
    return;      
}
int getNumBeampipe(void)
{
    return *n_obj_bpipe;
}
SoSeparator *Beampipe(void)
{
      SoSeparator *beampipe = new SoSeparator;
      beampipe->ref();
      if( getNumBeampipe() > 0)
      {
	McFDetectorTreeList *beampipeHead = new McFDetectorTreeList;
	beampipeHead->AddToTopOfTree();  //This is a high level "volume"
	beampipeHead->detector.deviceId = BEAMPIPE;
	beampipeHead->detector.whichOne = 0;
	strcpy(beampipeHead->detector.name, "beampipeHead");
	for( int i = 0; i < getNumBeampipe(); i++)
	{
            beampipe->addChild(AddBeampipeToDetectorTree(i+1, beampipeHead));
	}
      }
      beampipe->unrefNoDelete();
      return beampipe;
};
SoMcFDetectorTreeKit *AddBeampipeToDetectorTree(int which,  
                                            McFDetectorTreeList *mother)
{
    ConicalDetectorData data;
    getBeampipeDetectorData(which, data);
    McFDetectorTreeList *beampipe = new McFDetectorTreeList;
    beampipe->AddLeaf(mother);
    beampipe->detector.deviceId = BEAMPIPE;
    beampipe->detector.whichOne = which;
    getBeampipeDetectorName(which, beampipe->detector.name);
    
    SoMcFDetectorTreeKit *beampipeKit = beampipe->getDetectorKit();
    beampipeKit->device = BEAMPIPE;
    beampipeKit->whichDevice = which;
    
//transform the device to its location in Z
    SoTransform *Transform = (SoTransform *) 
                              beampipeKit->getPart("transform", TRUE);
    Transform->translation.setValue(0,0,data.z0);


//give it a default color
    SoMaterial *Plastic = 
                 (SoMaterial *) beampipeKit->getPart("appearance.material", TRUE);
                 
    Plastic ->diffuseColor.setValue(1.00, 0.93, 0.53);



//define a conical section for the detector
    SoMcFConsKit *consKit = new SoMcFConsKit();
       
    SoG4Cons *cons = (SoG4Cons *) consKit->getPart("cons", TRUE);
    cons->fRmin1 = data.rminZlow;
    cons->fRmin2 = data.rminZhigh;
    cons->fRmax1 = data.rmaxZlow;
    cons->fRmax2 = data.rmaxZhigh;
    cons->fDz = data.zlen/2.;
    cons->generateAlternateRep();
 
//Since beampipe detectors have no children the full and preview
//representations are the same.

    SoSeparator *full = (SoSeparator *) 
                        beampipeKit->getPart("fullSeparator",TRUE);
    SoSeparator *preview = (SoSeparator *) 
                        beampipeKit->getPart("previewSeparator",TRUE);
    full->addChild(consKit);
    preview->addChild(consKit);
    consKit->generateAlternateRep();
    
    beampipeKit->generateAlternateRep();
    
    return beampipeKit;
};

#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodes/SoRotationXYZ.h>
#include <Inventor/nodes/SoTranslation.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/nodekits/SoNodeKitListPart.h>
#include <Inventor/nodekits/SoShapeKit.h>
#include "solenoidCommon.hh"
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
//solenoid detectors are such a simple case that they don't rate a class
void getSolenoidDetectorData(int which, ConicalDetectorData &data)
{
      data.z0            = solenoid[which-1].z0; 
      data.zlen          = solenoid[which-1].zlen;
      data.rminZlow      = solenoid[which-1].rmin;
      data.rminZhigh     = solenoid[which-1].rmin;
      data.rmaxZlow      = solenoid[which-1].rmax;
      data.rmaxZhigh     = solenoid[which-1].rmax;
      return;
}
void getSolenoidDetectorName(int which, char *name)
{
    strcpy(name, solenoid[which-1].name);
    return;      
}
int NumSolenoid(void)
{
   return *n_obj_solenoid;
}
SoSeparator *Solenoid(void)
{
      SoSeparator *solenoid = new SoSeparator;
      solenoid->ref();
      if(NumSolenoid() > 0) 
      {
	McFDetectorTreeList *solenoidHead = new McFDetectorTreeList;
	solenoidHead->AddToTopOfTree();  //This is a high level "volume"
	solenoidHead->detector.deviceId = SOLENOID;
	solenoidHead->detector.whichOne = 0;
	strcpy(solenoidHead->detector.name, "solenoidHead");
	for( int i = 0; i < NumSolenoid(); i++)
	{
            solenoid->addChild(AddSolenoidToDetectorTree(i+1, solenoidHead));
	}
      }
      solenoid->unrefNoDelete();
      return solenoid;
};
SoMcFDetectorTreeKit *AddSolenoidToDetectorTree(int which,  
                                            McFDetectorTreeList *mother)
{
    ConicalDetectorData data;
    getSolenoidDetectorData(which, data);
    McFDetectorTreeList *solenoid = new McFDetectorTreeList;
    solenoid->AddLeaf(mother);
    solenoid->detector.deviceId = SOLENOID;
    solenoid->detector.whichOne = which;
    getSolenoidDetectorName(which, solenoid->detector.name);
    
    SoMcFDetectorTreeKit *solenoidKit = solenoid->getDetectorKit();
    solenoidKit->device = SOLENOID;
    solenoidKit->whichDevice = which;
    
//transform the device to its location in Z
    SoTransform *Transform = (SoTransform *) 
                              solenoidKit->getPart("transform", TRUE);
    Transform->translation.setValue(0,0,data.z0);


//give it a default color
    SoMaterial *Plastic = 
                 (SoMaterial *) solenoidKit->getPart("appearance.material", TRUE);
                 
    Plastic ->diffuseColor.setValue(0.66, 10.00, 0.61);
    
    SoDrawStyle *style = (SoDrawStyle *) solenoidKit->getPart(
                                              "appearance.drawStyle", TRUE);
    style->style = SoDrawStyle::LINES;
    style->lineWidth = 2.0;



//define a conical section for the detector
    SoMcFConsKit *consKit = new SoMcFConsKit();
       
    SoG4Cons *cons = (SoG4Cons *) consKit->getPart("cons", TRUE);
    cons->fRmin1 = data.rminZlow;
    cons->fRmin2 = data.rminZhigh;
    cons->fRmax1 = data.rmaxZlow;
    cons->fRmax2 = data.rmaxZhigh;
    cons->fDz = data.zlen/2.;
    cons->generateAlternateRep();
 
//Since solenoid detectors have no children the full and preview
//representations are the same.

    SoSeparator *full = (SoSeparator *) 
                        solenoidKit->getPart("fullSeparator",TRUE);
    SoSeparator *preview = (SoSeparator *) 
                        solenoidKit->getPart("previewSeparator",TRUE);
    full->addChild(consKit);
    preview->addChild(consKit);
    consKit->generateAlternateRep();
    
    solenoidKit->generateAlternateRep();
    
    return solenoidKit;
};

#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodes/SoRotationXYZ.h>
#include <Inventor/nodes/SoTranslation.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/nodekits/SoNodeKitListPart.h>
#include <Inventor/nodekits/SoShapeKit.h>
#include "muonCommon.hh"
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
//muon detectors are such a simple case that they don't rate a class
//at this time
void getMuonDetectorData(int which, ConicalDetectorData &data)
{
      data.z0            = muon[which-1].z0; 
      data.zlen          = muon[which-1].zlen;
      data.rminZlow      = muon[which-1].rmin[0];
      data.rminZhigh     = muon[which-1].rmin[1];
      data.rmaxZlow      = muon[which-1].rmax[0];
      data.rmaxZhigh     = muon[which-1].rmax[1];
      return;
}
void getMuonDetectorName(int which, char *name)
{
    strcpy(name, muon[which-1].name);
    return;      
}
int NumMuon(void)
{
     return *n_obj_muon;
}
SoSeparator *Muon(void)
{
      SoSeparator *muon = new SoSeparator;
      muon->ref();
      if(NumMuon() > 0 ) 
      {
	McFDetectorTreeList *muonHead = new McFDetectorTreeList;
	muonHead->AddToTopOfTree();  //This is a high level "volume"
	muonHead->detector.deviceId = MUON;
	muonHead->detector.whichOne = 0;
	strcpy(muonHead->detector.name, "MuonHead");
	for( int i = 0; i < NumMuon(); i++)
	{
            muon->addChild(AddMuonToDetectorTree(i+1, muonHead));
	}
      }
      muon->unrefNoDelete();
      return muon;
};
SoMcFDetectorTreeKit *AddMuonToDetectorTree(int which,  
                                            McFDetectorTreeList *mother)
{
    ConicalDetectorData data;
    getMuonDetectorData(which, data);
    McFDetectorTreeList *muon = new McFDetectorTreeList;
    muon->AddLeaf(mother);
    muon->detector.deviceId = MUON;
    muon->detector.whichOne = which;
    getMuonDetectorName(which, muon->detector.name);
    
    SoMcFDetectorTreeKit *muonKit = muon->getDetectorKit();
    muonKit->device = MUON;
    muonKit->whichDevice = which;
    
//transform the device to its location in Z
    SoTransform *Transform = (SoTransform *) 
                              muonKit->getPart("transform", TRUE);
    Transform->translation.setValue(0,0,data.z0);


//give it a default color
    SoMaterial *Plastic = 
                 (SoMaterial *) muonKit->getPart("appearance.material", TRUE);
                 
    Plastic ->diffuseColor.setValue(0.09,0.46,1.0);



//define a conical section for the detector
    SoMcFConsKit *consKit = new SoMcFConsKit();
       
    SoG4Cons *cons = (SoG4Cons *) consKit->getPart("cons", TRUE);
    cons->fRmin1 = data.rminZlow;
    cons->fRmin2 = data.rminZhigh;
    cons->fRmax1 = data.rmaxZlow;
    cons->fRmax2 = data.rmaxZhigh;
    cons->fDz = data.zlen/2.;
    cons->generateAlternateRep();
 
//Since muon detectors have no children (at this time) the full and preview
//representations are the same.

    SoSeparator *full = (SoSeparator *) 
                        muonKit->getPart("fullSeparator",TRUE);
    SoSeparator *preview = (SoSeparator *) 
                        muonKit->getPart("previewSeparator",TRUE);
    full->addChild(consKit);
    preview->addChild(consKit);
    consKit->generateAlternateRep();
    
    muonKit->generateAlternateRep();
    
    return muonKit;
};

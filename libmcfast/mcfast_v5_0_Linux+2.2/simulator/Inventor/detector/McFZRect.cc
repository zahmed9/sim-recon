#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoCube.h>
#include <Inventor/nodes/SoTransform.h>
#include "McFDetectorTreeList.hh"
#include "McFDetDevice.hh"
#include "hepvis/SoMcFDetectorTreeKit.hh"
#include "SilZRectData.hh"  //includes both layer and global sil structures
#include "SiZRectCommon.hh"
#include "absZRectLayer.hh"
#include "ZRectLayerManager.hh"
#include "McFZRect.hh"
SoSeparator *SilZRect(void)
{
    SoSeparator *xy = new SoSeparator;
    xy->ref();
    if(NumSiZRect() > 0)
    {
	McFDetectorTreeList *sixy = new McFDetectorTreeList;
	sixy->AddToTopOfTree();  //This is a high level "volume"
	sixy->detector.deviceId = SILZRECT;
	sixy->detector.whichOne = 0;
	sixy->doContracted(TRUE);
	strcpy(sixy->detector.name, "SilZRectHead");
	for(int i = 0; i < NumSiZRect(); i++)
	{
	    xy->addChild(AddSilZRectToTree(i+1, sixy));
	}
    }
    xy->unrefNoDelete();
    return xy;
}
SoMcFDetectorTreeKit *AddSilZRectToTree(int which,
                                            McFDetectorTreeList *mother)
{
    SilZRectGlobalData data;
    static int offset = 0;  //assume that the detectors are
                            // added in order and keep track of
                            // the offset for the layers
                            
    if(which == 1) offset = 0;  //reset offset for first device
                            
    //keep track of bounding box information for preview represetation.
    float xmax, xmin;
    float ymax, ymin;
    float zmax, zmin;
    float x1=0, x2 = 0, y1=0, y2 = 0, z1=0, z2 = 0;
    
    
    getSilZRectGlobalData(which, data); 
    int nlyr = data.nlayer;
    McFDetectorTreeList *sizrect = new McFDetectorTreeList;
    sizrect->AddLeaf(mother);  //this is a subvolume of the SIX branch
    sizrect->detector.deviceId = SILZRECT;
    sizrect->detector.whichOne = which;
    getSilZRectGlobalName(which, sizrect->detector.name);

    //get the full separator and add the layers as children to it.
    SoMcFDetectorTreeKit *siZRectKit = sizrect->getDetectorKit();
    siZRectKit->device = SILZRECT;
    siZRectKit->whichDevice = which;
    SoSeparator *fullSeparator = 
                   (SoSeparator *) siZRectKit->getPart("fullSeparator",TRUE);

    for (int i = 0; i < nlyr; i++)
    {
       absZRectLayer *zRectLayer 
                      = ZRectLayerManager::getLayerType((offset+i+1));

       fullSeparator->addChild(zRectLayer->makeSiZRectLayerRep((offset+i+1),
                               sizrect));
       getSilZRectLayerEdges(offset+i+1,x1,x2,y1,y2,z1,z2);

       if( i == 0)
       {
          xmin = x1; xmax = x2; ymin = y1; ymax = y2; 
          zmin = z1; zmax = z2; 
       }
       else
       {
	  if(xmin > x1) xmin = x1;
	  if(ymin > y1) ymin = y1;
	  if(zmin > z1) zmin = z1;
	  if(xmax < x2) xmax = x2;
	  if(ymax < y2) ymax = y2;
	  if(zmax < z2) zmax = z2;
       }
    }
    offset += nlyr;
    
    //generate a preview representation for the detector that is just a box
    //this will make it easy for people to get a representation that they
    //can rotate.
    SoSeparator *previewSeparator = 
                   (SoSeparator *) siZRectKit->getPart("previewSeparator",TRUE);
 
    SoMaterial *GreenPlastic = 
                 (SoMaterial *) siZRectKit->getPart("appearance.material", TRUE);
    GreenPlastic ->diffuseColor.setValue(0,1,0);

    SoTransform *translation = (SoTransform *)
                                siZRectKit->getPart("transform",TRUE);
    translation->translation.setValue(data.xpos,data.ypos,data.zpos);

    SoCube *box = new SoCube;
    box->width.setValue(xmax-xmin);
    box->height.setValue(ymax-ymin);
    box->depth.setValue(zmax-zmin);
        
    previewSeparator->addChild(box);

//The default representation is to show the planes, not the bounding box.
    siZRectKit->generateAlternateRep();
    siZRectKit->setPreview(FALSE);
    return (sizrect->getDetectorKit());
    
}

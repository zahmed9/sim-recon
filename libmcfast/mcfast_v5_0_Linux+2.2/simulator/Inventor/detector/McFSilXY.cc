#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoCube.h>
#include <Inventor/nodes/SoTransform.h>
#include "McFDetectorTreeList.hh"
#include "McFDetDevice.hh"
#include "hepvis/SoMcFDetectorTreeKit.hh"
#include "SilXYPlaneData.hh"  //includes both layer and global silxy structures
#include "SiXYCommon.hh"
#include "McFSilXY.hh"
#include "McFSilXYLayer.hh"
void upDateBoundingBox(float x1, float x2, float y1, float y2,
                  float z1, float z2,
                  float *xmin, float *xmax, float *ymin, float *ymax,
                  float *zmin, float *zmax);  //procedure for finding
                                              //bounding box --only used
                                              //here.
                  
SoSeparator *SilXY(void)
{
    SoSeparator *xy = new SoSeparator;
    xy->ref();
    if(NumSilXY() > 0)
    {
	McFDetectorTreeList *sixy = new McFDetectorTreeList;
	sixy->AddToTopOfTree();  //This is a high level "volume"
	sixy->detector.deviceId = SILXY;
	sixy->detector.whichOne = 0;
	sixy->doContracted(TRUE);
	strcpy(sixy->detector.name, "SilXYHead");
	for(int i = 0; i < NumSilXY(); i++)
	{
	    xy->addChild(McFSilXY::AddToDetectorTree(i+1, sixy));
	}
    }
    xy->unrefNoDelete();
    return xy;
}
SoMcFDetectorTreeKit *McFSilXY::AddToDetectorTree(int which,
                                            McFDetectorTreeList *mother)
{
    SilXYGlobalData data;
    static int offset = 0;  //assume that the detectors are
                            // added in order and keep track of
                            // the offset for the layers
                            
    if(which == 1) offset = 0;  //reset offset for first device
                            
    //keep track of bounding box information for preview represetation.
    float xmax, xmin;
    float ymax, ymin;
    float zmax, zmin;
    float x1=0, x2 = 0, y1=0, y2 = 0, z1=0, z2 = 0;
    
    
    getSilXYGlobalData(which, data); //get what data there is for SIXY devices
    int nlyr = data.nlayer;
    McFDetectorTreeList *sixy = new McFDetectorTreeList;
    sixy->AddLeaf(mother);  //this is a subvolume of the SIX branch
    sixy->detector.deviceId = SILXY;
    sixy->detector.whichOne = which;
    getSiXYGlobalName(which, sixy->detector.name);

    //get the full separator and add the layers as children to it.
    SoMcFDetectorTreeKit *siXYKit = sixy->getDetectorKit();
    siXYKit->device = SILXY;
    siXYKit->whichDevice = which;
    SoSeparator *fullSeparator = 
                   (SoSeparator *) siXYKit->getPart("fullSeparator",TRUE);

    for (int i = 0; i < nlyr; i++)
    {
       fullSeparator->addChild(McFSilXYLayer::AddToDetectorTree
                                         ((offset+i+1), sixy,
                                         x1,x2,y1,y2,z1,z2));

//keep track of edges to form bounding box
       if( i == 0)
       {
          xmin = x1; xmax = x2; ymin = y1; ymax = y2; 
          zmin = z1; zmax = z2; 
       }
       else
       {
       upDateBoundingBox(x1,x2,y1,y2,z1,z2,
                         &xmin, &xmax, &ymin, &ymax, &zmin, &zmax );   
       }
    }
    offset += nlyr;
    
    //generate a preview representation for the detector that is just a box
    //this will make it easy for people to get a representation that they
    //can rotate.
    SoSeparator *previewSeparator = 
                   (SoSeparator *) siXYKit->getPart("previewSeparator",TRUE);
 
    SoMaterial *GreenPlastic = 
                 (SoMaterial *) siXYKit->getPart("appearance.material", TRUE);
    GreenPlastic ->diffuseColor.setValue(0,1,0);

    SoTransform *translation = (SoTransform *)
                                siXYKit->getPart("transform",TRUE);
    translation->translation.setValue(0.,0.,data.z0);

    SoCube *box = new SoCube;
    box->width.setValue(xmax-xmin);
    box->height.setValue(ymax-ymin);
    box->depth.setValue(zmax-zmin);
        
    previewSeparator->addChild(box);

//The default representation is to show the planes, not the bounding box.
    siXYKit->generateAlternateRep();
    siXYKit->setPreview(FALSE);
    return (sixy->getDetectorKit());
    
}
void upDateBoundingBox(float x1, float x2, float y1, float y2, float z1, float z2,
                  float *xmin, float *xmax, float *ymin, float *ymax,
                  float *zmin, float *zmax)
{
   if(*xmin > x1) *xmin = x1;
   if(*ymin > y1) *ymin = y1;
   if(*zmin > z1) *zmin = z1;
   if(*xmax < x2) *xmax = x2;
   if(*ymax < y2) *ymax = y2;
   if(*zmax < z2) *zmax = z2;
}

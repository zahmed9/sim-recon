#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoCube.h>
#include <Inventor/nodes/SoTransform.h>
#include "McFDetectorTreeList.hh"
#include "hepvis/SoMcFBoxWithGap.hh"
#include "McFDetDevice.hh"
#include "hepvis/SoMcFDetectorTreeKit.hh"
#include "frameDetectorData.hh"
#include "forTrackLayer.hh"
#include "ftrkCommon.hh"
#include "McFFtrk.hh"

SoSeparator *ForwardTracker(void)
{
    SoSeparator *xy = new SoSeparator;
    xy->ref();
    if(NumFtrk() > 0)
    {
      McFDetectorTreeList *ftrk = new McFDetectorTreeList;
      ftrk->AddToTopOfTree();  //This is a high level "volume"
      ftrk->detector.deviceId = FTRACK;
      ftrk->detector.whichOne = 0;
      strcpy(ftrk->detector.name, "FTrackHead");
      for(int i = 0; i < NumFtrk(); i++)
      {
          xy->addChild(AddFtrkToDetectorTree(i+1, ftrk));
      }
    }
    xy->unrefNoDelete();
    return xy;
}
SoMcFDetectorTreeKit *AddFtrkToDetectorTree(int which,
                                            McFDetectorTreeList *mother)
{
    frameDetectorData data;
    static int offset = 0;  //assume that the detectors are
                            // added in order and keep track of
                            // the offset for the layers
                            
    if(which == 1) offset = 0;  //reset offset for first device
                                
    
    getFtrkData(which, data); //get what data there is for SIXY devices
    int nlyr = NumFtrklayer(which);
    McFDetectorTreeList *ftrk = new McFDetectorTreeList;
    ftrk->AddLeaf(mother);  //this is a subvolume of the SIX branch
    ftrk->detector.deviceId = FTRACK;
    ftrk->detector.whichOne = which;
    ftrk->doContracted(TRUE);
    getFtrkName(which, ftrk->detector.name);

    //get the full separator and add the layers as children to it.
    SoMcFDetectorTreeKit *ftrkKit = ftrk->getDetectorKit();
    ftrkKit->device = FTRACK;
    ftrkKit->whichDevice = which;
    SoSeparator *fullSeparator = 
                   (SoSeparator *) ftrkKit->getPart("fullSeparator",TRUE);

    for (int i = 0; i < nlyr; i++)
    {
       fullSeparator->addChild(AddFtrkLayerToDetectorTree((offset+i+1),
                               ftrk));
    }
    offset += nlyr;
    
    //for the full representation, show the frame around the detector planes
    
    SoMcFBoxWithGap *Block = new SoMcFBoxWithGap;
    Block->fDxOuter.setValue(data.xLenOuter); 
    Block->fDyOuter.setValue(data.yLenOuter); 
    Block->fDzOuter.setValue(data.zLenOuter); 
    Block->fDxInner.setValue(data.xLenInner); 
    Block->fDyInner.setValue(data.yLenInner); 
    Block->fDzInner.setValue(data.zLenInner); 
    Block->generateAlternateRep();
    fullSeparator->addChild(Block);


    //generate a preview representation for the detector that is just a box
    //this will make it easy for people to get a representation that they
    //can rotate.
    SoSeparator *previewSeparator = 
                   (SoSeparator *) ftrkKit->getPart("previewSeparator",TRUE);
 
    SoMaterial *Plastic = 
                 (SoMaterial *) ftrkKit->getPart("appearance.material", TRUE);
    Plastic ->diffuseColor.setValue(0,1,1);

    SoTransform *translation = (SoTransform *)
                                ftrkKit->getPart("transform",TRUE);
    translation->translation.setValue(0.,0.,data.z0);

    SoCube *box = new SoCube;
    box->width.setValue(data.xLenOuter*2.);  //the SoG4classes deal with 1/2 lengths
    box->height.setValue(data.yLenOuter*2.);//the inventor class have full lengths
    box->depth.setValue(data.zLenOuter*2.);
        
    previewSeparator->addChild(box);

//The default representation is to show the planes, not the bounding box.
    ftrkKit->generateAlternateRep();
    ftrkKit->setPreview(FALSE);
    return (ftrkKit);
    
}

//the code for the layers:
SoMcFDetectorTreeKit *AddFtrkLayerToDetectorTree(int which,
                                            McFDetectorTreeList *mother)
{
    frameDetectorData data;
    forTrackerLayer data1;

    getFtrkLayerData(which, data, data1);

    McFDetectorTreeList *layer = new McFDetectorTreeList;
    layer->AddLeaf(mother);
    layer->detector.deviceId = FTRACKLYR;
    layer->detector.whichOne = which;
    layer->doContracted(TRUE);

    sprintf(layer->detector.name, "ftrklayer_%d", which);
 
    SoMcFDetectorTreeKit *layerKit = layer->getDetectorKit();
    layerKit-> device = FTRACKLYR;
    layerKit-> whichDevice = which;

    SoSeparator *previewSeparator = 
                   (SoSeparator *) layerKit->getPart("previewSeparator",TRUE);
    SoSeparator *fullSeparator = 
                   (SoSeparator *) layerKit->getPart("fullSeparator",TRUE);

    SoMaterial *Plastic = 
                (SoMaterial *) layerKit->getPart("appearance.material", TRUE);
    Plastic ->diffuseColor.setValue(1,0.5,0.);


    SoTransform *translation = (SoTransform *)
                               layerKit->getPart("transform",TRUE);
    translation->translation.setValue(0.,0.,data.z0);
    
    
    SoMcFBoxWithGap *Block = new SoMcFBoxWithGap;
    Block->fDxOuter.setValue(data.xLenOuter); 
    Block->fDyOuter.setValue(data.yLenOuter); 
    Block->fDzOuter.setValue(data.zLenOuter); 
    Block->fDxInner.setValue(data.xLenInner); 
    Block->fDyInner.setValue(data.yLenInner); 
    Block->fDzInner.setValue(data.zLenInner); 
    Block->generateAlternateRep();
 
//the full representation will eventually have some cell information 
//for now, preview and full representations are the same
    fullSeparator->addChild(Block);
    previewSeparator->addChild(Block);

    layerKit->generateAlternateRep();
    layerKit->setPreview(FALSE);


     return layerKit;
}



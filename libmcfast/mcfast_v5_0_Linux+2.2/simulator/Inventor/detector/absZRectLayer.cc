#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoCube.h>
#include <math.h>
#include <stdio.h>
#include <iostream.h>
#include "absZRectLayer.hh"
#include "ZRectWaferManager.hh"
#include "hepvis/SoMcFDetectorTreeKit.hh"
#include "McFDetectorTreeList.hh"
#include "McFDetDevice.hh"
#include "absZRectWafer.hh"
#include "SiZRectCommon.hh"



SoMcFDetectorTreeKit *absZRectLayer::makeSiZRectLayerRep
                    (int which, McFDetectorTreeList *mother)
{
    
    McFDetectorTreeList *sizlayer = new McFDetectorTreeList;
    sizlayer->AddLeaf(mother);
    sizlayer->detector.deviceId = SILZRECTLYR;
    sizlayer->detector.whichOne = which;
    sprintf(sizlayer->detector.name, "SiZRectLayer_%d", which);

    SoMcFDetectorTreeKit *layerKit = sizlayer->getDetectorKit();
    layerKit->device = SILZRECTLYR;
    layerKit->whichDevice = which;

    layerKit->ref();
    SoSeparator *previewSep = 
         (SoSeparator *)layerKit->getPart("previewSeparator",TRUE);
    SoSeparator *fullSep = 
         (SoSeparator *)layerKit->getPart("fullSeparator",TRUE);

    getSilZRectLayerData(which, layerData);

//put the layer in the correct location
    SoTransform *transform = (SoTransform *) 
                      layerKit->getPart("transform",TRUE);
    transform->translation.setValue(0.0, 0.0, layerData.zLocal);
    SbVec3f axis;
    axis.setValue(0.,0.,1.0);
    transform->rotation.setValue(axis, layerData.rotation);
    
    SoMaterial *mat = (SoMaterial *)
                      layerKit->getPart("appearance.material",TRUE);
    mat->diffuseColor.setValue(1.0,1.0,0.61);

    int whichWafer = LayerToWafer(which);
    if(whichWafer >= 0) 
    {
 
       absZRectWafer *zRectWafer 
                      = ZRectWaferManager::getWaferType(whichWafer);
       fullSep->addChild(
                        zRectWafer->MakeSiZRectWaferRep(which, 
                        whichWafer, this, sizlayer));
       delete zRectWafer;
    }
    previewSep->addChild(makeSiZRectLayer());
    layerKit->generateAlternateRep();
    layerKit->unrefNoDelete();
    return layerKit;
   
}
float absZRectLayer::deadX(SilZRectLayerData layerData, 
                           SilZRectWaferData waferData)
{
//According to Julia, the wafers are distributed evenlX along
//the "active area" of the laXer.
//The dead area depends on the length of the wafer, the length of the laXer.


//I'm really confused about what dead is (12/5/97)
 

   float dead = 0.;
   if(dead < 0)
   {
       cout<< "Invalid ZRect layer/wafer/starting point combination in X"
       <<"LaXer X Length = " << layerData.lenXLayer << endl 
       << "Wafer X Length = " << waferData.lenXWaf << endl
       << "wafer1xlocal =" << layerData.startXWafer << endl
       <<"The display will assume full layer is active"<< endl;
       dead = 0;
   }
   return dead;
}
float absZRectLayer::deadY(SilZRectLayerData layerData, 
                           SilZRectWaferData waferData)
{
//According to Julia, the wafers are distributed evenly along
//the "active area" of the layer. Any dead area is strictly along one side
//The dead area depends on the length of the wafer, the lenght of the layer. 

   float dead = 0.;
   if(dead < 0)
   {
       cout<< "Invalid ZRect layer/wafer/starting point combination in Y"
       <<"Layer Y Length = " << layerData.lenYLayer << endl 
       << "Wafer Y Length = " << waferData.lenYWaf << endl
       << "wafer1xlocal =" << layerData.startYWafer << endl
       <<"The display will assume full layer is active"<< endl;
       dead = 0;
   }
   return dead;
}

#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/nodes/SoCube.h>
#include <Inventor/nodes/SoMaterial.h>
#include <math.h>
#include <stdio.h>
#include <iostream.h>
#include "spcZRectWafer.hh"
#include "SilZRectData.hh"  //includes both layer and global sil structures
#include "SiZRectCommon.hh"
#include "absZRectLayer.hh"
#include "hepvis/SoMcFDetectorTreeKit.hh"
#include "McFDetectorTreeList.hh"
SoMcFDetectorTreeKit *spcZRectWafer::MakeSiZRectWaferRep(int whichLayer,
                                 int whichWafer,
                                 absZRectLayer *zRectLayer,
                                 McFDetectorTreeList *mother)
{

    SilZRectLayerData layerData;
    SilZRectWaferData waferData;
    SoMcFDetectorTreeKit *tmp = new SoMcFDetectorTreeKit;
    tmp->ref();
    SoSeparator *tmpSep = 
            (SoSeparator *)tmp->getPart("fullSeparator",TRUE);
    tmp->setPreview(FALSE);

    //in this case whichWafer is the first wafer of layerData.nwaferX*
    //layerData.nwaferY.  I doubt this will ever be used.
    
 
    SoSeparator *sep;
    SoTransform *trans;
    getSilZRectLayerData(whichLayer, layerData);
    float x, y;
    for(int i = 0; i < layerData.nwaferX; i++)
    {
      for(int j = 0; j < layerData.nwaferY; j++)
      {
         getSilZRectWaferData(whichWafer, waferData);
         SoCube *wafer = MakeSiZRectWafer(waferData);
	 McFDetectorTreeList *sizwafer = new McFDetectorTreeList;
	 sizwafer->AddLeaf(mother);
	 sizwafer->detector.deviceId = SILZRECTWAFER;
	 sizwafer->detector.whichOne = whichWafer;
	 sprintf(sizwafer->detector.name, "SiZRectWafer_%d", whichWafer);

	 SoMcFDetectorTreeKit *waferKit = sizwafer->getDetectorKit();
	 waferKit->device = SILZRECTWAFER;
	 waferKit->whichDevice = whichWafer;
         SoSeparator *previewSep = 
            (SoSeparator *)waferKit->getPart("previewSeparator",TRUE);
         SoSeparator *fullSep = 
            (SoSeparator *)waferKit->getPart("fullSeparator",TRUE);
         if(zRectLayer->findWaferXYPosition
                    (waferData.waferNumX, 
                     waferData.waferNumY, layerData, waferData, x, y)== 0)
         {
            sep = new SoSeparator;
            trans = new SoTransform;
            trans->translation.setValue(x,y,waferData.zOffset*
                                        zTile(layerData.pattern,
                                         waferData.waferNumX-1,
                                         waferData.waferNumY-1));
            sep->addChild(trans);
            sep->addChild(wafer);
            previewSep->addChild(sep);
            fullSep->addChild(sep);
          }         
          waferKit->generateAlternateRep();
          waferKit->setPreview(TRUE);
          tmpSep->addChild(waferKit);
          whichWafer++;
      }
    }
    tmp->generateAlternateRep();
    tmp->unrefNoDelete();
    return tmp;
} 

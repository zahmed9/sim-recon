#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoCube.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodes/SoMaterial.h>
#include <math.h>
#include <stdio.h>
#include <iostream.h>
#include "allZRectWafer.hh"
#include "SilZRectData.hh"  //includes both layer and global sil structures
#include "SiZRectCommon.hh"
#include "absZRectLayer.hh"
#include "hepvis/SoMcFDetectorTreeKit.hh"
#include "McFDetectorTreeList.hh"
SoMcFDetectorTreeKit *allZRectWafer::MakeSiZRectWaferRep(int whichLayer,
                                 int whichWafer,
                                 absZRectLayer *zRectLayer,
                                 McFDetectorTreeList *mother)
{

    SilZRectLayerData layerData;
    SilZRectWaferData waferData;
    
    McFDetectorTreeList *sizwafer = new McFDetectorTreeList;
    sizwafer->AddLeaf(mother);
    sizwafer->detector.deviceId = SILZRECTWAFER;
    sizwafer->detector.whichOne = whichWafer;
    sprintf(sizwafer->detector.name, "SiZRectWafer_%d", whichWafer);

    SoMcFDetectorTreeKit *waferKit = sizwafer->getDetectorKit();
    waferKit->device = SILZRECTWAFER;
    waferKit->whichDevice = whichWafer;

    waferKit->ref();
    SoSeparator *previewSep = 
         (SoSeparator *)waferKit->getPart("previewSeparator",TRUE);
    SoSeparator *fullSep = 
         (SoSeparator *)waferKit->getPart("fullSeparator",TRUE);

    getSilZRectLayerData(whichLayer, layerData);
    getSilZRectWaferData(whichWafer, waferData);

    SoCube *wafer = MakeSiZRectWafer(waferData);
    SoSeparator *sep;
    SoTransform *trans;
    float x, y;
//to form some contrast between the tiled layers, use two shades of the
//material
    SoMaterial *mat1 = new SoMaterial;
    mat1->diffuseColor.setValue(1.0,1.0,0.61);
    SoMaterial *mat2 = new SoMaterial;
    mat2->diffuseColor.setValue(1.0,0.67,0.38);
//For the Y and X type tiling, the wafers run together.  Make a black
//outline so they show up better
    SoMaterial *black = new SoMaterial;
    black->diffuseColor.setValue(1.0,1.0,1.0);
    SoDrawStyle *style = new SoDrawStyle;
    style->style = SoDrawStyle::LINES;
    style->lineWidth.setValue(2.0);
        
   
    for(int i = 0; i < layerData.nwaferX; i++)
    {
      for(int j = 0; j < layerData.nwaferY; j++)
      {
         if(zRectLayer->findWaferXYPosition
                    (i, j, layerData, waferData, x, y)== 0)
         {
            sep = new SoSeparator;
            SoSeparator *sep2 = new SoSeparator;
            trans = new SoTransform;
            trans->translation.setValue(x,y,waferData.zOffset*
                                        zTile(layerData.pattern, i, j));
            if(zTile(layerData.pattern,i,j) < 0.) sep->addChild(mat1);
            if(zTile(layerData.pattern,i,j) > 0.) sep->addChild(mat2);
            
            sep->addChild(trans);
            sep->addChild(wafer);
            sep2->addChild(black);
            sep2->addChild(style);
            sep2->addChild(wafer);
            sep->addChild(sep2);
            previewSep->addChild(sep);
            fullSep->addChild(sep);
         }         
      }
    }
    waferKit->setPreview(TRUE);
    waferKit->generateAlternateRep();
    waferKit->unrefNoDelete();
    return waferKit;
} 

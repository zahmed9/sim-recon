#include <math.h>
#include <iostream.h>
#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoCube.h>
#include <Inventor/nodes/SoCoordinate3.h>
#include <Inventor/nodes/SoLineSet.h>
#include <Inventor/nodes/SoPointSet.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodes/SoTransform.h>
#include "absZRectLayer.hh"
#include "ZRectLayerManager.hh"
#include "absZRectWafer.hh"
#include "ZRectWaferManager.hh"
#include "hepvis/SoMcFSilStripHitKit.hh"
#include "pointsStruct.hh"
#include "McfastHitTypes.hh"
#include "hitsCommon.hh"
#include "SilZRectHitData.hh"
#include "SilZRectData.hh"  //includes both layer and global silxy structures
SoSeparator *MakeSilZRectHits(void)
{    
    
    SilZRectGlobalData detectorData;
    SilZRectLayerData layerData;
    SilZRectWaferData waferData;
    SilZRectHitData *hits = NULL;
    Points *traceHits = NULL;
    int layer, wafer;

    SoSeparator *mainSeparator = new SoSeparator;
    mainSeparator->ref();

    int nhits = NumSilZRectHits();  
    if(nhits > 0)
    {
      SoSeparator *hitsSeparator = new SoSeparator;
      SoSeparator *traceSeparator = new SoSeparator;

      SoDrawStyle *style = new SoDrawStyle;
      style->style = SoDrawStyle::POINTS;
      style->pointSize.setValue(5.0);

      SoMaterial *traceMat = new SoMaterial;
      traceMat->diffuseColor.setValue(1.0,1.0,0.0);
      SoCoordinate3 *traceCoor = new SoCoordinate3;

      SoPointSet *tracePoints = new SoPointSet;
      tracePoints->vertexProperty.setValue(traceCoor);

      traceSeparator->addChild(style);
      traceSeparator->addChild(traceMat);
      traceSeparator->addChild(tracePoints);
      tracePoints->numPoints.setValue(nhits);
      hits = new SilZRectHitData[nhits];
      traceHits = new Points[nhits]; 
      GetSilZRectHits(hits);
      GetTraceHits(JDEV_PIXELPLANE, traceHits);

      for(int i = 0; i < nhits; i++)
      { 
          if(hits[i].hitDetector < NumSiZRect())  //Since both zrect
	  //and SiXY hits are defined as pixelplane hits, need to check
	  //for both devices.
	  {
            layer = WhichSiZRectLayer(hits[i].hitDetector, hits[i].hitLayer);
            int icol, irow;
            absZRectLayer *zRectLayer 
                	= ZRectLayerManager::getLayerType(layer);
            getSilZRectGlobalData(hits[i].hitDetector, detectorData);
    	    getSilZRectLayerData(layer, layerData);

            zRectLayer->waferNumber(hits[i].hitWafer, layerData, icol, irow);
            wafer = WhichSiZRectWafer(hits[i].hitDetector, hits[i].hitLayer, 
                               icol, irow);

	    getSilZRectWaferData(wafer, waferData);

            absZRectWafer *zRectWafer 
                	= ZRectWaferManager::getWaferType(wafer);



	    SoMcFSilStripHitKit *stripKit = new SoMcFSilStripHitKit();
            stripKit->hitid = hits[i].hitId;

	    SoMaterial *stripPlastic = 
                     (SoMaterial *) stripKit->getPart("Appearance.material",
                     TRUE);
            stripPlastic ->diffuseColor.setValue(0,1,1);

            float xWafer,yWafer;
	    zRectLayer->findWaferXYPosition(icol,irow,layerData,waferData,
	                                    xWafer, yWafer);
            if(waferData.measureType == PIXEL)
	    {
              float xPixel,yPixel;

	      zRectWafer->findPixelXYPosition(hits[i].hitIcolX-1,
	                        	 hits[i].hitIrowY-1,
                                	 waferData, xPixel, yPixel);
              SoTransform *transform = (SoTransform *)
                                    stripKit->getPart("Transform",TRUE);

              transform->translation.setValue(
	            xWafer+xPixel, yWafer+yPixel,
        	   layerData.zLocal + 
		   detectorData.zpos + 
		   waferData.zOffset*
		   zRectWafer->zTile(layerData.pattern,icol,irow));

              float z = layerData.zLocal + detectorData.zpos +
	        	waferData.zOffset*
		   zRectWafer->zTile(layerData.pattern,icol,irow);

              SbVec3f axis;
              axis.setValue(0.,0.,1.0);

	      transform->rotation.setValue(axis,layerData.rotation);


	      SoCube *pixel = (SoCube *)
                                  stripKit->getPart("stripSeparator",TRUE);
	      pixel->width.setValue(waferData.lenXWaf*waferData.pitchX);
	      pixel->height.setValue(waferData.lenYWaf*waferData.pitchY);
	      pixel->depth.setValue(layerData.thick);
              hitsSeparator->addChild(stripKit);
              traceCoor->point.set1Value(i,traceHits[i].x,traceHits[i].y,
                                	traceHits[i].z);


            }

          }
     }    

      delete hits;
      delete traceHits;
      mainSeparator->addChild(hitsSeparator);
//the tracepoints are just for debugging
      mainSeparator->addChild(traceSeparator);
    }
    mainSeparator->unrefNoDelete();
    return mainSeparator;
    
}

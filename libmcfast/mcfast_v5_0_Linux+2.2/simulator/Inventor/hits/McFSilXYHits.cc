#include <math.h>
#include <iostream.h>
#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoCoordinate3.h>
#include <Inventor/nodes/SoLineSet.h>
#include <Inventor/nodes/SoPointSet.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodes/SoTransform.h>
#include "hepvis/SoMcFSilStripHitKit.hh"
#include "SiXYCommon.hh"
#include "hitsCommon.hh"
#include "pointsStruct.hh"
#include "McFSilXYLayer.hh"
#include "SilXYHitData.hh"
#include "SilXYPlaneData.hh"  //includes both layer and global silxy structures
#include "McfastHitTypes.hh"

SoSeparator *MakeSilXYHits(void)
{    
    
    SilXYGlobalData detectorData;
    SilXYPlaneData layerData;
    SilXYHitData *hits = NULL;
    Points *traceHits = NULL;
    int layer;

    SoSeparator *mainSeparator = new SoSeparator;
    mainSeparator->ref();

    int nhits = NumSilXYHits();
    if(nhits > 0)
    {

//Use one separator to hold the hit strip, the other to hold the trace points
      SoSeparator *hitsSeparator = new SoSeparator;
      SoSeparator *traceSeparator = new SoSeparator;

      SoDrawStyle *style = new SoDrawStyle;
      style->style = SoDrawStyle::POINTS;
      style->pointSize.setValue(3.0);

      SoMaterial *traceMat = new SoMaterial;
      traceMat->diffuseColor.setValue(1.0,1.0,0.0);
      SoCoordinate3 *traceCoor = new SoCoordinate3;

      SoPointSet *tracePoints = new SoPointSet;
      tracePoints->vertexProperty.setValue(traceCoor);

      traceSeparator->addChild(style);
      traceSeparator->addChild(traceMat);
      traceSeparator->addChild(tracePoints);


      tracePoints->numPoints.setValue(nhits);
      hits = new SilXYHitData[nhits];
      traceHits = new Points[nhits]; 
      GetSilXYHits(hits);
      GetTraceHits(JDEV_PIXELPLANE, traceHits);

      for(int i = 0; i < nhits; i++)
      { 
          layer = WhichPixelPlane(hits[i].hitDetector, hits[i].hitLayer);

          getSilXYGlobalData(hits[i].hitDetector, detectorData);
    	  getSilXYPlaneData(layer, layerData);

	  SoMcFSilStripHitKit *stripKit = new SoMcFSilStripHitKit();
          stripKit->hitid = hits[i].hitId;

	  SoMaterial *stripPlastic = 
                   (SoMaterial *) stripKit->getPart("Appearance.material",
                   TRUE);
          stripPlastic ->diffuseColor.setValue(0,1,1);


          SoCoordinate3 *coords = (SoCoordinate3 *)
                                  stripKit->getPart("Coord3",TRUE);

          SoLineSet *lineSet = (SoLineSet *) 
                        	stripKit->getPart("LineSet", TRUE);

	  SbVec3f *endPoints = new SbVec3f[4];
	  int numvertices[1] = {4}; 
	  float x[4], y[4];
	  McFSilXYLayer::SiXYPixelPosition(hits[i].hiticolX , hits[i].hitirowY,
	        	1, layerData, x,y);

	  for(int k = 0; k < 4; k++)
	  {
            (endPoints + k)->setValue(x[k], y[k], layerData.z + detectorData.z0);
	  }      
	  coords -> point.setValues(0,4,endPoints);
	  lineSet -> numVertices.setValues(0,1,numvertices);
	  hitsSeparator->addChild(stripKit);
          traceCoor->point.set1Value(i,traceHits[i].x,traceHits[i].y,
                                	traceHits[i].z);
     }    

      delete hits;
      delete traceHits;
      mainSeparator->addChild(hitsSeparator);
      mainSeparator->addChild(traceSeparator);
    }
    mainSeparator->unrefNoDelete();
    return mainSeparator;
    
}

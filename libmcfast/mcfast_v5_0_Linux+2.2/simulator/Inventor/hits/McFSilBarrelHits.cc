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
#include "McfastHitTypes.hh"
#include "hitsCommon.hh"
#include "pointsStruct.hh"
#include "SiBarrelCommon.hh"
#include "SilBarrelHitData.hh"
#include "SilBarrelData.hh"  //includes both layer and global silxy structures
void StripPosition(int iStrip, int factor, SilBarrelWaferData waferData,
                     SilBarrelLayerData layerData, float v1[3], float v2[3]);
SoSeparator *MakeSilBarrelHits(void)
{    
    
    SilBarrelGlobalData detectorData;
    SilBarrelLayerData layerData;
    SilBarrelWaferData waferData;
    SilBarrelHitData *hits = NULL;
    Points *traceHits = NULL;
    int layer, wafer;
    int numvertices = 2;
 
    SoSeparator *mainSeparator = new SoSeparator;
    mainSeparator->ref();

    int nhits = NumSilBarrelHits();
    if (nhits > 0) 
    {
  //Use one separator to hold the hit strip, the other to hold the trace points
      SoSeparator *hitsSeparator = new SoSeparator;
      SoSeparator *traceSeparator = new SoSeparator;


  //The trace points are displayed as points, make them larger than usual
  //with a distinct color from the strips.

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


      hits = new SilBarrelHitData[nhits];
      GetSilBarrelHits(hits);
      traceHits = new Points[nhits];
      GetTraceHits(JDEV_SIBARREL,traceHits);
      tracePoints->numPoints.setValue(nhits);


      for(int i = 0; i < nhits; i++)
      { 
          layer = WhichBarrelLayer(hits[i].hitDetector, hits[i].hitLayer);
          wafer = WhichBarrelWafer(hits[i].hitDetector, hits[i].hitLayer, 
                             hits[i].hitWafer);

          getSilBarrelGlobalData(hits[i].hitDetector, detectorData);
    	  getSilBarrelLayerData(layer, layerData);
	  getSilBarrelWaferData(wafer, waferData);

	  SoMcFSilStripHitKit *stripKit = new SoMcFSilStripHitKit();
          stripKit->hitid = hits[i].hitId;

	  SoMaterial *stripPlastic = 
                   (SoMaterial *) stripKit->getPart("Appearance.material",
                   TRUE);
          stripPlastic ->diffuseColor.setValue(1,0.5,1);

          SoTransform *transform = (SoTransform *)
                                  stripKit->getPart("Transform",TRUE);

          float phi = (2*M_PI*(float)(hits[i].hitWafer-1)/ 
                                   (float) layerData.nwafer);
          transform->translation.setValue(
                  layerData.delta*cos(phi + layerData.beta),
                  layerData.delta*sin(phi + layerData.beta),
                  detectorData.z0);

          SbVec3f axis;
          axis.setValue(0.,0.,1.0);
          transform->rotation.setValue(axis,
                  (phi+waferData.tilt
                   +layerData.beta));

          SoCoordinate3 *coords = (SoCoordinate3 *)
                                  stripKit->getPart("Coord3",TRUE);

          SoLineSet *lineSet = (SoLineSet *) 
                        	stripKit->getPart("LineSet", TRUE);

          SbVec3f *endPoints = new SbVec3f[2];
          float v1[3], v2[3];
          StripPosition(hits[i].hitStrip, 1, waferData, layerData, v1, v2);
          (endPoints)->setValue(v1[0], v1[1], v1[2]);
          (endPoints+1)->setValue(v2[0], v2[1], v2[2]);                   
          coords -> point.setValues(0,2,endPoints);
          lineSet -> numVertices.setValues(0,1,&numvertices);
          hitsSeparator->addChild(stripKit);

  //fill in coordinates for trace points
          traceCoor->point.set1Value(i,traceHits[i].x,traceHits[i].y,
                                	traceHits[i].z);

     }    

      delete hits;
      delete [] traceHits;
      mainSeparator->addChild(hitsSeparator);
      //mainSeparator->addChild(traceSeparator);
    }
    mainSeparator->unrefNoDelete();
    return mainSeparator;
    
}

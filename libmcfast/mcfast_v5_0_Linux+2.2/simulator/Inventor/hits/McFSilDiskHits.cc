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
#include "SiDiskCommon.hh"
#include "McfastHitTypes.hh"
#include "hitsCommon.hh"
#include "pointsStruct.hh"
#include "SilDiskStripPos.hh"
#include "SilDiskHitData.hh"
#include "SilDiskData.hh"  //includes both layer and global silxy structures
SoSeparator *MakeSilDiskHits(void)
{    
    
    SilDiskGlobalData detectorData;
    SilDiskLayerData layerData;
    SilDiskWedgeData wedgeData;
    SilDiskHitData *hits = NULL;
    Points *traceHits = NULL;
    int layer, wedge;

    SoSeparator *mainSeparator = new SoSeparator;
    mainSeparator->ref();

    int nhits = NumSilDiskHits();
    if(nhits > 0) 
    {

//Use one separator to hold the hit strip, the other to hold the trace points
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
      hits = new SilDiskHitData[nhits];
      traceHits = new Points[nhits]; 
      GetSilDiskHits(hits);
      GetTraceHits(JDEV_SILDISK,traceHits);

      for(int i = 0; i < nhits; i++)
      { 
          layer = WhichDiskLayer(hits[i].hitDetector, hits[i].hitLayer);
          wedge = WhichDiskWedges(hits[i].hitDetector, hits[i].hitLayer, 
                             hits[i].hitWedge);

          getSilDiskGlobalData(hits[i].hitDetector, detectorData);
    	  getSilDiskLayerData(layer, layerData);
	  getSilDiskWedgeData(wedge, wedgeData);

	  SoMcFSilStripHitKit *stripKit = new SoMcFSilStripHitKit();
          stripKit->hitid = hits[i].hitId;

	  SoMaterial *stripPlastic = 
                   (SoMaterial *) stripKit->getPart("Appearance.material",
                   TRUE);
          stripPlastic ->diffuseColor.setValue(0,1,1);

          SoTransform *transform = (SoTransform *)
                                  stripKit->getPart("Transform",TRUE);

          transform->translation.setValue(0, 0,
        	 layerData.zlocal + detectorData.z0);

          SbVec3f axis;
          axis.setValue(0.,0.,1.0);
	  float phi0 = layerData.phi[0] 
		     + (layerData.phi[1] - layerData.phi[0])
		     / (2*layerData.nwedge);


	  transform->rotation.setValue(axis,
	       ((hits[i].hitWedge-1)*(layerData.phi[1] -
	       layerData.phi[0])/layerData.nwedge +
			 phi0 ));


          SoCoordinate3 *coords = (SoCoordinate3 *)
                                  stripKit->getPart("Coord3",TRUE);

          SoLineSet *lineSet = (SoLineSet *) 
                        	stripKit->getPart("LineSet", TRUE);

          int stripno = hits[i].hitStrip;

          if(layerData.type == CIR || layerData.type == TRAP)
          {
             SbVec3f *endPoints = new SbVec3f[2];
             int numvertices[1] = {2}; 
             float v1[3], v2[3];
             if(layerData.type == CIR)
             {
        	 SiDiskCirStripPosition(stripno, 1, 
                      wedgeData, layerData, v1, v2);
             }
             else
             {
        	  SiDiskTrapStripPosition(stripno, 1, 
                       wedgeData, layerData, v1, v2);

             }

             (endPoints)->setValue(v1[0], v1[1], v1[2]);
             (endPoints+1)->setValue(v2[0], v2[1], v2[2]);
             coords -> point.setValues(0,2,endPoints);
             lineSet -> numVertices.setValues(0,1,numvertices);
             hitsSeparator->addChild(stripKit);
          }
          else if(layerData.type == PHI)
          {

	     SbVec3f * endPoints = new SbVec3f[4];
	     int numvertices[1] = {4};
	     float x[4], y[4];
             SiDiskPhiStripPosition(stripno, 1, wedgeData, layerData, x,y);
             for(int i = 0; i < 4; i++)
                   (endPoints + i)->setValue(x[i],y[i],0);

             coords -> point.setValues(0,4,endPoints);
             lineSet -> numVertices.setValues(0,1,numvertices);
             hitsSeparator->addChild(stripKit);
          }
          else if(layerData.type == RAD)
          {

	     SbVec3f * endPoints = new SbVec3f[5];
	     int numvertices[1] = {5};
	     float x[5], y[5];
             SiDiskRStripPosition(stripno, 1, wedgeData, layerData, x,y);
             for(int i = 0; i < 5; i++)
                   (endPoints + i)->setValue(x[i],y[i],0);

             coords -> point.setValues(0,5,endPoints);
             lineSet -> numVertices.setValues(0,1,numvertices);
             hitsSeparator->addChild(stripKit);

          }
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

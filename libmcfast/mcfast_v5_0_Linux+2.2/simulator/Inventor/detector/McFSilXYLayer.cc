#include <iostream.h>
#include <string.h>
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoCube.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodes/SoRotationXYZ.h>
#include <Inventor/nodes/SoTranslation.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/nodekits/SoNodeKitListPart.h>
#include <Inventor/nodekits/SoShapeKit.h>
#include <Inventor/nodes/SoCoordinate3.h>
#include <Inventor/nodes/SoLineSet.h>
#include "hepvis/SoMcFXYSilKit.hh"
#include "hepvis/SoMcFXYPlaneKit.hh"
#include "hepvis/SoMcFDetectorTreeKit.hh"
#include "McFDetectorTreeList.hh"
#include "McFDetDevice.hh"
#include "SiXYCommon.hh"
#include "McFSilXYLayer.hh"


void McFSilXYLayer::generateRepresentation
                                           (SilXYPlaneData data,
                                           SoMcFDetectorTreeKit *layerKit)
//represent a silicon layer as two planes separated by a gap.
//the preview representation shows the planes, the full representation
//shows the planes plus the segmentation.                                   
                                   
{    

    float xsize =  (data.xmax-data.xmin); 
    float ysize =  (data.ymax-data.ymin);
    
    if(data.xminGap != 0) 
                xsize = xsize/2. - (data.xmaxGap - data.xminGap)/2.;
 
    if(data.yminGap != 0) 
                ysize = ysize/2. - (data.ymaxGap - data.yminGap)/2.;


    SoMcFXYSilKit *silKit = new SoMcFXYSilKit();
    SoMaterial *RedPlastic = 
                 (SoMaterial *) layerKit->getPart("appearance.material", TRUE);
    RedPlastic ->diffuseColor.setValue(1,0,0);
    
    SoTransform *transform = (SoTransform *)
                                silKit->getPart("Transform",TRUE);
    transform->translation.setValue(0,0,data.z);
    
    

    // two plane kits
    SoMcFXYPlaneKit *planeKit1 = (SoMcFXYPlaneKit *)
                                     silKit->getPart("XYPlane1",TRUE);
    SoMcFXYPlaneKit *planeKit2 = (SoMcFXYPlaneKit *) 
                                     silKit->getPart("XYPlane2",TRUE);

    SoCube *plane = (SoCube *) planeKit1->getPart("Plane",TRUE);
    plane->width.setValue(xsize);
    plane->height.setValue(ysize);
    plane->depth.setValue(data.thick);

    plane = (SoCube *) planeKit2->getPart("Plane",TRUE);
    plane->width.setValue(xsize);
    plane->height.setValue(ysize);
    plane->depth.setValue(data.thick);
    
    SoTransform *transform1 = 
              (SoTransform *) planeKit1->getPart("Transform",TRUE);
    SoTransform *transform2 = 
              (SoTransform *) planeKit2->getPart("Transform",TRUE);
    
    if(data.xminGap == 0.0)
    {
       transform1->translation.setValue(0.,
       (data.ymin-data.yminGap)/2.+ data.yminGap,0.);
       transform2->translation.setValue(0.,
       (data.ymax-data.ymaxGap)/2.+ data.ymaxGap,0.);
    }
    else if(data.yminGap == 0)
    {
       transform1->translation.setValue(
            (data.xmin-data.xminGap)/2.+data.xminGap,0.,0.);
       transform2->translation.setValue(
             (data.xmax-data.xmaxGap)/2.+data.xmaxGap,0.,0.);
    
    } 
    else
    {
       cout << "The silicon xy layer is not physically two planes\n";
       cout << "please consult an McFast expert";
    }        
    
//set up the representations

    SoSeparator *previewSeparator = 
                   (SoSeparator *) layerKit->getPart("previewSeparator",TRUE); 
    previewSeparator->addChild(silKit); 
                    
    SoSeparator *fullSeparator = 
                   (SoSeparator *) layerKit->getPart("fullSeparator",TRUE);
    fullSeparator->addChild(silKit);
    SoSeparator *pixSep = new SoSeparator;
    SoMaterial *pixMat = new SoMaterial;
    pixMat->diffuseColor.setValue(0.0,0.5,0.5);
    SoDrawStyle *pixDrawStyle = new SoDrawStyle;
    pixSep->addChild(pixMat);
    pixSep->addChild(pixDrawStyle);
    pixSep->addChild(SiXYPixel(data));
    fullSeparator->addChild(pixSep);
    planeKit1->generateAlternateRep();
    planeKit2->generateAlternateRep();
    silKit->generateAlternateRep();
    layerKit->setPreview(TRUE);
    layerKit->generateAlternateRep();
 
    return;   
}


SoMcFDetectorTreeKit *McFSilXYLayer::AddToDetectorTree(int which,
                                        McFDetectorTreeList *mother,
                                        float &xmin, float &xmax, 
                                        float &ymin, float &ymax,
                                        float &zmin, float &zmax )
{
     SilXYPlaneData data;
     
     getSilXYPlaneData(which, data);
     xmin = data.xmin; xmax = data.xmax;
     ymin = data.ymin; ymax = data.ymax;
     zmin = data.z; zmax = data.z;
     
     McFDetectorTreeList *sixylayer = new McFDetectorTreeList;
     sixylayer->AddLeaf(mother);
     sixylayer->detector.deviceId = SIXYLYR;
     sixylayer->detector.whichOne = which;
     sprintf(sixylayer->detector.name, "Silayer_%d", which);
     
     SoMcFDetectorTreeKit *silKit = sixylayer->getDetectorKit();
     silKit->device = SIXYLYR;
     silKit->whichDevice = which;
     generateRepresentation(data, silKit);
     return silKit;
}

SoSeparator *McFSilXYLayer::SiXYPixel(SilXYPlaneData data)
{

    SoCoordinate3 *stripCoords = new SoCoordinate3;
    SoLineSet *stripLine = new SoLineSet;
    SbVec3f *endPoints;
    int *numvertices;
    SoSeparator *sep = new SoSeparator;
    sep->ref();
    int ncol, nrow, i, j;
    const int factor = 20;  //set distance between displayed strips
    ncol = data.nsegX/factor;
    nrow = data.nsegY/factor;
    endPoints = new SbVec3f[4*ncol*nrow];
    numvertices = new int[ncol*nrow];
    float x[4], y[4];
    for( i = 0; i<ncol; i++)
    {
      for( j = 0; j<nrow; j++)
      {

	SiXYPixelPosition(i, j, factor, data, x,y);
	for(int k = 0; k < 4; k++)
	{
          (endPoints + 4*(i*nrow+j) + k)->setValue(x[k], y[k], data.z);
	}      

	*(numvertices + (i*nrow+j)) = 4;                          
      }
    }

    stripCoords -> point.setValues(0,nrow*ncol*4,endPoints);
    stripLine -> numVertices.setValues(0,nrow*ncol,numvertices);

    sep->addChild(stripCoords);
    sep->addChild(stripLine);
    delete [] numvertices;
    
    return sep;
}                                        
void McFSilXYLayer::SiXYPixelPosition(int icol, int irow, int factor, 
                                      SilXYPlaneData data, 
                                      float x[4],float y[4])
{
  float x1, x2, y1, y2;
    
  x1 = (data.xmin + (icol*factor)*data.pitchX < data.xminGap) ?
       data.xmin + (icol*factor)*data.pitchX + data.startX :
       data.xmaxGap + (icol*factor - 0.5* data.nsegX)*data.pitchX
                    + data.startX;
       
  x2 = x1 + data.pitchX;

  y1 = (data.ymin + (irow*factor)*data.pitchY < data.yminGap) ?
       data.ymin + (irow*factor)*data.pitchY + data.startY:
       data.ymaxGap + (irow*factor - 0.5*data.nsegY)*data.pitchY
                    + data.startY;
       
  y2 = y1 + data.pitchY;
  
  x[0] = x1*cos(data.stereo) + y1*sin(data.stereo);
  y[0] = y1*cos(data.stereo) - x1*sin(data.stereo);
  x[2] = x2*cos(data.stereo) + y2*sin(data.stereo);
  y[2] = y2*cos(data.stereo) - x2*sin(data.stereo);
  
  x[1] = x[0];
  y[1] = y[2];
  
  x[3] = x[2];
  y[3] = y[0];
  return;
}

#include <math.h>
#include <iostream.h>
#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoCube.h>
#include <Inventor/nodes/SoCoordinate3.h>
#include <Inventor/nodes/SoLineSet.h>
#include <Inventor/nodekits/SoShapeKit.h>
#include <Inventor/nodes/SoTransform.h>
#include "McFDetectorTreeList.hh"
#include "McFDetDevice.hh"
#include "hepvis/SoMcFDetectorTreeKit.hh"
#include "hepvis/SoG4Cons.hh"
#include "SilBarrelData.hh"  //includes both layer and global silxy structures
#include "SiBarrelCommon.hh"
#include "McFSilBarrel.hh"


void upDateBoundingCylinder(float r1, float z1,
                         float &rmin, float &rmax, float &zlenmax);


SoMcFDetectorTreeKit *AddSiLayerToDetectorTree(int which,
                                  McFDetectorTreeList *mother,
                                  float &radius, float &length);
SoMcFDetectorTreeKit *AddSiWaferToDetectorTree(int whichLayer,
                                  McFDetectorTreeList *mother);
SoSeparator *SiStrips(SilBarrelWaferData waferData,
               SilBarrelLayerData layerData);
void StripPosition(int iStrip, int factor, SilBarrelWaferData waferData,
                     SilBarrelLayerData layerData, float v1[3], float v2[3]);
SoSeparator *SilBarrel(void)
{
    SoSeparator *barrel = new SoSeparator;
    barrel->ref();
    if(NumSilBarrel() > 0) 
    {
      McFDetectorTreeList *sibarrel = new McFDetectorTreeList;
      sibarrel->AddToTopOfTree();  //This is a high level "volume"
      sibarrel->detector.deviceId = SILBAR;
      sibarrel->detector.whichOne = 0;
      sibarrel->doContracted(TRUE);
      strcpy(sibarrel->detector.name, "SilBarrelHead");
      for(int i = 0; i < NumSilBarrel(); i++)
      {
          barrel->addChild(McFSilBarrel::AddToDetectorTree(i+1, sibarrel));
      }
    }
    barrel->unrefNoDelete();
    return barrel;
}
SoMcFDetectorTreeKit *McFSilBarrel::AddToDetectorTree(int which,
                                            McFDetectorTreeList *mother)
{
    SilBarrelGlobalData data;
    static int offset = 0;  //assume that the detectors are
                            // added in order and keep track of
                            // the offset for the layers
                            
    if(which == 1) offset = 0;  //reset offset for first device
                            
    //keep track of bounding information for preview represetation.
    float rmin, rmax;
    float zlenmax;
    float r1=0, z1=0;
    
    
    getSilBarrelGlobalData(which, data); //get data for barrel devices
    int nlyr = data.nlayer;
    McFDetectorTreeList *sibarrel = new McFDetectorTreeList;
    sibarrel->AddLeaf(mother);  //this is a subvolume of the SILBARREL branch
    sibarrel->detector.deviceId = SILBAR;
    sibarrel->detector.whichOne = which;
    getSiBarrelGlobalName(which, sibarrel->detector.name);

    //get the full separator and add the layers as children to it.
    SoMcFDetectorTreeKit *siBarrelKit = sibarrel->getDetectorKit();
    siBarrelKit->device = SILBAR;
    siBarrelKit->whichDevice = which; 
    SoSeparator *fullSeparator = 
                   (SoSeparator *) siBarrelKit->getPart("fullSeparator",TRUE);

    for (int i = 0; i < nlyr; i++)
    {
       fullSeparator->addChild(AddSiLayerToDetectorTree((offset+i+1),
                               sibarrel,
                               r1,z1));
       if( i == 0)
       {
          rmin = r1; rmax = r1, zlenmax = z1; 
       }
       else
       {
       upDateBoundingCylinder(r1, z1,
                         rmin, rmax, zlenmax );   
       }
    }
    offset += nlyr;
    
    //generate a preview representation for the detector that is just a cylinder
    //this will make it easy for people to get a representation that they
    //can rotate.
    SoSeparator *previewSeparator = 
                   (SoSeparator *) siBarrelKit->getPart("previewSeparator",TRUE);
 
    SoMaterial *Plastic = 
                 (SoMaterial *) siBarrelKit->getPart("appearance.material", TRUE);
    Plastic ->diffuseColor.setValue(0.79,0.82, 1.00);

    SoTransform *translation = (SoTransform *)
                                siBarrelKit->getPart("transform",TRUE);
    translation->translation.setValue(0.,0.,data.z0);

    SoG4Cons *cons = new SoG4Cons;
    cons->fRmin1 = rmin;
    cons->fRmin2 = rmin;
    cons->fRmax1 = rmax;
    cons->fRmax2 = rmax;
    cons->fDz = zlenmax/2.;
    cons->generateAlternateRep();
        
    previewSeparator->addChild(cons);

//The default representation is to show the planes, not the bounding box.
    siBarrelKit->generateAlternateRep();
    siBarrelKit->setPreview(FALSE);
    return (sibarrel->getDetectorKit());
    
}
void upDateBoundingCylinder(float r1, float z1,
                         float &rmin, float &rmax, float &zlenmax )
{
    if(rmin > r1) rmin = r1;
    if(rmax < r1) rmax = r1;
    if(zlenmax < z1) zlenmax = z1;
    return;
}
SoMcFDetectorTreeKit *AddSiLayerToDetectorTree(int which,
                                        McFDetectorTreeList *mother,
                                        float &radius, float &length)
{
     SilBarrelLayerData data;
     
     getSilBarrelLayerData(which, data);
     radius = data.delta;
     length = data.zlen;
     
     McFDetectorTreeList *siblayer = new McFDetectorTreeList;
     siblayer->AddLeaf(mother);
     siblayer->detector.deviceId = SIBLYR;
     siblayer->detector.whichOne = which;
     sprintf(siblayer->detector.name, "Siblayer_%d", which);
     
     SoMcFDetectorTreeKit *silKit = siblayer->getDetectorKit();
     silKit->device = SIBLYR;
     silKit->whichDevice = which; 

     //generate the preview representation
     
      SoSeparator *previewSeparator = 
                 (SoSeparator *)
                     silKit->getPart("previewSeparator",TRUE); 
      
      SoSeparator *fullSeparator = 
                 (SoSeparator *)
                     silKit->getPart("fullSeparator",TRUE); 

     if(!IsDoubleSiBLayer(which))
     {
       SoG4Cons *cons = new SoG4Cons();
       cons->fRmin1 = data.delta;
       cons->fRmin2 = data.delta;
       cons->fRmax1 = data.delta + data.thick;
       cons->fRmax2 = data.delta + data.thick;
       cons->fDz = data.zlen/2.;
       cons->generateAlternateRep();
       previewSeparator->addChild(cons);
     }
     
     fullSeparator->addChild(AddSiWaferToDetectorTree(which, siblayer));
     
    silKit->setPreview(FALSE);
    silKit->generateAlternateRep();
    return silKit;
}

SoMcFDetectorTreeKit *AddSiWaferToDetectorTree(int whichLayer,
                                        McFDetectorTreeList *mother)
{
//The layers don't know where the first wafer for that layer is
//in order to display the wafer, both layer and wafer info is needed

     // keep a pointer around to the last wafer so that double sided 
     // strips can be added.
     static SoMcFDetectorTreeKit *lastSilKit = NULL; 

     SilBarrelWaferData waferData;
     SilBarrelLayerData layerData;
     SoCube *cube;
     SoSeparator *strips, *siwafer, *sistrips;
     SoTransform *transform;
     getSilBarrelLayerData(whichLayer, layerData);
     
     int offset = 0;
     SoSeparator *preview, *full;  

     for(int which = whichLayer; which < NumSilBarrelWafers() + 1; which++)
     {
        getSilBarrelWaferData(which, waferData);

	if(waferData.ilyr ==  layerData.ilyr) break;  

     }
     if(which >= NumSilBarrelWafers() + 1) 
     {
         //opps, didn't find correct wafer
       cout << "Siwafer display: could not find correct wafer for layer "
            << whichLayer << endl;
        return NULL;
 
     }

     SbVec3f axis;
     axis.setValue(0.,0.,1.0);
//if the wafer type is all, just need to added one element to the tree
//for all n wafers.   If the wafer type is SPC, need to added one of all
//n wafers.

     SoMcFDetectorTreeKit *silKit;
     if (waferData.waferType == ALL)
     {
	 McFDetectorTreeList *sibwafer = new McFDetectorTreeList;
	 sibwafer->AddLeaf(mother);
	 sibwafer->detector.deviceId = SIBWAFER;
	 sibwafer->detector.whichOne = which;
	 sprintf(sibwafer->detector.name, "Sibwafer_%d", which);
          if(IsDoubleSiBLayer(whichLayer))
          {
              silKit = lastSilKit;
          }
          else
          {
              silKit = sibwafer->getDetectorKit();
              lastSilKit = silKit;
              silKit->device = SIBWAFER;
              silKit->whichDevice = which;
          }
         cube = new SoCube;
         cube->width = layerData.thick;
         cube->height = layerData.width;
         cube->depth = layerData.zlen;
         sistrips = SiStrips(waferData, layerData);
     }

     for(int i = 0; i < layerData.nwafer; i++)
     {
       if (waferData.waferType == SPC)
       {
        
	  McFDetectorTreeList *sibwafer = new McFDetectorTreeList;
	  sibwafer->AddLeaf(mother);
	  sibwafer->detector.deviceId = SIBWAFER;
	  sibwafer->detector.whichOne = which+offset;
	  sprintf(sibwafer->detector.name, "Sibwafer_%d", which);
          getSilBarrelWaferData(which + offset, waferData);
          silKit = sibwafer->getDetectorKit();
          silKit->device = SIBWAFER;
          silKit->whichDevice = which;
          cube = new SoCube;
          cube->width = layerData.width;
          cube->height = layerData.thick;
          cube->depth = layerData.zlen;
          sistrips = SiStrips(waferData, layerData);
          offset++;
       }

        transform = new SoTransform;

        transform->translation.setValue(
                layerData.delta*
                cos((2*M_PI*i/layerData.nwafer)+layerData.beta),
                layerData.delta*
                sin((2*M_PI*i/layerData.nwafer)+layerData.beta),
                0);

       transform->rotation.setValue(axis,
             (2*i*M_PI/layerData.nwafer+waferData.tilt
              +layerData.beta));

        full = (SoSeparator *) silKit->getPart("fullSeparator",TRUE);   

        if(!IsDoubleSiBLayer(whichLayer))
        {
           siwafer = new SoSeparator;
           siwafer->addChild(transform);
           siwafer->addChild(cube); 
           preview = (SoSeparator *) 
             silKit->getPart("previewSeparator",TRUE); 
         
          preview->addChild(siwafer);
          full->addChild(siwafer);
        }
        strips = new SoSeparator;
        strips->addChild(transform);
        strips->addChild(sistrips);
        full->addChild(strips);
      }
      silKit->setPreview(TRUE);
      silKit->generateAlternateRep();
      return silKit;  
}
SoSeparator *SiStrips(SilBarrelWaferData waferData,
                     SilBarrelLayerData layerData)
{

    SoCoordinate3 *stripCoords = new SoCoordinate3;
    SoLineSet *stripLine = new SoLineSet;
    SbVec3f *endPoints;
    int *numvertices;
    
    SoMaterial *stripMaterial = new SoMaterial;
    stripMaterial->diffuseColor.setValue(0.0, 0.0, 1.0); 

    int nstrips, i;

    SoSeparator *sep = new SoSeparator;
    sep->ref();
    sep->addChild(stripMaterial);

    nstrips = waferData.nstrip/20;
    endPoints = new SbVec3f[2*nstrips];
    numvertices = new int[nstrips];
    float v1[3], v2[3];
    for( i = 0; i<nstrips; i++)
    {
         StripPosition(i, 20, waferData, layerData, v1, v2);	
         (endPoints + 2*i)->setValue(v1[0], v1[1], v1[2]);
         (endPoints + 2*i +1)->setValue(v2[0], v2[1], v2[2]);                          
         *(numvertices + i) = 2;                          
    }

    stripCoords -> point.setValues(0,nstrips*2,endPoints);
    stripLine -> numVertices.setValues(0,nstrips,numvertices);

    sep->addChild(stripCoords);
    sep->addChild(stripLine);
    sep->unrefNoDelete();
    return sep;
}
void StripPosition(int iStrip, int factor, SilBarrelWaferData waferData,
                     SilBarrelLayerData layerData, float v1[3], float v2[3])
{

    //the nominal x measurement.  won't change
    float xnom = layerData.thick;

    if(layerData.type == 1 && (abs(waferData.stereo-M_PI/2.) > 0.001))
    {
	//first figure out 
	//the distance along x at zmax for the first wire
	//offset = 0 for stereo == 0 

	float offset = layerData.zlen*tan(waferData.stereo); 
		

	//the nominal z position of the measurement
	float zmin0 = -layerData.zlen/2., 
              zmax0 = layerData.zlen/2.;

	float yStart;
	if(cos(waferData.stereo) == 1)
        {
           yStart = waferData.c0x;
        }
        else
        {
	//the equation of the line for the 0th strip is y'=tan(stereo)*x'+b
	//where b is constrained by xtemp and ytemp
	
	//The intercept = waferData.c0x/cos(stereo);
	
	   float intercept = waferData.c0x/cos(waferData.stereo);
	
	//find the intial position in y at -zlen/2.
	   yStart = tan(waferData.stereo) * zmin0 + intercept;
        }

	//The distance along y to "next" wire
	//equals pitch for stereo = 0

	float deltaY = factor*waferData.pitch/cos(waferData.stereo);      


	//correction to z measurement when the x measurement
	//is greater than the wafer width 
	float zdelta, diff;           

        float ymin = yStart + iStrip*deltaY;
        float ymax = yStart + offset + iStrip*deltaY;
        float zpos = zmax0;
//        if( ymax > layerData.width/2.)
//        {
//           diff = ymax - layerData.width;
//           zdelta = diff/tan(waferData.stereo);
//           zpos = zmin0 + zdelta;
//           ymax = layerData.width;
//        }
        v1[0] = xnom;
        v1[1] = ymin;
        v1[2] = zpos;
        
        v2[0] = xnom;
        v2[1] = ymax;
        v2[2] = zmin0;
        return;                         
    }
    else if(layerData.type == 2 || (abs(waferData.stereo-M_PI/2.) < 0.001))
    {
	float deltaZ = factor*waferData.pitch;
        v1[0] = xnom;
        v1[1] = -layerData.width/2.;
        v1[2] = waferData.x0y + iStrip*deltaZ;
        
        v2[0] = xnom;
        v2[1] = layerData.width/2.;
        v2[2] = waferData.x0y + iStrip*deltaZ;
        return;
    }
    return;
    
}

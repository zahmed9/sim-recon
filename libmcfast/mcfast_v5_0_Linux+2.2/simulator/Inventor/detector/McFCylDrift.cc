#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/nodes/SoCoordinate3.h>
#include <Inventor/nodes/SoLineSet.h>
#include "McFDetectorTreeList.hh"
#include "hepvis/SoG4Cons.hh"
#include "McFDetDevice.hh"
#include "hepvis/SoMcFDetectorTreeKit.hh"
#include "ConicalDetectorData.hh"
#include "driftChamberData.hh"
#include "drftCommon.hh"
#include "McFCylDrift.hh"

SoSeparator *CylinderDrift(void)
{
    SoSeparator *xy = new SoSeparator;
    xy->ref();
    if(NumDrift() > 0)
    {
      McFDetectorTreeList *ftrk = new McFDetectorTreeList;
      ftrk->AddToTopOfTree();  //This is a high level "volume"
      ftrk->detector.deviceId = DRIFT;
      ftrk->detector.whichOne = 0;
      strcpy(ftrk->detector.name, "CylDriftHead");
      for(int i = 0; i < NumDrift(); i++)
      {
          xy->addChild(AddDriftToDetectorTree(i+1, ftrk));
      }
    }
    xy->unrefNoDelete();
    return xy;
}
SoMcFDetectorTreeKit *AddDriftToDetectorTree(int which,
                                            McFDetectorTreeList *mother)
{
    ConicalDetectorData data;
    static int offset = 0;  //assume that the detectors are
                            // added in order and keep track of
                            // the offset for the layers
                            
    if(which == 1) offset = 0;  //reset offset for first device
                                
    
    getDriftData(which, data); //get what data there is for SIXY devices
    int nlyr = NumDriftAnodeLayer(which);
    McFDetectorTreeList *dtrk = new McFDetectorTreeList;
    dtrk->AddLeaf(mother);  //this is a subvolume of the SIX branch
    dtrk->detector.deviceId = DRIFT;
    dtrk->detector.whichOne = which;
    dtrk->doContracted(TRUE);
    getDriftName(which, dtrk->detector.name);

    //get the full separator and add the layers as children to it.
    SoMcFDetectorTreeKit *dtrkKit = dtrk->getDetectorKit();
    dtrkKit->device = DRIFT;
    dtrkKit->whichDevice = which;
    SoSeparator *fullSeparator = 
                   (SoSeparator *) dtrkKit->getPart("fullSeparator",TRUE);

    for (int i = 0; i < nlyr; i++)
    {
       fullSeparator->addChild(AddAnodeLayerToDetectorTree((offset+i+1),
                               dtrk));
    }
    offset += nlyr;
    
    //generate a preview representation for the detector that is just a cylinder
    //this will make it easy for people to get a representation that they
    //can rotate.
    SoSeparator *previewSeparator = 
                   (SoSeparator *) dtrkKit->getPart("previewSeparator",TRUE);
 
    SoMaterial *Plastic = 
                 (SoMaterial *) dtrkKit->getPart("appearance.material", TRUE);
    Plastic ->diffuseColor.setValue(0.29,0.51,1.0);

    SoTransform *translation = (SoTransform *)
                                dtrkKit->getPart("transform",TRUE);
    translation->translation.setValue(0.,0.,data.z0);

    SoG4Cons *cons = new SoG4Cons;
    cons->fRmin1 = data.rminZlow;
    cons->fRmin2 = data.rminZhigh;
    cons->fRmax1 = data.rmaxZlow;
    cons->fRmax2 = data.rmaxZhigh;
    cons->fDz = data.zlen/2.;
        
    previewSeparator->addChild(cons);

//The default representation is to show the anode layers, not the bounding 
//cylinder
    dtrkKit->generateAlternateRep();
    dtrkKit->setPreview(FALSE);
    return (dtrkKit);
    
}

//the code for the layers:
SoMcFDetectorTreeKit *AddAnodeLayerToDetectorTree(int which,
                                            McFDetectorTreeList *mother)
{
    driftAnodeData data;
    driftOffsetData data1;

    getDriftAnodeData(which, data);
    getDriftOffsetData(which, data1);

    McFDetectorTreeList *layer = new McFDetectorTreeList;
    layer->AddLeaf(mother);
    layer->detector.deviceId = DRIFTANODE;
    layer->detector.whichOne = which;
    layer->doContracted(TRUE);

    sprintf(layer->detector.name, "dAnodelayer_%d", which);
 
    SoMcFDetectorTreeKit *layerKit = layer->getDetectorKit();
    layerKit-> device = DRIFTANODE;
    layerKit-> whichDevice = which;

    SoSeparator *previewSeparator = 
                   (SoSeparator *) layerKit->getPart("previewSeparator",TRUE);
    SoSeparator *fullSeparator = 
                   (SoSeparator *) layerKit->getPart("fullSeparator",TRUE);

    SoMaterial *Plastic = 
                (SoMaterial *) layerKit->getPart("appearance.material", TRUE);
    Plastic ->diffuseColor.setValue(0.7,0.93,1.0);

    
    SoG4Cons *cons = new SoG4Cons;
    cons->fRmin1 = data.radius;
    cons->fRmin2 = data.radius;
    cons->fRmax1 = data.radius + data.cellHeight;
    cons->fRmax2 = data.radius + data.cellHeight;
    cons->fDz = data.zlen/2.;
    
    cons->generateAlternateRep();
 
    fullSeparator->addChild(cylDriftWires(data, data1));
    fullSeparator->addChild(cons);
    previewSeparator->addChild(cons);

    layerKit->generateAlternateRep();
    layerKit->setPreview(TRUE);


     return layerKit;
}

SoSeparator *cylDriftWires(driftAnodeData anode, driftOffsetData offset)
{
   SoCoordinate3 *wireCoords = new SoCoordinate3;
   SoLineSet *wireLine = new SoLineSet;
   SbVec3f *endPoints;
   int *nvertices;
   int nwires = anode.nwires/20.;
   int npoints;
   nvertices = new int[nwires];
   if(anode.stereo == 0.0)
   {
      npoints = 2*nwires;
   }
   else
   {
      npoints = 10*nwires;
   }  
   endPoints = new SbVec3f[npoints];
   SbVec3f *points;
   int nvert;
   for( int i = 0; i<nwires; i++)
   {
	anodeWirePosition(i, 20, anode, offset, &points, nvert);
        wireCoords -> point.setValues(nvert*i,nvert,points);
	*(nvertices + i) = nvert;                          
   }
   wireLine -> numVertices.setValues(0,nwires,nvertices);


   SoMaterial *wireMaterial = new SoMaterial;
   wireMaterial->diffuseColor.setValue(0.29,0.51,1.00); 
   SoDrawStyle *style = new SoDrawStyle;
   style->lineWidth.setValue(2.0);
   SoSeparator *sep = new SoSeparator;
   sep->ref();
   sep->addChild(wireMaterial);
   sep->addChild(style);
   sep->addChild(wireCoords);
   sep->addChild(wireLine);
   sep->unrefNoDelete();
   return sep;
  

} 


void anodeWirePosition(int iStrip, int factor, driftAnodeData anode,
                       driftOffsetData offset, SbVec3f **points, int &nvert)


//no attempt to show any cell structure is made
{
    float dphi = 2*M_PI/anode.nwires;
    SbVec3f *temp;
    if(anode.stereo == 0)
    {
       nvert = 2;
       temp = new SbVec3f[nvert];
       temp[0].setValue(anode.radius*cos(dphi*iStrip*factor),
                          anode.radius*sin(dphi*iStrip*factor),
                          -anode.zlen/2.);
       temp[1].setValue(anode.radius*cos(dphi*iStrip*factor),
                          anode.radius*sin(dphi*iStrip*factor),
                          anode.zlen/2.);
       
    }
    else
    {
       nvert = 10;
       temp = new SbVec3f[nvert];
       float b = anode.radius*cos(anode.stereo)/sin(anode.stereo);
       float phiAngle = anode.zlen/b;
       float phi = 0;
       float delPhi = phiAngle/(float)(nvert-1);
       float StartPhi = dphi*iStrip*factor;
       for (int i = 0; i < nvert; i++)
       {
         temp[i].setValue(anode.radius*cos(phi + StartPhi),
                            anode.radius*sin(phi + StartPhi),
                            b*phi - anode.zlen/2.);         
          phi += delPhi;
       }
    }
    *points = temp;
    return;
}

#include <math.h>
#include <iostream.h>
#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoCoordinate3.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodes/SoLineSet.h>
#include <Inventor/nodekits/SoShapeKit.h>
#include <Inventor/nodes/SoTransform.h>
#include "McFDetectorTreeList.hh"
#include "McFDetDevice.hh"
#include "hepvis/SoMcFDetectorTreeKit.hh"
#include <Inventor/fields/SoSFFloat.h>
#include <Inventor/fields/SoSFLong.h>
#include "hepvis/SoG4Cons.hh"
#include "hepvis/SoMcFCons.hh"
#include "hepvis/SoMcFCirDiskWedge.hh"
#include "SilDiskData.hh"  //includes both layer and global silxy structures
#include "SiDiskCommon.hh"
#include "McFSilDisk.hh"
#include "SilDiskStripPos.hh"
void upDateBoundingCylinder(float r1, float r2, float z1, float z2,
                         float &rmin, float &rmax, float &zlenmax );

SoMcFDetectorTreeKit *AddSiDLayerToDetectorTree(int which,
                                        McFDetectorTreeList *mother,
                                        float &radiusMin, 
                                        float &radiusMax,
                                        float &zMin, float &zMax);
                                        
SoMcFDetectorTreeKit *AddSiDWedgeToDetectorTree(int whichLayer,
                                  McFDetectorTreeList *mother);
SoSeparator *SiDiskStrips(SilDiskWedgeData wedgeData,
                          SilDiskLayerData layerData);
SoSeparator *SilDisk(void)
{
    SoSeparator *disk = new SoSeparator;
    disk->ref();
    if(NumSilDisk() > 0)
    {
	McFDetectorTreeList *sidisk = new McFDetectorTreeList;
	sidisk->AddToTopOfTree();  //This is a high level "volume"
	sidisk->detector.deviceId = SILDISK;
	sidisk->detector.whichOne = 0;
	sidisk->doContracted(TRUE);
	strcpy(sidisk->detector.name, "SilDiskHead");
	for(int i = 0; i < NumSilDisk(); i++)
	{
	    disk->addChild(McFSilDisk::AddToDetectorTree(i+1, sidisk));
	}
    }
    disk->unrefNoDelete();
    return disk;
}
SoMcFDetectorTreeKit *McFSilDisk::AddToDetectorTree(int which,
                                            McFDetectorTreeList *mother)
{
    SilDiskGlobalData data;
    static int offset = 0;  //assume that the detectors are
                            // added in order and keep track of
                            // the offset for the layers
                            
    if(which == 1) offset = 0;  //reset offset for first device
                            
    //keep track of bounding information for preview represetation.
    float rmin, rmax;
    float zlenmax;
    float r1=0, z1=0, r2 = 0, z2 = 0;;
    
    
    getSilDiskGlobalData(which, data); //get data for disk devices
    int nlyr = data.nlayer;
    McFDetectorTreeList *sidisk = new McFDetectorTreeList;
    sidisk->AddLeaf(mother);  //this is a subvolume of the SILDISK branch
    sidisk->detector.deviceId = SILDISK;
    sidisk->detector.whichOne = which;
    getSiDiskGlobalName(which, sidisk->detector.name);

    //get the full separator and add the layers as children to it.
    SoMcFDetectorTreeKit *sidiskKit = sidisk->getDetectorKit();
    sidiskKit->device = SILDISK;
    sidiskKit->whichDevice = which;
    SoSeparator *fullSeparator = 
                   (SoSeparator *) sidiskKit->getPart("fullSeparator",TRUE);

    for (int i = 0; i < nlyr; i++)
    {
       fullSeparator->addChild(AddSiDLayerToDetectorTree((offset+i+1),
                               sidisk,
                               r1,r2,z1,z2));
       if( i == 0)
       {
          rmin = r1; rmax = r2, zlenmax = z2 - z1; 
       }
       else
       {
       upDateBoundingCylinder(r1, r2, z1, z2,
                         rmin, rmax, zlenmax );   
       }
    }
    offset += nlyr;
    
    //generate a preview representation for the detector that is just a cylinder
    //this will make it easy for people to get a representation that they
    //can rotate.
    SoSeparator *previewSeparator = 
                   (SoSeparator *) sidiskKit->getPart("previewSeparator",TRUE);
 
    SoMaterial *GreenPlastic = 
                 (SoMaterial *) sidiskKit->getPart("appearance.material", TRUE);
    GreenPlastic ->diffuseColor.setValue(1.00,0.65,0.81);

    SoTransform *translation = (SoTransform *)
                                sidiskKit->getPart("transform",TRUE);
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
    sidiskKit->generateAlternateRep();
    sidiskKit->setPreview(FALSE);
    return (sidisk->getDetectorKit());
    
}
void upDateBoundingCylinder(float r1, float r2, float z1, float z2,
                         float &rmin, float &rmax, float &zlenmax )
{
    if(rmin > r1) rmin = r1;
    if(rmax < r2) rmax = r2;
    if(zlenmax < (z2 - z1)) zlenmax = z2 - z1;
    return;
}
SoMcFDetectorTreeKit *AddSiDLayerToDetectorTree(int which,
                                        McFDetectorTreeList *mother,
                                        float &radiusMin, 
                                        float &radiusMax,
                                        float &zMin, float &zMax)
{
     SilDiskLayerData data;
     
     getSilDiskLayerData(which, data);
     radiusMin = data.rmin;
     radiusMax = data.rmax;
     zMin = data.zlocal - data.thick;
     zMax = data.zlocal + data.thick;
     
     
     McFDetectorTreeList *sidlayer = new McFDetectorTreeList;
     sidlayer->AddLeaf(mother);
     sidlayer->detector.deviceId = SIDLYR;
     sidlayer->detector.whichOne = which;
     sprintf(sidlayer->detector.name, "SiDlayer_%d", which);
     
     SoMcFDetectorTreeKit *silKit = sidlayer->getDetectorKit();
     silKit->device = SIDLYR;
     silKit->whichDevice = which;

     //move to the local z position
     SoTransform *transform = (SoTransform *)
                                silKit->getPart("transform",TRUE);
     transform->translation.setValue(0.,0.,data.zlocal);


     //generate the preview representation
     
      SoSeparator *previewSeparator = 
                 (SoSeparator *)
                     silKit->getPart("previewSeparator",TRUE); 
      
      SoSeparator *fullSeparator = 
                 (SoSeparator *)
                     silKit->getPart("fullSeparator",TRUE); 

     if(!IsDoubleSiDLayer(which))
     {
       SoG4Cons *cons = new SoG4Cons();
       cons->fRmin1 = data.rmin;
       cons->fRmin2 = data.rmin;
       cons->fRmax1 = data.rmax;
       cons->fRmax2 = data.rmax;
       cons->fDz = data.thick;
       cons->generateAlternateRep();
       previewSeparator->addChild(cons);
     }
     fullSeparator->addChild
        (AddSiDWedgeToDetectorTree(which, sidlayer));

     
     
    silKit->setPreview(TRUE);
    silKit->generateAlternateRep();
    return silKit;
}

SoMcFDetectorTreeKit *AddSiDWedgeToDetectorTree(int whichLayer,
                                        McFDetectorTreeList *mother)
{
//The layers don't know where the first wedge for that layer is
//in order to display the wedge, both layer and wedge info is needed

     // keep a pointer around to the last Wedge so that double sided 
     // strips can be added.
     static SoMcFDetectorTreeKit *lastSilKit = NULL; 

     SilDiskWedgeData wedgeData;
     SilDiskLayerData layerData;
     SoMcFCons *cons;
     SoMcFCirDiskWedge *diskWedge;

     SoSeparator *strips, *siwedge, *sistrips, *wedShape;
     SoTransform *transform;
     SbVec3f axis;
     axis.setValue(0.,0.,1.0);


     getSilDiskLayerData(whichLayer, layerData);
     
     int offset = 0;
     SoSeparator *preview, *full;  

     for(int which = whichLayer; which < NumSilDiskWedges() + 1; which++)
     {
        getSilDiskWedgeData(which, wedgeData);

	if(wedgeData.ilyr ==  layerData.ilyr) break;  

     }
     if(which >= NumSilDiskWedges() + 1) 
     {
         //opps, didn't find correct wedge
       cout << "Siwedge display: could not find correct wedge for layer "
            << whichLayer << endl;
        return NULL;  //returning NULL is bad idea--need to fix!
 
     }

//if the wedge type is all, just need to added one element to the tree
//for all n wedge.   If the wedge type is SPC, need to added one of all
//n wedges.

     SoMcFDetectorTreeKit *silKit;
     wedShape = new SoSeparator;
     SoTransform *transWedge = new SoTransform; 
       
     transWedge->rotation.setValue(axis,layerData.phi[0] 
                   + (layerData.phi[1] - layerData.phi[0])
                   / (2*layerData.nwedge));

     wedShape->addChild(transWedge);
     if (wedgeData.wedgeType == ALL)
     {
	 McFDetectorTreeList *sidwedge = new McFDetectorTreeList;
	 sidwedge->AddLeaf(mother);
	 sidwedge->detector.deviceId = SIDWEDGE;
	 sidwedge->detector.whichOne = which;
	 sprintf(sidwedge->detector.name, "Sidwedge_%d", which);
          if(IsDoubleSiDLayer(whichLayer))
          {
              silKit = lastSilKit;
          }
          else
          {
              silKit = sidwedge->getDetectorKit();
              lastSilKit = silKit;
              silKit -> device = SIDWEDGE;
              silKit -> whichDevice = which;
          }

         if(layerData.type == TRAP)
         {
	    cons = new SoMcFCons();
	    float r0min = layerData.rmin/cos(layerData.dphi/2);
            float r0max = layerData.rmax/cos(layerData.dphi/2);
	    cons->fRmin1 = r0min;
	    cons->fRmin2 = r0min;
	    cons->fRmax1 = r0max;
	    cons->fRmax2 = r0max;
	    cons->fDz = layerData.thick/2.;
	    cons->fSPhi = layerData.phi[0];
	    cons->fDPhi = layerData.dphi;
	    cons->nPhi  = 1;
	    cons->generateAlternateRep();
	    wedShape->addChild(cons);
	 }
	 else
	 {
	    diskWedge = new SoMcFCirDiskWedge();
	    diskWedge->fRmin = layerData.rmin;
	    diskWedge->fRmax = layerData.rmax;
	    diskWedge->fDz   = layerData.thick/2.;
	    diskWedge->fSPhi = layerData.phi[0];
	    diskWedge->fDPhi = layerData.dphi;
	    diskWedge->generateAlternateRep();
	    wedShape->addChild(diskWedge);
	 }

         sistrips = SiDiskStrips(wedgeData, layerData);
     }

     for(int i = 0; i < layerData.nwedge; i++)
     {
       if (wedgeData.wedgeType == SPC)
       {
        
	  McFDetectorTreeList *sidwedge = new McFDetectorTreeList;
	  sidwedge->AddLeaf(mother);
	  sidwedge->detector.deviceId = SIDWEDGE;
	  sidwedge->detector.whichOne = which+offset;
	  sprintf(sidwedge->detector.name, "SiDWedge_%d", which);
          getSilDiskWedgeData(which + offset, wedgeData);
          silKit = sidwedge->getDetectorKit();
          silKit -> device = SIDWEDGE;
          silKit -> whichDevice = which;
          if(layerData.type == TRAP)
          {
	    cons = new SoMcFCons();
	    cons->fRmin1 = layerData.rmin;
	    cons->fRmin2 = layerData.rmin;
	    cons->fRmax1 = layerData.rmax;
	    cons->fRmax2 = layerData.rmax;
	    cons->fDz = layerData.thick;
	    cons->fSPhi = layerData.phi[0];
	    cons->fDPhi = layerData.dphi;
	    cons->nPhi = 1;
	    cons->generateAlternateRep();
	    wedShape->addChild(cons);
	  }
	  else
	  {
	    diskWedge = new SoMcFCirDiskWedge();
	    diskWedge->fRmin = layerData.rmin;
	    diskWedge->fRmax = layerData.rmax;
	    diskWedge->fDz   = layerData.thick/2.;
	    diskWedge->fSPhi = layerData.phi[0];
	    diskWedge->fDPhi = layerData.dphi;
	    diskWedge->generateAlternateRep();
	    wedShape->addChild(diskWedge);
	  }
          sistrips = SiDiskStrips(wedgeData, layerData);
          offset++;
       }

        transform = new SoTransform; 

        float phi0 = layerData.phi[0] 
                   + (layerData.phi[1] - layerData.phi[0])
                   / (2*layerData.nwedge);
        
        transform->rotation.setValue(axis,
             -(i*(layerData.phi[1]-layerData.phi[0])
                 /layerData.nwedge)-phi0);

        full = (SoSeparator *) silKit->getPart("fullSeparator",TRUE);   

        if(!IsDoubleSiDLayer(whichLayer))
        {
           siwedge = new SoSeparator;
           siwedge->addChild(transform);
           siwedge->addChild(wedShape); 
           preview = (SoSeparator *) 
             silKit->getPart("previewSeparator",TRUE); 
         
          preview->addChild(siwedge);
          SoDrawStyle *style = (SoDrawStyle *) 
                          silKit->getPart("appearance.drawStyle",
                                                   TRUE);
          style->style = SoDrawStyle::LINES;
           full->addChild(siwedge);
	  strips = new SoSeparator;
	  SoMaterial *stripMaterial = new SoMaterial;
	  stripMaterial->diffuseColor.setValue(1.0, 0.0, 1.0); 
	  strips->addChild(stripMaterial);
	  strips->addChild(transform);
	  strips->addChild(sistrips);
	  full->addChild(strips);

        }
        else
        {
          //make the opposite strips a different color.
          strips = new SoSeparator;
	  SoMaterial *stripMaterial = new SoMaterial;
	  stripMaterial->diffuseColor.setValue(0.0, 0.0, 1.0); 
          strips->addChild(stripMaterial);
          strips->addChild(transform);
          strips->addChild(sistrips);
          full->addChild(strips);
        }
      }
      silKit->setPreview(TRUE);
      silKit->generateAlternateRep();
      return silKit;  
}
SoSeparator *SiDiskStrips(SilDiskWedgeData wedgeData,
                          SilDiskLayerData layerData)
{

    SoCoordinate3 *stripCoords = new SoCoordinate3;
    SoLineSet *stripLine = new SoLineSet;
    SbVec3f *endPoints;
    int *numvertices;
    
    const int factor = 20;  //set distance between displayed strips
    int nstrips, i;

    SoSeparator *sep = new SoSeparator;
    sep->ref();

    //what happens next strongly on the type of strip
    
    nstrips = wedgeData.nstrip/factor;

    if(layerData.type == RAD)
    {
	endPoints = new SbVec3f[5*nstrips];
	numvertices = new int[nstrips];
	float x[5], y[5];
	for( i = 0; i<nstrips; i++)
	{

          SiDiskRStripPosition(i, factor, wedgeData, layerData, x,y);

	  for(int j = 0; j < 5; j++)
	  {
               (endPoints + 5*i + j)->setValue(x[j], y[j], 0);
	  }      

          *(numvertices + i) = 5;                          
	}

	stripCoords -> point.setValues(0,nstrips*5,endPoints);
        stripLine -> numVertices.setValues(0,nstrips,numvertices);

        sep->addChild(stripCoords);
        sep->addChild(stripLine);
        delete [] numvertices;
         
    }
    else if(layerData.type == PHI)
    {
	endPoints = new SbVec3f[4*nstrips];
	numvertices = new int[nstrips];
	float x[5], y[5];
	for( i = 0; i<nstrips; i++)
	{

          SiDiskPhiStripPosition(i, factor, wedgeData, layerData, x,y);

	  for(int j = 0; j < 4; j++)
	  {
               (endPoints + 4*i + j)->setValue(x[j], y[j], 0);
	  }      

          *(numvertices + i) = 4;                          
	}

	stripCoords -> point.setValues(0,nstrips*4,endPoints);
        stripLine -> numVertices.setValues(0,nstrips,numvertices);

        sep->addChild(stripCoords);
        sep->addChild(stripLine);
//        delete [] numvertices;
    }
    else if(layerData.type == CIR || layerData.type == TRAP)
    {
	endPoints = new SbVec3f[2*nstrips];
	numvertices = new int[nstrips];
	float v1[3], v2[3];
	for( i = 0; i<nstrips; i++)
	{
             if(layerData.type == CIR)
             {
                SiDiskCirStripPosition(i, factor, 
                wedgeData, layerData, v1, v2);
             }	
             else
             {
                SiDiskTrapStripPosition(i, 
                factor, wedgeData, layerData, v1, v2);
             }
             (endPoints + 2*i)->setValue(v1[0], v1[1], v1[2]);
             (endPoints + 2*i +1)->setValue(v2[0], v2[1], v2[2]);                  

             *(numvertices + i) = 2;                          
	}

	stripCoords -> point.setValues(0,nstrips*2,endPoints);
        stripLine -> numVertices.setValues(0,nstrips,numvertices);

        sep->addChild(stripCoords);
        sep->addChild(stripLine);
//        delete [] numvertices;
         
    }

    sep->unrefNoDelete();
    return sep;
}
void SiDiskRStripPosition(int nstrip, int factor,
                          SilDiskWedgeData wedgeData,
                          SilDiskLayerData layerData, float x[5], float y[5])

{
     float deltaStrip = factor*wedgeData.pitch;
     float rmin = layerData.rmin+wedgeData.c0r+deltaStrip*nstrip;
     float deltaphi = layerData.dphi/4.;
     float phi = layerData.phi[0] - 0.5*layerData.dphi;
     for(int i = 0; i < 5; i++, phi+=deltaphi)
     {
        x[i] = rmin*cos(phi);
        y[i] = rmin*sin(phi);
     }
     return;
}
void SiDiskPhiStripPosition(int nstrip, int factor,
                            SilDiskWedgeData wedgeData,
                            SilDiskLayerData layerData,
                            float x[4], float y[4])
{
    float startPhi = factor*wedgeData.pitch*nstrip +
                     (layerData.phi[0] - 0.5*layerData.dphi);
    x[0] = layerData.rmin * cos(startPhi);
    y[0] = layerData.rmin * sin(startPhi);
    x[1] = layerData.rmax * cos(startPhi);
    y[1] = layerData.rmax * sin(startPhi);
    x[2] = layerData.rmin * cos(startPhi + wedgeData.pitch);
    y[2] = layerData.rmin * sin(startPhi + wedgeData.pitch);
    x[3] = layerData.rmax * cos(startPhi + wedgeData.pitch);
    y[3] = layerData.rmax * sin(startPhi + wedgeData.pitch);
    
}
void SiDiskTrapStripPosition(int nstrip, int factor, 
                             SilDiskWedgeData wedgeData, 
                             SilDiskLayerData layerData, float v1[3], float
                             v2[3])
{
   //adjust radius for dead regions      
//      float r0min = (layerData.rmin + wedgeData.c0r)/cos(layerData.dphi/2);
//      float r0max = (layerData.rmax - wedgeData.c0r)/cos(layerData.dphi/2);
    //Based on trk_make_sidisk_hit in MCFast as of 6/18/97, it looks as if
    //strips are counted from the edge of the wedge.  Strips that exist within
    //the dead area (c0_r,c0_phi) will not have hits. 
      float r0min = (layerData.rmin)/cos(layerData.dphi/2);
      float r0max = (layerData.rmax)/cos(layerData.dphi/2);
      float startAngle = wedgeData.stereo; 
      float wedgeAngle = layerData.dphi/2.;
      float increment;
      increment = factor*wedgeData.pitch/cos(startAngle);

  //find the equations for the edges of the wedge, by definition, the
  //the intercept is 0. 

      float slopeWedge1 = sin(wedgeAngle)/cos(wedgeAngle);
      float slopeWedge2 = -slopeWedge1;
      float ymin = r0min*sin(wedgeAngle);
      float xStMin = r0min*cos(wedgeAngle);
      float xStMax = r0max*cos(wedgeAngle);
      float yStMin = r0min*sin(wedgeAngle);
      float yStMax = r0max*sin(wedgeAngle);
      
  
  //find the strip coordinates.  Z coordinate is 0 as the strip lies on 
  //the plane.    

      float yNomMin = yStMin+ nstrip * increment;
            
      float yNomMax = (wedgeData.stereo > 0.) ? 
                        -yStMax + nstrip * increment:
                        yStMax - nstrip * increment;       

      //calculate the slope and intercept of the strip
      float stSlope = tan(wedgeData.stereo);
      float stIntercept = yNomMax - xStMax*stSlope;

      v1[0] = xStMin;
      v1[1] = stSlope*v1[0] + stIntercept;
      v1[2] = 0.0;
      
      v2[0] = xStMax;
      v2[1] = yNomMax;
      v2[2] = 0.0;     
      
      if(v1[1] > ymin && slopeWedge1 != stSlope)
      {
          
          v1[0] = stIntercept/(slopeWedge1 - stSlope);
          v1[1] = stSlope*v1[0] + stIntercept;

      }
      else if (v1[1] < -ymin && slopeWedge2 != stSlope)
      {
          
          v1[0] = stIntercept/(slopeWedge2 - stSlope);
          v1[1] = stSlope*v1[0] + stIntercept;
      }

      return;
}
void SiDiskCirStripPosition(int nstrip, int factor,
                             SilDiskWedgeData wedgeData, 
                             SilDiskLayerData layerData, float v1[3], 
                             float v2[3])
{

//This is a lot of fun!  Calculate the strip position as for the 
//trapizodal case, then calculate where the strip intersects the circle

   //adjust radius for dead regions      
      float r0min = (layerData.rmin + wedgeData.c0r) * cos(wedgeData.c0phi);
      float r0max = (layerData.rmax - wedgeData.c0r) * cos(wedgeData.c0phi);
      float wedgeAngle = layerData.dphi/2.;
 //increment is the multiplication factor for the pitch
      float increment = factor*wedgeData.pitch/cos(wedgeData.stereo);

  //find the equations for the edges of the wedge, by definition, the
  //the intercept is 0. 

      float slopeWedge1 = sin(wedgeAngle)/cos(wedgeAngle);
      float slopeWedge2 = -slopeWedge1;
      float ymin = r0min*sin(wedgeAngle);
      float xStMin = r0min*cos(wedgeAngle);
      float xStMax = r0max*cos(wedgeAngle);
      float yStMin = r0min*sin(wedgeAngle);
      float yStMax = r0max*sin(wedgeAngle);


      float yNomMax = (wedgeData.stereo > 0.) ? 
                        -yStMax + nstrip * increment:
                        yStMax - nstrip * increment;       

      //calculate the slope and intercept of the strip
      float stSlope = tan(wedgeData.stereo);
      float stIntercept = yNomMax - stSlope*xStMax;
      
      //find intersection with circle
       
      v1[0] = (r0min > fabs(stIntercept)) ? 
             sqrt(
              (r0min * r0min - stIntercept *stIntercept)
              /(stSlope * stSlope + 1) +
              (pow((stSlope*stIntercept)/(stSlope*stSlope + 1),2))
             ) 
             - stSlope*stIntercept/(stSlope*stSlope+1) 
             : xStMin ;

      v1[1] = stSlope*v1[0] + stIntercept;
      v1[2] = 0.0;
      
      v2[0] = sqrt
             (
              (r0max * r0max - stIntercept *stIntercept)
              /(stSlope * stSlope + 1) +
              (pow((stSlope*stIntercept)/(stSlope*stSlope + 1),2))
             )
             - stSlope*stIntercept/(stSlope*stSlope+1);   
      v2[1] = stSlope*v2[0] + stIntercept;
      v2[2] = 0.0;

      if(v1[1] > ymin && slopeWedge1 != stSlope)
      {
          
          v1[0] = stIntercept/(slopeWedge1 - stSlope);
          v1[1] = stSlope*v1[0] + stIntercept;

      }
      else if (v1[1] < -ymin && slopeWedge2 != stSlope)
      {
          
          v1[0] = stIntercept/(slopeWedge2 - stSlope);
          v1[1] = stSlope*v1[0] + stIntercept;
      }

      return;

}

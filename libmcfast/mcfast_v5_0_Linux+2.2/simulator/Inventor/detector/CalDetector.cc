#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/fields/SoSFFloat.h>
#include <Inventor/fields/SoSFInt32.h>
#include "McfUtilities.hh"
#include "calorCommon.hh"
#include "McfCalGeomManager.hh"
#include "McfCalGeomDisplay.hh"
#include "hepvis/SoMcFCalCellKit.hh"
#include "hepvis/SoMcFConsKit.hh"
#include "hepvis/SoMcFDetectorTreeKit.hh"
#include "hepvis/SoG4Cons.hh"
#include "McFDetectorTreeList.hh"
#include "McFDetDevice.hh"
#include "CalDetector.hh"
#include <iostream.h>
SoSeparator *CalDetectors(void)
{
    int i;
    SoSeparator *calorimeters = new SoSeparator;
    calorimeters->ref();
    if(NumCalorProj() > 0 )
    {
      McFDetectorTreeList *calor = new McFDetectorTreeList;
      calor->AddToTopOfTree();  //This is a high level "volume"
      calor->detector.deviceId = SILBAR;
      calor->detector.whichOne = 0;
      calor->doContracted(TRUE);
      strcpy(calor->detector.name, "ProjCalorHead");
      for (i=0; i < NumCalorProj(); i++)
      {
          calorimeters->addChild(AddProjCalorimeter(i+1, calor));
      }
    }
    calorimeters->unrefNoDelete();
    return calorimeters;
}

SoMcFDetectorTreeKit *AddProjCalorimeter(int which,
                                            McFDetectorTreeList *mother)
{


    McFDetectorTreeList *list = new McFDetectorTreeList;
    SoMcFDetectorTreeKit *CalKit = list->getDetectorKit();
 
    McfCalGeomDisplay *calGeom = McfCalGeomManager::getCal(which);

    if(calGeom == 0)
    {
       cout << "EMcal #" << which << "is not correctly defined for display"
       << endl;
       return CalKit;
    }
    list->AddLeaf(mother);  //this is a subvolume 
    list->detector.deviceId = CALORIMETER;
    list->detector.whichOne = which;
    getCalorName(which, list->detector.name);
    
    CalKit->device = CALORIMETER;
    CalKit->whichDevice = which; 
    SoSeparator *previewSeparator = 
                   (SoSeparator *) CalKit->getPart("previewSeparator",TRUE);    
    SoSeparator *fullSeparator = 
                   (SoSeparator *) CalKit->getPart("fullSeparator",TRUE);
                   
    //Global Properties
    SoMaterial *RedPlastic = 
                 (SoMaterial *) CalKit->getPart("appearance.material", TRUE);
                 
    RedPlastic ->diffuseColor.setValue(1,0,0);
    SoTransform *Transform = (SoTransform *) CalKit->getPart("transform", TRUE);
    calGeom->setDetectorTranslation(Transform);
    
    //Preview representation
    
    calGeom->setPreviewRepresentation(previewSeparator);    
    //Full representation
   for (int ieta = 0; ieta < calGeom->nseg2(); ieta++)
    {
       for( int iphi = 0; iphi < calGeom->nseg1(); iphi += calGeom->nseg1()/2.)
       {
          SoMcFCalCellKit *cellKit = new SoMcFCalCellKit;
          cellKit->cellIeta.setValue(ieta);
          cellKit->cellIphi.setValue(iphi);
          cellKit->cellIcal.setValue(which);
          cellKit->generateCellRepresentation(calGeom);

          SoDrawStyle *style = (SoDrawStyle *) 
                          cellKit->getPart("appearance.drawStyle",TRUE);
          style->style = SoDrawStyle::LINES;

          SoMaterial *material = (SoMaterial *)
                          cellKit->getPart("appearance.material",TRUE);
          material->diffuseColor.setValue(0.,0.,1.);
          cellKit->generateAlternateRep();
          fullSeparator->addChild(cellKit);
       }
    }


    CalKit->generateAlternateRep();
    CalKit->setPreview(TRUE);
    return CalKit;
    
}


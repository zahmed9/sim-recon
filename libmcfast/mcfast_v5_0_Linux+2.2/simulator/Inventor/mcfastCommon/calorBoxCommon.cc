#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoCylinder.h>
#include <Inventor/nodes/SoCone.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodes/SoTransform.h>
#include "hepvis/SoMcFCalCellKit.hh"
#include <math.h>
#ifndef MCFAST_DB
#define MCFAST_DB
#include "mcfast_db.h"
#endif
#include "McFDetectorTreeList.hh"
#include "McFDetDevice.hh"
#include "hepvis/SoMcFDetectorTreeKit.hh"

#include <iostream.h>
#include "calorBoxCommon.hh"
#include "McFBoxCal.hh"
int NumCalorBox(void)
{
    return *n_obj_calorbox;
}
void getCalorBoxData(int which, boxCalData &data) 
{
      data.z0 = calorbox[which-1].z0;

      data.xLenInner = (calorbox[which-1].xlimit_gap[1] 
                        - calorbox[which-1].xlimit_gap[0])/2.;
      data.yLenInner = (calorbox[which-1].ylimit_gap[1] 
                        - calorbox[which-1].ylimit_gap[0])/2.;
      data.xLenOuter = (calorbox[which-1].xlimit[1] 
                        - calorbox[which-1].xlimit[0])/2.;
      data.yLenOuter = (calorbox[which-1].ylimit[1] 
                        - calorbox[which-1].ylimit[0])/2.;

      data.zLenInner = (calorbox[which-1].zlen)/2.;
      data.zLenOuter = (calorbox[which-1].zlen)/2.;
      data.nSeg1 = calorbox[which-1].ncr1;
      data.nSeg2 = calorbox[which-1].ncr2;
      

      return;
}
void getCalorBoxName(int which, char *name)
{
    strcpy(name, calorbox[which-1].name);
    return;      
}
SoSeparator *CalorBox(void)
{
    SoSeparator *calBox = new SoSeparator;
    calBox->ref();
//make the head of the dipole detectors
    if(NumCalorBox() > 0)
    {
      McFDetectorTreeList *CalorBox = new McFDetectorTreeList;
      CalorBox->AddToTopOfTree();  //This is a high level "volume"
      CalorBox->detector.deviceId = CALORXY;
      CalorBox->detector.whichOne = 0;
      strcpy(CalorBox->detector.name, "BoxCalHead");

      for(int i = 0; i < NumCalorBox(); i++)
      {
          calBox->addChild(AddCalorBoxToDetectorTree((i+1), CalorBox));
      }
    }
    calBox->unrefNoDelete();
    return calBox;
 
}
SoMcFDetectorTreeKit *AddCalorBoxToDetectorTree(int which, 
                                              McFDetectorTreeList *mother )
{
    boxCalData data1;
    getCalorBoxData(which, data1);
    McFBoxCal *calGeom = new McFBoxCal;
    calGeom->setCalData(data1); 
        
                                       //fortran common
    McFDetectorTreeList *cal = new McFDetectorTreeList;
    cal->AddLeaf(mother);  //This is a "daughter"
    cal->detector.deviceId = CALORXY;
    cal->detector.whichOne = which;
    getCalorBoxName(which, cal->detector.name);
        
    SoMcFDetectorTreeKit *calKit = cal->getDetectorKit();
    calKit->device = CALORXY;
    calKit->whichDevice = which;
    SoSeparator *preview = 
                   (SoSeparator *) calKit->getPart("previewSeparator",TRUE); 


    SoSeparator *full = 
                   (SoSeparator *) calKit->getPart("fullSeparator",TRUE); 

    SoTransform *transform = (SoTransform *)
                                calKit->getPart("transform",TRUE);
    calGeom->setDetectorTranslation(transform);


//make the box.  
    SoMaterial *Material = (SoMaterial *)
                               calKit->getPart("appearance.material", TRUE);
    Material->diffuseColor.setValue(0.5,0.0,1.0);
    
    SoDrawStyle *style = new SoDrawStyle; 
    style->style = SoDrawStyle::FILLED;
    style->lineWidth.setValue(2.0); //make the line a little thicker thicker
    SoSeparator *calSep = new SoSeparator;
    preview->addChild(calSep);
    
    calSep->addChild(style);
    calGeom->setPreviewRepresentation(calSep);

    for(int ix = 0; ix < calGeom->nseg1(); ix++)
    {
        for(int iy = 0; iy < calGeom->nseg1(); iy++)
	{
          SoMcFCalCellKit *cellKit = new SoMcFCalCellKit;
          cellKit->cellIeta.setValue(iy);
          cellKit->cellIphi.setValue(ix);
          cellKit->cellIcal.setValue(which);
          cellKit->generateCellRepresentation(calGeom);

          SoDrawStyle *style = (SoDrawStyle *) 
                          cellKit->getPart("appearance.drawStyle",TRUE);
          style->style = SoDrawStyle::LINES;

          SoMaterial *material = (SoMaterial *)
                          cellKit->getPart("appearance.material",TRUE);
          material->diffuseColor.setValue(0.,0.,1.);
          cellKit->generateAlternateRep();
          full->addChild(cellKit);
	}
    }
 
    calKit->setPreview(TRUE);
    calKit->generateAlternateRep();

    return calKit;
    
}

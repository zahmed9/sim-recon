#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodes/SoTransform.h>
#include "McfCalGeomManager.hh"
#include "McfCalGeomDisplay.hh"
#include "Calorimeter.hh"
#include "calorCommon.hh"
#include "projectiveCalData.hh"
#include "SoMcFCalCellKit.hh"
#include "SoG4Cons.hh"

SoSeparator *Calorimeter::calEtaView(int ncal, int *pical)
{
     int ical, ieta, iphi;
     char string[132];
     
     SoSeparator *View = new SoSeparator;
     View->ref();

     sprintf(string,"CalEtaView");
     SbName *calName = new SbName(string);

     if(ncal == 0) return View;
     for( ical = 0; ical < ncal; ical++ )
     {
        McfCalGeomDisplay *calGeom = McfCalGeomManager::CalGeom(ical+1);
        SoSeparator *sep = new SoSeparator;
        SoTransform *trans = new SoTransform;
	calGeom->setDetectorTranslation(trans);
        sep->addChild(trans);
        View->addChild(sep);
        for( ieta = 0; ieta < getNEtaSegments( *(pical + ical)); ieta++ )
        {
            for ( iphi = 0; 
                  iphi < getNPhiSegments( *(pical + ical)); 
                  iphi += getNPhiSegments( *(pical + ical))/2 )
            {
               SoMcFCalCellKit *cellKit = new SoMcFCalCellKit;
               cellKit->cellIeta.setValue(ieta);
               cellKit->cellIphi.setValue(iphi);
               cellKit->cellIcal.setValue(ical + 1);
               cellKit->generateCellRepresentation(calGeom);

               SoDrawStyle *style = (SoDrawStyle *) 
                          cellKit->getPart("appearance.drawStyle",TRUE);
               style->style = SoDrawStyle::LINES;

               SoMaterial *material = (SoMaterial *)
                          cellKit->getPart("appearance.material",TRUE);
               material->diffuseColor.setValue(0.,0.,1.);
               cellKit->generateAlternateRep();
               sep->addChild(cellKit);
             }
                                                     
        }
	delete calGeom;
     }
     View->setName(*calName);
     View->unrefNoDelete();
     return View; 
}
SoSeparator *Calorimeter::calPhiView(int ncal, int *pical)
{
     int ical, iphi;
     char string[132];
     
     SoSeparator *View = new SoSeparator;

     sprintf(string,"CalPhiView");
     SbName *calName = new SbName(string);

     if(ncal == 0) return View;
     for( ical = 0; ical < ncal; ical++ )
     {
        McfCalGeomDisplay *calGeom = McfCalGeomManager::CalGeom(ical+1);
        SoSeparator *sep = new SoSeparator;
        SoTransform *trans = new SoTransform;
        calGeom->setDetectorTranslation(trans);
        sep->addChild(trans);
        View->addChild(sep);
        for ( iphi = 0; 
              iphi < getNPhiSegments( *(pical + ical)); 
              iphi++ )
        {
               SoMcFCalCellKit *cellKit = new SoMcFCalCellKit;
               cellKit->cellIeta.setValue(-1);
               cellKit->cellIphi.setValue(iphi);
               cellKit->cellIcal.setValue(ical + 1);
               cellKit->generateCellRepresentation(calGeom);

               SoDrawStyle *style = (SoDrawStyle *) 
                          cellKit->getPart("appearance.drawStyle",TRUE);
               style->style = SoDrawStyle::LINES;

               SoMaterial *material = (SoMaterial *)
                          cellKit->getPart("appearance.material",TRUE);
               material->diffuseColor.setValue(0.,0.,1.);
               
               cellKit->generateAlternateRep();
               sep->addChild(cellKit);
        }
        
     }
     View->setName(*calName);
     return View; 
}
SoSeparator *Calorimeter::calSimpleView(int ncal)
{
     int ical;
     SoSeparator *View = new SoSeparator;
     View->ref();
     SoDrawStyle *frameStyle = new SoDrawStyle;
     frameStyle->style = SoDrawStyle::LINES;
     View->addChild(frameStyle);
     
     for( ical = 0; ical < ncal; ical++ )
     {
         McfCalGeomDisplay *calGeom = McfCalGeomManager::CalGeom(ical+1);
         SoSeparator *sep = new SoSeparator;
         SoTransform *trans = new SoTransform;
         calGeom->setDetectorTranslation(trans);
         sep->addChild(trans);
         calGeom->setPreviewRepresentation(sep);
	 View->addChild(sep);
     }
     View->unrefNoDelete();
     return View;
     
}

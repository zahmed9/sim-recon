#include <Inventor/nodes/SoGroup.h>
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoSwitch.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/nodes/SoCube.h>
#include <Inventor/nodekits/SoShapeKit.h>
#include "calPlot.hh"
#include "SoMcFCalCellKit.hh"
#include "SoMcFCalEnergyKit.hh"
#include "calorCommon.hh"
#include "McfCalGeomManager.hh"
#include "McfCalGeomDisplay.hh"
const float ZEROSEP = 0.05;

SoSeparator *calPlot::FillInEnergy(void)
{
    SoSeparator *calHits = new SoSeparator;
    calHits->ref();
    
    for (int ihit = 0; ihit < energy->NumberOfHits(); ihit++)
    {
       SoSwitch *Switch = new SoSwitch;
       Switch->whichChild = SO_SWITCH_NONE;
       
       
       float cellEnergy = energy->energyMin(ihit) +
                          energy->energyHad(ihit) +
                          energy->energyEm(ihit);
       if(cellEnergy > ZEROSEP)
       {
	 SoMcFCalEnergyKit *energyKit = new SoMcFCalEnergyKit();
	 float cellEt = 
               energy->transEnergy(cellEnergy,energy->AddressOfHit(ihit));

	 energyKit->minEnergy.setValue(energy->energyMin(ihit));
	 energyKit->hadEnergy.setValue(energy->energyHad(ihit));
	 energyKit->emEnergy.setValue(energy->energyEm(ihit));
	 energyKit->cellEt.setValue(cellEt);

	 SoMcFCalCellKit *cellKit = (SoMcFCalCellKit *) 
                        	 energyKit->getPart("calCellKit", TRUE);
	 cellKit->cellIcal.setValue(energy->CalOfHit(ihit) + 1);
	 cellKit->cellIeta.setValue(energy->EtaOfHit(ihit));
	 cellKit->cellIphi.setValue(energy->PhiOfHit(ihit));

	 McfCalGeomDisplay *calGeom = 
	 McfCalGeomManager::CalGeom(energy->CalOfHit(ihit) + 1);
	 SoTransform *trans = (SoTransform *)
                           cellKit->getPart("transform", TRUE);
  	 calGeom->setDetectorTranslation(trans);
	 cellKit->generateCellRepresentation
                	(calGeom);
         

	 cellKit->generateAlternateRep();
	 energyKit->generateAlternateRep();
	 Switch->addChild(energyKit);       
	 calHits->addChild(Switch);
       }
          
    } 
    calHits->unrefNoDelete();
    return calHits;  
}

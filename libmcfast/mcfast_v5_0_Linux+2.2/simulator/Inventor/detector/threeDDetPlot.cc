#include <Inventor/nodes/SoSwitch.h>
#include "threeDDetPlot.hh"
#include "CalDetector.hh"
#include "McFSilBarrel.hh"
#include "McFSilDisk.hh"
#include "McFSilXY.hh"
#include "McFFtrk.hh"
#include "McFZRect.hh"
#include "McFCylDrift.hh"
#include "muonCommon.hh"
#include "absorberCommon.hh"
#include "absorberBoxCommon.hh"
#include "calorBoxCommon.hh"
#include "dipoleCommon.hh"
#include "Detector.hh"
#include "beampipeCommon.hh"
#include "solenoidCommon.hh"
int threeDDetPlot::hasBeenCreated=0;
SoSwitch *threeDDetPlot::detector;
SoSwitch *threeDDetPlot::makeDetector(void)
        {
	    if(hasBeenCreated == 1) return detector;
            Detector();  //make the head of the tree
            hasBeenCreated = 1;
	    detector = new SoSwitch;
            SoSeparator *sep = new SoSeparator;
            sep->addChild(SilBarrel());
            sep->addChild(SilDisk());
            sep->addChild(CylinderDrift());
            sep->addChild(Absorber());
            sep->addChild(AbsorberBox());
            sep->addChild(CalorBox());
            sep->addChild(Dipole());
            sep->addChild(CalDetectors());
            sep->addChild(Muon());
            sep->addChild(SilXY());
            sep->addChild(ForwardTracker());
            sep->addChild(Beampipe());
            sep->addChild(Solenoid());
            sep->addChild(SilZRect());
            detector->addChild(sep);
            return detector;
        }

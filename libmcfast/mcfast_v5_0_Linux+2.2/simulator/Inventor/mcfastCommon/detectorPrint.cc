#include <strstream.h>
#include <iostream.h>
#include "stringMax.hh"

#include "detectorPrint.hh"
#include "McFDetDevice.hh"

#include "absorberPrint.hh"
#include "absorberBoxPrint.hh"
#include "beampipePrint.hh"
#include "calorBoxPrint.hh"
#include "calorPrint.hh"
#include "dipolePrint.hh"
#include "drftPrint.hh"
#include "ftrkPrint.hh"
#include "muonPrint.hh" 
#include "SiBarrelPrint.hh"
#include "SiDiskPrint.hh"
#include "SiZRectPrint.hh"
#include "siXYPrint.hh"
#include "solenoidPrint.hh"

char *printNotComplete(void);
char *printNodevice(void);
char *printDetector( McFDetDevice device, int which)
{
     if(device == NODEVICE)
     {
        return printNodevice();
     }
     else if(device == SILBAR)
     {
          return printBarrelInfo(which);
     }
     else if( device == SIBLYR)
     {
          return printLayerInfo(which);
     }
     else if(device == SIBWAFER)
     {
          return printWaferInfo(which);
     }
     else if(device == SILXY)
     {
          return printSiXYPlane(which);
     }
     else if(device == SIXYLYR)
     {
         return printSiXYPlane(which);
     }
     else if(device == SILDISK)
     {
          return printDiskInfo(which);
     }
     else if(device == SIDLYR)
     {
          return printDLyrInfo(which);
     }
     else if(device == SIDWEDGE)
     {
          return printWedgeInfo(which);
     }
     else if(device == SILZRECT)
     {
          return printSilZRectInfo(which);
     }
     else if(device == SILZRECTLYR)
     {
          return printSilZRectLayerInfo(which);
     }
     else if(device == SILZRECTWAFER)
     {
          return printSilZRectWaferInfo(which);
     }
     else if(device == FTRACK )
     {   
          return printFtrkInfo(which);
     }
     else if(device == FTRACKLYR)
     {   
          return printFtrkLayerInfo(which);
     }
     else if(device == ABSORBER)
     {   
          return printAbsorberInfo(which);
     }
     else if(device == ABSORBERXY)
     {   
          return printAbsorberBoxInfo(which);
     }
     else if(device == MUON)
     {   
          return printMuonInfo(which);
     }
     else if(device == DIPOLE)
     {   
          return printDipoleInfo(which);
     }
     else if(device == CALORXY)
     {   
          return printCalorBoxInfo(which);
     }
     else if(device == CALORIMETER)
     {   
          return printCalorInfo(which);
     }
     else if(device == SOLENOID)
     {   
          return printSolenoidInfo(which);
     }
     else if(device == BEAMPIPE)
     {   
          return printBeampipeInfo(which);
     }
     else if(device == DRIFT)
     {   
          return printDriftInfo(which);
     }
     else if(device ==  DRIFTANODE)
     {   
          return printDriftAnodeInfo(which);
     }
     else if(device == DRIFTCATHODE)
     {   
          return printDriftCathodeInfo(which);
     }
     else
     {
         return printNotComplete();
     }
}
char *printNodevice(void)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);
    
    out << "This is a placeholder device that does not" << endl
        << "correspond to a valid MCFAST device" << endl;
    out << '\000';
    return output; 
     
}

char *printNotComplete(void)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);
    
    out << "Printing is not enabled for this device" << endl;
    out << '\000';
    return output; 
     
}

#include <iostream.h>
#include <stdio.h>
#include <Inventor/Xt/SoXt.h>
#include <Inventor/nodes/SoGroup.h>
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/fields/SoSFFloat.h>
#include <Inventor/fields/SoSFLong.h>
#include "hepvis/SoG4Cons.hh"
#include "hepvis/SoMcFCons.hh"
#include "hepvis/SoMcFCirDiskWedge.hh"
#include "hepvis/SoDetectorTreeKit.hh"
#include "hepvis/SoMcFDetectorTreeKit.hh"
#include "hepvis/SoMcFCalCellKit.hh"
#include "hepvis/SoMcFCalEnergyKit.hh"
#include "hepvis/SoMcFCalBlockKit.hh"
#include "hepvis/SoMcFConsKit.hh"
#include "hepvis/SoMcFXYSilKit.hh"
#include "hepvis/SoMcFXYPlaneKit.hh"
#include "hepvis/SoMcFBoxWithGap.hh"
#include "hepvis/SoMcFSilStripHitKit.hh"
#include "hepvis/SoMcFTraceKit.hh"
#include "hepvis/SoMcFZRectWaferKit.hh"
#include <Xm/Xm.h>
#include <Xm/RowColumn.h>
#include <Xm/MainW.h>
#include "mcfMainPanel.hh"
#include "McfMainMenu.hh"
#include "mcfFile.hh"
extern "C" {
#include "DialogF.h"
}
void McfMainMenu::McfGetStarted(char *filename)
{
     Widget mainWindow = SoXt::init("Inventor");
     if (mainWindow == NULL) exit(1);

   //initalize new So classes
     SoG4Cons::initClass();
     SoMcFCons::initClass();
     SoMcFCirDiskWedge::initClass();
     SoDetectorTreeKit::initClass();
     SoMcFDetectorTreeKit::initClass();
     SoMcFSilStripHitKit::initClass();
     SoMcFTraceKit::initClass();
     SoMcFCalCellKit::initClass();
     SoMcFCalEnergyKit::initClass();
     SoMcFCalBlockKit::initClass();
     SoMcFConsKit::initClass();
     SoMcFZRectWaferKit::initClass();
     SoMcFBoxWithGap::initClass();
     SoMcFXYSilKit::initClass();
     SoMcFXYPlaneKit::initClass();

     if(filename != NULL)
     {
	if( strstr( filename, ".db" ) != NULL )
	{
             mcfFile::readDbin(filename);
             mcfFile::setFilename(filename);
	}
	else //try to read an mcfio file
	{
           int stream; 
           stream = mcfFile::OpenMcfioFile(filename);
           if(stream < 0)
           {
             DialogF(DF_INF, SoXt::getTopLevelWidget(), 1,
            "Invalid file, please open a file from the menu",
            "OK");  
           }
           else 
           {
              mcfFile::setFilename(filename);
              mcfFile::setStream(stream);
              mcfFile::GetNextEvent();
           }
	}

     }
     mcfMainPanel *mainPanel = new mcfMainPanel(mainWindow);
     
      
     SoXt::show(mainWindow);
     SoXt::mainLoop();

}

#ifndef ABSBOXCOMMON
#define ABSBOXCOMMON
#include <Inventor/nodes/SoSeparator.h>
#include "hepvis/SoMcFDetectorTreeKit.hh"
#include "McFDetectorTreeList.hh"
#include "frameDetectorData.hh"

int NumAbsorberBox(void);
void getAbsorberBoxData(int which, frameDetectorData &data); 
void getAbsorberBoxName(int which, char *name);


SoSeparator *AbsorberBox(void);
SoMcFDetectorTreeKit *AddAbsorberBoxToDetectorTree(int which, 
                                             McFDetectorTreeList *mother );
#endif

#ifndef CALBOXCOMMON
#define CALBOXCOMMON
#include <Inventor/nodes/SoSeparator.h>
#include "hepvis/SoMcFDetectorTreeKit.hh"
#include "McFDetectorTreeList.hh"
#include "boxCalData.hh"

int NumCalorBox(void);
void getCalorBoxData(int which, boxCalData &data);
void getCalorBoxName(int which, char *name);


SoSeparator *CalorBox(void);
SoMcFDetectorTreeKit *AddCalorBoxToDetectorTree(int which, 
                                             McFDetectorTreeList *mother );
#endif

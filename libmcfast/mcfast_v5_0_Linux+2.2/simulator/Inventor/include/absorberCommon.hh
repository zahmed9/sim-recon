#ifndef ABSORBERCOMMON
#define ABSRORBERCOMMON
#include <Inventor/nodes/SoSeparator.h>
#include "ConicalDetectorData.hh"
#include "hepvis/SoMcFDetectorTreeKit.hh"

class McFDetectorTreeList;
void getAbsorberDetectorData(int which, ConicalDetectorData &data);
void getAbsorberDetectorName(int which, char *name);
int NumAbsorber(void);
SoSeparator *Absorber(void);
SoMcFDetectorTreeKit *AddAbsorberToDetectorTree(int which,
                      McFDetectorTreeList *mother);
#endif

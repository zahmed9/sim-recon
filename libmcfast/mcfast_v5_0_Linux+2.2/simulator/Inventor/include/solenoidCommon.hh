#ifndef SOLENOIDCOMMON
#define SOLENOIDCOMMON
#include <Inventor/nodes/SoSeparator.h>
#include "hepvis/SoMcFDetectorTreeKit.hh"

struct ConicalDetectorData;
class McFDetectorTreeList;

void getSolenoidDetectorData(int which, ConicalDetectorData &data);
void getSolenoidDetectorName(int which, char *name);
int NumSolenoid(void);
SoSeparator *Solenoid(void);
SoMcFDetectorTreeKit *AddSolenoidToDetectorTree(int which, 
                                            McFDetectorTreeList *mother);
#endif

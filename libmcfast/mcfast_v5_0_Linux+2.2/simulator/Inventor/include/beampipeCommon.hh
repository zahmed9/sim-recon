#ifndef BEAMPIPECOMMON
#define BEAMPIPECOMMON
#include <Inventor/nodes/SoSeparator.h>
#include "hepvis/SoMcFDetectorTreeKit.hh"
class McFDetectorTreeList;
struct ConicalDetectorData;

void getBeampipeDetectorData(int which, ConicalDetectorData &data);
void getBeampipeDetectorName(int which, char *name);
int getNumBeampipe(void);
SoSeparator *Beampipe(void);
SoMcFDetectorTreeKit *AddBeampipeToDetectorTree(int which, 
                                            McFDetectorTreeList *mother);
#endif

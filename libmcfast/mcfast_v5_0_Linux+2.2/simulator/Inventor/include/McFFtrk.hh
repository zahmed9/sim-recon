#include <Inventor/nodes/SoSeparator.h>
#ifndef MCFFTRK
#define MCFFTRK
class SoMcFDetectorTreeKit;
class McFDetectorTreeList;

SoSeparator *ForwardTracker(void);
SoMcFDetectorTreeKit *AddFtrkToDetectorTree(int which,
                                            McFDetectorTreeList *mother);
                                            
SoMcFDetectorTreeKit *AddFtrkLayerToDetectorTree(int which,
                                            McFDetectorTreeList *mother);
#endif

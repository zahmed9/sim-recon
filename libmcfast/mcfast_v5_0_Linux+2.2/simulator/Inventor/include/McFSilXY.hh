//this class has no member data
//Get all geometry information from the McFio commons.
#include <Inventor/nodes/SoSeparator.h>
#include "McFDetectorTreeList.hh"
#ifndef MCFSILXY
#define MCFSILXY
SoSeparator *SilXY(void);

class SoMcFDetectorTreeKit;

class McFSilXY
{
   public:
   static SoMcFDetectorTreeKit *AddToDetectorTree(int which,
                                            McFDetectorTreeList *mother);
};
#endif

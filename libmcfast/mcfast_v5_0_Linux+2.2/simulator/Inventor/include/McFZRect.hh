//this class has no member data
//Get all geometry information from the McFio commons.
#ifndef MCFSILZRECT
#define MCFSILZRECT

class SoMcFDetectorTreeKit;
class McFDetectorTreeList;
class SoSeparator;
class SoMcFPixel;

SoSeparator *SilZRect(void);

SoMcFDetectorTreeKit *AddSilZRectToTree(int which,
                                            McFDetectorTreeList *mother);
#endif

#ifndef CALDETECTOR
#define CALDETECTOR
class SoSeparator;
class SoMcFDetectorTreeKit;
class McFDetectorTreeList;

SoSeparator *CalDetectors(void);
SoMcFDetectorTreeKit *AddProjCalorimeter(int which,
                                            McFDetectorTreeList *mother);
#endif

#ifndef MCFCYLDRIFT
#define MCFCYLDRIFT
struct driftAnodeData;
struct driftOffsetData;
class SbVec3f;
class SoSeparator;
class SoMcFDetectorTreeKit;
class McFDetectorTreeList;
SoSeparator *CylinderDrift(void);
SoMcFDetectorTreeKit *AddDriftToDetectorTree(int which,
                                            McFDetectorTreeList *mother);
SoMcFDetectorTreeKit *AddAnodeLayerToDetectorTree(int which,
                                            McFDetectorTreeList *mother);
SoSeparator *cylDriftWires(driftAnodeData anode, driftOffsetData offset);
void anodeWirePosition(int iStrip, int factor, driftAnodeData anode,
                       driftOffsetData offset, SbVec3f **points, int &nvert);
#endif

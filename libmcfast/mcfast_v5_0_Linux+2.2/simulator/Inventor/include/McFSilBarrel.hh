#ifndef MCFSILBARREL
#define MCFSILBARREL
SoSeparator *SilBarrel(void);
class SoMcFDetectorTreeKit;
class McFDetectorTreeList;
class McFSilBarrel
{
    public:
    static SoMcFDetectorTreeKit *McFSilBarrel::AddToDetectorTree(int which,
                                                McFDetectorTreeList *mother);
};
#endif

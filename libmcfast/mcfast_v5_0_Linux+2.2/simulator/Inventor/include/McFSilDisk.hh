#ifndef MCFSILDISK
#define MCFSILDISK
SoSeparator *SilDisk(void);
class SoMcFDetectorTreeKit;
class McFDetectorTreeList;
class McFSilDisk
{
    public:
    static SoMcFDetectorTreeKit *McFSilDisk::AddToDetectorTree(int which,
                                                McFDetectorTreeList *mother);
};
#endif

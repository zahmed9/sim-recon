#ifndef ABSZRECTWAFER
#define ABSZRECTWAFER
class SoCube;
class absZRectLayer;
class McFDetectorTreeList;
class SoMcFDetectorTreeKit;
struct SilZRectWaferData;
enum stagger;
class absZRectWafer
{
   public:
   absZRectWafer(void)
   {
      return;
   }
   ~absZRectWafer(){return;}
    SoCube *MakeSiZRectWafer(SilZRectWaferData waferData);
    float absZRectWafer::zTile(stagger Pattern, int icol, int irow);
    virtual SoMcFDetectorTreeKit *MakeSiZRectWaferRep(int whichLayer,
                                 int whichWafer,
                                 absZRectLayer *zRectLayer,
                                 McFDetectorTreeList *mother) = 0;
    int absZRectWafer::findPixelXYPosition(int IxPix, int IyPix,
                                       SilZRectWaferData waferData,
				       float &x, float &y);
};
#endif

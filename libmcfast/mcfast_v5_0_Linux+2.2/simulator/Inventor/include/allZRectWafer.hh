#ifndef ALLZRECTWAFER
#define ALLZRECTWAFER
#include "absZRectWafer.hh"
class allZRectWafer : public absZRectWafer
{
   public:
   allZRectWafer(void):absZRectWafer()
   {
      return;
   }
   SoMcFDetectorTreeKit *MakeSiZRectWaferRep(int whichLayer,
                                 int whichWafer,
                                 absZRectLayer *zRectLayer,
                                 McFDetectorTreeList *mother);
   ~allZRectWafer()
   {
      return;
   }
};
#endif

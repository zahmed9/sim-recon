#ifndef SPCZRECTWAFER
#define SPCZRECTWAFER
#include "absZRectWafer.hh"
class spcZRectWafer : public absZRectWafer
{
   public:
   spcZRectWafer(void):absZRectWafer()
   {
      return;
   }
   SoMcFDetectorTreeKit *MakeSiZRectWaferRep(int whichLayer,
                                 int whichWafer,
                                 absZRectLayer *zRectLayer,
                                 McFDetectorTreeList *mother);
   ~spcZRectWafer()
   {
      return;
   }
};
#endif

#ifndef ZRECTWITHHOLE
#define ZRECTWITHHOLE
#include "absZRectLayer.hh"
class ZRectWithHole : public absZRectLayer
{
    public:
     ZRectWithHole():absZRectLayer(){return;}
     int findWaferXYPosition(int Icol, int Irow, 
                                  SilZRectLayerData layerData,
                                  SilZRectWaferData waferData,
                                  float &x, float &y);
     SoSeparator *makeSiZRectLayer
                             (void);

     ~ZRectWithHole(){return;}
};	
#endif

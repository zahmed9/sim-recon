#ifndef ONEZRECTPLANE
#define ONEZRECTPLANE
#include "absZRectLayer.hh"
class oneZRectPlane : public absZRectLayer
{
    public:
     oneZRectPlane():absZRectLayer(){return;}
     int findWaferXYPosition(int Icol, int Irow, 
                                  SilZRectLayerData layerData,
                                  SilZRectWaferData waferData,
                                  float &x, float &y);
     SoSeparator *makeSiZRectLayer
                             (void);

     ~oneZRectPlane(){return;}
};	
#endif

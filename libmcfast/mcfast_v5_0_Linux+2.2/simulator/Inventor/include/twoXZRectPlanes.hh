#ifndef TWOXZRECTPLANES
#define TWOXZRECTPLANES
#include "absZRectLayer.hh"
class twoXZRectPlanes : public absZRectLayer
{
    public:
     twoXZRectPlanes():absZRectLayer(){return;}
     int findWaferXYPosition(int Icol, int Irow, 
                                  SilZRectLayerData layerData,
                                  SilZRectWaferData waferData,
                                  float &x, float &y);
     SoSeparator *makeSiZRectLayer
                             (void);

     ~twoXZRectPlanes(){return;}
};	
#endif

#ifndef TWOYZRECTPLANES
#define TWOYZRECTPLANES
#include "absZRectLayer.hh"
class twoYZRectPlanes : public absZRectLayer
{
    public:
     twoYZRectPlanes():absZRectLayer(){return;}
     int findWaferXYPosition(int Icol, int Irow, 
                                  SilZRectLayerData layerData,
                                  SilZRectWaferData waferData,
                                  float &x, float &y);
     SoSeparator *makeSiZRectLayer
                             (void);

     ~twoYZRectPlanes(){return;}
};	
#endif

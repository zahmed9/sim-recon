#ifndef ABSZRECTLAYER
#define ABSZRECTLAYER
#include "SilZRectData.hh"  //includes both layer and global sil structures
class SoSeparator;
class SoMcFDetectorTreeKit;
class McFDetectorTreeList;
class absZRectLayer
{
     protected:
     SilZRectLayerData layerData;
       
     public:     
     absZRectLayer(void){return;}
     
     virtual int findWaferXYPosition(int Icol, int Irow, 
                                  SilZRectLayerData layerData,
                                  SilZRectWaferData waferData,
                                  float &x, float &y) = 0;
     virtual SoSeparator *makeSiZRectLayer(void) = 0;
     SoMcFDetectorTreeKit *makeSiZRectLayerRep
                     (int which, McFDetectorTreeList *mother);
     
     ~absZRectLayer(){return;}
     
     float deadX(SilZRectLayerData layerData, 
                                 SilZRectWaferData waferData);
     float deadY(SilZRectLayerData layerData, 
                           SilZRectWaferData waferData);
     void waferNumber(int wafer, SilZRectLayerData layerData, int &icol, 
                      int &irow)
     {
         icol = (int) fmod(wafer - 1, layerData.nwaferX);
	 irow = (int) (wafer - 1)/layerData.nwaferY;
     }	   
};
#endif

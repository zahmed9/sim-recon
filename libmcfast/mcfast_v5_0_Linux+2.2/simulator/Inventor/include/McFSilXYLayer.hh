#include "hepvis/SoMcFDetectorTreeKit.hh"
#include "SilXYPlaneData.hh"
class SoSeparator;
class SoMcFDetectorTreeKit;
class McFDetectorTreeList;

//this class has no member data
//Get all geometry information from the McFio commons.
#ifndef MCFSILXYLAYER
#define MCFSILXYLAYER
class McFSilXYLayer
{
   public:
    static void generateRepresentation(SilXYPlaneData data,
                                           SoMcFDetectorTreeKit *silKit);
   
    static SoMcFDetectorTreeKit *AddToDetectorTree(int which,
                                        McFDetectorTreeList *mother,
                                        float &xmin, float &xmax, 
                                        float &ymin, float &ymax,
                                        float &zmin, float &zmax );
   static SoSeparator *SiXYPixel(SilXYPlaneData data);
   static void SiXYPixelPosition(int icol, int irow, int factor, SilXYPlaneData data, 
                   float x[4],float y[4]);

};
#endif

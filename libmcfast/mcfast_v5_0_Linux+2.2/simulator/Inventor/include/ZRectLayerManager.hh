//this class exists for the sole purpose of figuring out what type of 
//layer under consideration.
#ifndef ZRECTLAYERMANAGER
#define ZRECTLAYERMANAGER
#include <stdio.h>
#include <iostream.h>
#include "absZRectLayer.hh"
#include "ZRectWithHole.hh"
#include "oneZRectPlane.hh"
#include "twoXZRectPlanes.hh"
#include "twoYZRectPlanes.hh"
#include "SilZRectData.hh"  //includes both layer and global sil structures
#include "SiZRectCommon.hh"
class ZRectLayerManager
{
    public:
    static absZRectLayer *getLayerType(int which)
    {
        ZRectLayerType type = getSilZRectLayerType(which);
        if( type == HOLE) return ( new ZRectWithHole());
        
        if( type == TWOX) return ( new twoXZRectPlanes());
        if( type == TWOY) return ( new twoYZRectPlanes());
        if( type == ONE)  return ( new oneZRectPlane());
        //if undefined type (which can't happen) 
        cout << "Z Rect layer definition does not conform to standard types"
        << endl << "Check defination of layer number " << which << endl
        << "Graphics assuming single plane" << endl;
        return (new oneZRectPlane());
    }
    
};
#endif

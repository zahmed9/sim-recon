
//this class exists for the sole purpose of figuring out what type of 
//wafer is under consideration.
#ifndef ZRECTWAFERMANAGER
#define ZRECTWAFERMANAGER
#include "absZRectWafer.hh"
#include "allZRectWafer.hh"
#include "spcZRectWafer.hh"
#include "SilZRectData.hh"  //includes both layer and global sil structures
#include "SiZRectCommon.hh"
class ZRectWaferManager
{
    public:
    static absZRectWafer *getWaferType(int which)
    {
        //if it's not SPC, assume it's ALL--It has to be one or the other.
        if(getSilZRectWaferType(which) == SPC)
        {
           return ( new spcZRectWafer());
           
        }
        else return( new allZRectWafer());
    }
};
#endif

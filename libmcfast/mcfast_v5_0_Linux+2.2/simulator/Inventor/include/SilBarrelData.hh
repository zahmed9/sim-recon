#ifndef SILBARRELDATA
#define SILBARRELDATA
const int ALL = 0;
const int SPC = 1;
struct SilBarrelGlobalData
{
    float z0;
    int nlayer;
    
};
struct SilBarrelLayerData
{
    float zlen;
    float beta; //phi angle from the x axis to center of wafer 1
    float delta; //radial distance in xy plane to center of each wafer
    float thick;
    float width;
    int ilyr;
    int type;
    int nwafer;
};
struct SilBarrelWaferData
{
    float tilt;
    float c0x;
    float x0y;
    float pitch;
    float stereo;
    int nstrip;
    int waferType;
    int ilyr;    
};
#endif

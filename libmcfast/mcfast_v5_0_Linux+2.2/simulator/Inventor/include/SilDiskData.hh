#ifndef SILDISKDATA
#define SILDISKDATA
const int ALL = 0;
const int SPC = 1;
struct SilDiskGlobalData
{
    float z0;
    int nlayer;
    
};
struct SilDiskLayerData
{
    float zlocal;
    float thick;
    float rmin;
    float rmax;
    float phi[2];
    float dphi;
    int type;
    int nwedge;
    int ilyr;
};
struct SilDiskWedgeData
{
    float c0r;
    float c0phi;
    float pitch;
    float stereo;
    int nstrip;
    int wedgeType;
    int ilyr;    
};
#endif

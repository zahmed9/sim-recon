#ifndef SILXYPLANEDATA
#define SILXYPLANEDATA
struct SilXYPlaneData
{
         float z; 
         float thick;
         float stereo;
         float xmin; 
         float xmax; 
         float ymin; 
         float ymax;
         float xminGap; 
         float xmaxGap; 
         float yminGap; 
         float ymaxGap;
         int   nsegX;
         int   nsegY;
         float pitchX;
         float pitchY;
         float startX;
         float startY;
};
#endif
#ifndef SILXYGLOBALDATA
#define SILXYGLOBALDATA
struct SilXYGlobalData
{
         float z0;
         int nlayer;
};
#endif

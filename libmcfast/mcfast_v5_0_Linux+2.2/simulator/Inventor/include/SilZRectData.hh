#ifndef SILZRECTGLOBALDATA
#define SILZRECTGLOBALDATA
const int ALL = 0;
const int SPC = 1;
//The staggering of the wafers is handled in the following fashion.  If
//the staggering pattern is 'X', alternating columns are offset by 2*waferData.
//zoffset with the first column at zoffset, the second columm at -zoffset.
//The Y staggering pattern works the similarily in rows
//The checkerboard pattern alternates every other tile. 
enum stagger {XTILE, YTILE, CHECKER, NOTILE};
enum ZRectLayerType {HOLE, TWOX, TWOY, ONE};
enum MEASTYPE {PIXEL = 1, STRIP};
struct SilZRectGlobalData
{
   int nlayer;
   float xpos;
   float ypos;
   float zpos;   
};
struct SilZRectLayerData
{
   int nwaferX;
   int nwaferY;
   float zLocal;
   float rotation;    //rotation about the z axis?
   float lenXLayer;	   //length of layer
   float lenYLayer;
   float lenXGap;
   float lenYGap;
   float thick;
   float startXWafer;
   float startYWafer;
   stagger pattern;  
};
struct SilZRectWaferData
{
   int waferNumX;    //wafer number in X
   int waferNumY;    //wafer number in y
   int measureType;  //pixel or strip
   float stereo;      //Strip orientation wrt to wafer x axis
   float lenXWaf;  //the length of the wafers in x,y,z
   float lenYWaf;
   float thick;
   float zOffset;   //offset of first wafer from nominal z layer
   float nsegX;
   float nsegY;
   float pitchX;
   float pitchY;
   float startXPixel;
   float startYPixel;   
};
#endif

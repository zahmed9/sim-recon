#ifndef DRIFTCHAMBERDATA
#define DRIFTCHAMBERDATA
struct driftAnodeData
{
      int detector;
      int layer;
      int nwires;
      float radius;
      float zlen;
      float cellHeight;
      float phi0;
      float stereo;
      float stereoOffset;
      
};
//not used currently
struct driftCathodeData
{
      int detector;
      int layer;
      int nstrips;
      int nPhiSeg;
      int cellOffset;
      float zlen;
      float deltaR;
};
struct driftOffsetData
{
      int detector;
      int layer;
      float cellOffset;
      float sag;
      
};
#endif

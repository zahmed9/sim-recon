#ifndef SIZRECTCOMMON
#define SIZRECTCOMMON
struct SilZRectGlobalData;
struct SilZRectLayerData;
struct SilZRectWaferData;
enum ZRectLayerType;
   void getSilZRectGlobalData(int which, SilZRectGlobalData &data);
   void getSilZRectLayerData(int which, SilZRectLayerData &data);
   void getSilZRectWaferData(int which, SilZRectWaferData &data);
   void getSilZRectGlobalName(int which, char *name);
   void getSilZRectLayerEdges(int which, float &xmin, float &xmax,
                                         float &ymin, float &ymax,
                                         float &zmin, float &zmax);
   float getSilZRectLayerThickness(int which);
   int getSilZRectWaferType(int which);
   ZRectLayerType getSilZRectLayerType(int which);
   int NumSiZRect(void);
   int NumSiZRectWafers(void);
   int WhichSiZRectLayer(int idet, int ilyr);
   int WhichSiZRectWafer(int idet, int ilyr, int iwafX, int iwafY);
   int LayerToWafer(int which);
#endif

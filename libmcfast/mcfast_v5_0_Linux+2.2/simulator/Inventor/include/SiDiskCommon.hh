#ifndef SIDISKCOMMON
#define SIDISKCOMMON

#include <X11/Intrinsic.h>
struct SilDiskGlobalData;
struct SilDiskLayerData;
struct SilDiskWedgeData;

void getSilDiskGlobalData(int which, SilDiskGlobalData &data);
void getSilDiskLayerData(int which, SilDiskLayerData &data);
void getSilDiskWedgeData(int which, SilDiskWedgeData &data);
void getSiDiskGlobalName(int which, char *name);
int NumSilDisk(void);
int NumSilDiskWedges(void);
Boolean IsDoubleSiDLayer(int which);
int WhichDiskLayer(int idet, int ilyr);
int WhichDiskWedges(int idet, int ilyr, int iwed);
#endif

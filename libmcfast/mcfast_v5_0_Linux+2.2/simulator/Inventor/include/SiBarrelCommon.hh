#ifndef SIBARRELCOMMON
#define SIBARRELCOMMON

#include <X11/Intrinsic.h>
struct SilBarrelGlobalData;
struct SilBarrelLayerData;
struct SilBarrelWaferData;

void getSilBarrelGlobalData(int which, SilBarrelGlobalData &data);
void getSilBarrelLayerData(int which, SilBarrelLayerData &data);
void getSilBarrelWaferData(int which, SilBarrelWaferData &data);
void getSiBarrelGlobalName(int which, char *name);
int NumSilBarrel(void);
int NumSilBarrelWafers(void);
Boolean IsDoubleSiBLayer(int which);
int WhichBarrelLayer(int idet, int ilyr);
int WhichBarrelWafer(int idet, int ilyr, int iwaf);
char *printBarrelInfo(int which);
char *printLayerInfo(int which);
char *printWaferInfo(int which);
#endif

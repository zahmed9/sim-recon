#ifndef SIXYDETECTOR
#define SIXYDETECTOR
#include <Inventor/nodes/SoSeparator.h>
//non class routines for SilXY detectors
SoSeparator *SilXY(void);
void getSilXYGlobalData(int which, SilXYGlobalData &data);
void getSilXYPlaneData(int which, SilXYPlaneData &data);
void getSiXYGlobalName(int which, char *name);
char *printSiXYGlobal(int which);
char *checkSiXYGlobal(int which);
char *printSiXYPlane(int which);
char *checkSiXYPlane(int which);
#endif

#ifndef SIXYCOMMON
#define SIXYCOMMON
struct SilXYGlobalData;
struct SilXYPlaneData;
//these are the routines used for accessing the mcfio commons for the
//detectors
void getSilXYGlobalData(int which, SilXYGlobalData &data);
void getSiXYGlobalName(int which, char *name);
void getSilXYPlaneData(int which, SilXYPlaneData &data);
char *printSiXYGlobal(int which);
char *checkSiXYGlobal(int which);
char *printSiXYPlane(int which);
char *checkSiXYPlane(int which);
int NumSilXY(void);
int WhichPixelPlane(int idet, int ilyr);
#endif

#ifndef HITCOMMON
#define HITCOMMON
struct Points;
struct SilBarrelHitData;
struct SilDiskHitData;
struct SilXYHitData;
struct SilZRectHitData;
void FindNumberOfDeviceHits(void);
int GetSilBarrelHits(SilBarrelHitData *hitData);
int NumSilBarrelHits(void);
int GetSilDiskHits(SilDiskHitData *hitData);
void GetTraceHits(int type, Points *trHits);
int NumSilDiskHits(void);
int NumSilXYHits(void);
int NumSilZRectHits(void);
int GetSilXYHits(SilXYHitData *hitData);
int GetSilZRectHits(SilZRectHitData *hitData);
char *hitMessage(int ihit);
#endif

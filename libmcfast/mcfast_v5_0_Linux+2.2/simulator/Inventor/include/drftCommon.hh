//this get the information from the forward tracker commons
#ifndef DRIFTCOMMON
#define DRIFTCOMMON
struct ConicalDetectorData;
struct driftAnodeData;
struct driftCathodeData;
struct driftOffsetData;
int NumDrift(void);
int NumDriftAnodeLayer(int which);
int NumDriftCathodeLayer(int which);
int NumDriftAnode(void);
int NumDriftCathode(void);
int NumDriftAnodeOffset(void);
void getDriftName(int which, char *name);
void getDriftData(int which, ConicalDetectorData &data);
void getDriftAnodeData(int which, driftAnodeData &data); 
void getDriftCathodeData(int which, driftCathodeData &data);
void getDriftOffsetData(int which, driftOffsetData &data);

#endif

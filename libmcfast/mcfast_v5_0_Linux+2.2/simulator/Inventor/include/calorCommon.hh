#ifndef CALORCOMMON
#define CALORCOMMON

class McFForwardCal;
class McFBarrelCal;
struct projectiveCalData;

int NumCalorProj(void);
int TypeCalorProj(int which);
void getProjectiveCalData(int which, projectiveCalData &data);
void getCalorName(int which, char *name);
int getNPhiSegments(int which);
int getNEtaSegments(int which);
#endif

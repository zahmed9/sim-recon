//this get the information from the forward tracker commons
#ifndef FTRKCOMMON
#define FTRKCOMMON
#include "frameDetectorData.hh"
#include "forTrackLayer.hh"
int NumFtrk(void);
int NumFtrklayer(int which);
void getFtrkName(int which, char *name);
void getFtrkData(int which, frameDetectorData &data);
void getFtrkLayerData(int which, frameDetectorData &data1, 
                                 forTrackerLayer &data2);

#endif

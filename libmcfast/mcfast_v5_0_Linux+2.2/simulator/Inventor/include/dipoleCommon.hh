#ifndef DIPOLECOMMON
#define DIPOLECOMMON
#include <Inventor/nodes/SoSeparator.h>
#include "hepvis/SoMcFDetectorTreeKit.hh"
#include "McFDetectorTreeList.hh"
#include "frameDetectorData.hh"
#include "magnetFieldData.hh"

int NumDipole(void);
void getDipoleData(int which, frameDetectorData&data1, 
                              magneticFieldData &data2);
void getDipoleName(int which, char *name);


SoSeparator *Dipole(void);
SoMcFDetectorTreeKit *AddDipoleToDetectorTree(int which, 
                                             McFDetectorTreeList *mother );
#endif

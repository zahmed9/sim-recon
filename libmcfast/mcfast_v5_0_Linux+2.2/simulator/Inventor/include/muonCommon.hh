#ifndef MUONCOMMON
#define MUONCOMMON
#include <Inventor/nodes/SoSeparator.h>
#include "ConicalDetectorData.hh"
#include "hepvis/SoMcFDetectorTreeKit.hh"
class McFDetectorTreeList;

void getMuonDetectorData(int which, ConicalDetectorData &data);
void getMuonDetectorName(int which, char *name);
int NumMuon(void);
SoSeparator *Muon(void);
SoMcFDetectorTreeKit *AddMuonToDetectorTree(int which, 
                                            McFDetectorTreeList *mother);
#endif

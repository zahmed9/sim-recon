#ifndef SILDISKSTRIPPOS
#define SILDISKSTRIPPOS
const int RAD=1,PHI=2,CIR=3,TRAP=4;
void SiDiskCirStripPosition(int nstrip,  int factor,
                            SilDiskWedgeData wedgeData, 
                            SilDiskLayerData layerData, float v1[3], 
                            float v2[3]);               
void SiDiskTrapStripPosition(int nstrip, int factor,
                             SilDiskWedgeData wedgeData, 
                             SilDiskLayerData layerData, float v1[3], float
                             v2[3]);
void SiDiskPhiStripPosition(int nstrip, int factor,
                            SilDiskWedgeData wedgeData,
                            SilDiskLayerData layerData,
                            float x[4], float y[4]);                      
void SiDiskRStripPosition(int nstrip, int factor,
                          SilDiskWedgeData wedgeData,
                          SilDiskLayerData layerData, float x[5], float y[5]);
                                              
#endif

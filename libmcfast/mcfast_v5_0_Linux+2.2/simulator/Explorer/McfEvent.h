void McfStdDispInfo(int hep, long window);
void McfHepGenPosition(void);
void McfTracePosition(int PlotTrack, int PlotTrace, int PlotNeutr,
                      int PlotHit, double EtaMin, double EtaMax,
                      int MomSwitch, double MomCut, double RadMax);
int McfTraceDisplay(int nvert, struct Position *pos, float *color, int id);
int McfHitDisplay(int nhit, struct Position *hit);
void McfHepLattice(int *nhep, float **hepdata);
void Mcf_HepTrackDisplay(struct Position begin, struct Position end, 
                         float color[3]);
double Eta( double px, double py, double pz);
double d_sign(double arg);
int McfSetDisp(int reset, int pickinfo, int pickhep);
enum {HEP, HEP_PX,HEP_PY,HEP_PZ,HEP_X,HEP_Y,HEP_Z,HEP_ID,HEP_PAR,
      OFF_PX,OFF_PY,OFF_PZ};
enum {TRACE, TRACK, NEUTR, PARENT};
#define HEPLATDATASIZE 12

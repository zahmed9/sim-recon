#ifndef _RESIDCDC_H_
#define _RESIDCDC_H_

#include "CDC/DCDCTrackHit.h"
#include "MyTrajectory.h"
#include "DLine.h"

#define ERROR_CDC 0.0180

class residCDC {
 public:
  residCDC(vector<const DCDCTrackHit*> *trackhits, MyTrajectory *trajectory,
		    int level = 1);
  void calcResids(vector<double> params);
  void calcResids(const HepVector* paramsVectorPtr);
  void setInnerResidFrac(double innerResidFracIn);
  void getResids(vector<double> &residsRef);
 private:
  unsigned int n_cdc;
  vector<const DCDCTrackHit*> *trkhitVectorPtr;
  MyTrajectory *trajPtr;
  DLine trackhit2line(const DCDCTrackHit &trackhit);
  vector<double> delta;
  int debug_level;
  double innerResidFrac;
  vector<double> doca, dist, resid, error;
  vector<HepLorentzVector> poca;
};

#endif // _RESIDCDC_H_

// end of C++ source

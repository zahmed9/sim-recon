#ifndef _RESIDFDC_H_
#define _RESIDFDC_H_

#define PIOVER2 1.570796327
#define PIOVER4 0.785398163
#include "FDC/DFDCPseudo.h"
#include "CDC/DCDCTrackHit.h"
#include "MyTrajectory.h"

#define BIG_DOUBLE 1.0e12
#define DRIFT_VELOCITY 55e-4
#define ERROR_FDC 0.0250

class residFDC {
 public:
  residFDC(vector<const DFDCPseudo*> *pseudopoints, const MyTrajectory *trajectory,
		    const DLorentzDeflections *lorentz_def, int level = 1);
  void calcResids();
 private:
  unsigned int n_fdc;
  vector<const DFDCPseudo*> *ppPtr;
  const MyTrajectory *trajPtr;
  HepVector pseudo2HepVector(const DFDCPseudo &pseudopoint);
  int debug_level;
  bool getCorrectionSign(const DFDCPseudo &pseudopoint, double x, double y,
			 double deltaX, double deltaY);
  void getCorrectionValue(const DFDCPseudo &pseudopoint, double x, double y,
			  double z, double t, double &delta_x, double &delta_y);
  const DLorentzDeflections *lorentz_def;
};

#endif // _RESIDFDC_H_

// end of C++ source

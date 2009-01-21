#include <iostream>
#include <vector>

using namespace std;

#include "MyTrajectory.h"

MyTrajectory::MyTrajectory(int level) : nparams(4), delta(4, 0.001), debug_level(level) {
  // explicit default constructor, set number of params for straight line
  //  cout << "MyTrajectory constructor called\n";
  //  cout << "nparams = " << nparams << endl;
  return;
}

MyTrajectory::~MyTrajectory() {
  clear();
  return;
}

unsigned int MyTrajectory::getNumberOfParams() {
  return nparams;
}

void MyTrajectory::clear() {
  if (traj.size() != 0) {
    for (vector<HepLorentzVector*>::iterator iVector = traj.begin();
	 iVector != traj.end();
	 iVector++) {
      // cout << "traj x = " << (**iVector)(1) << ", traj y = " << (**iVector)(2) << ", traj z = " << (**iVector)(3) << endl;
      delete *iVector;
    }
  }
  traj.clear();
  return;
}

void MyTrajectory::swim(HepVector startingPoint, double theta,
			double phi)
// default swim, straight line
{
  //  cout << "straight line swim with start point = "<< startingPoint << "theta = " << theta << " phi = " << phi << endl;
  checkClear();
  double stepLength = 1.0;
  HepLorentzVector step;
  step.setX(stepLength*sin(theta)*cos(phi));
  step.setY(stepLength*sin(theta)*sin(phi));
  step.setZ(stepLength*cos(theta));
  HepLorentzVector* thisVector;
  thisVector = new HepLorentzVector(startingPoint(1), startingPoint(2), startingPoint(3));
  traj.push_back(thisVector);
  HepLorentzVector lastVector(*thisVector);
  for (int i = 0; i < 600; i++) {
    thisVector = new HepLorentzVector();
    *thisVector = lastVector + step;
    //    if (i == 100) cout << "point on traj " << i << " " << *thisVector;
    traj.push_back(thisVector);
    lastVector = *thisVector;
  }
  return;
}

void MyTrajectory::swim(const HepVector& startingVector) {
  HepVector startingPoint(3);
  startingPoint(1) = startingVector(1);
  startingPoint(2) = startingVector(2);
  startingPoint(3) = 0.0; // start at z = 0 every time
  double theta = startingVector(3);
  double phi = startingVector(4);
  swim(startingPoint, theta, phi);
  return;
}

void MyTrajectory::swimMC(vector<const DMCTrackHit*> &mctrackhits) {
  checkClear();
  const DMCTrackHit* mchit;
  HepLorentzVector *point;
  for (vector<const DMCTrackHit*>::iterator imchit = mctrackhits.begin();
       imchit != mctrackhits.end();
       imchit++) {
    mchit = *imchit;
    if (mchit->system & (SYS_CDC | SYS_FDC) && mchit->primary == 1) {
      double r = mchit->r, phi = mchit->phi, z = mchit->z;
      point = new HepLorentzVector(r*cos(phi), r*sin(phi), z);
      traj.push_back(point);
    }
  }
}

void MyTrajectory::print()
{
  cout << "### MyTrajectory print out begin ###" << endl;
  for (vector<HepLorentzVector*>::iterator iVector = traj.begin();
       iVector != traj.end();
       iVector++) {
    cout << (**iVector).x() << " " << (**iVector).y() << " " << (**iVector).z()
    	 << endl;
  }
  cout << "### MyTrajectory print out end ###" << endl;
}

vector<HepLorentzVector*>* MyTrajectory::getTrajectory() {
  return &traj;
}

double MyTrajectory::dist(HepVector& point, int trajIndex) {
  Hep3Vector delta, point3(point(1), point(2), point(3));
  delta = point3 - traj[trajIndex]->getV();
  return delta.mag();
}

double MyTrajectory::dist(DLine& line, int trajIndex) {
  return line.doca(*traj[trajIndex]);
}

int MyTrajectory::get_xy(double z, double &x, double &y) {
  int iBefore = 0, iAfter = traj.size() - 1, iTry;
  double zBefore = (*traj[iBefore])(3);
  double zAfter = (*traj[iAfter])(3);
  double zTry;
  if (z < zBefore || z > zAfter) {
    return 1;
  }
  while (iAfter - iBefore > 1) {
    iTry = iBefore + (int)((double)(iAfter - iBefore)*(z - zBefore)/(zAfter - zBefore) + 0.5);
    // cout << iBefore << ' ' << iTry << ' ' << iAfter << endl;
    if (iBefore == iTry) iTry++;
    if (iAfter == iTry) iTry--;
    // cout << iBefore << ' ' << iTry << ' ' << iAfter << endl;
    zTry = (*traj[iTry])(3);
    // cout << "zTry = " << zTry << endl;
    if (z < zTry) {
      iAfter = iTry;
      zAfter = (*traj[iAfter])(3);
    } else if (z > zTry) {
      iBefore = iTry;
      zBefore = (*traj[iBefore])(3);
    } else {
      x = (*traj[iTry])(1);
      y = (*traj[iTry])(2);
    }
    // cout << z << ' ' << zBefore << ' ' << zTry << ' ' << zAfter << endl;
  }
  double frac, otherfrac;
  frac = (z - zBefore)/(zAfter - zBefore);
  otherfrac = 1.0 - frac;
  // cout << frac << ' ' << otherfrac << endl;
  // cout << "x before, after " << (*traj[iBefore])(1) << ' '<< (*traj[iAfter])(1) << endl;
  // cout << "y before, after " << (*traj[iBefore])(2) << ' '<< (*traj[iAfter])(2) << endl;
  x = frac*(*traj[iAfter])(1) + otherfrac*(*traj[iBefore])(1);
  y = frac*(*traj[iAfter])(2) + otherfrac*(*traj[iBefore])(2);
  return 0;
}

void MyTrajectory::para_min(double yMinus, double yZero, double yPlus,
			    double &xMinFrac, double &yMin) {
  double a, b, c;
  a = 0.5*(yPlus - 2.0*yZero + yMinus);
  b = 0.5*(yPlus - yMinus);
  c = yZero;
  yMin = -b*b/(4.0*a) + c;
  if (yMin < 0.0) yMin = 0.0;
  xMinFrac = -b/(2.0*a);
  return;
}

void MyTrajectory::checkClear() {
  if (traj.size() != 0) {
    int ierror = 2;
    throw ierror;
  }
  return;
}

void MyTrajectory::dump_ascii(ostream *trajFile, int tag) {
  HepVector trajPoint(3);
  for (unsigned int i = 0; i < traj.size(); i++) {
    trajPoint = *(traj[i]);
    *trajFile << tag << " " << i + 1 << " " << trajPoint(1) << " "
	      << trajPoint(2) << " " << trajPoint(3) << endl;
  }
}

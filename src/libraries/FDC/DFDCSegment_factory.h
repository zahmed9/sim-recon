//******************************************************************
// DFDCSegment_factory.h: class definition for a factory creating
// track segments from pseudopoints
//******************************************************************
#ifndef DFACTORY_DFDCSEGMENT_H
#define DFACTORY_DFDCSEGMENT_H

#include "JANA/JFactory.h"
#include "JANA/JException.h"
#include "JANA/JStreamLog.h"

#include "DFDCSegment.h"
#include "DFDCPseudo.h"
#include "DFDCHit.h"

#include "HDGEOMETRY/DMagneticFieldMap.h"
#include "HDGEOMETRY/DLorentzDeflections.h"
#include <TDecompLU.h>
#include <DVector2.h>

#include <algorithm>
#include <map>
#include <cmath>

/* The folowing are for interpreting grid of Lorentz deflection data */
/*#define PACKAGE_Z_POINTS 10 
#define LORENTZ_X_POINTS 21
#define LORENTZ_Z_POINTS 4*PACKAGE_Z_POINTS
*/

///
/// class DFDCSegment_factory: definition for a JFactory that
/// produces space points from pseudopoints.
/// 
class DFDCSegment_factory : public JFactory<DFDCSegment> {
 public:
		
  ///
  /// DFDCSegment_factory::DFDCSegment_factory():
  /// default constructor -- initializes log file
  ///
  DFDCSegment_factory();
		
  ///
  /// DFDCSegment_factory::~DFDCSegment_factory():
  /// default destructor -- closes log file
  ///
  ~DFDCSegment_factory();

  typedef struct{
    DVector2 xy;
    double z,covr,covrphi;
  }xyz_t;
	
  
  jerror_t FindSegments(vector<const DFDCPseudo*>points);
  //		jerror_t CorrectPoints(vector<DFDCPseudo*>point,DMatrix XYZ);
  jerror_t GetHelicalTrackPosition(double z,const DFDCSegment *segment,
				   double &xpos,double &ypos);
  jerror_t RiemannHelicalFit(vector<const DFDCPseudo*>points,
			     DMatrix &CR,vector<xyz_t>&XYZ);
  jerror_t RiemannCircleFit(vector<const DFDCPseudo*>points,
			    DMatrix &CRPhi);
  jerror_t RiemannLineFit(vector<const DFDCPseudo *>points,
			  DMatrix &CR,vector<xyz_t>&XYZ);
  jerror_t UpdatePositionsAndCovariance(unsigned int n,double r1sq,
					vector<xyz_t> &XYZ,DMatrix &CRPhi,
					DMatrix &CR);
  double GetRotationSense(unsigned int n,vector<xyz_t>&XYZ,DMatrix &CR, 
		   DMatrix &CRPhi);
  jerror_t CircleFit(vector<const DFDCPseudo *>points);

	protected:
		///
		/// DFDCSegment_factory::brun():
		///
		jerror_t brun(JEventLoop *eventLoop, int runnumber);

		///
		/// DFDCSegment_factory::evnt():
		/// this is the place that finds track segments and  
		/// converts pseudopoints into space points.
		///
		jerror_t evnt(JEventLoop *eventLoop, int eventNo);

	private:
		JStreamLog* _log;

		double N[3];
	        double varN[3][3];
	 	double dist_to_origin,xc,yc,rc;
		double xavg[3],var_avg;
		
		// Track parameters
		double tanl,z0,zvertex,D,phi0;
		double var_tanl,Phi1;
		double rotation_sense;
		unsigned int ref_plane;
		double RotationSenseToCharge;
	
		double chisq;
		int Ndof;

                const DMagneticFieldMap *bfield;
		const DLorentzDeflections *lorentz_def;
//		double ref_time;
//		bool use_tof,use_sc;
		double TARGET_Z,BEAM_VARIANCE;
		int DEBUG_LEVEL;

		//vector of flags indicating whether or not a hit has been used
		vector<bool>used;

		int myeventno;
};

#endif // DFACTORY_DFDCSEGMENT_H


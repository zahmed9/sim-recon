


#ifndef __DMAGNETICFIELDSTEPPER_H__
#define __DMAGNETICFIELDSTEPPER_H__

#include <math.h>

#include <TVector3.h>
#include "JANA/jerror.h"

#include "DMagneticFieldMap.h"


/// DMagneticFieldStepper class
///
/// This class will step a particle track through a magnetic
/// field. It has methods to find the point on the track which
/// comes closest to a specified point in space.


class DMagneticFieldStepper
{
	public:

		DMagneticFieldStepper(const DMagneticFieldMap *map, double q=1.0);
		DMagneticFieldStepper(const DMagneticFieldMap *map, double q, const TVector3 *x, const TVector3 *p);
		~DMagneticFieldStepper();
	
		jerror_t SetStartingParams(double q, const TVector3 *x, const TVector3 *p);
		jerror_t SetMagneticFieldMap(const DMagneticFieldMap *map);
		jerror_t SetStepSize(double step);
		double Step(TVector3 *newpos=NULL, double stepsize=0.0);
		void GetDirs(TVector3 &xdir, TVector3 &ydir, TVector3 &zdir);
		void GetMomentum(TVector3 &mom){mom = this->mom;}
		void GetPosition(TVector3 &pos){pos = this->pos;}
		double GetCharge(void){return q;}
		void GetPosMom(TVector3 &pos, TVector3 &mom){pos=this->pos; mom=this->mom;}
		bool SwimToPlane(TVector3 &pos, TVector3 &mom, const TVector3 &origin, const TVector3 &norm);
		bool DistToPlane(TVector3 &pos, const TVector3 &origin, const TVector3 &norm);
		bool SwimToRadius(TVector3 &pos, TVector3 &mom, double R);
		bool DistToRadius(TVector3 &pos, double R);

		inline double GetRo(void){return fabs(Ro);}
		inline double Getdz_dphi(void){return Ro*mom.Dot(zdir)/mom.Dot(ydir);}
		inline double GetStepSize(void) const{return stepsize;}
	
	private:
		const DMagneticFieldMap *bfield; ///< pointer to magnetic field map
		double stepsize;		///< maximum distance(cm) to move particle when Step() is called
		double last_stepsize;///< stepsize (cm) used for last step
		double q;				///< electric charge in units of e
		TVector3 pos;			///< current position of particle
		TVector3 mom;			///< current location of particle
		TVector3 start_pos;	///< starting position of track
		TVector3 start_mom;	///< starting momentum of track
		TVector3 B;
		double Ro, Rp;
		double cos_theta, sin_theta;
		
		TVector3 xdir, ydir, zdir;
		
		void CalcDirs(void);
};

#endif // __DMAGNETICFIELDSTEPPER_H__

#line 10 "drift.nw"
#ifndef __DRIFT_H_
#define __DRIFT_H_
	
	
#line 19 "drift.nw"
class driftChamber {
   private:
	
#line 30 "drift.nw"
	threeVec _readout;
	threeVec _normal;
	threeVec _center;
	double    _radius;
	double    _dnorm;
	double    _spacing;
	int            _ncells;
	void driftChamber::_init(threeVec readout,threeVec normal,threeVec center,double radius,double dnorm,double spacing);

#line 23 "drift.nw"
   public:
	
#line 41 "drift.nw"
	driftChamber() { this->._init(threeVec(0,0,0),threeVec(0,0,0),threeVec(0,0,0),0,0,0);};
	driftChamber(threeVec rd,threeVec n,threeVec c,double r,double d,double s) { this->_init(rd,n,c,r,d,s); }
	void driftChamber::set(threeVec rd,threeVec n,threeVec c,double r,double d,double s) { this->_init(rd,n,c,r,d,s); }
	~driftChamber();
       	int driftChamber::channel(threeVec position);

#line 25 "drift.nw"
};
#line 14 "drift.nw"
#endif

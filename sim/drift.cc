#line 52 "drift.nw"
	
#line 57 "drift.nw"
#include <Vec.h>
#include <drift.h>
#line 53 "drift.nw"
	
#line 62 "drift.nw"
	void driftChamber::_init(threeVec readout,threeVec normal,threeVec center,double radius,double dnorm,double spacing) {
		this->_readout = readout;
		this->_normal = normal;
		this->_center = center;
		this->_radius = radius;	
		this->_dnorm = dnorm;
		this->_spacing = spacing;
	}
	int driftChamber::channel(threeVec position) {
		int channel = -1000;
		threeVec Norm,A;
		Norm = this->_dnorm * this->_normal;
		A = Norm - this->_center;
		if (~A < this->_radius) {
			channel = (A * this->_readout/this->_spacing);
		}
		return(channel);
	}
#line 54 "drift.nw"
	


// Author: David Lawrence  Feb. 4, 2005
//
//
// DTrkHit.h

#include <TH2.h>

#include "derror.h"

class DTrkHit{
	public:
		DTrkHit(float x, float y);
		~DTrkHit(){};
		
		enum {
			Y_OF_X,
			X_OF_Y
		};
		
		float Dist2ToLine(float x, float y);
		float DistToLine(float x, float y);
		float Density(float x, float y);
		derror_t FillDensityHistogram(TH2F *density);
		
		float xhit, yhit;
		float m, b;
		int orientation;
		int used;
};




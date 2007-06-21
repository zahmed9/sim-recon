// $Id$
//
//    File: DTOFMCResponse.h
// Created: Mon Aug 15 11:33:45 EST 2005
// Creator: remitche (on Linux mantrid00 2.4.20-18.8 i686)
//

#ifndef _DTOFMCResponse_
#define _DTOFMCResponse_

#include "JANA/JObject.h"
#include "JANA/JFactory.h"

class DTOFMCResponse:public JObject{
    public:
        HDCLASSDEF(DTOFMCResponse);
	
        int orientation;  // 0: vertical,  1: horizontal
	int ptype;        // particle type
	int bar;          // bar number
        float y;          // x/y position of bar center
        float t_north;          // time of light at end of bar  (smeared) 
        float E_north;          // attenuated energy deposition  (smeared)
	int ADC_north;
        float t_south;          // time of light at end of bar  (smeared) 
        float E_south;          // attenuated energy deposition  (smeared)
	int ADC_south;
};

#endif // _DTOFMCResponse_


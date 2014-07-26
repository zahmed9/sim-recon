// $Id$
//
// File: DTAGFHit.h
// Created: Sat Jul 5 07:49:15 EDT 2014
// Creator: jonesrt (on gluey.phys.uconn.edu)
//

#ifndef _DTAGFhit_
#define _DTAGFhit_

#include <JANA/JObject.h>
#include <JANA/JFactory.h>

class DTAGFHit:public jana::JObject{
	public:
		JOBJECT_PUBLIC(DTAGFHit);

		double E;
		double t;
		int channel;

		void toStrings(vector<pair<string,string> > &items)const{
		  AddString(items, "channel", "%d", channel);
		  AddString(items, "E(GeV)", "%f", E);
		  AddString(items, "t(ns)", "%f", t);
		}
};

#endif // _DTAGFHit_

// Author: David Lawrence  June 25, 2004
//
//
// MyProcessor.h
//
/// Example program for a Hall-D analyzer which uses DANA
///

#include "DEventProcessor.h"
#include "DEventLoop.h"

#include <TFile.h>
#include <TH1.h>
#include <TH2.h>
#include <TTree.h>

class DMagneticFieldMap;

class MyProcessor:public DEventProcessor
{
	public:
		derror_t init(void);					///< Called once at program start.
		derror_t brun(int runnumber){};	///< Called everytime a new run number is detected.
		derror_t evnt(int eventnumber);	///< Called every event.
		derror_t erun(void){};				///< Called everytime run number changes, provided brun has been called.
		derror_t fini(void);					///< Called after last event of last event source has been processed.

		DMagneticFieldMap *Bfield;

		TFile *ROOTfile;
		TH1 *p_rec, *e_rec, *theta_rec, *phi_rec, *z_rec;
		TTree *rec;
		
		float t_p, t_e, t_theta, t_phi, t_z;
};

// Author: David Lawrence  June 25, 2004
//
//
// MyProcessor.h
//
/// Example program for a Hall-D analyzer which uses DANA
///

#include "DEventProcessor.h"
#include "DEventLoop.h"
#include "DTrkHit.h"

#include <TFile.h>
#include <TH1.h>
#include <TH2.h>
#include <TTree.h>
#include <TLine.h>
#include <TEllipse.h>
#include <TCanvas.h>

class DMagneticFieldMap;
class DFactory_MCTrackCandidates;

class MyProcessor:public DEventProcessor
{
	public:
		derror_t init(void);					///< Called once at program start.
		derror_t brun(int runnumber){};	///< Called everytime a new run number is detected.
		derror_t evnt(int eventnumber);	///< Called every event.
		derror_t erun(void){};				///< Called everytime run number changes, provided brun has been called.
		derror_t fini(void);					///< Called after last event of last event source has been processed.

		//derror_t FindTracks(void);
		derror_t densityPlot(void);
		//derror_t FillDensityHistogram(TH2F *hist);

		//DTrkHit *trkhit[300];
		//int Ntrkhits;
		//DMagneticFieldMap *Bfield;

		TFile *ROOTfile;
		TTree *pat;
		TH2F *axes;
		DFactory_MCTrackCandidates *factory;
		
		//float cmax;
		//float x,y,z,r,phi;
		
		//TH2F *density, *density_work;
		TLine *lines[500];
		int Nlines;
		//TEllipse *ellipse[100];
		//int Nellipse;
};



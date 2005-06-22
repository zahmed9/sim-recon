// Author: David Lawrence  June 25, 2004
//
//
// MyProcessor.h
//
/// Example program for a Hall-D analyzer which uses DANA
///


#include "DApplication.h"
#include "DEventProcessor.h"
#include "DEventLoop.h"

#include <TFile.h>
#include <TH1.h>
#include <TH2.h>
#include <TTree.h>
#include <TLine.h>
#include <TEllipse.h>
#include <TCanvas.h>
#include <TMarker.h>

class DMagneticFieldMap;
class DFactory_DMCTrackCandidate;

class MyProcessor:public DEventProcessor
{
	public:
		derror_t init(void);					///< Called once at program start.
		derror_t evnt(DEventLoop *eventLoop, int eventnumber);	///< Called every event.
		derror_t fini(void);					///< Called after last event of last event source has been processed.

		derror_t PlotLines(void);
		derror_t PlotDensity(void);
		derror_t PlotDensityX(void);
		derror_t PlotDensityY(void);
		derror_t PlotSlope(void);
		derror_t PlotIntercept(void);
		derror_t PlotPhiVsZ(void);
		derror_t PlotHits(void);
		derror_t PlotStats(void);

		TH2F *axes, *axes_phiz, *axes_hits;
		DFactory_DMCTrackCandidate *factory;
		DEventLoop *eventLoop;
		
		vector<TLine*> lines;
		vector<TMarker*> markers;
		vector<TEllipse*> circles;
};



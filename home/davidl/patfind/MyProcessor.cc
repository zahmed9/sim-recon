// Author: David Lawrence  June 25, 2004
//
//
// MyProcessor.cc
//

#include <iostream>
using namespace std;

#include <TF1.h>

#include "MyProcessor.h"
#include "hddm_s.h"

#include "DMagneticFieldMap.h"
#include "DQuickFit.h"
#include "DFactory_MCCheatHits.h"
#include "DFactory_MCTrackCandidates.h"

#define rad2deg 57.3
#define PI_MASS 0.139568

static int colors[] = {kRed,kBlue,kMagenta,kGreen,kBlack};

extern TCanvas *maincanvas;

//------------------------------------------------------------------
// init   -Open output file here (e.g. a ROOT file)
//------------------------------------------------------------------
derror_t MyProcessor::init(void)
{
	// Print list of factories
	event_loop->PrintFactories();
	
	// Get a pointer to the MCTrackCandidates factory object so we can 
	// access things not included in the normal _data container
	factory = (DFactory_MCTrackCandidates*)event_loop->GetFactory("MCTrackCandidates");
	
	// Set factory to handle flipping of x-axis for proper viewing
	factory->flip_x_axis = 1;
	
	// Tell factory to keep around a few density histos
	factory->SetNumDensityHistograms(4);

	// Initialize Nlines Nmarkers Nellipse;
	Nlines = 0;
	Nmarkers = 0;
	Nellipse = 0;
	
	// set limits for plot. This represents the space where the center 
	// of the circle can be. It can be (and often is) outside of the
	// bounds of the solenoid.
	float cmax = 150.0; // in cm.

	axes = new TH2F("axes","",10,-cmax,cmax,10,-cmax,cmax);
	axes->SetStats(0);

	axes_phiz = new TH2F("axes_phiz","",10,0.0,650.0, 10, -2.0*M_PI, 2.0*M_PI);
	axes_phiz->SetStats(0);
	axes_phiz->SetXTitle("z-coordinate (cm)");
	axes_phiz->SetYTitle("\\phi angle (radians)");

	axes_hits = new TH2F("axes_hits","",10,-100.0,100.0, 10, -100.0,100.0);
	axes_hits->SetStats(0);

	return NOERROR;
}

//------------------------------------------------------------------
// evnt   -Fill histograms here
//------------------------------------------------------------------
derror_t MyProcessor::evnt(int eventnumber)
{
	axes->Draw();

	// set limits for plot. This represents the space where the center 
	// of the circle can be. It can be (and often is) outside of the
	// bounds of the solenoid.
	float cmax = 300.0; // in cm.
	
	// Delete lines from previous event
	for(int i=0;i<Nlines;i++)delete lines[i];
	Nlines = 0;

	// Invoke the MCTrackCandidates factory so it's internal structures
	// are filled with the current event's data
	event_loop->Get("MCTrackCandidates");

	// Loop over the archits to find the two points defining each line
	int Narchits = factory->GetNarchits();
	DArcHit *a = factory->Getarchits();
	for(int i=0; i<Narchits; i++, a++){
		float m = a->m;
		float b = a->b;
		float x1,y1,x2,y2;
		if(a->orientation == DArcHit::Y_OF_X){
			x1 = -cmax;
			x2 = cmax;
			y1 = m*x1 + b;
			y2 = m*x2 + b;
		}else{
			y1 = -cmax;
			y2 = cmax;
			x1 = m*y1 + b;
			x2 = m*y2 + b;
		}
		// The drawing canvas has the y-axis pointing up. This
		// is the opposite of what the positive y-axis for a downstream
		// looking view. Hence, we flip the y-coordinate here.
		lines[Nlines] = new TLine(x1,y1,x2,y2);
		lines[Nlines]->SetLineColor(colors[a->track-1]);
		lines[Nlines++]->Draw();
		if(Nlines>=500)break;
	}
	
	// Draw circles at focus points
	int Ncircles = factory->GetNcircles();
	TEllipse *circle = factory->GetCircles();
	for(int i = 0;i<Ncircles;i++, circle++){
		circle->SetLineColor(kRed);
		circle->SetFillStyle(0);
		circle->Draw();
	}

	maincanvas->Update();
	cout<<endl<<"Done ("<<factory->GetNcircles()<<" tracks)"<<endl;
	
	return NOERROR;
}

//------------------------------------------------------------------
// densityPlot
//------------------------------------------------------------------
derror_t MyProcessor::densityPlot(void)
{

	// Invoke the MCTrackCandidates factory so it's internal structures
	// are filled with the current event's data
	event_loop->Get("MCTrackCandidates");

	// Draw contour map
	TH2F *density = factory->GetDensityHistogram(0);
	density->Draw("cont");

	// Draw circles at focus points
	int Ncircles = factory->GetNcircles();
	TEllipse *circle = factory->GetCircles();
	for(int i = 0;i<Ncircles;i++, circle++){
		circle->SetLineColor(kRed);
		circle->Draw();
	}

	// Update canvas
	maincanvas->Update();
	cout<<endl<<"Done"<<endl;
	
	return NOERROR;
}

//------------------------------------------------------------------
// PlotSlope
//------------------------------------------------------------------
derror_t MyProcessor::PlotSlope(void)
{
	factory->slope_density->Draw();
	for(int i=0; i<factory->GetNumDensityHistograms(); i++){
		TH1F *hist = factory->GetSlopeDensityHistogram(i);
		if(hist){
			hist->SetLineColor(colors[i%5]);
			float maxloc = hist->GetBinCenter(hist->GetMaximumBin());
			//hist->Fit("gaus","0", "", maxloc-0.002, maxloc+0.002);
			//hist->GetFunction("gaus")->ResetBit(1<<9); // make function draw with histo (deep in TH1 document)
			hist->Draw("same");
		}
	}
	
	maincanvas->Update();

	return NOERROR;
}

//------------------------------------------------------------------
// PlotOffset
//------------------------------------------------------------------
derror_t MyProcessor::PlotOffset(void)
{
	factory->offset_density->Draw();
	for(int i=0; i<factory->GetNumDensityHistograms(); i++){
		TH1F *hist = factory->GetOffsetDensityHistogram(i);
		if(hist){
			hist->SetLineColor(colors[i%5]);
			hist->Draw("same");
		}
	}

	maincanvas->Update();

	return NOERROR;
}

//------------------------------------------------------------------
// PlotPhiVsZ
//------------------------------------------------------------------
derror_t MyProcessor::PlotPhiVsZ(void)
{
	axes_phiz->Draw();
	factory->DrawPhiZPoints();
	
	maincanvas->SetGridx(1);
	maincanvas->SetGridy(1);
	maincanvas->Update();
	maincanvas->SetGridx(0);
	maincanvas->SetGridy(0);

	return NOERROR;
}


//------------------------------------------------------------------
// DrawHits
//------------------------------------------------------------------
derror_t MyProcessor::DrawHits(void)
{
	// Draw the empty screen
	axes_hits->Draw("AXIS");
	
	// Delete old Markers
	for(int i=0; i<Nmarkers; i++)delete markers[i];
	Nmarkers = 0;

	// Delete old Ellipses
	for(int i=0; i<Nellipse; i++)delete ellipse[i];
	Nellipse = 0;

	// Draw BCAL for reference
	float R1=65.0;
	float R2=90.0;
	ellipse[Nellipse] = new TEllipse(0.0,0.0,R1,R1);
	ellipse[Nellipse++]->SetLineColor(14);
	ellipse[Nellipse] = new TEllipse(0.0,0.0,R2,R2);
	ellipse[Nellipse++]->SetLineColor(14);
	ellipse[Nellipse] = new TEllipse(0.0,0.0,(R1+R2)/2.0,(R1+R2)/2.0);
	ellipse[Nellipse]->SetLineWidth(56);
	ellipse[Nellipse++]->SetLineColor(16); // 16= light grey
	
	// Draw circles based on MCTrackCandidates
	DContainer *mctc = event_loop->Get("MCTrackCandidates");
	MCTrackCandidate_t *tc = (MCTrackCandidate_t*)mctc->first();
	for(int i=0;i<mctc->nrows;i++, tc++){
		float x0 = tc->x0;
		float y0 = tc->y0;
		float r0 = sqrt(x0*x0 + y0*y0);
		ellipse[Nellipse++] = new TEllipse(x0, y0, r0, r0);
	}
	
	// Draw all ellipses
	for(int i=0; i<Nellipse; i++)ellipse[i]->Draw();
	
	// Loop over all cheat hits and draw them
	DContainer *mccheathits = event_loop->Get("MCCheatHits");
	MCCheatHit_t *mccheathit = (MCCheatHit_t*)mccheathits->first();
	for(int i=0; i<mccheathits->nrows; i++, mccheathit++){
		float x = mccheathit->r*cos(mccheathit->phi);
		float y = -mccheathit->r*sin(mccheathit->phi);
		int color = colors[mccheathit->track-1];
		int markerstyle = 20;
		if(mccheathit->system>2){markerstyle = 22; color+=100;}
		markers[Nmarkers] = new TMarker(x,y,markerstyle);
		markers[Nmarkers]->SetMarkerColor(color);
		markers[Nmarkers]->Draw();
		if(++Nmarkers>=500)break;
	}
	
	maincanvas->Update();

	return NOERROR;
}

//------------------------------------------------------------------
// fini   -Close output file here
//------------------------------------------------------------------
derror_t MyProcessor::fini(void)
{
	delete axes;
	delete axes_phiz;
	delete axes_hits;

	return NOERROR;
}


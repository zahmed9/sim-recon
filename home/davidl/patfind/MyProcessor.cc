// Author: David Lawrence  June 25, 2004
//
//
// MyProcessor.cc
//

#include <iostream>
using namespace std;

#include <TF1.h>

#include "MyProcessor.h"
#include "MyMainFrame.h"

#include "DEventLoop.h"
#include "DMagneticFieldMap.h"
#include "DQuickFit.h"
#include "DFactory_DMCCheatHit.h"
#include "DFactory_DMCTrackCandidate.h"

#define rad2deg 57.3
#define PI_MASS 0.139568

static int colors[] = {kRed,kBlue,kCyan,kGreen,kBlack};

extern DEventLoop *eventloop;
extern MyMainFrame *mmf;

//------------------------------------------------------------------
// init   -Open output file here (e.g. a ROOT file)
//------------------------------------------------------------------
derror_t MyProcessor::init(void)
{
	// Print list of factories
	eventloop->PrintFactories();
	
	// Get a pointer to the MCTrackCandidates factory object so we can 
	// access things not included in the normal _data container
	factory = (DFactory_DMCTrackCandidate*)eventloop->GetFactory("DMCTrackCandidate");
	
	// Set factory to handle flipping of x-axis for proper viewing
	factory->flip_x_axis = 1;
	
	// Tell factory to keep around a few density histos
	factory->SetMaxDensityHistograms(10);
	
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
// evnt
//------------------------------------------------------------------
derror_t MyProcessor::evnt(int eventnumber)
{
	// Invoke the MCTrackCandidates factory so it's internal structures
	// are filled with the current event's data
	vector<const DMCTrackCandidate*> mctrackcandidates;
	eventloop->Get(mctrackcandidates);

	// Call the appropriate plotting routine depending upon what's selected
	switch(mmf->GetDisplayType()){
		case MyMainFrame::dtLines:					PlotLines();		break;
		case MyMainFrame::dtHoughDensity:		PlotDensity();		break;
		case MyMainFrame::dtSlopeDensity:		PlotSlope();		break;
		case MyMainFrame::dtInterceptDensity:	PlotIntercept();	break;
		case MyMainFrame::dtPhiVsZ:				PlotPhiVsZ();		break;
		case MyMainFrame::dtHits:					PlotHits();			break;
		case MyMainFrame::dtStats:					PlotStats();		break;
		default:
			cout<<__FILE__<<":"<<__LINE__<<" Unknown display type ("<<mmf->GetDisplayType()<<")"<<endl;
	}

	return NOERROR;
}

//------------------------------------------------------------------
// PlotLines
//------------------------------------------------------------------
derror_t MyProcessor::PlotLines(void)
{
	mmf->EnableRadioButtons(0);
	axes->Draw();

	// set limits for plot. This represents the space where the center 
	// of the circle can be. It can be (and often is) outside of the
	// bounds of the solenoid.
	float cmax = 300.0; // in cm.
	
	// Delete lines from previous call
	for(int i=0;i<lines.size();i++)delete lines[i];
	lines.clear();

	// Loop over the archits to find the two points defining each line
	vector<DArcHit*> archits = factory->GetDArcHits();
	for(int i=0; i<archits.size(); i++){
		DArcHit *a = archits[i];
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
		
		// Create a line using the color from the cheat code
		TLine *line = new TLine(x1,y1,x2,y2);
		line->SetLineColor(colors[(a->track-1)%5]);
		line->Draw();
		lines.push_back(line);
		if(lines.size()>=500)break;
	}
	
	// Draw circles at focus points
	vector<TEllipse*> circles = factory->GetCircles();
	for(int i = 0; i<circles.size(); i++){
		TEllipse *circle = circles[i];
		circle->SetLineColor(kRed);
		circle->SetFillStyle(0);
		circle->Draw();
	}

	// Update the canvas so the new plot is drawn
	mmf->Update();
	
	return NOERROR;
}

//------------------------------------------------------------------
// PlotDensity
//------------------------------------------------------------------
derror_t MyProcessor::PlotDensity(void)
{
	vector<TEllipse*> circles = factory->GetCircles();
	mmf->EnableRadioButtons(circles.size());

	Int_t option = mmf->GetRadioOption();
	if(option<1 || option>factory->GetNumDensityHistograms()){
		cout<<__FILE__<<":"<<__LINE__<<" out of range ("<<option<<")";
		cout<<"Ndensity_histos="<<factory->GetNumDensityHistograms()<<endl;
		return NOERROR;
	}

	// Get and draw density histogram
	TH2F *density = factory->GetDensityHistogram(option);
	density->Draw("cont");

	// Draw circles at focus points
	for(int i = 0; i<circles.size(); i++){
		TEllipse *circle = circles[i];
		circle->SetLineColor(kRed);
		circle->SetFillStyle(0);
		circle->Draw();
	}
	
	// Update the canvas so the new plot is drawn
	mmf->Update();
	
	return NOERROR;
}

//------------------------------------------------------------------
// PlotSlope
//------------------------------------------------------------------
derror_t MyProcessor::PlotSlope(void)
{
	mmf->EnableRadioButtons(factory->GetNumDensityHistograms()-1);
	Int_t option = mmf->GetRadioOption();
	if(option<1 || option>factory->GetNumDensityHistograms()){
		cout<<__FILE__<<":"<<__LINE__<<" out of range ("<<option<<")";
		cout<<"Ndensity_histos="<<factory->GetNumDensityHistograms()<<endl;
		return NOERROR;
	}

	// Draw the histo
	TH1F *hist = factory->GetSlopeDensityHistogram(option);
	hist->SetLineColor(colors[(option-1)%5]);
	hist->Draw();
	
	// Update the canvas so the new plot is drawn
	mmf->Update();

	return NOERROR;
}

//------------------------------------------------------------------
// PlotIntercept
//------------------------------------------------------------------
derror_t MyProcessor::PlotIntercept(void)
{
	mmf->EnableRadioButtons(factory->GetNumDensityHistograms()-1);
	Int_t option = mmf->GetRadioOption();
	if(option<1 || option>factory->GetNumDensityHistograms()){
		cout<<__FILE__<<":"<<__LINE__<<" out of range ("<<option<<")";
		cout<<"Ndensity_histos="<<factory->GetNumDensityHistograms()<<endl;
		return NOERROR;
	}

	// Draw first histo in list to replace pad contents
	TH1F *hist = factory->GetOffsetDensityHistogram(option);
	hist->SetLineColor(colors[(option-1)%5]);
	hist->Draw();
	
	// Update the canvas so the new plot is drawn
	mmf->Update();

	return NOERROR;
}

//------------------------------------------------------------------
// PlotPhiVsZ
//------------------------------------------------------------------
derror_t MyProcessor::PlotPhiVsZ(void)
{
	// Enable options for all tracks
	vector<const DMCTrackCandidate*> mctc;
	eventloop->Get(mctc);
	mmf->EnableRadioButtons(mctc.size());

	axes_phiz->Draw();
	factory->DrawPhiZPoints();
	
	mmf->SetGrid(1);
	mmf->Update();
	mmf->SetGrid(0);

	return NOERROR;
}

//------------------------------------------------------------------
// PlotHits
//------------------------------------------------------------------
derror_t MyProcessor::PlotHits(void)
{
	// Enable options for all tracks
	vector<const DMCTrackCandidate*> mctc;
	eventloop->Get(mctc);
	mmf->EnableRadioButtons(mctc.size());

	// Draw the empty screen
	axes_hits->Draw("AXIS");
	
	// Delete old Markers
	for(int i=0; i<markers.size(); i++)delete markers[i];
	markers.clear();

	// Delete old Ellipses
	for(int i=0; i<circles.size(); i++)delete circles[i];
	circles.clear();

	// Draw BCAL for reference
	float R1=65.0;
	float R2=90.0;
	TEllipse *circle = new TEllipse(0.0,0.0,R1,R1);
	circle->SetLineColor(14);
	circles.push_back(circle);
	circle = new TEllipse(0.0,0.0,R2,R2);
	circle->SetLineColor(14);
	circles.push_back(circle);
	circle = new TEllipse(0.0,0.0,(R1+R2)/2.0,(R1+R2)/2.0);
	circle->SetLineWidth(56);
	circle->SetLineColor(16); // 16= light grey
	circles.push_back(circle);
	
	// Draw circles based on MCTrackCandidates
	for(int i=0;i<mctc.size();i++){
		const DMCTrackCandidate *tc = mctc[i];
		float x0 = tc->x0;
		float y0 = tc->y0;
		float r0 = sqrt(x0*x0 + y0*y0);
		TEllipse *circle = new TEllipse(x0, y0, r0, r0);
		circles.push_back(circle);
	}
	
	// Draw all ellipses
	for(int i=0; i<circles.size(); i++)circles[i]->Draw();
	
	// Loop over all cheat hits and draw them
	vector<const DMCCheatHit*> mccheathits;
	eventloop->Get(mccheathits);
	for(int i=0; i<mccheathits.size(); i++){
		const DMCCheatHit *mccheathit = mccheathits[i];
		float x = mccheathit->r*cos(mccheathit->phi);
		float y = -mccheathit->r*sin(mccheathit->phi);
		int color = colors[mccheathit->track-1];
		int markerstyle = 20+mccheathit->track-1;
		if(mccheathit->system>2)continue;
		if(mccheathit->system>2){markerstyle = 22; color+=100;}
		TMarker *marker = new TMarker(x,y,markerstyle);
		marker->SetMarkerColor(color);
		marker->SetMarkerSize(0.75);
		marker->Draw();
		markers.push_back(marker);
		if(markers.size()>=500)break;
	}
	
	mmf->Update();

	return NOERROR;
}

//------------------------------------------------------------------
// PlotStats
//------------------------------------------------------------------
derror_t MyProcessor::PlotStats(void)
{

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


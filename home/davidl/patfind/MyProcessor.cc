// Author: David Lawrence  June 25, 2004
//
//
// MyProcessor.cc
//

#include <iostream>
using namespace std;

#include "MyProcessor.h"
#include "hddm_s.h"

#include "DMagneticFieldMap.h"
#include "DQuickFit.h"
#include "DFactory_MCCheatHits.h"

#define rad2deg 57.3
#define PI_MASS 0.139568

extern TCanvas *maincanvas;

//------------------------------------------------------------------
// init   -Open output file here (e.g. a ROOT file)
//------------------------------------------------------------------
derror_t MyProcessor::init(void)
{
	// Print list of factories
	event_loop->PrintFactories();
	
	// Create magnetic field map
	//Bfield = new DMagneticFieldMap(41,251);
	//Bfield->readMap();
	Bfield = new DMagneticFieldMap(-2.0);

	// open ROOT file
	ROOTfile = new TFile("hd_ana.root","RECREATE","Produced by hd_ana");
	cout<<"Opened ROOT file \"hd_ana.root\""<<endl;

	// Create Tree
	pat = new TTree("pat","Pattern Recognition");
	pat->Branch("patterns",&x,"x/F:y:z:r:phi");
	
	// Initialize Nlines Nellipse;
	Nlines = 0;
	Nellipse = 0;
	Ntrkhits = 0;
	
	// set limits for plot. This represents the space where the center 
	// of the circle can be. It can be (and often is) outside of the
	// bounds of the solenoid.
	cmax = 120.0; // in cm.

	axes = new TH2F("axes","",10,-cmax,cmax,10,-cmax,cmax);
	
	density = new TH2F("density","Density",240,-cmax,cmax,240,-cmax,cmax);	

	// We want to leave the actual density histo with the full
	// map for drawing. Hence, we make a duplicate here for
	// working with.
	density_work = new TH2F(*density);

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

	// Get MCCheatHits and loop over them
	DContainer *mccheathits = event_loop->Get("MCCheatHits");
	MCCheatHit_t *mccheathit = (MCCheatHit_t*)mccheathits->first();
	for(int i=0;i<mccheathits->nrows;i++, mccheathit++){
	
		float x = mccheathit->r*cos(mccheathit->phi);
		float y = mccheathit->r*sin(mccheathit->phi);

		// decide on using x as a function of y or y as func. of x
		// so we avoid infinite slope
		float x1,y1,x2,y2;
		if(y>x){
			float m = -x/y;
			float b = -1.0/(2.0*y)*(x*x + y*y);
			
			x1 = -cmax;
			x2 = cmax;
			y1 = m*x1 + b;
			y2 = m*x2 + b;
		}else{
			float m = -y/x;
			float b = -1.0/(2.0*x)*(x*x + y*y);
			
			y1 = -cmax;
			y2 = cmax;
			x1 = m*y1 + b;
			x2 = m*y2 + b;
		}
		
		lines[Nlines] = new TLine(x1,y1,x2,y2);
		int colors[] = {kBlack,kRed,kBlue,kMagenta};
		lines[Nlines]->SetLineColor(colors[mccheathit->track]);
		lines[Nlines++]->Draw();
	}
	
	// Draw circles at focus points
	for(int i = 0;i<Nellipse;i++)ellipse[i]->Draw();

	maincanvas->Update();
	cout<<endl<<"Done"<<endl;
	
	return NOERROR;
}

//------------------------------------------------------------------
// FindTracks
//------------------------------------------------------------------
derror_t MyProcessor::FindTracks(void)
{
	/// Find tracks by repeatedly filling the density
	/// histogram and looking for the maximum. As each
	/// maximum is found, a TEllipse is created centered
	// on the maximum.

	// Delete old ellipses (tracks)
	for(int i=0;i<Nellipse;i++)delete ellipse[i];
	Nellipse = 0;
	
	// Delete old DTrkHits
	for(int i=0;i<Ntrkhits;i++)delete trkhit[i];
	Ntrkhits = 0;
	
	// Create a new DTrkHit object for each MCCheatHit
	DContainer *mccheathits = event_loop->Get("MCCheatHits");
	MCCheatHit_t *mccheathit = (MCCheatHit_t*)mccheathits->first();
	for(Ntrkhits=0;Ntrkhits<mccheathits->nrows;Ntrkhits++, mccheathit++){
		float x = mccheathit->r*cos(mccheathit->phi);
		float y = mccheathit->r*sin(mccheathit->phi);

		trkhit[Ntrkhits] = new DTrkHit(x,y);
		if(Ntrkhits>=299)break;
	}
	
	do{
		TH2F *tmp;
		tmp = Nellipse<1 ? density:density_work;
	
		// Fill the density histogram
		FillDensityHistogram(tmp);

		// Find the coordinates of the maximum
		int xbin, ybin, zbin;
		tmp->GetMaximumBin(xbin,ybin,zbin);
		float x = tmp->GetXaxis()->GetBinCenter(xbin);
		float y = tmp->GetYaxis()->GetBinCenter(ybin);

		// Flag all hits within masksize of the focus as used
		int Nhits_this_track = 0;
		int Nhits_not_used = 0;
		float masksize = 5.0;
		DTrkHit **t = trkhit;
		for(int i=0;i<Ntrkhits;i++ ,t++){
			if((*t)->used)continue;
			float d = (*t)->DistToLine(x,y);
			if(d <= masksize){
				(*t)->used = 1;
				Nhits_this_track++;
			}else{
				Nhits_not_used++;
			}
		}
		
		// If there are less than 4 hits on this track, assume that
		// means it's not really a track and we've already found them
		// all.
		if(Nhits_this_track<4)break;
		
		// Record the location of the maximum by making a TEllipse we can
		// draw there later.
		ellipse[Nellipse] = new TEllipse(x,y,masksize);
		ellipse[Nellipse]->SetLineColor(Nellipse<3 ? kRed:kBlue);
		Nellipse++;
		
		// If less than 4 hits remain unused, we can stop looking now
		if(Nhits_not_used<4)break;

	}while(Nellipse<10);
	cout<<__FILE__<<":"<<__LINE__<<" Found "<<Nellipse<<" tracks"<<endl;
	
	return NOERROR;
}

//------------------------------------------------------------------
// densityPlot
//------------------------------------------------------------------
derror_t MyProcessor::densityPlot(void)
{
	
	// If tracks haven't been found yet, then find them
	if(Nellipse==0)FindTracks();
	
	// Draw contour map
	density->Draw("cont");

	// Draw circles at focus points
	for(int i = 0;i<Nellipse;i++)ellipse[i]->Draw();
	
	// Update canvas
	maincanvas->Update();
	cout<<endl<<"Done"<<endl;
	
	return NOERROR;
}

//------------------------------------------------------------------
// FillDensityHistogram
//------------------------------------------------------------------
derror_t MyProcessor::FillDensityHistogram(TH2F *hist)
{
	/// Loop over all trkhits and fill the density histo for
	/// any that don't have their used flag set.
	hist->Reset();
	DTrkHit **t = trkhit;
	for(int i=0;i<Ntrkhits;i++ ,t++){
		if((*t)->used)continue;
		
		(*t)->FillDensityHistogram(hist);
	}
	
	return NOERROR;
}

//------------------------------------------------------------------
// fini   -Close output file here
//------------------------------------------------------------------
derror_t MyProcessor::fini(void)
{
	ROOTfile->Write();
	delete ROOTfile;
	cout<<endl<<"Closed ROOT file"<<endl;

	return NOERROR;
}


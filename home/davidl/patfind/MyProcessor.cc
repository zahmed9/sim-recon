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
	
	// set limits for plot. This represents the space where the center 
	// of the circle can be. It can be (and often is) outside of the
	// bounds of the solenoid.
	cmax = 100.0; // in cm.

	axes = new TH2F("axes","",10,-cmax,cmax,10,-cmax,cmax);
	
	density = new TH2F("density","Density",200,-cmax,cmax,200,-cmax,cmax);	

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

	// Get MCCheatHits and loop over them, adding them to the DQuickFit object
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
	
	maincanvas->Update();
	cout<<endl<<"Done"<<endl;
	
	return NOERROR;
}

//------------------------------------------------------------------
// densityPlot
//------------------------------------------------------------------
derror_t MyProcessor::densityPlot(void)
{
	TAxis *yaxis = density->GetYaxis();
	TAxis *xaxis = density->GetXaxis();
	int NbinsY = yaxis->GetNbins();
	int NbinsX = xaxis->GetNbins();
	
	// Delete old circles
	for(int i=0;i<Nellipse;i++)delete ellipse[i];
	Nellipse = 0;
	
	// Fill density plot (if needed)
	if(density->Integral()==0.0){
		for(int i=1;i<=NbinsY;i++){
			float y = yaxis->GetBinCenter(i);
			for(int j=1;j<=NbinsX;j++){
				float x = xaxis->GetBinCenter(j);
			
				FillDensityBin(x,y);
			}
		}
	}
	
	density->Draw("cont");

	// Indentify peaks
	TH2F *tmp = new TH2F(*density);
	double max = tmp->GetMaximum();
	for(int Nellipse=0;Nellipse<99;Nellipse++){
	
		int xbin, ybin, zbin;
		tmp->GetMaximumBin(xbin,ybin,zbin);
		float x = xaxis->GetBinCenter(xbin);
		float y = yaxis->GetBinCenter(ybin);

		cout<<__FILE__<<":"<<__LINE__<<"x="<<x<<"  y="<<y<<endl;
		cout<<__FILE__<<":"<<__LINE__<<" frac="<<tmp->GetMaximum()/max<<endl;
		if(tmp->GetMaximum()/max < 0.25)break;

		int masksize = 15;
		ellipse[Nellipse] = new TEllipse(x,y,masksize);
		ellipse[Nellipse]->SetLineColor(Nellipse<3 ? kRed:kBlue);
		ellipse[Nellipse]->Draw();
		
		// Zero out neighbors of max so we can find new max
		// on next iteration
		for(int ii=xbin-masksize;ii<=xbin+masksize;ii++){
			if(ii<1 || ii>NbinsX)continue;
			for(int jj=ybin-masksize;jj<=ybin+masksize;jj++){
				if(jj<1 || jj>NbinsY)continue;
				float r2 = pow((double)ii-xbin,2.0) + pow((double)jj-ybin,2.0);
				if(sqrt(r2)>masksize)continue;
				tmp->SetBinContent(ii,jj,0);
			}
		}
		
	}
	
	maincanvas->Update();
	delete tmp;
	cout<<endl<<"Done"<<endl;
	
	return NOERROR;
}

//------------------------------------------------------------------
// FillDensityBin
//------------------------------------------------------------------
derror_t MyProcessor::FillDensityBin(float X, float Y)
{
	// Get MCCheatHits and loop over them, adding them to the DQuickFit object
	DContainer *mccheathits = event_loop->Get("MCCheatHits");
	MCCheatHit_t *mccheathit = (MCCheatHit_t*)mccheathits->first();
	for(int i=0;i<mccheathits->nrows;i++, mccheathit++){
	
		float x = mccheathit->r*cos(mccheathit->phi);
		float y = mccheathit->r*sin(mccheathit->phi);

		// decide on using x as a function of y or y as func. of x
		// so we avoid infinite slope
		float x1,y1;
		if(y>x){
			float m = -x/y;
			float b = -1.0/(2.0*y)*(x*x + y*y);
			
			x1 = (X-m*(b-Y))/(1.0+m*m);
			y1 = m*x1 + b;
			
		}else{
			//continue;
			float m = -y/x;
			float b = -1.0/(2.0*x)*(x*x + y*y);
			
			y1 = (Y-m*(b-X))/(1.0+m*m);
			x1 = m*y1 + b;
		}
		
		float d2 = pow((double)(X-x1),2.0) + pow((double)(Y-y1),2.0);
		float w = exp(-d2*d2/1.0);
		density->Fill(X,Y,w);
		//break;
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


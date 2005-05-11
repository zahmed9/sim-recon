// Author: David Lawrence  June 25, 2004
//
//
// MyProcessor.cc
//

#include <iostream>
using namespace std;

#include "MyProcessor.h"

#include "DFactory_DMCCheatHit.h"
#include "DFactory_DMCTrackHists.h"

TH1F *FDC_z, *FDC_r, *CDC_z, *CDC_r;

//------------------------------------------------------------------
// init   -Open output file here (e.g. a ROOT file)
//------------------------------------------------------------------
derror_t MyProcessor::init(void)
{
	// Print list of factories
	eventLoop->PrintFactories();

	// open ROOT file
	ROOTfile = new TFile("hd_ana.root","RECREATE","Produced by hd_ana");
	cout<<"Opened ROOT file \"hd_ana.root\""<<endl;
	
	FDC_z = new TH1F("FDC_z","FDC z-hits", 6510, 0.0, 650.0);
	CDC_z = new TH1F("CDC_z","CDC z-hits", 6510, 0.0, 650.0);
	FDC_r = new TH1F("FDC_r","FDC r-hits", 1100,0.0, 100.0);
	CDC_r = new TH1F("CDC_r","CDC r-hits", 1100, 0.0, 100.0);
	
	return NOERROR;
}

//------------------------------------------------------------------
// evnt   -Fill histograms here
//------------------------------------------------------------------
derror_t MyProcessor::evnt(int eventnumber)
{

	// Histograms are created and filled in DMCTrackHists factory
	vector<const DMCTrackHists*> TrackHists;
	eventLoop->Get(TrackHists);

	// Histograms to determine angles from geometry
	vector<const DMCCheatHit*> mccheathits;
	eventLoop->Get(mccheathits);
	for(unsigned int i=0; i<mccheathits.size(); i++){
		const DMCCheatHit *hit = mccheathits[i];
		if(hit->system==1){
			CDC_z->Fill(hit->z);
			CDC_r->Fill(hit->r);
		}
		if(hit->system==2){
			FDC_z->Fill(hit->z);
			FDC_r->Fill(hit->r);
		}
	}
	
	eventLoop->PrintRate();

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


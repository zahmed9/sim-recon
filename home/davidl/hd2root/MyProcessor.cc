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

//------------------------------------------------------------------
// init   -Open output file here (e.g. a ROOT file)
//------------------------------------------------------------------
derror_t MyProcessor::init(void)
{
	// Print list of factories
	event_loop->PrintFactories();
	
	// Create magnetic field map
	Bfield = new DMagneticFieldMap(41,251);
	Bfield->readMap();
	//Bfield = new DMagneticFieldMap(-2.0);

	// open ROOT file
	ROOTfile = new TFile("hd_ana.root","RECREATE","Produced by hd_ana");
	cout<<"Opened ROOT file \"hd_ana.root\""<<endl;

	// Create histogram
	p_rec			= new TH1F("p_rec","Reconstucted momentum(GeV/c)",1000, 1.0, 2.0);
	e_rec			= new TH1F("e_rec","Reconstucted pion Energy(GeV/c^2)",1000, 1.0, 2.0);
	theta_rec	= new TH1F("theta_rec","Reconstucted theta(degrees)",3000, 0.0, 150.0);
	phi_rec		= new TH1F("phi_rec","Reconstucted phi(degrees)",3600, 0.0, 360.0);
	z_rec			= new TH1F("z_rec","Reconstucted z(cm)",1200, 0.0, 120.0);
	
	// Create Tree
	rec = new TTree("rec","Reconstructed Values");
	rec->Branch("reconstructed",&t_p,"p/F:E:theta:phi:z");

	return NOERROR;
}

//------------------------------------------------------------------
// evnt   -Fill histograms here
//------------------------------------------------------------------
derror_t MyProcessor::evnt(int eventnumber)
{
	// Create a DQuickfit object and specify the B-field
	DQuickFit *qf = new DQuickFit();
	qf->SetMagneticFieldMap(Bfield);
	
	// Get MCCheatHits and loop over them, adding them to the DQuickFit object
	DContainer *mccheathits = event_loop->Get("MCCheatHits");
	MCCheatHit_t *mccheathit = (MCCheatHit_t*)mccheathits->first();
	for(int i=0;i<mccheathits->nrows;i++, mccheathit++){

		// DQuickFit assumes a constant B-field so only give it
		// CDC and FDC hits.
		if(mccheathit->system==1 || mccheathit->system==2){
			qf->AddHit(mccheathit->r, mccheathit->phi, mccheathit->z);
		}
	}
	
	// Do the fit
	qf->FitTrack();
	
	// Fill the histos and Tree
	t_p		= qf->p;
	t_e		= sqrt(qf->p*qf->p + PI_MASS*PI_MASS);
	t_theta	= qf->theta*rad2deg;
	t_phi		= qf->phi*rad2deg;
	t_z		= qf->z_vertex;
	p_rec->Fill(t_p);
	e_rec->Fill(t_e);
	theta_rec->Fill(t_theta);
	phi_rec->Fill(t_phi);
	z_rec->Fill(t_z);
	rec->Fill();

	// delete the DQuickFit object and update the rate displayed
	delete qf;	
	event_loop->PrintRate();

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


//*************************************************
//**
//**  Root Macro:    main3_tof.C  
//**  Author:        Curtis A. Meyer
//**  Creation Date: 18-February-1999
//**
//**  Purpose: Read in an mcfast file and look at the 
//**           effect of time-of-flight resolution on
//**           the particle identification. Events are
//**           read in, and the path length, time of
//**           flight and reconstructed momentum are
//**           extracted for each particle. These are
//**           then used to compute the particle mass.
//**           The path lengths are then smeared by
//**           a "clipped" gaussian functions whose 
//**           sigmas are given in the sigma array:
//**
//*************************************************

//
//Begin_Html
/*
<a href= "smearedTOF.gif" >
Here is the output using smeared momentum in the calculation</a>
<a href= "tracedTOF.gif" >
Here is the output for using the trace point momentum   </a>
*/
//End_Html

//******************************************************
//** If __CINT__ is defined then we are using the rootcint
//** C++ interpreter otherwise we are compiling the macro
//** to make a stand-alone executable
//******************************************************

#ifdef __CINT__
{
#endif

#include <iostream.h>
#include <string.h>

//******************************************************
//** Include files if we compile the code;
//******************************************************

  //#ifndef __CINT__
#include <stdlib.h>
#include "TROOT.h"
#include "TApplication.h"
#include "TFile.h"
#include "TRandom.h"
#include "TNtuple.h"
#include "TTree.h"
#include "TBranch.h"
#include "TClonesArray.h"
#include "TStopwatch.h"
#include "TSystem.h"
#include "TCanvas.h"
#include "TMCFastHepEvt.h"
#include "TMCFastTOF.h"
#include "TMCFastOfflineTrack.h"
#include "TMCFastCalorimeter.h"
#include "TLGDsmears.h"
#include "TMCesr.h"
  
extern void InitGui();
VoidFuncPtr_t initfuncs[] = { InitGui, 0 };
TROOT root("GUI", "GUI test environement", initfuncs);
int main(int argc, char **argv){
    TApplication theApp("App", &argc, argv);
    //#endif

//**************************************************
//**  Root header for the file
//**********************************************        
#ifdef __CINT__

gROOT->Reset();
gSystem->Load("libTMCFast.so"); 

#endif

//** Define the variables that are used througout the program:

//** sigmas in cm

Float_t sigma[10]  = { 0, .25 , .5 , .75, 1 , 1.25, 1.5 , 2 , 2.5 , 5 };

Int_t   pdgmap[20];   //** Map: pdgmap[hepindex] = pdgid.
Int_t   heppt[20];    //** Map: heppt[offtrk] = hepindex.
Int_t   ntrk = 0;     //** Number of offline tracks in the event.
Float_t tuple[27];    //** Array for ntuple data.
Double_t Fmass[10];   //** Array of forward masses.
Double_t Cmass[10];   //** Array of central masses.
Double_t betal[10];   //** Array of smeared betas.
Double_t beta=0;      //** Beta nominal:

//** Initialize arrays to zero:

for ( Int_t ii=0; ii<20; ii++){
  pdgmap[ii]=0; 
  heppt[ii]=0;
}
for ( Int_t i=0; i<26; i++){tuple[i]=0;}

//**  Open the histogram file:

TFile *hfile = (TFile *)gROOT->FindObject("leng-hist.root"); if (hfile) hfile->Close();
hfile = new TFile("leng-hist.root","RECREATE","Time of Fligh Checks");

//** Book an ntuple to store the data in:

TNtuple *ms_tup = new TNtuple("ms_tup","TOF Resolution",
 "id:p:pz:pt:th:l:t:mc0:mc1:mc2:mc3:mc4:mc5:mc6:mc7:mc8:mc9:mf0:mf1:mf2:mf3:mf4:mf5:mf6:mf7:mf8:mf9");

//** Open the HDFast file:

TFile f("p_K-pi+pi-K+:B10M1.7W0.25.rdt");

//** Set up appropriate pointers to the data tree:

TTree *tree = (TTree*)f.Get("T");

TBranch *b1 = tree->GetBranch("hepevt");
TBranch *b2 = tree->GetBranch("tof_trace");
TBranch *b3 = tree->GetBranch("offtrk");
TBranch *b4 = tree->GetBranch("bcal");
TBranch *b5 = tree->GetBranch("lgdSmears");

TMCFastHepEvt *hepevt         = new TMCFastHepEvt();
TMCFastTOF *trace             = new TMCFastTOF();
TMCFastOfflineTrack *offtrk   = new TMCFastOfflineTrack();
TMCFastHepParticle *particle;
TMCFastCalorimeter *bcal      = new TMCFastCalorimeter();
TLGDsmears *lgdSmears         = new TLGDsmears();

b1->SetAddress(&hepevt);
b2->SetAddress(&trace);
b3->SetAddress(&offtrk);
b4->SetAddress(&bcal);
b5->SetAddress(&lgdSmears); 

//** Initialize timing:

TStopwatch timer;
timer.Start();

//*********************************************************
//**  Initialization is complete
//*********************************************************

//** Loop over all the events in the data file:

Int_t nentries = (Int_t)tree->GetEntries(); //** Get number of events.
cout << "I found " << nentries << " events in this file. \n" ;

for (Int_t ev = 1; ev < nentries; ev++) {
  
  tree->GetEvent(ev);        //** Read  event in memory

  //** For the first event, we want to build a map between the hpeindex
  //** and the pdg code for the particle: Note that indicies start
  //** at 1 and not at 0 in this array...

  if ( ev == 1 ) {
    cout << "Buliding Map \n";
    TIter next (hepevt->GetHepParticles());
    while ( (particle = (TMCFastHepParticle *)next()) ) {
      Int_t idx = particle->GetIndex();
      Int_t pdx = particle->GetIdhep();
      pdgmap[idx] = pdx; 
      cout << "Map build "<< idx << " " << pdx << "\n";
    }

    //** Now we want to make one loop over the off-trk group to set up
    //** a mapping between the entry and the hepindex of the particle.
    //** in this array, the index for offline tracks start at 0 .. grrr.

    ntrk = offtrk->GetNtracks();
    for (Int_t i = 0; i<ntrk; i++){
      heppt[i]=offtrk->GetHep(i); 
      cout << "Map build " << i << "  " << heppt[i] << "\n";
    }

  }

  //** The following is done for every event:

  //** Now we want to loop over all the particles inside the 
  //** event. Traces start at index 0.

  Int_t npt = (Int_t)trace->GetNtraces(); //** Get the number of tof traces:
  Int_t hepindex = 0;
  Int_t pdgId    = 0;

  //** Loop over all the tof traces:

  for (Int_t pt = 0; pt < npt; pt++) {

    //** Ok, this is interesting. We have up to two entries per particle.
    //** The first is at the vertex, so we need to be sure to get that
    //** one first.

    hepindex       = trace->GetHep(pt);
    Int_t type     = trace->GetType(pt);
    Int_t ptt      = pt+1;
    Int_t type2    = trace->GetType(ptt);

    //** Valid entries will have type=4 and type2=41 or 42, we need
    //** to locate and process these.

    if ( type == 4 && type2 != 4) {

      //** Get the pdg particle code from the map:

      pdgId = pdgmap[hepindex];

      //** Determine the offtrk index for this track, these indiceis start
      //** at zero. indx will point to the offline track with the correct
      //** hepindex.

      Int_t indx=0;
      for ( indx=0; indx<ntrk; indx++){
	if ( hepindex == heppt[indx] ) break;
      }

      //** Handle the condition that we did not find a match...

      if ( indx > ntrk ) {
	cout << "I am lost! ";
	exit(1);
      }
      
      //** Get the reconstructed momentum of this particle:

      Float_t theta = 0.;
      Float_t p     = (Float_t)offtrk->GetP(indx);
      Float_t ptran = (Float_t)offtrk->GetPt(indx);
      Float_t pz    = (Float_t)offtrk->GetPz(indx);
      if ( p != 0. ) {theta = acos(pz/p);}

      //** Copy these into the tuple array:

      tuple[0] = (Float_t)pdgId;
      tuple[1] = p;
      tuple[2] = pz;
      tuple[3] = ptran;
      tuple[4] = theta;

      //** Get the time of flight of the particle -- units are ns:

      Double_t t0  = trace->GetTime(pt);
      Double_t tf  = trace->GetTime(ptt);
      Double_t tof = tf - t0;

      //** Get the path length of the track -- units are cm:

      Double_t l0  = trace->GetPath(pt);
      Double_t lf  = trace->GetPath(ptt);
      Double_t path = lf - l0;

      //** Store the path length and time of flight (unsmeared).

      tuple[5] = (Float_t) path;
      tuple[6] = (Float_t) tof;

      //** Produce a random Gaussian distributions centered at 0, and
      //** with a sigma of 1.0. Also require that the number be within
      //** four sigma of the mean:

      Double_t rndm = (Double_t)gRandom->Gaus(0.0 , 1.0);
      while ( rndm < -4. || rndm >4.) {
	rndm = (Double_t)gRandom->Gaus(0.0 , 1.0);
      }

      //** Speed of light = 29.9792 cm/ns
      //** c(-1) = 0.0333564 ns/cm
      //** Generate a series of beta's based on smeared time of flights

      beta     = 0.0333564 / tof;

      for ( Int_t i=0; i<10; i++){
	betal[i] = beta * ( path + (rndm*((Double_t)sigma[i])));
	if ( type2 == 41 ) {       //** Central:
	  Cmass[i] = ((Double_t)p)*sqrt( (1.0/(betal[i]*betal[i])) - 1.0 );
	  Fmass[i] = -100.;
	}
	else if ( type2 ==42 ) {    //** Forward:
	  Fmass[i] = ((Double_t)p)*sqrt( (1.0/(betal[i]*betal[i])) - 1.0 );
	  Cmass[i] = -100.;
	}
	//**  Store all the data into the ntuple array:

	tuple[7+i]  = (Float_t)Cmass[i];
	tuple[17+i] = (Float_t)Fmass[i];
      }

      ms_tup->Fill(tuple);

    }
  }
  // Get the next event

  hepevt->Clear();
  trace->Clear();
  offtrk->Clear();
  bcal->Clear();
  lgdSmears->Clear(); 
}

timer.Stop();
Double_t rtime = timer.RealTime();
Double_t ctime = timer.CpuTime();
printf("RealTime=%f seconds, CpuTime=%f seconds\n",rtime,ctime);

hfile->Write();

// now create some pads to put the histo's

return 0;
}





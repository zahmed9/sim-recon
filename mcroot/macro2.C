{
//
// This is an example of a simple histograming macro
//Begin_Html
/*
<a href= "macro2.gif" >
Here is the output </a>
*/
//End_Html
//
#include <iostream.h>

gSystem.Load("libTMCFast.so");

TFile f("test.rdt");
TTree *tree = (TTree*)f.Get("T");

TBranch *b1 = tree->GetBranch("hepevt");
TBranch *b2 = tree->GetBranch("tof_trace");
TBranch *b3 = tree->GetBranch("offtrk");

TMCFastHepEvt *hepevt=0;
TMCFastTOF *trace=0; 
TMCFastOfflineTrack *offtrk=0;  
hepevt = new TMCFastHepEvt();
trace = new TMCFastTOF();
offtrk = new TMCFastOfflineTrack();

b1->SetAddress(&hepevt);
b2->SetAddress(&trace);
b3->SetAddress(&offtrk);

// create some histograms
TH1F *h1 = new TH1F("h1", "particle #1 Px",100,-1.0,1.0);
TH1F *h2 = new TH1F("h2", "particle #2 Px",100,-1.0,1.0);
TH1F *h3 = new TH1F("h3", "particle #3 Px",100,-1.0,1.0);
TH1F *h4 = new TH1F("h4", "particle #4 Px",100,-1.0,1.0);

// now create some pads to put the histo's
TCanvas *c1;
c1 = new TCanvas("c1","The FillRandom example",200,10,700,900);
c1->SetFillColor(18);

TPad *pad1,pad2,pad3,pad4;
pad1 = new TPad("pad1","The pad for particle #1",0.05,0.55,0.45,0.95,21);
pad2 = new TPad("pad2","The pad for particle #2",0.05,0.05,0.45,0.45,21);
pad3 = new TPad("pad3","The pad for particle #3",0.55,0.55,0.95,0.95,21);
pad4 = new TPad("pad4","The pad for particle #4",0.55,0.05,0.95,0.45,21);

pad1->Draw();
pad2->Draw();
pad3->Draw();
pad4->Draw();

Int_t nentries = (Int_t)tree->GetEntries();
cout<<"this data file has "<<nentries<<" events.\n";

for (Int_t ev = 1; ev < nentries; ev++) {
  tree->GetEvent(ev);        //read  event in memory

  // fill the histos
  TIter next(hepevt->GetHepParticles());
  TMCFastHepParticle *particle = (TMCFastHepParticle *)next();
  h1->Fill(particle->GetPx());
  particle = (TMCFastHepParticle *)next();
  h2->Fill(particle->GetPx());
  particle = (TMCFastHepParticle *)next();
  h3->Fill(particle->GetPx());
  particle = (TMCFastHepParticle *)next();
  h4->Fill(particle->GetPx());
   
   /*
  if(ev == 1){ 
  cout << "\nDumping one event:" << endl ;
  cout << "\nhepevt->Dump()\n";
  hepevt->Dump();
  cout << "\nparticle->Dump()\n";
  particle->Dump();
  cout << "\ntrace->Dump()\n";
  trace->Dump();
  cout << "\nofftrk->Dump()\n";
  offtrk->Dump();
  }
  */

  hepevt->Clear();
  trace->Clear();
  offtrk->Clear();
}
// draw the histos
pad1->cd();
h1->Draw();
pad2->cd();
h2->Draw();
pad3->cd();
h3->Draw();
pad4->cd();
h4->Draw();

return 0;
}

{
gROOT->Reset();
gSystem.Load("libTMCFast.so");

TFile f("Event.rdt");
TTree *tree = (TTree*)f.Get("T");
TBranch *b1 = tree->GetBranch("hepevt");
TBranch *b2 = tree->GetBranch("trace");
TBranch *b3 = tree->GetBranch("offtrk");

TMCFastHepEvt *hepevt=0;
TMCFastTOF *trace=0; 
TMCFastOfflineTrack *offtrk=0;
TMCFastHepParticle *particle=0;
hepevt = new TMCFastHepEvt();
hepevt->Clear();
trace = new TMCFastTOF();
offtrk = new TMCFastOfflineTrack();

b1->SetAddress(&hepevt);
b2->SetAddress(&trace);
b3->SetAddress(&offtrk);

TH1F *h[4];

h[0] = new TH1F("h1", "x momentum",100,0.0,1.0);
h[1] = new TH1F("h2", "x momentum",100,0.0,1.0);
h[2] = new TH1F("h3", "x momentum",100,0.0,1.0);
h[3] = new TH1F("h4", "x momentum",100,0.0,1.0);

TCanvas *c1;
c1 = new TCanvas("c1","MCFast histos",200,10,700,900);
TPad *pad1,pad2,pad3,pad4;

pad1 = new TPad("pad1","The pad with the function",0.05,0.55,0.45,0.95,21);
pad2 = new TPad("pad2","The pad with the histogram",0.05,0.05,0.45,0.45,21);
pad3 = new TPad("pad3","The pad with the histogram",0.55,0.55,0.95,0.95,21);
pad4 = new TPad("pad4","The pad with the function",0.55,0.05,0.95,0.45,21);
pad1->Draw();
pad2->Draw();
pad3->Draw();
pad4->Draw();

Int_t nentries = (Int_t)tree->GetEntries();
for (Int_t ev = 1; ev < nentries; ev++) {
  tree->GetEvent(ev);        //read  event in memory
  
  TIter next(hepevt->GetHepParticles());
  for(Int_t i=0;i<4;i++){
    particle = (TMCFastHepParticle *)next();
    h[i]->Fill(particle->GetPx());
  }
 
    
  hepevt->Clear();
  trace->Clear();
  offtrk->Clear();
}
pad1->cd();
h[0]->Draw();
pad2->cd();
h[1]->Draw();
pad3->cd();
h[2]->Draw();
pad4->cd();
h[3]->Draw();
}

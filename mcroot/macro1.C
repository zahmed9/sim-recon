{

gROOT->Reset();
gSystem->Load("libTMCFast.so"); // Do this once!


TFile f("test1.rdt");
TTree *tree = (TTree*)f.Get("T");

TBranch *b1 = tree->GetBranch("hepevt");
TBranch *b2 = tree->GetBranch("tof_trace");
TBranch *b3 = tree->GetBranch("offtrk");

TMCFastHepEvt *hepevt;
TMCFastTOF *trace; 
TMCFastOfflineTrack *offtrk;  
hepevt = new TMCFastHepEvt();
trace = new TMCFastTOF();
offtrk = new TMCFastOfflineTrack();

b1->SetAddress(&hepevt);
b2->SetAddress(&trace);
b3->SetAddress(&offtrk);
// create some histograms and some place to put them

TH1F *h1 = new TH1F("h1", "CTOF mass kaon",100,0.1,0.8);
TH1F *h2 = new TH1F("h2", "CTOF mass pion",100,0.0,0.5);
TH1F *h3 = new TH1F("h3", "CTOF mass proton",100,0.2,1.2);
TH1F *h4 = new TH1F("h4", "FTOF mass kaon",100,0.1,0.8);
TH1F *h5 = new TH1F("h5", "FTOF mass pion",100,0.0,0.5);
TH1F *h6 = new TH1F("h6", "FTOF mass proton",100,0.2,1.2);

// now create some pads to put the histo's
c1 = new TCanvas("c1","Halld Time-of-Flight",100,10,700,900);
c1->SetFillColor(18);


pad1 = new TPad("pad1","The pad with the function",0.05,0.66,0.45,0.96,21);
pad2 = new TPad("pad2","The pad with the histogram",0.05,0.34,0.45,0.64,21);
pad3 = new TPad("pad3","The pad with the histogram",0.05,0.02,0.45,0.32,21);

pad4 = new TPad("pad4","The pad with the function",0.55,0.66,0.95,0.96,21);
pad5 = new TPad("pad5","The pad with the histogram",0.55,0.34,0.95,0.64,21);
pad6 = new TPad("pad6","The pad with the histogram",0.55,0.02,0.95,0.32,21);

/*
pad3 = new TPad("pad3","The pad with the histogram",0.55,0.55,0.95,0.95,21);
pad4 = new TPad("pad4","The pad with the function",0.55,0.05,0.95,0.45,21);
pad5 = new TPad("pad5","The pad with the histogram",0.55,0.55,0.95,0.95,21);
pad6 = new TPad("pad6","The pad with the function",0.55,0.05,0.95,0.45,21);
*/
pad1->Draw();
pad2->Draw();
pad3->Draw();
pad4->Draw();
pad5->Draw();
pad6->Draw();

Int_t nentries = (Int_t)tree->GetEntries();

for (Int_t ev = 0; ev < nentries; ev++) {
  
  tree->GetEvent(ev);        //read  event in memory
  
  //cout<< *hepevt;
  //Int_t nn=hepevt->GetNhep();
  //hepevt->Dump();
  //trace->Dump();
  //offtrk->Dump();
  
  for(Int_t i=0;i< hepevt->GetNhep() ;i++){
 
    /**** Using the smeared momentum */
    h1->Fill(trace->CTOFmass(1,*offtrk));// kaon
    h1->Fill(trace->CTOFmass(4,*offtrk));// kaon
    h2->Fill(trace->CTOFmass(2,*offtrk));// pion
    h2->Fill(trace->CTOFmass(3,*offtrk));// pion
    h3->Fill(trace->CTOFmass(5,*offtrk));// proton
    h4->Fill(trace->FTOFmass(1,*offtrk));// kaon
    h4->Fill(trace->FTOFmass(4,*offtrk));// kaon
    h5->Fill(trace->FTOFmass(2,*offtrk));// pion
    h5->Fill(trace->FTOFmass(3,*offtrk));// pion
    h6->Fill(trace->FTOFmass(5,*offtrk));// proton
    /*******/
    /******* Using the trace point momentum *
    h1->Fill(trace->CTOFmass(1));// kaon
    h1->Fill(trace->CTOFmass(4));// kaon
    h2->Fill(trace->CTOFmass(2));// pion
    h2->Fill(trace->CTOFmass(3));// pion
    h3->Fill(trace->CTOFmass(5));// proton
    h4->Fill(trace->FTOFmass(1));// kaon
    h4->Fill(trace->FTOFmass(4));// kaon
    h5->Fill(trace->FTOFmass(2));// pion
    h5->Fill(trace->FTOFmass(3));// pion
    h6->Fill(trace->FTOFmass(5));// proton
    ************/
  }
  hepevt->Clear();
  trace->Clear();
  offtrk->Clear();
}
pad1->cd();
h1->Draw();
pad2->cd();
h2->Draw();
pad3->cd();
h3->Draw();
pad4->cd();
h4->Draw();
pad5->cd();
h5->Draw();
pad6->cd();
h6->Draw();
return 0;
}

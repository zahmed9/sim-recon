{
#include <iostream.h>
//gROOT->Reset();
gSystem.Load("libTMCFast.so");


TFile f("test1.rdt");
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

 Int_t nentries = (Int_t)tree->GetEntries();

 Int_t nparts;

for( Int_t ev = 1;ev<20;ev++){ 
  nparts=0;
  cout<<"\nEvent: "<<ev<<endl;
 tree->GetEvent(ev);        //read  event in memory
 TIter next(hepevt->GetHepParticles());
 TMCFastHepParticle *particle = (TMCFastHepParticle *)next() ;
 particle->Dump();
 nparts++;
 cout<<endl;
 while(particle = (TMCFastHepParticle *)next() )
   {
     //particle->Dump();
     particle->Print();
   nparts++;
   cout<<endl;
 }
 cout << "Number of particles in Event is "<< nparts <<endl;
}


/*************
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


 Int_t nn=hepevt->GetNevhep();

 TIter next(hepevt->GetHepParticles());
 if(ev != 0){ 
  
  TMCFastHepParticle *particle = (TMCFastHepParticle *)next();
  
  particle = (TMCFastHepParticle *)next();
  particle = (TMCFastHepParticle *)next();
  particle = (TMCFastHepParticle *)next();
  
  }

  hepevt->Clear();
  trace->Clear();
  offtrk->Clear();
  ************************/
return 0;
}

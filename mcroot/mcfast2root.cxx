//*-- author :    Paul Eugenio  2-Nov-98

////////////////////////////////////////////////////////////////////////
//
//             A simple example with a ROOT tree
//             =================================
//
//  This program creates :
//    - a ROOT file
//    - a tree
//    -  MCFastStdHep object
//
//  
////////////////////////////////////////////////////////////////////////


#include <stdio.h>
#include <fstream.h>
#include <stdlib.h>
#include <TROOT.h>
#include <TFile.h>
#include <TRandom.h>
#include <TTree.h>
#include <TBranch.h>
#include <TClonesArray.h>
#include <TStopwatch.h>
#include <TSystem.h>

#include "TMCFastHepEvt.h"
#include "TMCFastTOF.h"
#include "TMCFastOfflineTrack.h"

struct event_t {
  struct traces_t traces;    // defined in TMCFastTOF.h
  struct hepevt_t  mcevt;  // defined in TMCFastHepEvt.h
  struct ntrkoff_t offtrk;  // defined in TMCFastOfflineTrack.h
};

int  ReadEvent(ifstream &inFile, event_t *event);

//______________________________________________________________________________

TROOT simple("simple","Example of creation of a tree");


int main(int argc, char **argv)
{

  //   
  //
  // Create a new ROOT binary machine independent file.
  // Note that this file may contain any kind of ROOT objects, histograms,
  // pictures, graphics objects, detector geometries, tracks, events, etc..
  // This file is now becoming the current directory.
  
  event_t event;

  //  gSystem->Load("libTMCFast.so");

  Int_t comp   = 1;       // by default file is compressed
  Int_t split  = 1;       // by default, split Event in sub branches
  TFile *rdtfile;
  rdtfile = new TFile((const Text_t *)("Event.rdt"),(Option_t *)("RECREATE"),(const Text_t *)("TTree benchmark ROOT file"));
  rdtfile->SetCompressionLevel(comp);
  
  
  // Create a ROOT Tree and one superbranch
  TTree *tree = new TTree("T","An example of a ROOT tree");
  tree->SetAutoSave(1000000000);  // autosave when 1 Gbyte written
  Int_t bufsize = 256000;
  if (split)  bufsize /= 4;



  // Open input file and read c structure

    ifstream inFile("mcfast.cat");
  

  
  if(inFile.bad())
    cerr<< "Could not open input file \n";
  //inFile.read(&event, sizeof(struct event_t));

   // read event
  Int_t reading=ReadEvent(inFile, &event);


    // Now we have an event.

 

  Int_t counter=0;   
 
  
  TMCFastHepEvt *hepevt=0;
  TMCFastTOF *trace=0;
  TMCFastOfflineTrack *offtrk=0;
  // TTree *tree;
  Int_t nb = 0;

   
  // Create one event
  hepevt = new TMCFastHepEvt(&(event.mcevt));
  trace = new TMCFastTOF(&(event.traces));
  offtrk = new TMCFastOfflineTrack(&(event.offtrk));

  TBranch *b1=tree->Branch("hepevt", "TMCFastHepEvt", &hepevt, bufsize,split);
  TBranch *b2=tree->Branch("trace", "TMCFastTOF", &trace, bufsize,split);
  TBranch *b3=tree->Branch("offtrk", "TMCFastOfflineTrack", &offtrk, bufsize,split);
  while(reading){
 
    
 
    cout<< "counter: "<<counter++<<endl;
    //cout << *hepevt ;
    //cout << *offtrk;
    //cout << *trace ; // Now Print objects
    nb += tree->Fill();  //fill the tree
    
    // clear Particle container
    hepevt->GetHepParticles()->Clear();

    // read event
    reading=ReadEvent(inFile,&event);


    // create new objects 
    hepevt->Fill(&(event.mcevt));
    trace->Fill(&(event.traces));
    offtrk->Fill(&(event.offtrk));
  }
  
  cout<<"\n\nEvents Written: "<<counter<<endl;
  // remember to write and close the file
  rdtfile->Write();
  rdtfile->Close();
  
  return 1;
}

int  ReadEvent(ifstream &inFile, event_t *event){
  Int_t i,status=1,nevhep=0,nhep=0,ntracks=0,ntraces=0;
  static heppart_t *heppart;
  static offline_track_t *trk_off;
  static trace_t *trace;

  inFile.read((char *)(&nevhep), sizeof(int));
  if(inFile.gcount() !=  sizeof(int)){
    cerr<< "Finished reading input data: \n";
    status = 0;
  }else{  
    inFile.read((char *)(&nhep), sizeof(int));
    delete heppart; 
    heppart = new heppart_t[nhep];
    for( i=0;i< nhep;i++)
      inFile.read((char *)(&(heppart[i])), sizeof(heppart_t));

    inFile.read((char *)(&ntracks), sizeof(int));
    delete trk_off;   
    trk_off = new offline_track_t[ntracks];
    for( i=0;i< ntracks;i++)
      inFile.read((char *)(&(trk_off[i])), sizeof(struct offline_track_t));
    
    inFile.read((char *)(&ntraces), sizeof(int));
    delete trace;
    trace = new trace_t[ntraces];
    for( i=0;i< ntraces;i++)
      inFile.read((char *)(&(trace[i])), sizeof(struct trace_t));
  
    if(inFile.gcount() !=  sizeof(struct trace_t)){
      cerr<< "Read bad input data event: \n";
      status =0;
    }
  
  // now make event data

  event->mcevt.nevhep = nevhep;
  event->mcevt.nhep = nhep;
  event->mcevt.heppart = heppart;
  event->offtrk.ntracks = ntracks;
  event->offtrk.trk_off = trk_off;
  event->traces.ntraces = ntraces;
  event->traces.trace = trace;
  }
  return status;
}

//*-- author :    Paul Eugenio  2-Nov-98

////////////////////////////////////////////////////////////////////////
//
//             usr_mcfast2root.cxx
//             =================================
//
//  This routine creates :
//    - a tree of MCFastStdHep object
//
//  
////////////////////////////////////////////////////////////////////////
 

#include <iostream>
#include <fstream> 
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
#include "TMCFastOfflineTrack.h"
#include "TMCFastCalorimeter.h" 
#include "TLGDsmears.h"
//#include "TMCFastHits.h"
#include "TMCFastTraceEvent.h"

using namespace std; 

struct cal_hits_t{
  int nCalHits;
  cal_hit_t **CalorHits;
};
 
struct event_t {
  struct traces_t traces;    // defined in TMCFastTraceEvent.h
  struct hepevt_t  mcevt;  // defined in TMCFastHepEvt.h
  struct ntrkoff_t offtrk;  // defined in TMCFastOfflineTrack.h
  struct cal_hits_t calor0; // defined in TMCFastCalorimeter.h
  lgd_smearedparts_t *lgdSmears;   
  //dev_hits_t *devhits;
  //dev_hits_t *devhits_cdc;
};

//______________________________________________________________________________


extern "C" int usr_mcfast2root(event_t *event)
{

  //   
  // create C++ object from the event structure and save theses
  // objects in a ROOT Tree.
  //
  // Note, a ROOT I/O file may contain any kind of ROOT objects, histograms,
  // pictures, graphics objects, detector geometries, tracks, events, etc..
  // 
  // 
  
  static TMCFastHepEvt *hepevt=0;
  static TMCFastOfflineTrack *offtrk=0;
  //static TMCFastHits *vtx_hits=0;
  //static TMCFastHits *cdc_hits=0;
  static TMCFastTraceEvent *tr_event=0;
  static TMCFastCalorimeter *bcal=0;
  static TLGDsmears *lgdSmears=0;
  

  // Create a ROOT Tree and one superbranch
  static TTree *tree = new TTree("T","HDFast MC event format");

  extern Int_t counter,Nevents,Debug;
  static Int_t firstPass =1;
  if(firstPass){
    firstPass=0;    
    

    // A root file was opened in usr_main.cxx
    
    tree->SetAutoSave(10000000);  // autosave when 100 Mbyte written
    Int_t bufsize = 256000;
    Int_t split  = 0;  // by default, split Event in sub branches
    if (split)  bufsize /= 4;
    
    
    // Create event objects
    hepevt = new TMCFastHepEvt(&(event->mcevt));
    offtrk = new TMCFastOfflineTrack(&(event->offtrk));    
    //vtx_hits = new TMCFastHits(event->devhits);
    //cdc_hits = new TMCFastHits(event->devhits_cdc);
    bcal = new TMCFastCalorimeter(event->calor0.nCalHits,event->calor0.CalorHits);
    lgdSmears = new TLGDsmears(event->lgdSmears);
    tr_event = new TMCFastTraceEvent(&(event->traces));

    //
    // Set branch address
    //
    static TBranch *b1;
    static TBranch *b2;
    static TBranch *b3;
    static TBranch *b4;
    static TBranch *b5;

    b1=tree->Branch("hepevt", "TMCFastHepEvt", 
			     &hepevt, bufsize,split);
    b2=tree->Branch("offtrk", "TMCFastOfflineTrack", 
			     &offtrk, bufsize,split);
    b3=tree->Branch("bcal", "TMCFastCalorimeter", 
			     &bcal, bufsize,split);
    b4=tree->Branch("lgdSmears", "TLGDsmears", 
			     &lgdSmears, bufsize,split);
    b5=tree->Branch("traces", "TMCFastTraceEvent", 
    				    &tr_event, bufsize,split);
    //Int_t Branch_Hits=0;
    //if(Branch_Hits){
    //  static TBranch *b6=tree->Branch("vtx_hits", "TMCFastHits", 
    //				      &vtx_hits, bufsize,split);	    
    //  static TBranch *b7=tree->Branch("cdc_hits", "TMCFastHits", 
    //				      &cdc_hits, bufsize,split);	    
    //}


  }else{
    // create replace the objects objects 
    /*
     * Since the brances are set to the object addresses,
     * it easier to replace(overwrite) them then to delete
     * them, create new objects, and then reset the branch addresses.
     */ 

    hepevt->Fill(&(event->mcevt));
    offtrk->Fill(&(event->offtrk));
    bcal->Fill(event->calor0.nCalHits,event->calor0.CalorHits);  
    lgdSmears->Fill(event->lgdSmears);
    tr_event->Fill(&(event->traces));

    //vtx_hits->Fill(event->devhits);
    //cdc_hits->Fill(event->devhits_cdc);
  }

  counter++;
  Nevents += tree->Fill();  //fill the tree
  
  if(Debug==1){
    cerr <<  *hepevt;
    cerr <<  *offtrk;
    cerr << *bcal << *lgdSmears;
    cerr<<*tr_event;
  }

  // clear object containers
  hepevt->Clear();
  bcal->Clear();
  tr_event->Clear();
  lgdSmears->Clear();
  //vtx_hits->Clear();
  //cdc_hits->Clear();
  
  return 1;
}




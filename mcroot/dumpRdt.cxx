//*-- Author :    Paul Eugenio  2-Nov-98

////////////////////////////////////////////////////////////////////////
//
//             Dump the Hall D ROOT tree
//             =================================
//
//
//  
////////////////////////////////////////////////////////////////////////

#include <stdlib.h>
#include <iostream.h>
#include <string.h>

#include "TROOT.h"
#include "TFile.h"
#include "TRandom.h"
#include "TTree.h"
#include "TBranch.h"
#include "TClonesArray.h"
#include "TStopwatch.h"
#include "TSystem.h"

#include "TMCFastHepEvt.h"
#include "TMCFastTOF.h"
#include "TMCFastOfflineTrack.h"
#include "TMCFastCalorimeter.h"
#include "TLGDsmears.h"
#include "TMCesr.h"
#include "TMCFastHits.h"
#include "TMCFastCerenkov.h"


//______________________________________________________________________________

TROOT dumpRdt("dumpRdt","Dump the Hall D ROOT tree");
TFile *rdtfile;


void PrintUsage(char *processName)
{
  cerr << processName << " usage: [switches] inputfile" <<endl;
  cerr << "\t-n<nevents> The number of event to read (default all).\n";
  cerr << "\t-s<nevents> The number of events to skip before reading(default=0).\n";
  cerr << "\t-L   List branch names of first event\n";
  cerr << "\t-Bbranch1,branch2,...  Dump  these branches\n";
  cerr << "\t-Vbranch1,branch2,... Dump  these virtual branches \n";
  cerr << "\t-g      Dump esr to gamp format (also use -Vesr ) \n";
  cerr<<"\t-h Print this help message\n\n";
}



int main(int argc, char **argv)
{

    
  //   gSystem->Load("libTMCFast.so");
  
  Char_t *argptr,*token,rootfile[500]="Event.rdt",leaf[100][25],Vleaf[100][25];
  Int_t nevents=0,listBranches=0,nleaves2save=0,nVirtualLeaves2save=0;
  Int_t dump_hepevt=0,dump_tof_trace=0,dump_offtrk=0,dump_all=0,
    dump_bcal=0,dump_lgdSmears=0,dump_esr=0,dump_vtx_hits=0,
    dump_cdc_hits=0,dump_ceren=0,dump_gamp=0;
  Int_t skipEvents=0;
  Double_t kludge_beamE=0;
  // MCFast objects
  /*
   * These are the objects (leaves) contained in the tree
   */
  TMCFastHepEvt *hepevt=0; //use  leaf name
  TMCFastTOF *tof_trace=0;  
  TMCFastOfflineTrack *offtrk=0;  
  TMCFastCalorimeter *bcal=0;// barrel
  TLGDsmears *lgdSmears=0;// lgd
  TMCFastHits *vtx_hits=0;// vtx
  TMCFastHits *cdc_hits=0;// cdc
  TMCFastCerenkov *ceren=0;//ceren
  TMCesr *esr=0;

  hepevt = new TMCFastHepEvt();
  tof_trace = new TMCFastTOF();
  offtrk = new TMCFastOfflineTrack();
  bcal = new TMCFastCalorimeter();
  lgdSmears = new TLGDsmears();
  vtx_hits = new TMCFastHits();
  cdc_hits = new TMCFastHits();
  ceren = new TMCFastCerenkov();

  /*
   * Read the command line switches
   */

  if (argc == 1){
    PrintUsage(argv[0]);
    exit (0);
  }
  else {
    for (Int_t i=1; i<argc; i++) {
      argptr = argv[i];
      if ((*argptr == '-') && (strlen(argptr) > 1)) {
        argptr++;
        switch (*argptr) {
	case 's':
	  skipEvents=atoi(++argptr);
	  cerr<<"Skipping "<<skipEvents<<" events\n";
	  break;
        case 'n':
	  nevents =atoi(++argptr) - 1 ;
	  cerr<<"Dumping "<<nevents<<" events\n";
	  break;
	case 'L':
	    listBranches=1;
	    break;
	case 'g':
	  kludge_beamE = atof(++argptr);
	  cerr<<"Dumping Events to Gamp format ("<<kludge_beamE<<" GeV)\n";
	  dump_all=0;
	  dump_gamp=1;
	  break;
	case 'V':
	  cerr<<"Dumping Virutal branches:\n";
	  nVirtualLeaves2save=0;
	  dump_all=0;
	  token =  strtok(++argptr,",");
	  strcpy(Vleaf[nVirtualLeaves2save++],token);
	  while((token = strtok(NULL,",")))
		 strcpy(Vleaf[nVirtualLeaves2save++],token);
	  for(Int_t i=0; i<nVirtualLeaves2save;i++)
	    cerr<<"\t"<<Vleaf[i]<<endl;
	  break;
	case 'B':
	  cerr<<"Dumping only these branches:\n";
	  nleaves2save=0;
	  dump_all=0;
	  token =  strtok(++argptr,",");
	  strcpy(leaf[nleaves2save++],token);
	  while((token = strtok(NULL,",")))
		 strcpy(leaf[nleaves2save++],token);
	  for(Int_t i=0; i<nleaves2save;i++)
	    cerr<<"\t"<<leaf[i]<<endl;
	  break;
	case 'h':
	  PrintUsage(argv[0]);    
          exit(1);
	break;
	default:
          cerr<<"Unrecognized argument -"<< argptr<< "\n\n";
          PrintUsage(argv[0]);    
          exit(-1);
          break;
        }
      }
      else{
	strcpy(rootfile ,argptr);
	cerr<< "Opening "<< rootfile << " for input\n";
      }
    }
  }
  rdtfile = new TFile(rootfile);
  if(! rdtfile->IsOpen()){
    cerr<<"Unable to open file: "<<rootfile<<endl<<"exiting\n";
    exit(-1);
  }
  TBranch *b[10];
  Int_t nbranches=0;
  TTree *tree ;
  tree = (TTree*)rdtfile->Get("T");

 cerr<< "set dump branches\n";

  // set dump flags
  for(Int_t i=0; i<nleaves2save;i++){
    if(strcmp(leaf[i],"hepevt")==0){
      dump_hepevt=1;
      b[nbranches] = tree->GetBranch(leaf[i]);
      b[nbranches++]->SetAddress(&hepevt);
    }
    if(strcmp(leaf[i],"tof_trace")==0){
      dump_tof_trace=1;
      b[nbranches] = tree->GetBranch(leaf[i]);
      b[nbranches++]->SetAddress(&tof_trace);
    }
    if(strcmp(leaf[i],"offtrk")==0){
      dump_offtrk=1;
      b[nbranches] = tree->GetBranch(leaf[i]);
      b[nbranches++]->SetAddress(&offtrk);
    }
    if(strcmp(leaf[i],"bcal")==0){
      dump_bcal=1;
      b[nbranches] = tree->GetBranch(leaf[i]);
      b[nbranches++]->SetAddress(&bcal);
    }
    if(strcmp(leaf[i],"lgdSmears")==0){
      dump_lgdSmears=1;
      b[nbranches] = tree->GetBranch(leaf[i]);
      b[nbranches++]->SetAddress(&lgdSmears);
    }
    if(strcmp(leaf[i],"vtx_hits")==0){
      dump_vtx_hits=1;    
      b[nbranches] = tree->GetBranch(leaf[i]);
      b[nbranches++]->SetAddress(&vtx_hits);
    }
    if(strcmp(leaf[i],"cdc_hits")==0){
      dump_cdc_hits=1;    
      b[nbranches] = tree->GetBranch(leaf[i]);
      b[nbranches++]->SetAddress(&cdc_hits);
    }
    if(strcmp(leaf[i],"ceren")==0){
      dump_ceren=1;  
      b[nbranches] = tree->GetBranch(leaf[i]);
      b[nbranches++]->SetAddress(&ceren);
    }
  }
  // set dump flags for virtual leaves
  for(Int_t i=0; i<nVirtualLeaves2save;i++){
    if(strcmp(Vleaf[i],"esr")==0){
      dump_esr=1;
      if(!dump_hepevt){
	b[nbranches] = tree->GetBranch("hepevt");
	b[nbranches++]->SetAddress(&hepevt);
      }
      if(!dump_offtrk){
	b[nbranches] = tree->GetBranch("offtrk");
	b[nbranches++]->SetAddress(&offtrk);
      }
      if(!dump_bcal){
	b[nbranches] = tree->GetBranch("bcal");
	b[nbranches++]->SetAddress(&bcal);
      }
      if(!dump_lgdSmears){
	b[nbranches] = tree->GetBranch("lgdSmears");
	b[nbranches++]->SetAddress(&lgdSmears);
      }
    }
    if(strcmp(Vleaf[i],"all")==0)
      dump_all=1;
  }
 
  // open file and set tree branches
  cerr.flush();
  
  
 cerr<< "List Branches\n";
  
  // List the Branches
  cerr<< "Branch list:\n";
  TIter next(tree->GetListOfBranches());
  TBranch *branch;
  while(( branch = (TBranch *)next())){
    cerr<< "\t"<<branch->GetName()<<endl;  
  }
  cerr<<"Virtual Branch list:\n"; 
  cerr<< "\tesr\tRequires(hepevt,offtrk,bcal,lgdSmears)" <<endl;
  cerr<<endl;

  Int_t nentries = (Int_t)tree->GetEntries();
  cerr<<"The Tree contains "<<nentries<<" events\n";
  if(listBranches) exit(0);
 
  if(nevents == 0) 
    nevents =nentries-skipEvents;
  else
    nevents +=skipEvents+1; // I skipped the 1st because of missing TCloneArray problem
 
  // Now loop over the events in the file
  for (Int_t ev = 1+skipEvents; ev < nevents; ev++) {
    //read  event in memory 
    tree->GetEvent(ev);   
    // that's it we have one so now let's dump it   

    cerr<<"Event Number: " << ev << "\r";

    if(dump_hepevt || dump_all)
      cout<<  "hepevt\n"<<*hepevt; 
    if(dump_esr){
      esr = new TMCesr(*hepevt,*offtrk,*lgdSmears,*bcal);
      if(dump_gamp)
	esr->DumpGampFormat(&cout,kludge_beamE);
      else
	cout<<  "esr\n"<<*esr;
    }
    if(dump_bcal || dump_all)
      cout<< "bcal\n"<<*bcal;
    if(dump_lgdSmears || dump_all)
      cout<< "lgdSmears\n"<<*lgdSmears;
    if(dump_offtrk || dump_all)
      cout<< "offtrk_hits\n"<<*offtrk;
    if(dump_vtx_hits || dump_all)
      cout<< "vtx_hits\n"<<*vtx_hits;
    if(dump_cdc_hits || dump_all)
      cout<< "cdc_hits\n"<<*cdc_hits;
    if(dump_ceren || dump_all)
      cout<<  "cerenkov_hits\n"<<*ceren;

    if(dump_tof_trace || dump_all){
      cout<<  "tof_hits\n"<<*tof_trace;
      // dump both forward & central TOF for each particle
      for(Int_t i=0; i< hepevt->GetNhep();i++){
	cout << "CTOF["<<i+1<<"]: "<<tof_trace->GetCTOF(i+1)
	  <<"\tmass: "<<tof_trace->CTOFmass(i+1)
	    << " FTOF["<<i+1<<"]: "<< tof_trace->GetFTOF(i+1) 
	      <<"\tmass: "<< tof_trace->FTOFmass(i+1)
		<<endl;
      }
    }
    
    hepevt->Clear();
    tof_trace->Clear();
    offtrk->Clear();
    bcal->Clear();
    ceren->Clear();
    cdc_hits->Clear();
    vtx_hits->Clear();
    lgdSmears->Clear();
    if(dump_esr)
      esr->Clear();
  }
  cerr<<endl;
  rdtfile->Close();
  return 0;
  
}


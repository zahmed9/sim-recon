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

//______________________________________________________________________________

TROOT dumpRdt("dumpRdt","Dump the Hall D ROOT tree");
TFile *rdtfile;

void PrintUsage(char *processName)
{
  cerr << processName << " usage: [switches] inputfile" <<endl;
  cerr << "\t-n<nevents> The number of event to read (default all).\n";
  cerr << "\t-s<nevents> The number of events to skip before reading(default=0).\n";
  cerr << "\t-L   List branch names of first event\n";
  cerr << "\t-Bbranch1,branch2,... or \"all\" Dump only these branches\n";
  cerr << "\t-Vbranch1,branch2,... Dump only these virtual branches \n";
  cerr<<"\t-h Print this help message\n\n";
}



int main(int argc, char **argv)
{

    
  //   gSystem->Load("libTMCFast.so");
  
  Char_t *argptr,*token,rootfile[50]="Event.rdt",leaf[100][25],Vleaf[100][25];
  Int_t nevents=0,listBranches=0,nleaves2save=0,nVirtualLeaves2save=0;
  Int_t dump_hepevt=0,dump_tof_trace=0,dump_offtrk=0,dump_all=1,
        dump_bcal=0,dump_lgdSmears=0,dump_esr=0;
  Int_t skipEvents=0;
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
	  nevents =atoi(++argptr);
	  cerr<<"Dumping "<<nevents<<" events\n";
	  break;
	case 'L':
	    listBranches=1;
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
  // set dump flags
  for(Int_t i=0; i<nleaves2save;i++){
    if(strcmp(leaf[i],"hepevt")==0)
      dump_hepevt=1;
    if(strcmp(leaf[i],"tof_trace")==0)
      dump_tof_trace=1;
    if(strcmp(leaf[i],"offtrk")==0)
      dump_offtrk=1;
    if(strcmp(leaf[i],"bcal")==0)
      dump_bcal=1;
    if(strcmp(leaf[i],"lgdSmears")==0)
      dump_lgdSmears=1;
    
    
  }
  // set dump flags for virtual leaves
  for(Int_t i=0; i<nVirtualLeaves2save;i++){
    if(strcmp(Vleaf[i],"esr")==0)
      dump_esr=1;
    if(strcmp(Vleaf[i],"all")==0)
      dump_all=1;
  }
 
  // open file and set tree branches
  cerr.flush();
  
  rdtfile = new TFile(rootfile);
  TBranch *b[10];
  Int_t nbranches=0;
  TTree *tree ;
  tree = (TTree*)rdtfile->Get("T");

  
  // List the Branches
  cout<< "Branch list:\n";
  TIter next(tree->GetListOfBranches());
  TBranch *branch;
  while((branch= (TBranch *)next())){
    cout<< "\t"<<branch->GetName()<<endl;
    b[nbranches++] = tree->GetBranch(branch->GetName());
  }
  cout<<"Virtual Branch list:\n"; 
  cout<< "\tesr\tRequires(hepevt,offtrk,bcal,lgdSmears)" <<endl;
  cout<<endl;


  // MCFast objects
  /*
   * These are the objects (leaves) contained in the tree
   */
  TMCFastHepEvt *hepevt=0; //use  leaf name
  TMCFastTOF *tof_trace=0;  
  TMCFastOfflineTrack *offtrk=0;  
  TMCFastCalorimeter *bcal=0;// barrel
  TLGDsmears *lgdSmears=0;// lgd

  hepevt = new TMCFastHepEvt();
  tof_trace = new TMCFastTOF();
  offtrk = new TMCFastOfflineTrack();
  bcal = new TMCFastCalorimeter();
  lgdSmears = new TLGDsmears();

  b[0]->SetAddress(&hepevt);
  b[1]->SetAddress(&tof_trace);
  b[2]->SetAddress(&offtrk);
  b[3]->SetAddress(&bcal);
  b[4]->SetAddress(&lgdSmears);


  Int_t nentries = (Int_t)tree->GetEntries();
  cout<<"The Tree contains "<<nentries<<" events\n";
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
    cout<< endl;
    cout<<"Event Number: " << ev << endl;

 
    if(dump_esr){
      TMCesr *esr=0;
      esr = new TMCesr(*hepevt,*offtrk,*lgdSmears,*bcal);
      cout<< *esr;
    }

    if(dump_bcal || dump_all)
      cout<< *bcal;
    if(dump_lgdSmears || dump_all)
      cout<< *lgdSmears;

    if(dump_hepevt || dump_all)
      cout<< *hepevt;
    if(dump_offtrk || dump_all)
      cout<< *offtrk;
    if(dump_tof_trace || dump_all){
      cout<< *tof_trace;
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
    lgdSmears->Clear();
  }

  rdtfile->Close();
  return 0;
}


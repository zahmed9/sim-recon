//*-- author :    Paul Eugenio  17-Dec-98

////////////////////////////////////////////////////////////////////////
//
//              HDFast: The Hall D Fast MC Package
//             =================================
//              This package is build upon the MCFast framework.
//
//  This program creates :
//    - a ROOT file which contains a tree of MCFast objects
//    
//             
//
//  
////////////////////////////////////////////////////////////////////////


#include <iostream.h>
#include <fstream.h>
#include <stdlib.h>
#include <time.h>
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

// undefined reference errors occur because errno is not defined
// on RHEL3 GCC3.2. Define it here to avoid this.
#undef errno
  extern "C" int errno=0;

void PrintUsage(char *processName);
#ifndef HDFAST_LITE
TROOT HDFast("HDFast","The Hall D Fast MC Package");
#endif
extern "C" void mcfast_main(int argc, char **argv);
Int_t counter=0,Nevents=0,Debug=0,SaveBrokenEvents =0,SaveOldFormat =0;

int main(int argc, char **argv)
{

  char defaultFile[25]="hdfast.rdt";
  char *outputfile,*argptr;

  // gSystem->Load("libTMCFast.so");

  outputfile = defaultFile;
  if (argc == 1){
    PrintUsage(argv[0]);
    exit (0);
  }
  
    for (Int_t i=1; i<argc; i++) {
      argptr = argv[i];
      if ((*argptr == '-') && (strlen(argptr) > 1)) {
        argptr++;
        switch (*argptr) {
	case 'v':
	  SaveOldFormat=1;
	  break;
	case 'u':
          SaveBrokenEvents =1;
          break;
        case 'd':
	  argptr+=2;
          Debug = atoi(argptr);
	  cerr<< "Using debug level: "<< Debug<<endl;
          break;
        case 'h':
	  argptr++;
	  if(!(*argptr == 'b')){
          PrintUsage(argv[0]);
          exit(0);
	  }
          break;
        case 'o':
          outputfile = (argptr + 2);
	  cerr << "Opening "<< outputfile << " for output\n" ;
          break;
	case 'f': // mcfast options
	case 'l':
	  break;
	default:
          cerr << "Unrecognized argument -" << argptr << "\n\n";
          PrintUsage(argv[0]);    
          exit(-1);
          break;
        }
      }
    }

    if(SaveOldFormat==1 && SaveBrokenEvents==1){
      fprintf(stderr,"Sorry, one cannot use the -u and -v option together\n");
      exit(-1);
    }
    /*
     * Seed drand48() ; we use it outside of MCFast in usr_lgd.cxx .
     */
    long now =time(NULL);
    srand48(now);

    /*
     *  Open the data file.
     */
    Int_t comp   = 5;    // 0=no 1=min(but fast) , ... 9=max(but slow) compression 

#ifndef HDFAST_LITE  
    TFile *rdtfile=0; 
    cerr<<"new TFile("<<outputfile<<")\n";
    rdtfile = new TFile(outputfile,"RECREATE","TTree Hall D ROOT file");
    rdtfile->SetCompressionLevel(comp);
#endif
    /*
     * Now call the mcfast framework
     */
    mcfast_main(argc, argv);
    
    
    /*
     * Close the Root I/O
     */
    
    cout<<"\n\nEvents Written: "<<counter<<endl;
#ifndef HDFAST_LITE
    // remember to write and close the file
    rdtfile->Write();
    rdtfile->Close();
#endif
    return 1;
}

void PrintUsage(char *processName){
  
  cerr<< processName << " usage: [switches]" << endl;
  cerr<< "\t-f <cmdfile> The mcfast command file.\n";
  cerr<< "\t-u           Save Broken Events  (*.evt file do not use w/ -v ).\n";
  cerr<< "\t-l <logfile> The log file.\n";
  cerr<< "\t-hb <hbookfile> A hbook file used for testing.\n";
  cerr<< "\t-d <level> Debug level --use level=1 for basic debug\n";
#ifdef HDFAST_LITE
  cerr<< "\t-o <rdtfile> The output  file.\n";
  cerr<< "\t-v           Save in old Event Format  (*.evt file).\n";
#endif


  cerr<< "\t-h Print this help message\n\n";

}


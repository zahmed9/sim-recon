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

void PrintUsage(char *processName);
TROOT HDFast("HDFast","The Hall D Fast MC Package");
extern "C" void mcfast_main(int argc, char **argv);
Int_t counter=0,Nevents=0,Debug=0,SaveUsingMCFIO =0;

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
	  case 'u':
          SaveUsingMCFIO =1;
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

    /*
     *  Open the data file.
     */
    Int_t comp   = 1;       // by default file is compressed
    TFile *rdtfile=0;
    if(! SaveUsingMCFIO){
      rdtfile = new TFile(outputfile,"RECREATE","TTree Hall D ROOT file");
      rdtfile->SetCompressionLevel(comp);
    }
    /*
     * Now call the mcfast framework
     */
  mcfast_main(argc, argv);


  /*
   * Close the Root I/O
   */
   if(! SaveUsingMCFIO){
     cout<<"\n\nEvents Written: "<<counter<<endl;
     // remember to write and close the file
     rdtfile->Write();
     rdtfile->Close();
   }
  return 1;
}

void PrintUsage(char *processName){
  
  cerr<< processName << " usage: [switches]" << endl;
  cerr<< "\t-f <cmdfile> The mcfast command file.\n";
  cerr<< "\t-o <rdtfile> The output  file.\n";
  cerr<< "\t-l <logfile> The log file.\n";
  cerr<< "\t-u           Use the old mcfast output (*.evt file).\n";
  cerr<< "\t-hb <hbookfile> A hbook file used for testing.\n";
  cerr<< "\t-d <level> Debug level --use level=1 for basic debug\n";
  cerr<< "\t-h Print this help message\n\n";

}


#ifdef __CINT__
{
#endif
//////////////////////////////////////////////////
// 
//  
//*-- Author :    Paul Eugenio 22-Feb-99
//*-- CMZ : PME 22-Feb-99
//////////////////////////////////////////////////

//
//Begin_Html
/*

*/
//End_Html


#include <iostream.h>
#include <string.h>

#ifndef __CINT__
#include <stdlib.h>
#include "TROOT.h"
#include "TApplication.h"
#include "TFile.h"
#include "TRandom.h"
#include "TTree.h"
#include "TBranch.h"
#include "TClonesArray.h"
#include "TStopwatch.h"
#include "TSystem.h"
#include "TCanvas.h"
#include "TMCFastHepEvt.h"
#include "TMCFastTOF.h"
#include "TMCFastOfflineTrack.h"
#include "TMCFastCalorimeter.h"
#include "TLGDsmears.h"
#include "TMCesr.h"

extern void InitGui();
VoidFuncPtr_t initfuncs[] = { InitGui, 0 };
TROOT root("GUI", "GUI test environement", initfuncs);
int main(int argc, char **argv){

#endif
 
#ifndef __CINT__
   TApplication theApp("App", &argc, argv);
#endif

   //gROOT->Reset();

#ifdef __CINT__
   gSystem->Load("./libTMCFast.so"); 
   cout<<"gSystem->Loading\n";
#endif
   //   Create a timer object to benchmark this loop
   TStopwatch timer;
   timer.Start();

   ////////////////////////// START OF MACRO //////////////







   
   ////////////////////////// END OF MACRO //////////////


 //  Stop timer and print results
 timer.Stop();
 Double_t rtime = timer.RealTime();
 Double_t ctime = timer.CpuTime();
 printf("RealTime=%f seconds, CpuTime=%f seconds\n",rtime,ctime);

#ifndef __CINT__
 // Here we don't return from the eventloop. "Exit ROOT" will quit the app.
 theApp.Run();
#endif

 return 0;
 }

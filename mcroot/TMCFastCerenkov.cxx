//*-- Author :    Paul Eugenio 8-Apr-1999

////////////////////////////////////////////////////////////////////////
// TMCFastCerenkov
//
// This class contains a collection of trace points (TMCFastTrace objects). 
// Each trace point coresponds to charged particle crossing at the front
// of the Cerenkov plane. See geometry file for pane definition.
// 
//
//  TMCFastCerenkov contains a TClonesArray of  TMCFastTrace
//
////////////////////////////////////////////////////////////////////////


#include "TMCFastCerenkov.h"
ClassImp(TMCFastCerenkov)

TClonesArray *TMCFastCerenkov::fgtrace_points = 0;

//____________________________________________________________________________
TMCFastCerenkov::TMCFastCerenkov(struct traces_t *traces){
  // Create the object 
  // and fill it using  FIll(struct traces_t *traces) 
  //
  if(!fgtrace_points) fgtrace_points = new TClonesArray("TMCFastTrace",10);
  ftrace_points = fgtrace_points;
  
  Fill(traces);

}

TMCFastCerenkov::TMCFastCerenkov(){
  if(!fgtrace_points) fgtrace_points = new TClonesArray("TMCFastTrace",10);
  ftrace_points = fgtrace_points;


}

//____________________________________________________________________________
void  TMCFastCerenkov::Fill(struct traces_t *traces){
  // Fill the object using a c 
  // struct map of the trace point
  // 
  TClonesArray &tp=*(this->ftrace_points);
  
  for(Int_t i =0; i< traces->ntraces;i++){
  
    new(tp[i]) TMCFastTrace(traces->trace + i);
  
  }
  //this->ftrace_points->Add(new TMCFastCerenTrace(traces->trace + i));
}
//____________________________________________________________________________
void TMCFastCerenkov::Clear()
{
  // Clear the TClonesArray fHepParticle
  //
   ftrace_points->Clear();
}


//____________________________________________________________________________
TMCFastCerenkov::~TMCFastCerenkov()
{
   this->Clear();
}

//____________________________________________________________________________
void TMCFastCerenkov::Print(ostream *os){
  // Prints TMCFastCerenkov object
  //
  // This function is also used
  // to  overload  &operator<< 
  // 
  // For example;
  // cout << ceren;
  // 
  // where ceren is an instance of TMCFastCerenkov
  Int_t count=0;

  *os<<"Cerenkov has "<< this->GetNTraces()<<" trace point(s)\n";
  
  // Now Print the trace points

  TIter next(this->GetTraces());
  
  while( TMCFastTrace *trace = (TMCFastTrace *)next()){
    *os<<"  ["<<count++<<"] ";
    trace->Print(os);
  }
}


ostream &operator<<(ostream &os, TMCFastCerenkov &ceren){
// overload the standard print operator
  ceren.Print(&os);
  return os;
}

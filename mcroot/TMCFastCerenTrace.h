#ifndef ROOT_TMCFastCerenTrace
#define ROOT_TMCFastCerenTrace

//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TMCFastCerenTrace   MCFast Trace  Class                                  //
//                                                                      //
// This is port of MCFast Trace Common Block to ROOT                    //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

#include "TObject.h"
#include "TH1.h"
#include "TMCFastTrace.h"
#include "TMath.h"
 
#include <iostream.h>



class TMCFastCerenTrace: public TMCFastTrace {
  
private:
  // inherits all data members from TMCFastTrace

public:
  TMCFastCerenTrace(trace_t *trace);
  virtual ~TMCFastCerenTrace() ;
  Double_t TraceTo(Double_t &Rmin, Double_t &Rmax, Double_t &Zmax);
  void TraceTo(Double_t &Rmin, Double_t &Rmax, Double_t &Zmax,
	       Int_t nSegments,Double_t *Segment);
  Int_t Npe(Double_t indexOfRefraction, Double_t &Rmin, Double_t &Rmax, 
	    Double_t &Zmax);
  Int_t Npe(Double_t indexOfRefraction,Double_t PathLength);
  void Print(ostream *os);
  ClassDef(TMCFastCerenTrace,1)  //Needed by ROOT
};

ostream &operator<<(ostream &os,TMCFastCerenTrace &trace); 


#endif

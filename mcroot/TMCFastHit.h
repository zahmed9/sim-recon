#ifndef ROOT_TMCFastHit
#define ROOT_TMCFastHit

//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TMCFastHit   MCFast Trace  Class                                  //
//                                                                      //
// This is port of MCFast Trace Common Block to ROOT                    //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

#include "TObject.h"
#include "TMCFastTracePoint.h"

#include <iostream>
using namespace std;

struct dev_hit_t{
  Int_t layer;
  Int_t wire_info[3];
  struct trace_t trace;
};

class TMCFastHit: public TObject {
  
private:
  Int_t flayer;            // Layer # (or Plane #) in device
  Int_t fWireInfo[3];      // Wire info within the layer
  TMCFastTracePoint ftrace;    // Trace point of the device hit
  void SetTrace(trace_t *trace) { ftrace.Fill(trace);}
  void Fill(dev_hit_t *devhit);
public:
  TMCFastHit() ;
  TMCFastHit(TMCFastHit &source);
  TMCFastHit(dev_hit_t *devhit);
  void TMCFastHit::operator=(TMCFastHit &source); //assignment operator
  virtual ~TMCFastHit() ;
  Int_t  GetLayer() const { return flayer; }
  Int_t  GetWireInfo(Int_t i) const { return fWireInfo[i]; }
  TMCFastTrace *GetTrace()  { return &ftrace; }
  void SetLayer(Int_t n)  {  flayer=n; }
  void SetWireInfo(Int_t i,Int_t n)  {  fWireInfo[i]=n; }

  Double_t GetdX();
  Double_t GetADCsignal();
  Double_t GetADCsignal(Double_t dX);
  Double_t GetdEdX();
  Double_t GetdEdX2();
  void Print(ostream *os);
   
  ClassDef(TMCFastHit,2)  //Needed by ROOT
};

ostream &operator<<(ostream &os,TMCFastHit &hit); 

#endif
